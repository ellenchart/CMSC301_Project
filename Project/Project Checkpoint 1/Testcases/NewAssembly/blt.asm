.data
.text
.align 2
.globl main 

init:
    # Test case: a = 3, b = 5, should branch
    addi $s0, $zero, 3  # a = 3
    addi $s1, $zero, 5  # b = 5
main:
    ble $s0, $s1, end # branch if  3 < 5; should branch
    addi $s1, $0, -1

end:
    addi $v0, $zero, 10
    syscall #End the program


