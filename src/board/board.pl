:- use_module(library(lists)).


initial_state([['X','X','X','X','X','X','X','X'],
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

display_game(GameState) :- write('\n   - - - - - - - - - - - - - - - - \n'),
                        write('  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |\n'),    
                        write('   - - - - - - - - - - - - - - - - '),
                        continueDisplayBoard(GameState, 1).

replace([H|T], 0, X, [X|T]) :- !.
replace([H|T], I, X, [H|R]) :- 
                    NI is I-1,
                    replace(T, NI, X, R).

placePiece(Board, Piece, X, Y, NewBoard) :- 
                        Y1 is Y-1,
                        X1 is X-1,
                        nth0(Y1, Board, Line),
                        replace(Line, X1, Piece, NewLine),
                        replace(Board, Y1, NewLine, NewBoard).


removePiece(Board, X, Y, NewBoard) :- 
                        Y1 is Y-1,
                        X1 is X-1,
                        nth0(Y1, Board, Line),
                        replace(Line, X1, ' ', NewLine),
                        replace(Board, Y1, NewLine, NewBoard).

getPiece(Board, X, Y, Piece):-
    nth1(Y, Board, Row),
    nth1(X, Row, Piece).

validate_move(GameState, 1, (X,Y)-D) :-
    X > 0, X < 9,
    Y > 0, Y < 8,
    D > 0, D < 9,
    
    (D = 1 -> X1 is X, Y1 is Y-1, X2 is X, Y2 is Y-2;(
        D = 2 -> X1 is X, Y1 is Y+1, X2 is X, Y2 is Y+2;(
            D = 3 -> X1 is X-1, Y1 is Y, X2 is X-2, Y2 is Y;(
                D = 4 -> X1 is X+1, Y1 is Y, X2 is X+2, Y2 is Y;(
                    D = 5 -> X1 is X-1, Y1 is Y-1, X2 is X-2, Y2 is Y-2;(
                        D = 6 -> X1 is X+1, Y1 is Y-1, X2 is X+2, Y2 is Y-2;(
                            D = 7 -> X1 is X-1, Y1 is Y+1, X2 is X-2, Y2 is Y+2;(
                                D = 8 -> X1 is X+1, Y1 is Y+1, X2 is X+2, Y2 is Y+2
                            )))))))),

    X1 > 0, X1 < 9, Y1 > 0, Y1 < 8,
    X2 > 0, X2 < 9, Y2 > 0, Y2 < 8,

    getPiece(GameState, X, Y, Org),
    (Org = 'X'),
    getPiece(GameState, X1, Y1, Dest1),
    (Dest1 = 'o';
    getPiece(GameState, X2, Y2, Dest2),
    (Dest1 = ' '; Dest1 = 'x') , (Dest2 = ' ' ; Dest2 = 'x')).

validate_move(GameState, 2, (X,Y)-D) :-
    X > 0, X < 9,
    Y > 0, Y < 8,
    D > 0, D < 9,
    
    (D = 1 -> X1 is X, Y1 is Y-1, X2 is X, Y2 is Y-2;(
        D = 2 -> X1 is X, Y1 is Y+1, X2 is X, Y2 is Y+2;(
            D = 3 -> X1 is X-1, Y1 is Y, X2 is X-2, Y2 is Y;(
                D = 4 -> X1 is X+1, Y1 is Y, X2 is X+2, Y2 is Y;(
                    D = 5 -> X1 is X-1, Y1 is Y-1, X2 is X-2, Y2 is Y-2;(
                        D = 6 -> X1 is X+1, Y1 is Y-1, X2 is X+2, Y2 is Y-2;(
                            D = 7 -> X1 is X-1, Y1 is Y+1, X2 is X-2, Y2 is Y+2;(
                                D = 8 -> X1 is X+1, Y1 is Y+1, X2 is X+2, Y2 is Y+2
                            )))))))),

    X1 > 0, X1 < 9, Y1 > 0, Y1 < 8,
    X2 > 0, X2 < 9, Y2 > 0, Y2 < 8,

    getPiece(GameState, X, Y, Org),
    (Org = 'O'),
    getPiece(GameState, X1, Y1, Dest1),
    (Dest1 = 'x';
    getPiece(GameState, X2, Y2, Dest2),
    (Dest1 = ' '; Dest1 = 'o') , (Dest2 = ' ' ; Dest2 = 'o')).

valid_moves(GameState, Player, ListOfMoves):-
  findall((X,Y)-D, (between(1, 8, X), between(1, 7, Y), between(1, 8, D), validate_move(GameState, Player, (X,Y)-D)), ListOfMoves).


execute_move(GameState, 1, (X,Y)-D, NewGameState) :-

    (D = 1 -> X1 is X, Y1 is Y-1, X2 is X, Y2 is Y-2;(
        D = 2 -> X1 is X, Y1 is Y+1, X2 is X, Y2 is Y+2;(
            D = 3 -> X1 is X-1, Y1 is Y, X2 is X-2, Y2 is Y;(
                D = 4 -> X1 is X+1, Y1 is Y, X2 is X+2, Y2 is Y;(
                    D = 5 -> X1 is X-1, Y1 is Y-1, X2 is X-2, Y2 is Y-2;(
                        D = 6 -> X1 is X+1, Y1 is Y-1, X2 is X+2, Y2 is Y-2;(
                            D = 7 -> X1 is X-1, Y1 is Y+1, X2 is X-2, Y2 is Y+2;(
                                D = 8 -> X1 is X+1, Y1 is Y+1, X2 is X+2, Y2 is Y+2
                            )))))))),

    getPiece(GameState, X1, Y1, Dest1),
   % empty cell
   (Dest1 = 'o' -> 
        removePiece(GameState, X1, Y1, GameState2),
        placePiece(GameState2, 'x', X, Y, NewGameState)
   ;
        getPiece(GameState, X2, Y2, Dest2),
        removePiece(GameState, X, Y, GameState2),
       % enemy wall
       (Dest1 = ' ' -> 
           placePiece(GameState2, 'x', X1, Y1, GameState3)
       ;
           % player wall
           (Dest1 = 'x' -> 
               placePiece(GameState2, 'X', X1, Y1, GameState3)
           )
       ),
       (Dest2 = ' ' -> 
           placePiece(GameState3, 'x', X2, Y2, NewGameState)
       ;
           % player wall
           (Dest2 = 'x' -> 
               placePiece(GameState3, 'X', X2, Y2, NewGameState)
           )
       )
   ).

execute_move(GameState, 2, (X,Y)-D, NewGameState) :-
    (D = 1 -> X1 is X, Y1 is Y-1, X2 is X, Y2 is Y-2;(
        D = 2 -> X1 is X, Y1 is Y+1, X2 is X, Y2 is Y+2;(
            D = 3 -> X1 is X-1, Y1 is Y, X2 is X-2, Y2 is Y;(
                D = 4 -> X1 is X+1, Y1 is Y, X2 is X+2, Y2 is Y;(
                    D = 5 -> X1 is X-1, Y1 is Y-1, X2 is X-2, Y2 is Y-2;(
                        D = 6 -> X1 is X+1, Y1 is Y-1, X2 is X+2, Y2 is Y-2;(
                            D = 7 -> X1 is X-1, Y1 is Y+1, X2 is X-2, Y2 is Y+2;(
                                D = 8 -> X1 is X+1, Y1 is Y+1, X2 is X+2, Y2 is Y+2
                            )))))))),

    getPiece(GameState, X1, Y1, Dest1),
   % empty cell
   (Dest1 = 'x' -> 
        removePiece(GameState, X1, Y1, GameState2),
        placePiece(GameState2, 'o', X, Y, NewGameState)
   ;
        getPiece(GameState, X2, Y2, Dest2),
        removePiece(GameState, X, Y, GameState2),
       % enemy wall
       (Dest1 = ' ' -> 
           placePiece(GameState2, 'o', X1, Y1, GameState3)
       ;
           % player wall
           (Dest1 = 'o' -> 
               placePiece(GameState2, 'O', X1, Y1, GameState3)
           )
       ),
       (Dest2 = ' ' -> 
           placePiece(GameState3, 'o', X2, Y2, NewGameState)
       ;
           % player wall
           (Dest2 = 'o' -> 
               placePiece(GameState3, 'O', X2, Y2, NewGameState)
           )
       )
   ).

reach_opposite_row(GameState, 1) :-
   getPiece(GameState, _ , 7, 'X').

reach_opposite_row(GameState, 1) :-
   getPiece(GameState, _ , 7, 'x').

reach_opposite_row(GameState, 2) :-
   getPiece(GameState, _ , 1, 'O').

reach_opposite_row(GameState, 2) :-
   getPiece(GameState, _ , 1, 'o').

