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


displayBoard([]) :- print('  - - - - - - - - - - - - - - - - ').

displayBoard([L1|L2]) :- print('  - - - - - - - - - - - - - - - - '),
                        nl, drawLine(L1), nl,
                       displayBoard(L2).



