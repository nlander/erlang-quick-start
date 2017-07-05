%%% Message interface between the client,
%%% server and client shell.


%%% Messages from client to server
%%% received by server/1
-record(logon, {client_pid, username}).
-record(message, {client_pid, to_name, message}).
%%% {'EXIT', ClientPid, Reason}
%%% client terminated or unreachable


%%% Messages from server to client
%%% received by await_result/0
-record(abort_client, {message}).
%%% Messages: user_exists_at_other_node, you_are_not_logged_in
-record(server_reply, {message}).
%%% Messages: logged_on, receiver_not_found, sent
%%%
%%% Messages from server to client
%%% received by client/1
-record(message_from, {from_name, message}).


%%% Messages from shell to client
%%% received by client/1
%%% spawn(mess_client, client, [server_node(), Name])
-record(message_to, {to_name, message}).
%%% logoff
