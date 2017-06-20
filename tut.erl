-module(tut).
-export([double/1, fac/1, mult/2, convert/2, convert_length/1, list_length/1, format_temps/1, list_max/1, reverse/1, convert_list_to_c/1, test_if/2, month_length/2]).

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

convert_length(Length) ->
  case Length of
    {centimeter, X} ->
      {inch, X / 2.54};
    {inch, Y} ->
      {centimeter, Y * 2.54}
  end.

month_length(Year, Month) ->
  Leap = if
    Year rem 400 == 0 ->
      leap;
    Year rem 100 == 0 ->
      not_leap;
    Year rem 4 == 0 ->
      leap;
    true ->
      not_leap
  end,
  case Month of
    sep -> 30;
    apr -> 30;
    jun -> 30;
    nov -> 30;
    feb when Leap == leap -> 29;
    feb -> 28;
    jan -> 31;
    mar -> 31;
    may -> 31;
    jul -> 31;
    aug -> 31;
    oct -> 31;
    dec -> 31
  end.

list_length([]) ->
  0;
list_length([_ | Rest]) ->
  1 + list_length(Rest).

format_temps(List_To_Convert) ->
  Converted_List = convert_list_to_c(List_To_Convert),
  print_temp(Converted_List),
  {Max_City, Min_City} = find_max_and_min(Converted_List),
  print_max_and_min(Max_City, Min_City).

convert_list_to_c([Head | Rest]) ->
  [convert_to_celcius(Head) | convert_list_to_c(Rest)];
convert_list_to_c([]) ->
  [].

convert_to_celcius({Name, {c, Temp}}) -> % No conversion necessary
  {Name, {c, Temp}};
convert_to_celcius({Name, {f, Temp}}) -> % Do the conversion
  {Name, {c, (Temp - 32) * 5 / 9}}.

find_max_and_min([City | Rest]) ->
  find_max_and_min(Rest, City, City).

find_max_and_min([{Name, {c, Temp}} | Rest]
                , {Max_Name, {c, Max_Temp}}
                , {Min_Name, {c, Min_Temp}}) ->
  if
    Temp > Max_Temp ->
      Max_City = {Name, {c, Temp}};
    true ->
      Max_City = {Max_Name, {c, Max_Temp}}
  end,
  if
    Temp < Min_Temp ->
      Min_City = {Name, {c, Temp}};
    true ->
      Min_City = {Min_Name, {c, Min_Temp}}
  end,
  find_max_and_min(Rest, Max_City, Min_City);
find_max_and_min([], Max_City, Min_City) ->
  {Max_City, Min_City}.

print_max_and_min({Max_Name, {c, Max_Temp}}, {Min_Name, {c, Min_Temp}}) ->
  io:format("Max temperature was ~w c in ~w~n", [Max_Temp, Max_Name]),
  io:format("Min temperature was ~w c in ~w~n", [Min_Temp, Min_Name]).

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

test_if(A, B) ->
  if
    A == 5 ->
      io:format("A == 5~n", []),
      a_equals_5;
    B == 6 ->
      io:format("B == 6~n", []),
      b_equals_6;
    A == 2, B == 3 ->
      io:format("A == 2, B == 3~n", []),
      a_equals_2_b_equals_3;
    A == 1 ; B == 7 ->
      io:format("A == 1 ; B == 7~n", []),
      a_equals_1_b_equals_7
  end.
