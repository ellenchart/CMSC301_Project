.data
.text
.globl main

main:
    # Arithmetic operations
    addi $t1, $t2, -5 # $t1 = $t2 + (-5)
    add $t0, $t1, $t2 # $t0 = $t1 + $t2

    addi $t4, $zero, -5
    addi $t5, $zero, 3
    sub $t3, $t4, $t5 # $t3 = $t4 - $t5

    # Multiplication and Division
    addi $s3, $zero, 281938
    addi $s4, $zero, 283497
    mult $s3, $s4 # Multiply $s3 by 
    $s4, result in LO and HI
    mflo $s5 # Move LO to $s5
    mfhi $s6 # Move HI to $s6

    div $s3, $s4 
    mflo $s5 # Move LO (quotient) to $s5
    mfhi $s6 # Move HI (remainder) to $s6

    # Shift operations
    addi $s0, $zero, 10
    sll $t9, $s0, 4 # $t9 = $s0 << 4 (logical shift left by 4)

    addi $s2, $zero, 48
    srl $s1, $s2, 2 # $s1 = $s2 >> 2 (logical shift right by 2)

    # Comparison
    slt $t6, $s0, $s2

    # Logical Operations
    addi $t1, $zero, 78
    addi $t2, $zero, 29
    and $t0, $t1, $t2 # $t0 = $t1 AND $t2
    or $t0, $t1, $t2 # $t0 = $t1 OR $t2
    xor $t0, $t1, $t2 # $t0 = $t1 XOR $t2
    nor $t0, $t1, $t2 # $t0 = NOT($t1 OR $t2)