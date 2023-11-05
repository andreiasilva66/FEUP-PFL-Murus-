:-use_module(library(lists)).
:-use_module(library(random)).



count_pieces(GameState, Player, Row, Count) :-
   nth1(Row, GameState, RowState),
   include(=('X'), RowState, Player1Pieces),
   length(Player1Pieces, Count).

count_pieces(GameState, Player, Row, Count) :-
   nth1(Row, GameState, RowState),
   count_pieces_in_row(RowState, Player, 0, Count).

count_pieces_in_row([], _, Count, Count).

count_pieces_in_row(['X'|T], 1, Acc, Count) :-
   NewAcc is Acc + 1,
   count_pieces_in_row(T, 1, NewAcc, Count).

count_pieces_in_row(['O'|T], 2, Acc, Count) :-
   NewAcc is Acc + 1,
   count_pieces_in_row(T, 2, NewAcc, Count).

count_pieces_in_row([_|T], Player, Acc, Count) :-
   count_pieces_in_row(T, Player, Acc, Count).

value(GameState, 1, Value) :-
   count_pieces(GameState, 1, 7, Value).

value(GameState, 2, Value) :-
   count_pieces(GameState, 2, 7, Value).

% Level 1 -> easy mode
choose_move(GameState, Player, 1, Move) :-
    valid_moves(GameState, Player, ListOfMoves),
    random_member(Move, ListOfMoves).

choose_move(GameState, Player, 2, Move) :-
  valid_moves(GameState, Player, Moves),
  findall(Value-Move, (member(Move, Moves), value(GameState, Player, Value)), ValueMoves),
  max_member(Value-Move, ValueMoves),
  Move = Move.

    
    