# Binary Game (MIPS Assembly)

A terminal-based Binary Game implemented in MIPS assembly for the CS/SE 2340 term project. The game presents 10 rounds of binary-to-decimal and decimal-to-binary conversions on an ASCII board, validates user input, and tracks score out of 10.

## Repository Layout

- `main.asm` - program entry point and gameplay loop
- `rng.asm` - random number generation helpers
- `drawBoard.asm` - ASCII board rendering and user input parsing

## How to Run

1. Use MARS 4.5 or newer.
2. Open all three files in the same MARS session.
3. Make sure `main.asm` is set as the entry file.
4. Assemble, then Run.
5. Follow the prompts in the console.

Tested in MARS with:
- Syscall 30 to get time in milliseconds for seeding
- Syscall 40 to seed the RNG
- Syscall 42 for bounded random integers

## Gameplay

- The game runs 10 rounds. On each round a mode is chosen from a 10-bit level map.
- If the mode is binary to decimal, the board shows eight 0/1 cells. Enter the decimal value for the shown 8-bit number.
- If the mode is decimal to binary, the board shows an empty 8-cell lane and prints a decimal value. Enter the binary string for the 8-bit value.
- After each answer the game prints `Correct!` or `Wrong!` and the running score.
- At the end the game prints the final score as `Final score: X/10`.

Example of the binary-to-decimal board:

```
  128  64  32  16  8  4   2   1
+---+---+---+---+---+---+---+---+
| 1 | 0 | 1 | 1 | 0 | 1 | 0 | 1 |
+---+---+---+---+---+---+---+---+
Enter decimal:
```

Example of the decimal-to-binary board:

```
Decimal: 173

 128  64  32  16   8  4   2   1
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
Enter 8-bit binary:
```

## Input Rules and Validation

- Binary input accepts up to 8 characters composed of 0 and 1. Any other character or more than 8 bits is invalid.
- Decimal input must be an integer in the range 0 to 255.
- Invalid input is reported and counted as incorrect for that round.
- Valid input that does not match the hidden value is counted as wrong, without a penalty beyond the missed point.

## Design Overview

### Modules

- `main.asm`
  - Seeds the RNG once at startup using time.
  - Builds a 10-bit level map and iterates 10 rounds.
  - For each round, calls either `draw_binary_board` or `draw_decimal_board` and compares the returned value with the hidden 8-bit number.
  - Tracks and prints score.

- `rng.asm`
  - `rand_10bit` returns a bounded random number used as a 10-round mode map.
  - `rand_8bit` returns the current round's hidden 8-bit value.

- `drawBoard.asm`
  - `draw_binary_board(a0=value)` prints the ASCII board with the 8 bits of `value`, prompts for decimal, validates, and returns the parsed integer or -1 on invalid.
  - `draw_decimal_board(a0=value)` prints the ASCII board outline and the decimal `value`, prompts for an 8-bit binary string, validates and parses it, and returns the integer or -1 on invalid.

### Control Flow

1. Seed RNG and generate a 10-bit level map.
2. For round i in 0..9:
   - Generate an 8-bit value.
   - Choose mode from level map bit i.
   - Render the appropriate board and read user input.
   - If input parses and equals the hidden value, increment score and print `Correct!`. Otherwise print `Wrong!`.
3. Print final score and exit.

## How This Meets The Spec

- Random problems every run via MARS RNG with time-based seeding.
- ASCII board that labels 128 to 1 above eight cells.
- Two modes:
  - Binary to decimal: shows 8 bits and asks for decimal.
  - Decimal to binary: shows decimal and asks for 8-bit binary string.
- Input validation for both decimal and binary entries. Invalid input is flagged and scored as incorrect.
- Multi-module design with separate files for main loop, RNG, and UI/validation.

Notes:
- Timeout, graphics, and sound are not implemented.







