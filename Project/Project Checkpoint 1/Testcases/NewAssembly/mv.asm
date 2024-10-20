.data
.text
.align 2
.globl main 

# mv is add with $0
init:
    # Test case: a = 10, b = 0
    addi $s0, $zero, 10  # a = 9
    addi $s1, $zero, 0  # b = 0

main:
    mv $s0, $s1 # s1 should now hold value 10
    
    addi $v0, $0, 10
    syscall