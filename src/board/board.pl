:- use_module(library(lists)).

% The `initial_state` predicate defines the initial game state. No comment is needed.

initial_state([['X','X','X','X','X','X','X','X'],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            [' ',' ',' ',' ',' ',' ',' ',' '],
            ['8','8','8','8','8','8','8','8']
            ]).

% The `drawLine/1` predicate is used to stop drawing a horizontal line in the game board.

drawLine([]) :- !.

% The `drawLine/1` predicate is a recursive predicate that prints each element in a list separated by '|'.

drawLine([E1|E2]) :- print(E1), write(' | '),
                        drawLine(E2).

% The `drawLine/2` predicate is a variant of the previous one, which also displays row numbers.

drawLine([E1|E2], N) :- write(N), write(' | '), write(E1), write(' | '),
                        drawLine(E2).

% Stop displaying the board

continueDisplayBoard([],_) :- !.

% The `continueDisplayBoard/2` predicate recursively displays the game board and separates rows with a line.

continueDisplayBoard([L1|L2], N) :- 
                        nl, drawLine(L1,N), nl,
                        write('- - - - - - - - - - - - - - - - - -'),
                        N1 is N+1,
                       continueDisplayBoard(L2, N1).

% The `display_game/1` predicate is used to display the game board.

display_game(GameState) :- write('\n   - - - - - - - - - - - - - - - - \n'),
                        write('  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |\n'),    
                        write('- - - - - - - - - - - - - - - - - -'),
                        continueDisplayBoard(GameState, 1).

% The `replace/3` predicate replaces an element at a specified index in a list with another element.

replace([H|T], 0, X, [X|T]) :- !.
replace([H|T], I, X, [H|R]) :- 
                    NI is I-1,
                    replace(T, NI, X, R).

% The `placePiece/4` predicate is used to place a game piece on the game board.

placePiece(Board, Piece, X, Y, NewBoard) :- 
                        Y1 is Y-1,
                        X1 is X-1,
                        nth0(Y1, Board, Line),
                        replace(Line, X1, Piece, NewLine),
                        replace(Board, Y1, NewLine, NewBoard).

% The `removePiece/3` predicate is used to remove a game piece from the game board.

removePiece(Board, X, Y, NewBoard) :- 
                        Y1 is Y-1,
                        X1 is X-1,
                        nth0(Y1, Board, Line),
                        replace(Line, X1, ' ', NewLine),
                        replace(Board, Y1, NewLine, NewBoard).

% The `getPiece/3` predicate retrieves the piece at the specified coordinates on the game board.

getPiece(Board, X, Y, Piece):-
    nth1(Y, Board, Row),
    nth1(X, Row, Piece).

% The `validate_move/3` predicates are used to validate whether a move is legal for the respective player.

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
    (
        (Dest1 = ' ', Dest2 = ' ');
        (Dest1 = 'v', Dest2 = 'v');
        (Dest1 = 'v', Dest2 = ' ');
        (Dest1 = ' ', Dest2 = 'v')
    )).

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
    (Org = '8'),
    getPiece(GameState, X1, Y1, Dest1),
    (Dest1 = 'v';
    getPiece(GameState, X2, Y2, Dest2),
    (
        (Dest1 = ' ', Dest2 = ' ');
        (Dest1 = 'o', Dest2 = 'o');
        (Dest1 = 'o', Dest2 = ' ');
        (Dest1 = ' ', Dest2 = 'o')
    )).

% The `valid_moves/3` predicate generates a list of valid moves for a player.

valid_moves(GameState, Player, ListOfMoves):-
  findall((X,Y)-D, (between(1, 8, X), between(1, 7, Y), between(1, 8, D), validate_move(GameState, Player, (X,Y)-D)), ListOfMoves).

% The `execute_move/4` predicates execute a move on the game board for the respective player.

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
   
   (Dest1 = 'o' -> 
        removePiece(GameState, X1, Y1, GameState2),
        placePiece(GameState2, 'v', X, Y, NewGameState)
   ;
        getPiece(GameState, X2, Y2, Dest2),
        removePiece(GameState, X, Y, GameState2),
       
       (Dest1 = ' ' -> 
           placePiece(GameState2, 'v', X1, Y1, GameState3)
       ;
           
           (Dest1 = 'v' -> 
               placePiece(GameState2, 'X', X1, Y1, GameState3)
           )
       ),
       (Dest2 = ' ' -> 
           placePiece(GameState3, 'v', X2, Y2, NewGameState)
       ;
           
           (Dest2 = 'v' -> 
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
   
   (Dest1 = 'v' -> 
        removePiece(GameState, X1, Y1, GameState2),
        placePiece(GameState2, 'o', X, Y, NewGameState)
   ;
        getPiece(GameState, X2, Y2, Dest2),
        removePiece(GameState, X, Y, GameState2),
       
       (Dest1 = ' ' -> 
           placePiece(GameState2, 'o', X1, Y1, GameState3)
       ;
           
           (Dest1 = 'o' -> 
               placePiece(GameState2, '8', X1, Y1, GameState3)
           )
       ),
       (Dest2 = ' ' -> 
           placePiece(GameState3, 'o', X2, Y2, NewGameState)
       ;
           
           (Dest2 = 'o' -> 
               placePiece(GameState3, '8', X2, Y2, NewGameState)
           )
       )
   ).

% Predicates for checking if players have reached the opposite row.

reach_opposite_row(GameState, 1) :-
   getPiece(GameState, _ , 7, 'X').

reach_opposite_row(GameState, 1) :-
   getPiece(GameState, _ , 7, 'v').

reach_opposite_row(GameState, 2) :-
   getPiece(GameState, _ , 1, '8').

reach_opposite_row(GameState, 2) :-
   getPiece(GameState, _ , 1, 'o').

