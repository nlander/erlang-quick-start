-module(conc).

-export([start/0, say_something/2, ping/1, pong/0]).

ping(0) ->
  pong ! finished,
  io:format("ping finished~n", []);
ping(N) ->
  pong ! {ping, self()},
  receive
    pong ->
      io:format("Ping received pong~n", [])
  end,
  ping(N - 1).

pong() ->
  receive
    finished ->
      io:format("pong finished~n", []);
    {ping, Ping_PID} ->
      io:format("Pong received ping~n", []),
      Ping_PID ! pong,
      pong()
  end.

say_something(_, 0) ->
  done;
say_something(What, Times) ->
  io:format("~p~n", [What]),
  say_something(What, Times - 1).

start() ->
  register(pong, spawn(conc, pong, [])),
  spawn(conc, ping, [3]).
