:-consult 'src/board/board.pl'.
:-consult 'src/menu/menu.pl'.


choose_game:-
    print_start_menu,
    read(Option),
    (
        Option = 1 -> print_mode_menu,
        read(Option2),
        (
            Option2 = 1 -> play_pvp;
            Option2 = 1 -> play_pvc;
        )
        Option = 2 -> print_instructions;
        Option = 3 -> abort;
    ).


play_pvp:-
    create_board(Board),
    displayBoard(Board),
    game_cycle(Board, 0).


game_cycle(Board, Round):-
    Player is Round mod 2,
    check_move(Board, Player, New_Board),
    game_cycle(New_Board, Player).


check_move(Board, Player, New_Board):-
    Player = 0 -> print('Player 1 turn. Please Input current piece coordinates, and directions (T, L, D, R, TL, TR, DL, DR)'), nl;
    Player = 1 -> print('Player 2 turn. Please Input current piece coordinates, and directions (T, L, D, R, TL, TR, DL, DR)'), nl,
    write('Piece Line: '),nl,
    read(X),
    write('Piece Column: '),nl,
    read(Y),
    write('Direction: '),nl,
    read(Dir),
    check_valid_move(Board, Player, X, Y, Dir).

    removePiece(Board, X, Y, New_Board),
    placePiece(New_Board, 'X', X, Y, Final_Board),
    displayBoard(Final_Board).



check_valid_move(Board, Player, X, Y, Dir) :-
    (
        Dir = 'T', New_X is X, New_Y is Y+1;
        Dir = 'L', New_X is X-1, New_Y is Y;
        Dir = 'D', New_X is X, New_Y is Y-1;
        Dir = 'R', New_X is X+1, New_Y is Y;
        Dir = 'TL', New_X is X - 1, New_Y is Y  1;
        Dir = 'TR', New_X is X  1, New_Y is Y + 1;
        Dir = 'DL', New_X is X - 1, New_Y is Y - 1;
        Dir = 'DR', New_X is X + 1, New_Y is Y - 1
    ),
    New_X >= 0, New_X < 8, New_Y >= 0, New_Y < 8,
    getPiece(Board, X, Y, Piece),
    Player = 0 -> (
        Piece = 'X' -> (
            getPiece(Board, New_X, New_Y, Dest),
            Dest = ' ' -> (
                removePiece(Board, X, Y, New_Board),
                placePiece(New_Board, 'X', New_X, New_Y, Final_Board),
                displayBoard(Final_Board)
            )
            Dest = 'O'-> write('Invalid Move'), nl.
            Dest = 'o' -> (
                removePiece(Board, X, Y, New_Board),
                placePiece(New_Board, 'x', New_X, New_Y, Final_Board),
                displayBoard(Final_Board)
            )
        )
        Piece = 'x' -> (
         write('Invalid Move')   
        )
    ),
    Player = 1 -> (
        Piece = 'O' -> (
            getPiece(Board, New_X, New_Y, Dest),
            Dest = ' ' -> (
                removePiece(Board, X, Y, New_Board),
                placePiece(New_Board, 'O', New_X, New_Y, Final_Board),
                displayBoard(Final_Board)
            )
            Dest = 'X'-> write('Invalid Move'), nl.
            Dest = 'x' -> (
                removePiece(Board, X, Y, New_Board),
                placePiece(New_Board, 'o', New_X, New_Y, Final_Board),
                displayBoard(Final_Board)
            )
        )
        Piece = 'o' -> (
            write('Invalid Move')      
        )
    ).



move(GameState, Player, Move, NewGameState).

    



game_over(GameState, Winner).