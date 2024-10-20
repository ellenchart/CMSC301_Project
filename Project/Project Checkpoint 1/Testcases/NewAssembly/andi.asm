.data
.text
.align 2
.globl main 

init:
    # Test case: a = 12 (1100 in binary), immediate = 5 (0101 in binary)
    addi $s0, $zero, 12  # a = 12

main:
    # Perform bitwise AND with immediate value 5, result should be 4 (0100 in binary)
    andi $t0, $s0, 5

    # Print the result
    addi $v0, $0, 1
    move $a0, $t0
    syscall  # Should print 4

    # Exit
    addi $v0, $0, 10
    syscall