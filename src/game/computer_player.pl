:-use_module(library(lists)).
:-consult 'src/board/board.pl'.

% Gets the coordinates of all computer pieces
getComputerPieces(Board, Player, ComputerPieces) :-
    findall([X, Y], (between(0, 7, X), between(0, 6, Y), check_initial_tile(Board, Player, X, Y)), ComputerPieces).


getPossibleMoves(Board, Player, [X, Y], Moves) :-
    findall([X2, Y2], isValidMove(Board, Player, X, Y, X2, Y2), Moves).

randomComputerTurn(Board, Player, NewBoard) :-
    getComputerPieces(Board, Player, ComputerPieces),
    random_member([X,Y], ComputerPieces),
    %length(ComputerPieces, Size),
    %random(0, Size, Piece),
    %nth0(PieceIndex, ComputerPieces, [X, Y]),
    getPossibleMoves(Board, Player, [X, Y], Moves),
    (Moves \= [] -> 
        random_member([X2, Y2], Moves),
        getPiece(Board, X2, Y2, Dest),
        Dest = ' ' -> (
                removePiece(Board, X, Y, New_Board),
                placePiece(New_Board, 'X', New_X, New_Y, Final_Board),
                displayBoard(Final_Board)
            )
        
        !;
        randomComputerTurn(Board, Player, NewBoard)
    ).


    
    