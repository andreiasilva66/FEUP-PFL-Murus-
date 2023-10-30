:-use_module(library(lists)).



create_board([['X','X','X','X','X','X','X','X'],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            ['O','O','O','O','O','O','O','O']
            ]).

drawLine([]) :- !.

drawLine([E1|E2]) :- print(E1), write(' | '),
                        drawLine(E2).

drawLine([E1|E2], N) :- write(N), write(' | '), write(E1), write(' | '),
                        drawLine(E2).

continueDisplayBoard([],_) :- !.

continueDisplayBoard([L1|L2], N) :- 
                        nl, drawLine(L1,N), nl,
                        write('   - - - - - - - - - - - - - - - - '),
                        N1 is N+1,
                       continueDisplayBoard(L2, N1).

displayBoard([H|T]) :- write('\n   - - - - - - - - - - - - - - - - \n'),
                        write('  | A | B | C | D | E | F | G | H |\n'),
                        write('   - - - - - - - - - - - - - - - - '),
                        continueDisplayBoard([H|T], 1).

replace([_|T], 1, X, [X|T]) :- !.
replace([H|T], I, X, [H|R]) :- I > 1,
                    NI is I-1,
                    replace(T, NI, X, R).

placePiece(Board, Piece, X, Y, NewBoard) :- 
                        nth1(Y, Board, Line),
                        replace(Line, X, Piece, NewLine),
                        replace(Board, Y, NewLine, NewBoard).


removePiece(Board, X, Y, NewBoard) :- 
                        nth1(Y, Board, Line),
                        replace(Line, X, ' ', NewLine),
                        replace(Board, Y, NewLine, NewBoard).

letter_to_index(Letter, Index) :-
    char_code(Letter, Code),
    Index is Code - 65.

check_initial_tile(Board, Player, X, Y) :-
    nth0(YIndex, Board, Row),
    nth0(XIndex, Row, Piece),
    (Player = 0, Piece = 'X') ;
    (Player = 1, Piece = 'O').


check_final_tile(Board, Player, X2, Y2) :-
    nth0(Y2, Board, Row),            
    nth0(X2, Row, Cell),               

    (Cell = ' ' -> true;
    Cell = 'X', Player = 0 -> true;
    Cell = 'O', Player = 1 -> true;
    true -> false).

getPiece(Board, X, Y, Piece):-
    nth1(X, Board, Row),
    nth1(Y, Row, Piece).
