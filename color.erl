-module(color).

-export([new/4, blend/2]).

-define(is_channel(V), (is_float(V), andalso V >= 0.0 andalso V =< 1.0)).

new(R,G,B,A) ->
    #{red => R, green => G, blue => B, alpha => A}.

blend(Src,Dst) ->
  blend(Src,Dst,alpha(Src,Dst)).

blend(Src,Dst,Alpha) when Alpha > 0.0 ->
  Dst#{ red   := red(Src,Dst) / Alpha
      , green := green(Src,Dst) / Alpha
      , blue := blue(Src,Dst) / Alpha
      , alpha := Alpha
      }.

alpha(#{alpha := SA}, #{alpha := DA}) ->
  SA + DA*(1.0 - SA).

red(#{red := SV, alpha := SA}, #{red := DV, alpha := DA}) ->
  SV*SA + DV*DA*(1.0 - SA).
green(#{green := SV, alpha := SA}, #{green := DV, alpha := DA}) ->
  SV*SA + DV*DA*(1.0 - SA).
blue(#{blue := SV, alpha := SA}, #{blue := DV, alpha := DA}) ->
  SV*SA + DV*DA*(1.0 - SA).
