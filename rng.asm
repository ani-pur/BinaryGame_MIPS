
.text
.globl rand_10bit
.globl rand_8bit

# Return: $v0, value between [0,$a1] - can change to adjust level bias
rand_10bit:
    li   $v0, 42          # random int
    li   $a1, 1024        # upper bound (exclusive)
    syscall               # result in $a0
    move $v0, $a0         # return in v0
    jr   $ra

# Return: $v0 in [0,255]
rand_8bit:
    li   $v0, 42
    li   $a1, 256
    syscall
    move $v0, $a0
    jr   $ra
