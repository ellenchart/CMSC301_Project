.data
.text
.align 2
.globl main 

init:
    # Test case: a = 9 (1001 in binary), b = 6 (0110 in binary)
    addi $s0, $zero, 9  # a = 9
    addi $s1, $zero, 6  # b = 6

main:
    # Perform bitwise OR between $s0 and $s1, result should be 15 (1111 in binary)
    or $t0, $s0, $s1

    # Print the result
    li $v0, 1
    move $a0, $t0
    syscall  # Should print 15

    # Exit
    li $v0, 10
    syscall
