.data
.text
.align 2
.globl main 

init:
    # Test case: a = 3, b = 5
    addi $s0, $zero, 3  # a = 3
    addi $s1, $zero, 5  # b = 5
main:
    sle $s2, $s0, $s1 # 1 if  3 <= 5, 0 otherwise; should be 1
    sle $s3, $s1, $s0 # 1 if  5 <= 3, 0 otherwise; should be 0
    sle $s4, $s1, $s1 # 1 if  5 <= 5, 0 otherwise; should be 1
    
end:
    addi $v0, $zero, 10
    syscall #End the program


