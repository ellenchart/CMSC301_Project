.data
    test: .word 12
.text
.align 2
.globl main 

init:
    # Test case: a = 10, b = 0
    addi $s0, $zero, 0  # a = 9
    addi $s1, $zero, 0  # b = 0

main:
    ld $s0, test # load 12 into s0 with overflow into s1
    
    addi $v0, $0, 10
    syscall