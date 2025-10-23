# ===============================
# drawBoard.asm
# Prints one row of ASCII boxes
# ===============================

.data
topRow:     .asciiz "+---+---+---+---+---+---+---+---+-------+\n"
midRow:     .asciiz "|   |   |   |   |   |   |   |   |       |\n"
bottomRow:  .asciiz "+---+---+---+---+---+---+---+---+-------+\n"
newline:    .asciiz "\n"

.text
.globl main

main:
    # print top row
    li $v0, 4
    la $a0, topRow
    syscall

    # print middle row
    li $v0, 4
    la $a0, midRow
    syscall

    # print bottom row
    li $v0, 4
    la $a0, bottomRow
    syscall

    # print a newline for spacing
    li $v0, 4
    la $a0, newline
    syscall

    # exit program
    li $v0, 10
    syscall
