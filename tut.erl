-module(tut).
-export([double/1, fac/1, mult/2, convert/2, convert_length/1, list_length/1, format_temps/1, list_max/1, reverse/1, convert_list_to_c/1]).

double(X) ->
  2 * X.

fac(1) ->
  1;
fac(N) ->
  N * fac(N - 1).

mult(X, Y) ->
  X * Y.

convert(M, inch) ->
  M / 2.54;

convert(N, centimeter) ->
  N * 2.54.

convert_length({centimeter, X}) ->
  {inch, X / 2.54};
convert_length({inch, Y}) ->
  {centimeter, Y * 2.54}.

list_length([]) ->
  0;
list_length([_ | Rest]) ->
  1 + list_length(Rest).

format_temps(List_To_Convert) ->
  Converted_List = convert_list_to_c(List_To_Convert),
  print_temp(Converted_List).

convert_list_to_c([Head | Rest]) ->
  [convert_to_celcius(Head) | convert_list_to_c(Rest)];
convert_list_to_c([]) ->
  [].

convert_to_celcius({Name, {c, Temp}}) -> % No conversion necessary
  {Name, {c, Temp}};
convert_to_celcius({Name, {f, Temp}}) -> % Do the conversion
  {Name, {c, (Temp - 32) * 5 / 9}}.

print_temp([{Name, {c, Temp}} | Rest]) ->
  io:format("~-12w ~w c~n", [Name, Temp]),
  print_temp(Rest);
print_temp([]) ->
  ok.

list_max([Head|Rest]) ->
  list_max(Rest, Head).

list_max([], Res) ->
  Res;
list_max([Head|Rest], Result_so_far) when Head > Result_so_far ->
  list_max(Rest, Head);
list_max([_|Rest], Result_so_far) ->
  list_max(Rest, Result_so_far).

reverse(List) ->
  reverse(List, []).

reverse([Head | Rest], Reversed_List) ->
  reverse(Rest, [Head | Reversed_List]);
reverse([], Reversed_List) ->
  Reversed_List.
