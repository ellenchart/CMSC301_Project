.data
.text
.globl main

main:
    # Arithmetic operations
    add $t0, $t1, $t2 # $t0 = $t1 + $t2
    addi $t1, $t2, -5 # $t1 = $t2 + (-5)
    sub $t3, $t4, $t5 # $t3 = $t4 - $t5

    # Multiplication and Division
    mult $s3, $s4 # Multiply $s3 by $s4, result in LO and HI
    mflo $s5 # Move LO to $s5
    mfhi $s6 # Move HI to $s6
    div $s7, $a0 # Divide $s7 by $a0, result in LO and HI
    mflo $s5 # Move LO (quotient) to $s5
    mfhi $s6 # Move HI (remainder) to $s6

    # Shift operations
    sll $t9, $s0, 4 # $t9 = $s0 << 4 (logical shift left by 4)
    srl $s1, $s2, 2 # $s1 = $s2 >> 2 (logical shift right by 2)

    # Comparison
    slt $t6, $t7, $t8 # $t6 = ($t7 < $t8) ? 1 : 0

    # Additional Arithmetic
    addi $t1, $t1, 4 # $t1 = $t1 + 4
    addi $t2, $t2, 5 # $t2 = $t2 + 5

    # Logical Operations
    and $t0, $t1, $t2 # $t0 = $t1 AND $t2
    addi $t1, $t1, 1 # $t1 = $t1 + 1
    addi $t2, $t2, 5 # $t2 = $t2 + 5
    or $t0, $t1, $t2 # $t0 = $t1 OR $t2
    xor $t0, $t1, $t2 # $t0 = $t1 XOR $t2
    nor $t0, $t1, $t2 # $t0 = NOT($t1 OR $t2)

end:
    addi $v0, $zero, 10 # Syscall to exit the program
    syscall