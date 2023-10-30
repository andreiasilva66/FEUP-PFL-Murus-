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


check_move(Board, Player, New_Board) :-
    (Player = 0 ->
        print('Player 1 turn. Please Input current piece coordinates, and directions (T, D, R, L, TR, TL, DR, DL)'), nl
        ;
        Player = 1 ->
            print('Player 2 turn. Please Input current piece coordinates, and directions (T, D, R, L, TR, TL, DR, DL)'), nl,
            write('Piece Column: '), nl,
            read(XLetter),
            letter_to_index(XLetter, X),
            write('Piece Line: '), nl,
            read(YIni),
            Y is YIni - 1,
            % Check if the piece at the specified coordinates belongs to the player
            (check_initial_tile(Board, Player, X, Y) ->
                true
                ;
                print('Select a valid piece to move.'), nl,
                check_move(Board, Player, New_Board) % Ask for input again
            ),
            write('Direction: '), nl,
            read(Dir),
            (
                Dir = 'T' -> X2 is X, Y2 is Y - 1;
                Dir = 'D' -> X2 is X, Y2 is Y + 1;
                Dir = 'R' -> X2 is X + 1, Y2 is Y;
                Dir = 'L' -> X2 is X - 1, Y2 is Y;
                Dir = 'TR' -> X2 is X + 1, Y2 is Y - 1;
                Dir = 'TL' -> X2 is X - 1, Y2 is Y - 1;
                Dir = 'DR' -> X2 is X + 1, Y2 is Y + 1;
                Dir = 'DL' -> X2 is X - 1, Y2 is Y + 1;
                true -> (print('Invalid direction. Please input a valid direction.'), nl, check_move(Board, Player, New_Board)) % Handle invalid direction
            ),
            % Check if the destination tile is valid
            (check_final_tile(Board, Player, X2, Y2) ->
                true
                ;
                print('Select a valid destination tile.'), nl,
                check_move(Board, Player, New_Board) % Ask for input again
            )
    ),

    removePiece(Board, X, Y, New_Board),
    placePiece(New_Board, 'X', X, Y, Final_Board),
    displayBoard(Final_Board).


