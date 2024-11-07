.data
.text
.globl main

main:
    addi $t0, $zero, 3
    addi $t1, $zero, 6
    sub $t2, $t0, $t1
    sub $t3, $t1, $t0