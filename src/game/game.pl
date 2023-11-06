:- use_module(library(system)).

% Player vs Player initialization and game cycle
play_pvp :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_pvp(GameState, 0).


game_cycle_pvp(GameState, Round):-
    Player is (Round mod 2)+1,
    receive_move(Player, X, Y, D),
    (
        move(GameState, Player, (X, Y)-D, NewGameState),
        Round2 is Round + 1,
        display_game(NewGameState),
        (game_over(NewGameState, Winner),
        game_over_menu(Winner);
        game_cycle_pvp(NewGameState, Round2));
        nl, print('\n Invalid Move.\n Try again.\n'), nl,
        game_cycle_pvp(GameState, Round)
    ).



% Player vs Computer initialization and game cycle
play_pvc(Player, Level) :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_pvc(GameState, 0, Player, Level).

game_cycle_pvc(GameState, Round, Person, Level):-
    Player is (Round mod 2) + 1,
    (Player = Person ->
        receive_move(Player, X, Y, D),
        (
            move(GameState, Player, (X, Y)-D, NewGameState),
            display_game(NewGameState),
            (game_over(NewGameState, Winner) ->
                game_over_menu(Winner)
                ;
                game_cycle_pvc(NewGameState, Player, Person, Level)
            )
        ;
        print('\nInvalid Move.\nTry again.\n'), 
        game_cycle_pvc(GameState, Round, Person, Level)
        )
    ;
    (
        player_turn(Player),
        choose_move(GameState, Player, Level, Move),
        move(GameState, Player, Move, NewGameState),
        sleep(3),
        display_game(NewGameState),
        (game_over(NewGameState, Winner) ->
            game_over_menu(Winner)
            ;
            game_cycle_pvc(NewGameState, Player, Person, Level)
        )
    )).


% Computer vs Computer initialization and game cycle
play_cvc(Level) :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_cvc(GameState, 0, Level).

game_cycle_cvc(GameState, Round, Level) :-
    Player is (Round mod 2)+1,
    player_turn(Player),
    choose_move(GameState, Player, Level, Move),
    move(GameState, Player, Move, NewGameState),
    sleep(3),
    display_game(NewGameState),
    (game_over(NewGameState, Winner),
    game_over_menu(Winner);
    game_cycle_cvc(NewGameState, Player, Level)).

% Displays player turn
player_turn(Player) :-
    ( 
        Player = 1 -> 
            write('\nPlayer 1 Turn'), nl;
        Player = 2 -> 
            write('\nPlayer 2 Turn'), nl
    ).

% Receives a move by the player
receive_move(Player, X, Y, D):-

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
    read(D).
   
   

% Calls functions to validate and execute a move
move(GameState, Player, Move, NewGameState) :-
    validate_move(GameState, Player, Move),
    execute_move(GameState,Player, Move, NewGameState).
    
% Displays the game over menu and reads the input
game_over_menu(Winner) :-
    print_game_over_menu(Winner),
    read(Option),
    (
        Option = 1 -> play;
        Option = 2 -> halt;
        write('Invalid Option'), nl, game_over_menu(Winner)
    ).

% Predicates to end the game
game_over(GameState, Winner) :-
   reach_opposite_row(GameState, Winner).

game_over(GameState, Winner) :-
   valid_moves(GameState, 1, []),
   Winner = 2.

game_over(GameState, Winner) :-
   valid_moves(GameState, 2, []),
   Winner = 1.