:- consult('board/board.pl').
:- consult('menu/menu.pl').
:- consult('game/utils.pl').
:- consult('game/computer_player.pl').
:- consult('game/game.pl').


% Main function
play :-
    print_start_menu,
    read(Option),
    (
        Option = 1 ->
        print_mode_menu,
        read(Option2),
        (
            Option2 = 1 -> play_pvp
                ;(
                Option2 = 2 -> print_pcmode_menu,
                    read(Level),
                    print_player_menu,
                    read(Player),
                    play_pvc(Player, Level)
                    ;(
                        Option2 = 3 -> print_pcmode_menu,
                            read(Level),
                            play_cvc(Level);
                            (
                                write('Invalid Option'), nl, play
                            )
                    )
                )

        );
        Option = 2 -> (
            print_instructions,
            read(Back), Back = 1,
            play; play
        );
        Option = 3 -> abort;
        write('Invalid Option'), nl, play
    ).