.data
.text
.globl main

main:
    # sub
    addi $t0, $zero, 25
    addi $t1, $zero, 5
    sub $t2, $t0, $t1

    # and
    and $t3, $t0, $t1 # expect false

    # or
    or $t4, $t0, $t1 # expect

    # xor
    xor $t5, $t0, $t1
    
    # nor
    nor $s0, $t0, $t1
    
    #test sub, and, or, xor, nor 