:-use_module(library(lists)).
:-use_module(library(random)).

% Level 1 -> easy mode
choose_move(GameState, Player, 1, Move) :-
    valid_moves(GameState, Player, ListOfMoves),
    random_member(Move, ListOfMoves).
    













    
    