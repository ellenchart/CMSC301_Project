.data
.text
.align 2
.globl main 

init:
    # Test case: a = 8 (1000 in binary), immediate = 3 (0011 in binary)
    addi $s0, $zero, 8  # a = 8

main:
    # OR $s0 with immediate value 3, result should be 11 (1011 in binary)
    ori $t0, $s0, 3

    # Print the result
    li $v0, 1
    move $a0, $t0
    syscall  # Should print 11

    # Exit
    li $v0, 10
    syscall
