# no practice modes implemented yet

.data
scoreMsg:  .asciiz "\nFinal score: "
correctMsg:   .asciiz "\n Correct! Score: "
wrongMsg:     .asciiz "\n Wrong! Score: "
slash10:   .asciiz "/10\n \n"

.text
.globl main

main:
    # seed RNG once with current time
    li   $v0, 30          # time in ms -> $a0
    syscall
    li   $v0, 40          # seed RNG with $a0
    syscall

    li   $s6, 0           # score = 0

    # get level map (10 bits)
    jal  rand_10bit
    move $s0, $v0

    li   $s2, 0           # level index 0..9

level_loop:
    beq  $s2, 10, show_score

    li   $t3, 9
    sub  $t3, $t3, $s2
    srlv $t4, $s0, $t3
    andi $t4, $t4, 1      # bit: 1 = bin->dec, 0 = dec->bin

    jal  rand_8bit
    move $s1, $v0         # current number

    bnez $t4, do_bin
    j    do_dec

do_bin:
    move $a0, $s1
    jal  draw_binary_board      # $v0 = user's decimal or -1
    move $t5, $v0
    beq  $t5, $s1, correct
    li $v0, 4
    la $a0, wrongMsg
    syscall

    li $v0, 1
    move $a0, $s6
    syscall

    li $v0, 4
    la $a0, slash10
    syscall

    j    advance

do_dec:
    move $a0, $s1
    jal  draw_decimal_board     # $v0 = parsed binary or -1
    move $t5, $v0
    beq  $t5, $s1, correct
    li $v0, 4
    la $a0, wrongMsg
    syscall

    li $v0, 1
    move $a0, $s6
    syscall

    li $v0, 4
    la $a0, slash10
    syscall

    j    advance

correct:
    li $v0, 4
    la $a0, correctMsg
    syscall
    addi $s6, $s6, 1
    li $v0, 1
    move $a0, $s6
    syscall
    
    li $v0, 4
    la $a0, slash10
    syscall

advance:
    addi $s2, $s2, 1
    j    level_loop

show_score:
    li   $v0, 4
    la   $a0, scoreMsg
    syscall

    li   $v0, 1
    move $a0, $s6
    syscall

    li   $v0, 4
    la   $a0, slash10
    syscall

    li   $v0, 10
    syscall
