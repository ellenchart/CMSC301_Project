.data
.text
.align 2
.globl main 

init:
    # Test case: a = 2, b = 5, should not set $t0 to 1
    addi $s0, $zero, 2  # a = 2
    addi $s1, $zero, 5  # b = 5

main:
    # Set $t0 to 1 if $s0 >= $s1
    sge $t0, $s0, $s1

    # Print the result
    li $v0, 1
    move $a0, $t0
    syscall  # Should print 0 since a < b

    # Exit
    li $v0, 10
    syscall
