:- consult('board/board.pl').
:- consult('menu/menu.pl').
:- consult('game/utils.pl').
:- consult('game/computer_player.pl').
:- consult('game/game.pl').


play :-
    print_start_menu,
    read(Option),
    (
        Option = 1 ->
        print_mode_menu,
        read(Option2),
        (
            Option2 = 1 -> play_pvp;
            Option2 = 2 -> play_pvc;
            write("Invalid Option"), nl, choose_game

        );
        Option = 2 -> (
            print_instructions,
            read(Back), Back = 1,
            play
        );
        Option = 3 -> abort;
        write("Invalid Option"), nl, choose_game
    ).