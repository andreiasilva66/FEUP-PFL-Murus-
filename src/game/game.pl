:- use_module(library(system)).

play_pvp :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_pvp(GameState, 0).


game_cycle_pvp(GameState, Round):-
    Player is (Round mod 2)+1,
    receive_move(X, Y, Dir, X2, Y2),
    move(GameState, Player, (X, Y)-(X2, Y2), NewGameState),
    display_game(NewGameState),
    game_cycle_pvp(New_Board, Player).


play_pvc(Player, Level) :-
    initial_state(GameState),
    display_game(GameState),
    game_cycle_pvc(GameState, 0, Player, Level).

game_cycle_pvc(GameState, Round, Person, Level):-
    Player is (Round mod 2)+1,
    (Player = Person ->
        !, receive_move(X, Y, Dir, X2, Y2),
        move(GameState, Player, (X, Y)-(X2, Y2), NewGameState)
        ;(
            choose_move(GameState, Player, Level, Move),
            move(GameState, Player, Move, NewGameState),
            sleep(3)
        )),
    display_game(NewGameState),
    !,
    game_cycle_pvc(NewGameState, Player, Person, Level).

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

receive_move(X, Y, Dir, X2, Y2):-

    player_turn(Player),
    write('Piece Column: '),nl,
    read(X),
    write('Piece Line: '),
    read(Y),
    write('Enter direction (N, S, E, W, NW, NE, SW, SE): '),
    read(Dir),
    (
        Dir = 'N' -> (X2 is X, Y2 is Y - 1);
        Dir = 'S' -> (X2 is X, Y2 is Y + 1);
        Dir = 'E' -> (X2 is X + 1, Y2 is Y);
        Dir = 'W' -> (X2 is X - 1, Y2 is Y);
        Dir = 'NW' -> (X2 is X - 1, Y2 is Y - 1);
        Dir = 'NE' -> (X2 is X + 1, Y2 is Y - 1);
        Dir = 'SW' -> (X2 is X - 1, Y2 is Y + 1);
        Dir = 'SE' -> (X2 is X + 1, Y2 is Y + 1);
        write('Invalid Direction'), nl, receive_move(X, Y, X2, Y2)
    ), !.
   


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