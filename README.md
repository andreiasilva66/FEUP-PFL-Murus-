# Programação Funcional e em Lógica

## Game 

Murus Gallicus

## Authors 

- Andreia Filipa Gonçalves Silva up202108769 (50%)
- Miguel Morais Dionísio up202108788 (50%)  
*Murus Gallicus_7*

## Installation and Execution

After the installation of SICStus Prolog 4.8, the consult command must be run on the main.pl file, which is inside the src folder.
To start the game execute ``` play ``` predicate:

```prolog
play.
```

Then follow the instructions in the menu.

## Description of the game

Murus Gallicus is a two-player board game invented by Phil Leduc in 2009.
It's played on a 8x7 board.
There are two players: Light (Romans) and Dark (Gauls), each having 16 stones of the corresponding color.

There are two types of pieces: Towers, stacks of two stones, and Walls, single stones. In the implemented game Romans are represented as ```X``` and ```v``` and Gauls as ```8``` and ```o```, towers and walls respectively.
The start board is the following:

![image](https://github.com/andreiasilva66/FEUP-PFL-Murus-/assets/93837084/44743f79-b088-44fb-b351-20a2d0e73c58)

There are two kind of moves a player can make: <br>

1 - Move a tower by distributing its two stones from its initial cell into the two nearest cells in any straight direction (orthogonal or diagonal). Each destination cell must be empty or contain a friendly wall. <br>
2 - Sacrifice a tower stone to remove an adjacent (orthogonal or diagonal) enemy wall. Sacrifice is not forced by the presence of an adjacent enemy wall.

The objective of Murus Gallicus game is to reach the opposite row with one of the player's stones or leave the opponent without legal moves.

## Game Logic

### Internal Game State Representation

The game state is represented by a 8x7 matrix, that contains the current state of the board. It's a crucial argument in most predicates in the implementation.

Initial State: The board without any moves.

```prolog
initial_state([
    ['X','X','X','X','X','X','X','X'],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    ['8','8','8','8','8','8','8','8']
    ]).
```

Example of GameState during the game:

```prolog
    [['X',' ',' ',' ','X',' ','X','X'],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     [' ','X','v','o',' ',' ',' ',' '],
     [' ',' ',' ',' ','v',' ',' ',' '],
     [' ','o',' ','8',' ',' ','o',' '],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     ['8','8',' ',' ','8',' ',' ','8']]
```

Example of final GameState:

```prolog
    [[' ',' ',' ',' ','X',' ','X','X'],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     [' ','X','v','o',' ',' ','8',' '],
     ['8',' ',' ',' ','x',' ',' ',' '],
     [' ','o',' ','8',' ',' ','o',' '],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     [' ',' ','X',' ',' ',' ',' ','8']]
```

In this case game reach the final state because the X piece reached the opponent side.

## Game State

### Menu

The game presents a start menu, where the player can choose to start playing, see the instructions or exit the game.
When the player chooses to start the game, the menu of the mode will appear (Human vs Human, Human vs Computer, etc), followed by the menu of difficulty of the computer, when appropriate.

## Visualization

Game state visualization is made via a set of functions that print the whole board and line and column indicators. The display_game/1 predicate is responsible for printing the game board to the console.

It takes a GameState as input. The predicate first prints a header row with the column numbers, and then iterates over each row of the GameState to print the contents of each cell. The continueDisplayBoard/2 predicate is used to iterate over each row of the GameState. It first prints the row number, followed by a vertical bar (|), and then iterates over each cell in the row to print its contents. The predicate then prints another vertical bar to separate the cells. After printing all the cells in the row, the continueDisplayBoard/2 predicate prints a horizontal line to separate the rows, and then recursively calls itself with the next row of the GameState. The drawLine/1 and drawLine/2 predicates are helper predicates used by continueDisplayBoard/2 to print the contents of each cell in a row. Finally, the display_game/1 predicate calls continueDisplayBoard/2 with the GameState and a starting row number of 1 to print the entire game board. The result is as follows:

![image](https://github.com/andreiasilva66/FEUP-PFL-Murus-/)

## Input Validation

Every input in the project is expected to be part of a set of valid inputs, so validation is performed in the predicate where the input is being read, all throughout the implementation. For example:

```prolog
read(Dir),
    (
        Dir = 1 -> X2 is X, Y2 is Y-1;
        Dir = 2 -> X2 is X, Y2 is Y+1;
        Dir = 3 -> X2 is X-1, Y2 is Y;
        Dir = 4 -> X2 is X+1, Y2 is Y;
        Dir = 5 -> X2 is X-1, Y2 is Y-1;
        Dir = 6 -> X2 is X+1, Y2 is Y-1;
        Dir = 7 -> X2 is X-1, Y2 is Y+1;
        Dir = 8 -> X2 is X+1, Y2 is Y+1;
        write("Invalid Direction"), nl, receive_move(X, Y, X2, Y2)
    ).
```

## Move Validation and Execution

The game is implemented in a single cycle per gamemode, after an auxiliar function creates and displays the game board and starts the round count. The counting of rounds is only relevant to keep track of players' turns, as there is no round limit.

```prolog
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
```

 Move validation and execution is performed through ```validate-move(GameState, Player, Move)``` and ```execute_move(GameState, Player, Move)``` respectively.
 They are both called in ```move``` predicate. The argument move has the format of (X, Y)-D where X, Y the coordinates of the tower the player wants to move, and direction takes values 1 through 8, corresponding to all possible directions.

 ```prolog
move(GameState, Player, Move, NewGameState) :-
    validate_move(GameState, Player, Move),
    execute_move(GameState,Player, Move, NewGameState).
```

```validate_move``` validates the move the player wants to make, considering the game rules. It checks if the player is picking a tower of his, and if the move is legal. It then proceeds to calculate both destination slots according to the direction the player chose. There are two predicates, one for each player.

```prolog
validate_move(GameState, 1, (X,Y)-D) :-
    X > 0, X < 9,
    Y > 0, Y < 8,
    D > 0, D < 9,
    
    (D = 1 -> X1 is X, Y1 is Y-1, X2 is X, Y2 is Y-2;(
        D = 2 -> X1 is X, Y1 is Y+1, X2 is X, Y2 is Y+2;(
            D = 3 -> X1 is X-1, Y1 is Y, X2 is X-2, Y2 is Y;(
                D = 4 -> X1 is X+1, Y1 is Y, X2 is X+2, Y2 is Y;(
                    D = 5 -> X1 is X-1, Y1 is Y-1, X2 is X-2, Y2 is Y-2;(
                        D = 6 -> X1 is X+1, Y1 is Y-1, X2 is X+2, Y2 is Y-2;(
                            D = 7 -> X1 is X-1, Y1 is Y+1, X2 is X-2, Y2 is Y+2;(
                                D = 8 -> X1 is X+1, Y1 is Y+1, X2 is X+2, Y2 is Y+2
                            )))))))),

    X1 > 0, X1 < 9, Y1 > 0, Y1 < 8,
    X2 > 0, X2 < 9, Y2 > 0, Y2 < 8,

    getPiece(GameState, X, Y, Org),
    (Org = 'X'),
    getPiece(GameState, X1, Y1, Dest1),
    (Dest1 = 'o';
    getPiece(GameState, X2, Y2, Dest2),
    (
        (Dest1 = ' ', Dest2 = ' ');
        (Dest1 = 'v', Dest2 = 'v');
        (Dest1 = 'v', Dest2 = ' ');
        (Dest1 = ' ', Dest2 = 'v')
    )).
```

```execute_move``` executes the move after it's been validated. It's quite straight forward, removes what needs removing and places what needs placing.

## List of Valid Moves

The predicate ```valid_moves(GameState, PLayer, ListOfMoves)``` obtains a list of valid moves. The predicate findall is used for this purpose.

```prolog
valid_moves(GameState, Player, ListOfMoves):-
  findall((X,Y)-D, (between(1, 8, X), between(1, 7, Y), between(1, 8, D), validate_move(GameState, Player, (X,Y)-D)), ListOfMoves).
```

It stores all (X,Y)-D values that can compose moves that pass ```validate_move```.

## End of Game

The game ends when a player reaches the other side of the board or when there are no valid moves left.

```prolog
game_over(GameState, Winner) :-
   reach_opposite_row(GameState, Winner).

game_over(GameState, Winner) :-
   valid_moves(GameState, 1, []),
   Winner = 2.

game_over(GameState, Winner) :-
   valid_moves(GameState, 2, []),
   Winner = 1.
```

The predicates ```reach_oposite_row``` will tell us if there is a piece of a given player in the other side of the board. For example:

```prolog
reach_opposite_row(GameState, 1) :-
   getPiece(GameState, _ , 7, 'X').
```

The ```game_over``` predicates are called in the cycle when appropriate, as seen above in ***Move Validation and Execution***.

## Game State Evaluation

A given GameState is evaluated assigning value to pieces based on their board position. The values are as follows, and invert depending on the side of the piece. They are obtained in the ```piece_value/3``` predicates.

```prolog
piece_value('o', Row, Value) :-
    (Row = 1, Value = 15);
    (Row = 2, Value = 7);
    (Row = 3, Value = 5);
    (Row = 4, Value = 3);
    (Row = 5, Value = 2);
    (Row = 6, Value = 1);
    (Row = 7, Value = 1).
```

We found that this would be an appropriate method for evaluating the board, since the main objective of the game is to reach the other side.
The predicates ```value(GameState, Player, Value)``` are responsible for this evaluation.  
Value is calculated based on the total value of each type of piece for the current player and the opponent, the number of valid moves for the current player, and whether the game is over or not. If the game is over and the current player has won, the Value is set to 1000. Otherwise, the Value is calculated as the difference between the total value of the current player's pieces and the opponent's pieces, adjusted by the number of valid moves for the current player.  
Essentially, the Value score represents the advantage or disadvantage of the player whose turn it is. It's implemented as follows:

```prolog
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

calculate_piece_value(GameState, Piece, TotalValue) :-
    findall((Piece, RowIndex), (nth1(RowIndex, GameState, Row), member(Piece, Row)), PiecesWithRow),
    findall(Value, (member((Piece, RowIndex), PiecesWithRow), piece_value(Piece, RowIndex, Value)), PieceValues),
    sumlist(PieceValues, TotalValue).
```

The ```calculate_piece``` predicate finds all positions of the specified piece in the game state and their row indices, calculates the values for each piece and row index ans sums the values in the list.

## Computer plays

### Random Mode

The computer makes random moves. Simply picks a move from the list of valid moves.

```prolog
choose_move(GameState, Player, 1, Move) :-
    valid_moves(GameState, Player, ListOfMoves),
    random_member(Move, ListOfMoves).
```

### Smart Mode

The computer bases its moves on the evaluation explained above. ```best_move(GameState, Player, Depth, [Move | RestMoves], BestValue, CurrBestMove, BestMove)``` is a predicate used to select the best move for the computer player based on the current game state. The parameter ```Depth``` is used to limit the depth of the search tree when evaluating potential moves. It "hypothetically" applies all moves to current GameState, to calculate the value of each outcome, and choose the best possible move according to our evaluation parameters. The goal is to maximize the computer player's advantage. It does so recursively until the limit of the depth search is reached or there are more valid moves to evaluate. The implementation is as follows:

```prolog
choose_move(GameState, Player, 1, Move) :-
    valid_moves(GameState, Player, ListOfMoves),
    random_member(Move, ListOfMoves).

choose_move(GameState, Player, 2, Move) :-
    valid_moves(GameState, Player, Moves),
    best_move(GameState, Player, 5, Moves, -10000, none, Move).


best_move(_, _, _, [], BestValue, BestMove, BestMove) :- BestValue \= -10000.

best_move(GameState, Player, Depth, [Move | RestMoves], BestValue, CurrBestMove, BestMove) :-
    move(GameState, Player, Move, NewGameState),
    value(NewGameState, Player, Value),
    (Value > BestValue ->
        NewBestValue is Value,
        NewBestMove = Move
    ;
        NewBestValue is BestValue,
        NewBestMove = CurrBestMove
    ),
    best_move(GameState, Player, Depth, RestMoves, NewBestValue, NewBestMove, BestMove).

```

## Conclusions

We believe we developed a competent implementation of the Murus Gallicius boardgame. It can be played against another player, against a computer, or simply put the computer playing against itself.  
However, we are aware that our evaluation system has its limitations. It values piece position and results in computer plays that tend to prioritize board progression, and resulting in a poor defense. It also results in similar plays when the computer is playing against itself.  

If we were to continue the development of this project, our main focus would be to improve the evaluation system, studying the game better and understanding how it could be done.

## Bibliography

The rules of the implemented game were consulted from:
- https://www.iggamecenter.com/en/rules/murusgallicus