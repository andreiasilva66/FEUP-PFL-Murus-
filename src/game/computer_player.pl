:-use_module(library(lists)).
:-use_module(library(random)).


% Predicate to assign values to pieces based on type and row
piece_value('X', Row, Value) :-
    % Define values for X pieces based on row position
    (Row = 1, Value = 1);
    (Row = 2, Value = 2);
    (Row = 3, Value = 3);
    (Row = 4, Value = 5);
    (Row = 5, Value = 7);
    (Row = 6, Value = 10);
    (Row = 7, Value = 15).

piece_value('v', Row, Value) :-
    % Define values for X pieces based on row position
    (Row = 1, Value = 1);
    (Row = 2, Value = 1);
    (Row = 3, Value = 2);
    (Row = 4, Value = 3);
    (Row = 5, Value = 5);
    (Row = 6, Value = 7);
    (Row = 7, Value = 15).

piece_value('8', Row, Value) :-
    % Define values for X pieces based on row position
    (Row = 1, Value = 15);
    (Row = 2, Value = 10);
    (Row = 3, Value = 7);
    (Row = 4, Value = 5);
    (Row = 5, Value = 3);
    (Row = 6, Value = 2);
    (Row = 7, Value = 1).

piece_value('o', Row, Value) :-
    % Define values for X pieces based on row position
    (Row = 1, Value = 15);
    (Row = 2, Value = 7);
    (Row = 3, Value = 5);
    (Row = 4, Value = 3);
    (Row = 5, Value = 2);
    (Row = 6, Value = 1);
    (Row = 7, Value = 1).

calculate_piece_value(GameState, Piece, TotalValue) :-
    % Find all positions of the specified piece in the game state and their row indices
    findall((Piece, RowIndex), (nth1(RowIndex, GameState, Row), member(Piece, Row)), PiecesWithRow),
    % Calculate the values for each piece and row index
    findall(Value, (member((Piece, RowIndex), PiecesWithRow), piece_value(Piece, RowIndex, Value)), PieceValues),
    % Sum the values in the list
    sumlist(PieceValues, TotalValue).

value(GameState, 1, Value) :-
   calculate_piece_value(GameState, 'X', XTCount),
   calculate_piece_value(GameState, 'v', XWCount),
   calculate_piece_value(GameState, '8', OTCount),
   calculate_piece_value(GameState, 'o', OWCount),
   valid_moves(GameState, 1, Moves),
   length(Moves, MovesCount),
   (game_over(GameState,1) , Value is 1000;
   Value is (XTCount + XWCount - (OTCount + OWCount)*0.5 + MovesCount * 5)
   ).

value(GameState, 2, Value) :-
   calculate_piece_value(GameState, 'X', XTCount),
   calculate_piece_value(GameState, 'v', XWCount),
   calculate_piece_value(GameState, '8', OTCount),
   calculate_piece_value(GameState, 'o', OWCount),
   valid_moves(GameState, 2, Moves),
   length(Moves, MovesCount),
   (game_over(GameState,2) , Value is 1000;
   Value is (OTCount + OWCount - (XTCount + XWCount)*0.5 + MovesCount * 5)
   ).

% Level 1 -> easy mode
choose_move(GameState, Player, 1, Move) :-
    valid_moves(GameState, Player, ListOfMoves),
    random_member(Move, ListOfMoves).

choose_move(GameState, Player, 2, Move) :-
    valid_moves(GameState, Player, Moves), % Get the valid moves
    best_move(GameState, Player, 5, Moves, -10000, none, Move).

% Base case when there are no more moves to evaluate
best_move(_, _, _, [], BestValue, BestMove, BestMove) :- BestValue \= -10000.

best_move(GameState, Player, Depth, [Move | RestMoves], BestValue, CurrBestMove, BestMove) :-
    % Apply the move to get the new game state
    move(GameState, Player, Move, NewGameState),
    % Evaluate the new game state
    value(NewGameState, Player, Value),
    % Choose the move with the highest value
    (Value > BestValue ->
        NewBestValue is Value,
        NewBestMove = Move
    ;
        NewBestValue is BestValue,
        NewBestMove = CurrBestMove
    ),
    % Recursively evaluate the rest of the moves
    best_move(GameState, Player, Depth, RestMoves, NewBestValue, NewBestMove, BestMove).


    
    