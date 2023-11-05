:- use_module(library(system)).

play_pvp :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_pvp(GameState, 0).


game_cycle_pvp(GameState, Round):-
    Player is (Round mod 2)+1,
    receive_move(X, Y, X2, Y2),
    move(GameState, Player, (X, Y)-(X2, Y2), NewGameState),
    Round2 is Round + 1,
    display_game(NewGameState),
    game_cycle_pvp(New_Board, Round2).


play_pvc(Player, Level) :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_pvc(GameState, 0, Player, Level).

game_cycle_pvc(GameState, Round, Person, Level):-
    Player is (Round mod 2)+1,
    (Player = Person ->
        receive_move(X, Y, Dir, X2, Y2),
        move(GameState, Player, (X, Y)-(X2, Y2), NewGameState)
        ;(
            choose_move(GameState, Player, Level, Move),
            move(GameState, Player, Move, NewGameState),
            sleep(3)
        )),
    display_game(NewGameState),
    (game_over(GameState, Winner),
    print_game_over_menu(Winner);
    game_cycle_pvc(NewGameState, Player, Level)).

play_cvc(Level) :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_cvc(GameState, 0, Level).

game_cycle_cvc(GameState, Round, Level) :-
    Player is (Round mod 2)+1,
    choose_move(GameState, Player, Level, Move),
    move(GameState, Player, Move, NewGameState),
    sleep(3),
    display_game(NewGameState),
    (game_over(GameState, Winner),
    print_game_over_menu(Winner);
    game_cycle_cvc(NewGameState, Player, Level)).


player_turn(Player) :-
    ( 
        Player = 1 -> 
            write('\nPlayer 1 Turn'), nl;
        Player = 2 -> 
            write('\nPlayer 2 Turn'), nl
    ).

receive_move(X, Y, X2, Y2):-

    player_turn(Player),
    write('Tower Column: '),nl,
    read(X),
    write('Tower Line: '),
    read(Y),
    write('Direction:'), nl,
    write('1 - Up'), nl,
    write('2 - Down'), nl,
    write('3 - Left'), nl,
    write('4 - Right'), nl,
    write('5 - Up-Left'), nl,
    write('6 - Up-Right'), nl,
    write('7 - Down-Left'), nl,
    write('8 - Down-Right'), nl,
    read(Dir),
    (
        Dir = 1 -> X2 is X, Y2 is Y-1;
        Dir = 2 -> X2 is X, Y2 is Y+1;
        Dir = 3 -> X2 is X-1, Y2 is Y;
        Dir = 4 -> X2 is X+1, Y2 is Y;
        Dir = 5 -> X2 is X-1, Y2 is Y-1;
        Dir = 6 -> X2 is X+1, Y2 is Y-1;
        Dir = 7 -> X2 is X-1, Y2 is Y+1;
        Dir = 8 -> X2 is X+1, Y2 is Y+1
    ).
   
   


move(GameState, Player, Move, NewGameState) :-
    validate_move(GameState, Player, Move),
    execute_move(GameState,Player, Move, NewGameState).
    

game_over(GameState, Winner) :-
   reach_opposite_row(GameState, Winner).

game_over(GameState, Winner) :-
   valid_moves(GameState, 1, []),
   Winner = 2.

game_over(GameState, Winner) :-
   valid_moves(GameState, 2, []),
   Winner = 1.