
between(Lower, Upper, Lower) :-
   Lower =< Upper.
between(Lower, Upper, Value) :-
   Lower < Upper,
   Next is Lower + 1,
   between(Next, Upper, Value).