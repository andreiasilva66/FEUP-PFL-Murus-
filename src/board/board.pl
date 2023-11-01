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

display_game(GameState) :- write('\n   - - - - - - - - - - - - - - - - \n'),
                        write('  | A | B | C | D | E | F | G | H |\n'),    
                        write('   - - - - - - - - - - - - - - - - '),
                        continueDisplayBoard(GameState, 1).

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
    nth0(Y, Board, Row),
    nth0(X, Row, Piece).

isEmpty(Board, X, Y) :-
    nth0(Y, Board, Row),
    nth0(X, Row, ' ').


% Calculates the change in X direction
dx(X1, X2, DX) :- DX is X2 - X1.

% Calculates the change in Y direction
dy(Y1, Y2, DY) :- DY is Y2 - Y1.

% Calculates the absolute value
abs(X, ABX) :- (X >= 0, ABX is X); (X < 0, ABX is -X).


% Predicate to check if a move is valid for Player 0
isValidMove(Board, 0, X, Y, X2, Y2) :-
    dx(X, X2, DX),
    dy(Y, Y2, DY),
    (withinBoard(X2, Y2), isEmpty(Board, X2, Y2);
    withinBoard(X2, Y2), adjacentPiece(Board, X2, Y2, DX, DY, 'x')).

movableWall(Board, X, Y, DX, DY, Piece) :-
    nth0(Y, Board, Row),
    nth0(X, Row, Piece),
    X2 is X + DX,
    Y2 is Y + DY,
    withinBoard(X2, Y2),
    isEmpty(Board, X2, Y2).

% Predicate to check if a move is valid for Player 1
isValidMove(Board, 1, X, Y, X2, Y2) :-
    dx(X, X2, DX),
    dy(Y, Y2, DY),
    (withinBoard(X2, Y2), isEmpty(Board, X2, Y2);
    withinBoard(X2, Y2), adjacentPiece(Board, X, Y, DX, DY, 'o')).

validate_move(GameState, 0, (X1,Y1)-(X2,Y2)) :-
    dx(X1, X2, DX),
    dy(Y1, Y2, DY),
    abs(DX, ABX),
    abs(DY, ABY),
    (ABX = 1, ABY = 1; ABX = 1, ABY = 0; ABX = 0, ABY = 1),
    getPiece(GameState, X1, Y1, Org),
    (Org = 'X'),
    getPiece(GameState, X2, Y2, Dest),
    (Dest = ' '; 
    (getPiece(GameState, (X2+DX), (Y2+DY), Adj), 
    Dest = 'x' , Adj = ' ')).

validate_move(GameState, 1, (X1,Y1)-(X2,Y2)) :-
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
    (getPiece(GameState, (X2+DX), (Y2+DY), Adj), 
    Dest = 'o' , Adj = ' ')).

valid_moves(GameState, Player, ListOfMoves) :-
    findall(Move, validate_move(GameState, Player, Move), ListOfMoves).
