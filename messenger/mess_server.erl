-module(mess_server).
-export([start_server/0, server/0]).
-include("mess_interface.hrl").

server() ->
  process_flag(trap_exit, true),
  server([]).

server(UserList) ->
  io:format("User list = ~p~n", [UserList]),
  receive
    #logon{client_pid=From, username=Name} ->
      New_User_List = server_logon(From, Name, UserList),
      server(New_User_List);
    {'EXIT', From, _} ->
      New_User_List = server_logoff(From, UserList),
      server(New_User_List);
    #message{client_pid=From, to_name=To, message=Message} ->
      server_transfer(From, To, Message, UserList),
      server(UserList)
  end.

start_server() ->
  register(messenger, spawn(?MODULE, server, [])).

server_logon(From, Name, UserList) ->
  case lists:keymember(Name, 2, UserList) of
    true ->
      From ! #abort_client{message=user_exists_at_other_node},
      UserList;
    false ->
      From ! #server_reply{message=logged_on},
      link(From),
      [{From, Name} | UserList]
  end.

server_logoff(From, UserList) ->
  lists:keydelete(From, 1, UserList).

server_transfer(From, To, Message, UserList) ->
  case lists:keysearch(From, 1, UserList) of
    false ->
      From ! #abort_client{message=you_are_not_logged_in};
    {value, {_, Name}} ->
      server_transfer(From, Name, To, Message, UserList)
  end.

server_transfer(From, Name, To, Message, UserList) ->
  case lists:keysearch(To, 2, UserList) of
    false ->
      From ! #server_reply{message=receiver_not_found};
    {value, {ToPid, To}} ->
      ToPid ! #message_from{from_name=Name, message=Message},
      From  ! #server_reply{message=sent}
  end.
