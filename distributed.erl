-module(distributed).

-export([start/1, ping/2, pong/0]).

ping(N, Pong_PID) ->
  link(Pong_PID),
  ping1(N, Pong_PID).

ping1(0, _) ->
  exit(ping);

ping1(N, Pong_PID) ->
  Pong_PID ! {ping, self()},
  receive
    pong ->
      io:format("Ping received pong~n", [])
  end,
  ping1(N - 1, Pong_PID).

pong() ->
  process_flag(trap_exit, true),
  pong1().

pong1() ->
  receive
    {ping, Ping_PID} ->
      io:format("Pong received ping~n", []),
      Ping_PID ! pong,
      pong1();
    {'EXIT', From, Reason} ->
      io:format("pong exiting, got ~p~n", [{'EXIT', From, Reason}])
  end.

start(Ping_Node) ->
  Pong_PID = spawn(distributed, pong, []),
  spawn(Ping_Node, distributed, ping, [3, Pong_PID]).
