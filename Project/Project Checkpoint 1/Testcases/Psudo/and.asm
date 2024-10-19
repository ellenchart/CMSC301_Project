.data
.text
.align 2
.globl main 

init:
    # Test case: a = 6 (binary: 0110), b = 3 (binary: 0011)
    addi $s0, $zero, 6  # a = 6
    addi $s1, $zero, 3  # b = 3

main:
    # Perform bitwise AND: $t0 = $s0 & $s1
    and $t0, $s0, $s1

    # Print the result
    li $v0, 1
    move $a0, $t0
    syscall  # Should print 2 (binary: 0010)

    # Exit
    li $v0, 10
    syscall
