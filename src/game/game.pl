:- consult('../board/board.pl').
:- consult('../menu/menu.pl').
:- consult('../game/utils.pl').
/*:- consult('computer_player.pl').*/



play:-
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
        Option = 2 -> print_instructions;
        Option = 3 -> abort;
        write("Invalid Option"), nl, choose_game
    ).


play_pvp:-
    initial_state(GameState),
    display_game(GameState),
    game_cycle(GameState, 0).


game_cycle(GameState, Round):-
    Player is (Round mod 2)+1,
    receive_move(X, Y, Dir, X2, Y2),
    move(GameState, Player, (X, Y)-(X2, Y2), NewGameState),
    display_game(NewGameState),
    game_cycle(New_Board, Player).

player_turn(Player) :-
    ( 
        Player = 1 -> 
            write('Player 1 Turn'), nl;
        Player = 2 -> 
            write('Player 2 Turn'), nl
    ).

receive_move(X, Y, Dir, X2, Y2):-

    player_turn(Player),
    write('Piece Column: '),nl,
    read(X),
    write('Piece Line: '),
    read(Y),
    write('Enter direction (N, S, E, W, NW, NE, SW, SE): '),
    read(Dir),
    (
        Dir = 'N' -> X2 is X, Y2 is Y + 1;
        Dir = 'S' -> X2 is X, Y2 is Y - 1;
        Dir = 'E' -> X2 is X + 1, Y2 is Y;
        Dir = 'W' -> X2 is X - 1, Y2 is Y;
        Dir = 'NW' -> X2 is X - 1, Y2 is Y + 1;
        Dir = 'NE' -> X2 is X + 1, Y2 is Y + 1;
        Dir = 'SW' -> X2 is X - 1, Y2 is Y - 1;
        Dir = 'SE' -> X2 is X + 1, Y2 is Y - 1;
        write('Invalid Direction'), nl, receive_move(X, Y, Dir, X2, Y2)
    ).
   


move(GameState, Player, Move, NewGameState) :-
    validate_move(GameState, Player, Move),
    execute_move(GameState,Player, Move, NewGameState).

    



% game_over(GameState, Winner).