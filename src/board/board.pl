createBoard([['X','X','X','X','X','X','X','X'],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            ['O','O','O','O','O','O','O','O']
            ]).

drawLine([]) :- print(' | ').


drawLine([E1|E2]) :- print(' | '), print(E1),
                        drawLine(E2).

drawLine([E1|E2], N) :- print(N), print(' | '), print(E1),
                        drawLine(E2).


continueDisplayBoard([],0) :- print('   - - - - - - - - - - - - - - - - ').




continueDisplayBoard([L1|L2], N) :- print('   - - - - - - - - - - - - - - - - '),
                        nl, drawLine(L1,N), nl,
                        N1 is N-1,
                       continueDisplayBoard(L2, N1).

displayBoard(L) :- print(' |  A  B  C  D  E  F  G  H  |'),
                    nl, continueDisplayBoard(L, 7).

