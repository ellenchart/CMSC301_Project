.data
array: .word 10, 20, 30, 40 # Static memory for testing
.text

main:
    la $t0, array          # Load address of array into $t0
    lw $t1, 0($t0)         # Load word from array[0] into $t1
    sw $t1, 4($t0)         # Store $t1 into array[1]
    addi $t2, $t0, 8       # $t2 points to array[2]
    lw $t3, -4($t2)        # Store array[1] into $t3

end:
    addi $v0, $zero, 10
    syscall #End the program

