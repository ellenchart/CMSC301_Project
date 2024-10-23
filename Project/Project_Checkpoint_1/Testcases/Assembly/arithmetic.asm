.data 
.text 
.globl main

main:
    add $t0, $t1, $t2      # $t0 = $t1 + $t2
    addi $t1, $t2,-5       # $t1 = $t2 + -5
    sub $t3, $t4, $t5      # $t3 = $t4 - $t5
    slt $t6, $t7, $t8      # $t6 = ($t7 < $t8) ? 1 : 0
    sll $t9, $s0, 4        # $t9 = $s0 << 4 (logical shift left)
    srl $s1, $s2, 2        # $s1 = $s2 >> 2 (logical shift right)
    mult $s3, $s4          # Multiply $s3 by $s4, result in LO and HI
    mflo $s5               # Move LO to $s5
    mfhi $s6               # Move HI to $s6
    div $s7, $a0           # Divide $s7 by $a0, result in LO and HI

end:
    addi $v0, $zero, 10
    syscall #End the program