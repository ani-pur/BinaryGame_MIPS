# ===============================
# drawBoard.asm (dynamic version)
# Prints 1 row of 8-bit boxes using random byte
# ===============================

.data
bitReps:    .asciiz " 128  64  32  16   8   4   2   1\n" 
topRow:     .asciiz "+---+---+---+---+---+---+---+---+\n"
midStart:   .asciiz "| "
midSep:     .asciiz " | "
endBox_newline:     .asciiz " \n"
bottomRow:  .asciiz "+---+---+---+---+---+---+---+---+\n"

.text
.globl main

main:
    # --- generate random number 0–255 ---
    li $v0, 42
    li $a1, 256
    syscall
    move $t0, $a0      # $t0 = random byte

    # print bit representations above topRow
    li $v0, 4
    la $a0, bitReps
    syscall
    
    # --- print top border ---
    li $v0, 4
    la $a0, topRow
    syscall

    # --- print middle row ---
    li $v0, 4
    la $a0, midStart
    syscall

    li $t1, 7           # bit index = 7 (MSB)
print_loop:
    srlv $t2, $t0, $t1   # shift right by bit index
    andi $t2, $t2, 1    # isolate lowest bit

    addi $a0, $t2, 48   # convert 0/1 to ASCII ('0' or '1')
    li $v0, 11          # print char syscall
    syscall

    # print separator (between boxes)
    li $v0, 4
    la $a0, midSep
    syscall

    addi $t1, $t1, -1
    bgez $t1, print_loop

    # end of binary boxes, print last column 
    li $v0, 4
    la $a0, endBox_newline
    syscall

    # print bottom border 
    li $v0, 4
    la $a0, bottomRow
    syscall

    # exit
    li $v0, 10
    syscall
