# Programação Funcional e em Lógica

## Game 

Murus Gallicus

## Authors 

- Andreia Filipa Gonçalves Silva up202108769 (50%)
- Miguel Morais Dionísio up202108788 (50%)
*Murus Gallicus_7*

# Installation and Execution

After the installation of SICStus Prolog 4.8, the consult command must be run on the main.pl file, with is inside the src folder.
Then, to start the game execute ``` play ``` predicate:

```
play.
```
Then you must only follow the instructions in the menu.

# Description of the game

Murus Gallicus is a two-player board game invented by Phil Leduc in 2009.
It's played on a 8x7 board.
There are two players: Light (Romans) and Dark (Gauls), each having 16 stones of the corresponding color.
In the implemented game Romans are represented as ```X``` and Gauls with ```O```.

There are two types of pieces: Towers, stacks of two stones represented in uppercase, and Walls, single stones in lowercase.
The start board is the next:

![image](https://github.com/andreiasilva66/FEUP-PFL-Murus-/assets/93837084/44743f79-b088-44fb-b351-20a2d0e73c58)

Walls cannot move but can block the opponent`s movement.
Towers can move in every direction, both orthogonal and diagonal. The destination cell must be empty or contain a friendly wall. In the last case, the friendly wall will move to the next position in that direction.
Towers can only move one cell per turn.

If a tower is adjacent to an enemy wall, it may capture it, sacrificing one of its stones and becoming a wall.

The objective of Murus Gallicus game is to reach the opposite row with one of the player's stones or leave the opponent without legal moves.

# Game Logic

## Internal Game State Representation

The game state is represented by a list of lists with the current board situation.

Initial State:
```
initial_state([
    ['X','X','X','X','X','X','X','X'],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    [' ',' ',' ',' ',' ',' ',' ',' '],
    ['O','O','O','O','O','O','O','O']
    ]).
```
Example of middle state:
```
    [['X',' ',' ',' ','X',' ','X','X'],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     [' ','X','x','o',' ',' ',' ',' '],
     [' ',' ',' ',' ','x',' ',' ',' '],
     [' ','o',' ','O',' ',' ','o',' '],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     ['O','O',' ',' ','O',' ',' ','O']]
```
Example of final state:
```
    [[' ',' ',' ',' ','X',' ','X','X'],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     [' ','X','x','o',' ',' ','O',' '],
     ['O',' ',' ',' ','x',' ',' ',' '],
     [' ','o',' ','O',' ',' ','o',' '],
     [' ',' ',' ',' ',' ',' ',' ',' '],
     [' ',' ','X',' ',' ',' ',' ','O']]
```
The game reach the final state because the X piece reached the opponent side.

## Game State Visualization

### Menu

The game apresents a start menu, where the player can choose to start playing, see the instructions or exit the game.
When the player chooses to start the game, the menu of the mode will appear (Human vs Human, Human vs Computer, etc), followed by the menu of difficulty of the computer, when it is a player.
The last menu before playing is to choose if the player will be player 1 or player 2, when they are playing aginst the computer.


### Input Validation


### Visualization


## Move Validation and Execution



## List of Valid Moves

## End of Game

## Game State Evaluation

## Computer plays

# Conclusions

# Bibliography
