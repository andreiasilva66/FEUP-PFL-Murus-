
between(Lower, Upper, Lower) :-
   Lower =< Upper.
between(Lower, Upper, Value) :-
   Lower < Upper,
   Next is Lower + 1,
   between(Next, Upper, Value).

% Calculates the change in X direction
dx(X1, X2, DX) :- DX is X2 - X1.

% Calculates the change in Y direction
dy(Y1, Y2, DY) :- DY is Y2 - Y1.

% Calculates the absolute value
abs(X, ABX) :- (X >= 0, ABX is X); (X < 0, ABX is -X).