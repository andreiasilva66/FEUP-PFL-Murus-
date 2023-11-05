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

/*
letter_to_index(Letter, Index) :-
    char_code(Letter, Code),
    Index is Code - 65.
*/
check_initial_tile(Board, Player, X, Y) :-
    nth0(Y, Board, Row),
    nth0(X, Row, Piece),
    (Player = 1, Piece = 'X') ;
    (Player = 2, Piece = 'O').


check_final_tile(Board, Player, X2, Y2) :-
    nth0(Y2, Board, Row),            
    nth0(X2, Row, Cell),               

    (Cell = ' ' -> true;
    Cell = 'X', Player = 1 -> true;
    Cell = 'O', Player = 2 -> true;
    true -> false).

getPiece(Board, X, Y, Piece):-
    nth1(Y, Board, Row),
    nth1(X, Row, Piece).

isEmpty(Board, X, Y) :-
    nth0(Y, Board, Row),
    nth0(X, Row, ' ').


% Calculates the change in X direction
dx(X1, X2, DX) :- DX is X2 - X1.

% Calculates the change in Y direction
dy(Y1, Y2, DY) :- DY is Y2 - Y1.

% Calculates the absolute value
abs(X, ABX) :- (X >= 0, ABX is X); (X < 0, ABX is -X).


% movableWall(Board, X, Y, DX, DY, Piece) :-
%     nth0(Y, Board, Row),
%     nth0(X, Row, Piece),
%     X2 is X + DX,
%     Y2 is Y + DY,
%     withinBoard(X2, Y2),
%     isEmpty(Board, X2, Y2).

% % Predicate to check if a move is valid for Player 0
% isValidMove(Board, 0, X, Y, X2, Y2) :-
%     dx(X, X2, DX),
%     dy(Y, Y2, DY),
%     (withinBoard(X2, Y2), isEmpty(Board, X2, Y2);
%     withinBoard(X2, Y2), adjacentPiece(Board, X2, Y2, DX, DY, 'x')).

% % Predicate to check if a move is valid for Player 1
% isValidMove(Board, 1, X, Y, X2, Y2) :-
%     dx(X, X2, DX),
%     dy(Y, Y2, DY),
%     (withinBoard(X2, Y2), isEmpty(Board, X2, Y2);
%     withinBoard(X2, Y2), adjacentPiece(Board, X, Y, DX, DY, 'o')).

validate_move(GameState, 1, (X1,Y1)-(X2,Y2)) :-
    X1 > 0, X1 < 9,
    X2 > 0, X2 < 9,
    Y1 > 0, Y1 < 8,
    Y2 > 0, Y2 < 8,
    dx(X1, X2, DX),
    dy(Y1, Y2, DY),
    abs(DX, ABX),
    abs(DY, ABY),
    (ABX = 1, ABY = 1; ABX = 1, ABY = 0; ABX = 0, ABY = 1),
    getPiece(GameState, X1, Y1, Org),
    (Org = 'X'),
    getPiece(GameState, X2, Y2, Dest),
    (Dest = ' ';
     
    ( XAdj is X2+DX, YAdj is Y2+DY,
    getPiece(GameState, XAdj, YAdj, Adj), 
    Dest = 'x' , Adj = ' ')).

validate_move(GameState, 2, (X1,Y1)-(X2,Y2)) :-
    X1 > 0, X1 < 9,
    X2 > 0, X2 < 9,
    Y1 > 0, Y1 < 8,
    Y2 > 0, Y2 < 8,
    dx(X1, X2, DX),
    dy(Y1, Y2, DY),
    abs(DX, ABX),
    abs(DY, ABY),
    (ABX = 1, ABY = 1; ABX = 1, ABY = 0; ABX = 0, ABY = 1),
    getPiece(GameState, X1, Y1, Org),
    (Org = 'O'),
    getPiece(GameState, X2, Y2, Dest),
    getPiece(GameState, (X2+DX), (Y2+DY), Adj),
    (Dest = ' '; 
    Dest = 'x';
    (XAdj is X2+DX, YAdj is Y2+DY,
    getPiece(GameState, XAdj, YAdj, Adj), 
    Dest = 'o' , Adj = ' ')).

valid_moves(GameState, Player, ListOfMoves):-
  findall((X1,Y1)-(X2,Y2), (between(1, 8, X1), between(1, 7, Y1), between(1, 8, X2), between(1, 7, Y2), validate_move(GameState, Player, (X1,Y1)-(X2,Y2))), ListOfMoves).


execute_move(GameState, 1, (X1,Y1)-(X2,Y2), NewGameState) :-
    getPiece(GameState, X2, Y2, Dest),
   % empty cell
   (Dest = ' ' -> 
       removePiece(GameState, X1, Y1, GameState2),
       placePiece(GameState2, 'X', X2, Y2, NewGameState)
   ;
       % enemy wall
       (Dest = 'o' -> 
           removePiece(GameState, X2, Y2, GameState2),
           removePiece(GameState2, X1, Y1, GameState3),
           placePiece(GameState3, 'x', X1, Y1, NewGameState)
       ;
           % player wall
           (Dest = 'x' -> 
               dx(X1, X2, DX), dy(Y1, Y2, DY),
               XAdj is X2+DX, YAdj is Y2+DY,
               removePiece(GameState, X1, Y1, GameState2),
               removePiece(GameState2, X2, Y2, GameState2),
               placePiece(GameState3, 'X', X2, Y2, GameState4),
               removePiece(GameState4, XAdj, YAdj, GameState5),
               placePiece(GameState5, 'x', XAdj, YAdj, NewGameState)
           )
       )
   ).

execute_move(GameState, 2, (X1,Y1)-(X2,Y2), NewGameState) :-
    getPiece(GameState, X2, Y2, Dest),
   % empty cell
   (Dest = ' ' -> 
       removePiece(GameState, X1, Y1, GameState2),
       placePiece(GameState2, 'O', X2, Y2, NewGameState)
   ;
       % enemy wall
       (Dest = 'x' -> 
           removePiece(GameState, X2, Y2, GameState2),
           removePiece(GameState2, X1, Y1, GameState3),
           placePiece(GameState3, 'o', X1, Y1, NewGameState)
       ;
           % player wall
           (Dest = 'o' -> 
               dx(X1, X2, DX), dy(Y1, Y2, DY),
               XAdj is X2+DX, YAdj is Y2+DY,
               removePiece(GameState, X1, Y1, GameState2),
               removePiece(GameState2, X2, Y2, GameState2),
               placePiece(GameState3, 'O', X2, Y2, GameState4),
               removePiece(GameState4, XAdj, YAdj, GameState5),
               placePiece(GameState5, 'o', XAdj, YAdj, NewGameState)
           )
       )
   ).

