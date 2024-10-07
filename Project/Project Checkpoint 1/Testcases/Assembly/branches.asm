.data
.text

j main

equal:
    add $t4, $zero, $zero  # Reset $t4 to 0
    j end                  # Jump to the end

main:
    addi $t2, $0, 1
    bne $t2, $t3, notequal # If $t2 != $t3, go to "notequal"
    beq $t0, $t1, equal    # If $t0 == $t1, go to "equal"
    j end

notequal:
    addi $t4, $zero, 99     # Set $t4 to 99

addi $v0, $0, 1
add $a0, $0, $0
while:
    beq $a0, $t4, endwhile
    syscall #exit 
    addi $a0, $a0, 1
    j while
endwhile:

end:
    addi $v0, $zero, 10
    syscall #End the program

