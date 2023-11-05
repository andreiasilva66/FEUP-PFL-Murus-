


print_start_menu:-  % Prints Start menu
    nl,
    print('================================================'), nl,
    print('|                MURUS GALLICUS                |'), nl,
    print('================================================'), nl,
    print('|                                              |'), nl,
    print('|                 1 - Start                    |'), nl,
    print('|                 2 - Instructions             |'), nl,
    print('|                 3 - Exit                     |'), nl,
    print('|                                              |'), nl,
    print('================================================'), nl.



print_mode_menu:- % Prints the menu to choose the mode
    nl,
    print('================================================'), nl,
    print('|                    MODE                      |'), nl,
    print('================================================'), nl,
    print('|                                              |'), nl,
    print('|               1 - Human vs Human             |'), nl,
    print('|               2 - Human vs Computer          |'), nl,
    print('|               3 - Computer vs Computer       |'), nl,
    print('|               4 - Back                       |'), nl,
    print('|                                              |'), nl,
    print('================================================'), nl.



print_pcmode_menu :- % Prints the menu to choose the computer mode
    nl,
    print('================================================'), nl,
    print('|                    PC MODE                   |'), nl,
    print('================================================'), nl,
    print('|                                              |'), nl,
    print('|                 1 - Random                   |'), nl,
    print('|                 2 - Smart                    |'), nl,
    print('|                                              |'), nl,
    print('================================================'), nl.



print_player_menu :-
    nl,
    print('================================================'), nl,
    print('|                CHOOSE PLAYER                 |'), nl,
    print('================================================'), nl,
    print('|                                              |'), nl,
    print('|                 1 - Light (Romans)           |'), nl,
    print('|                 2 - Dark (Gauls)             |'), nl,
    print('|                                              |'), nl,
    print('================================================'), nl.


print_instructions :-
    nl,
    print('================================================================'), nl,
    print('|                          INSTRUCTIONS                        |'), nl,
    print('================================================================'), nl,
    print('|                                                              |'), nl,
    print('|  Players take turns, starting with the one who has X pieces. |'), nl, 
    print('|  Player 2 has O pieces.                                      |'), nl,
    print('|  There are two types of pieces: Towers,  as stacks of two    |'), nl,
    print('|  stones represented in uppercase, and Walls, single stones   |'), nl,
    print('|  in lowercase.                                               |'), nl,
    print('|                                                              |'), nl,
    print('|  Walls cannot move but can block the opponent`s movement.    |'), nl,
    print('|                                                              |'), nl,
    print('|  Towers can move in every direction, both orthogonal and     |'), nl,
    print('|  diagonal. The destination cell must be empty or contain     |'), nl,
    print('|  a friendly wall. In the last case, the friendly wall will   |'), nl,
    print('|  move to the next position in that direction.                |'), nl,
    print('|  Towers can only move one cell per turn.                     |'), nl,
    print('|                                                              |'), nl,
    print('|  If a tower is adjacent to an enemy wall, it may capture     |'), nl,
    print('|  it, sacrificing one of its stones and becoming a wall.      |'), nl,
    print('|                                                              |'), nl,
    print('|  If you reach the other side of the board or the opponent    |'), nl,
    print('|  has no more legal moves, you win!                           |'), nl,
    print('|                                                              |'), nl,
    print('|  Good luck and have fun!                                     |'), nl,
    print('|                                                              |'), nl,
    print('|                1 - Go back to the start menu                 |'), nl,
    print('|                                                              |'), nl,
    print('================================================================'), nl.


print_game_over_menu(0) :- % Prints the menu to choose the mode
    nl,
    print('================================================'), nl,
    print('|                                              |'), nl,
    print('|                  GAME OVER                   |'), nl,
    print('|                                              |'), nl,
    print('|                 Player 1 won                 |'), nl,
    print('|                                              |'), nl,
    print('|                1 - Play Again                |'), nl,
    print('|                                              |'), nl,
    print('|                                              |'), nl,
    print('================================================'), nl.

print_game_over_menu(2) :- % Prints the menu to choose the mode
    nl,
    print('================================================'), nl,
    print('|                                              |'), nl,
    print('|                  GAME OVER                   |'), nl,
    print('|                                              |'), nl,
    print('|                 Player 2 won                 |'), nl,
    print('|                                              |'), nl,
    print('|                1 - Play Again                |'), nl,
    print('|                                              |'), nl,
    print('|                                              |'), nl,
    print('================================================'), nl.
