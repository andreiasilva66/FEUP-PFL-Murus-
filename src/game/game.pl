:-consult 'src/game/board.pl'.
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
    nth0(Board, )
    check_valid_move(Board, Player, X, Y, X2, Y2, New_Board).

    removePiece(Board, X, Y, New_Board),
    placePiece(New_Board, 'X', X, Y, Final_Board),
    displayBoard(Final_Board).


check_valid_move()