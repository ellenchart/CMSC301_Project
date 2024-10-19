.data
.text
.align 2
.globl main 

init:
    # Test case: a = 5, b = 3, should branch
    addi $s0, $zero, 5  # a = 5
    addi $s1, $zero, 3  # b = 3

main:
    # Check if $s0 >= $s1
    bge $s0, $s1, BranchTaken

    # If not branched, set $s2 = 0
    addi $s2, $zero, 0
    j End

BranchTaken:
    # If branched, set $s2 = 1
    addi $s2, $zero, 1

End:
    # Print the result
    li $v0, 1
    move $a0, $s2
    syscall  # Should print 1 if branch was taken, 0 otherwise

    # Exit
    li $v0, 10
    syscall
