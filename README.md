# Binary Game (MIPS Assembly)

A terminal based Binary Game implemented in MIPS assembly for my Computer Architecture course (term project). The game presents 10 rounds of binary to decimal and decimal to binary conversions on an ASCII board, validates user input, and tracks score out of 10.

## Layout

- `main.asm` - program entry point and gameplay loop
- `rng.asm` - random number generation functions
- `drawBoard.asm` - ASCII board rendering and user input parsing

## How to Run

1. Use MARS 4.5 or newer.
2. Open all three files in the same MARS session.
3. Make sure `main.asm` is set as the entry file.
4. Assemble, then Run.
5. Follow the prompts in the console.


## Gameplay

- The game runs 10 rounds. On each round a mode is chosen from a 10-bit level map.
- If the mode is binary to decimal, the board shows eight 0/1 cells. Enter the decimal value for the shown 8-bit number.
- If the mode is decimal to binary, the board shows an empty 8-cell lane and prints a decimal value. Enter the binary string for the 8-bit value.
- After each answer the game prints `Correct!` or `Wrong!` and the running score.
- At the end the game prints the final score as `Final score: /10`.

Example of binary to decimal board:

```
  128  64  32  16  8  4   2   1
+---+---+---+---+---+---+---+---+
| 1 | 0 | 1 | 1 | 0 | 1 | 0 | 1 |
+---+---+---+---+---+---+---+---+
Enter decimal:
```

Example of decimal to binary board:

```
Decimal: 173

 128  64  32  16   8  4   2   1
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
Enter 8-bit binary:
```


## Design Overview

### Modules

- `main.asm`
  - Seeds rng once at startup using system time
  - Builds 10 bit level map and iterates 10 rounds
  - For each round, calls `draw_binary_board` or `draw_decimal_board` and compares the returned value with the hidden 8-bit number
  - Tracks and prints score

- `rng.asm`
  - `rand_10bit` returns a bounded random number used as a 10round mode map
  - `rand_8bit` returns the current round's hidden 8bit value
    
### 10Bit Level Map Logic

At the start of each game, the program generates a single **10bit value** that acts as a compact blueprint for the entire session.
This value can be thought of as a short binary string, where each bit represents one round of gameplay.
The program reads these bits one by one, starting from the least significant bit, and uses them to decide which type of round to run.  
If the current bit is **0**, the game calls routine that displays a binary value and asks for its decimal form
If the bit is **1**, the game calls routine that shows a decimal number and asks for its binary equivalent

This design allows a single 10bit number to define the entire 10 round sequence without requiring multiple random calls or branching logic spread throughout the code.  
It also makes it easy to bias or control the ratio between the two round types by adjusting the upper bound for the rng through which map is generated.  
Each round operates independently but follows the same pattern: read a bit, call the corresponding function from `drawBoard.asm`, and validate the player’s answer against the 8-bit random number from `rng.asm`.

Together, these parts create a modular structure where:
- `rng.asm` handles random number generation and game structure
- `drawBoard.asm` manages board display and user input
- `main.asm` coordinates overall flow using the level map to decide which routines to call 


Notes:
- Timeout, graphics, and sound are not implemented. Wanted to use mario soundtracks but couldn't find the time rip







