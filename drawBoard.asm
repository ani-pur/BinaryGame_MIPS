
.data
bitReps:          .asciiz " 128  64  32  16   8   4   2   1\n"
topRow:           .asciiz "+---+---+---+---+---+---+---+---+\n"
midStart:         .asciiz "| "
midSep:           .asciiz " | "
midRow:       .asciiz "  |   |   |   |   |   |   |   |  "
endBox:           .asciiz " |\n"
bottomRow:        .asciiz "+---+---+---+---+---+---+---+---+\n"
promptBinToDec:   .asciiz "Enter decimal: "
promptDecToBin:   .asciiz "Enter 8-bit binary: "
decimalLabel:     .asciiz "Decimal: "
invalidMsg:       .asciiz "Invalid input. Counting as incorrect.\n"
binBuf:           .space  16

.text
.globl draw_binary_board
.globl draw_decimal_board

# ------------------------------------------------------
# draw_binary_board
# In : $a0 = 8-bit value to show as boxes
# Out: $v0 = user's decimal int (0..255) or -1 if invalid
# ------------------------------------------------------
draw_binary_board:
    move $t0, $a0            # value to display

    li   $v0, 4
    la   $a0, bitReps
    syscall

    li   $v0, 4
    la   $a0, topRow
    syscall

    li   $v0, 4
    la   $a0, midStart
    syscall

    li   $t1, 7              # bit index (MSB..LSB)
dbb_bits:
    srlv $t2, $t0, $t1
    andi $t2, $t2, 1
    addi $a0, $t2, 48        # '0'/'1'
    li   $v0, 11
    syscall

    beqz $t1, dbb_after_cells
    li   $v0, 4
    la   $a0, midSep
    syscall
dbb_after_cells:
    addi $t1, $t1, -1
    bgez $t1, dbb_bits

    li   $v0, 4
    la   $a0, endBox
    syscall

    li   $v0, 4
    la   $a0, bottomRow
    syscall

    li   $v0, 4
    la   $a0, promptBinToDec
    syscall

    li   $v0, 5              # read int (decimal)
    syscall
    move $t6, $v0

    bltz $t6, dbb_bad
    li   $t7, 255
    bgt  $t6, $t7, dbb_bad

    move $v0, $t6
    jr   $ra

dbb_bad:
    li   $v0, 4
    la   $a0, invalidMsg
    syscall
    li   $v0, -1
    jr   $ra

# ------------------------------------------------------
# draw_decimal_board
# In : $a0 = 8-bit value to show as decimal
# Out: $v0 = parsed binary (0..255) or -1 if invalid
# ------------------------------------------------------
draw_decimal_board:
    move $t0, $a0

    li   $v0, 4
    la   $a0, decimalLabel
    syscall
    
    li   $v0, 1
    move $a0, $t0
    syscall

    li   $v0, 11
    li   $a0, 10
    syscall
    
    # print bit representations
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
    

    # print separator (between boxes)
    li $v0, 4
    la $a0, midRow
    syscall

    # end of binary boxes, print last column 
    li $v0, 4
    la $a0, endBox
    syscall

    # print bottom border 
    li $v0, 4
    la $a0, bottomRow
    syscall

    li   $v0, 4
    la   $a0, promptDecToBin
    syscall

    li   $v0, 8              # read string
    la   $a0, binBuf
    li   $a1, 16
    syscall

    la   $t1, binBuf
    li   $t2, 0              # result
    li   $t3, 0              # bit count

parse_loop:
    lb   $t4, 0($t1)
    beqz $t4, parse_done
    beq  $t4, 10, parse_done
    beq  $t4, 13, parse_done

    li   $t5, '0'
    beq  $t4, $t5, got_zero
    li   $t5, '1'
    beq  $t4, $t5, got_one
    j    parse_bad

got_zero:
    bge  $t3, 8, parse_bad
    sll  $t2, $t2, 1
    addi $t3, $t3, 1
    addi $t1, $t1, 1
    j    parse_loop

got_one:
    bge  $t3, 8, parse_bad
    sll  $t2, $t2, 1
    addi $t2, $t2, 1
    addi $t3, $t3, 1
    addi $t1, $t1, 1
    j    parse_loop

parse_bad:
    li   $v0, 4
    la   $a0, invalidMsg
    syscall
    li   $v0, -1
    jr   $ra

parse_done:
    move $v0, $t2
    jr   $ra
