
between(Lower, Upper, Lower) :-
   Lower =< Upper.
between(Lower, Upper, Value) :-
   Lower < Upper,
   Next is Lower + 1,
   between(Next, Upper, Value).
   

% Flatten a list of lists
flatten([], []).
flatten([L|Ls], Flat) :-
    flatten(L, F),
    flatten(Ls, Fs),
    append(F, Fs, Flat).

% Flatten an atom (single element)
flatten(X, [X]) :- atomic(X).