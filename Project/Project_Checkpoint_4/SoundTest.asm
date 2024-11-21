.data
.text
.globl main
main:
    addi $t0, $0, 0xFFA4 
    li $t1, 440 # Set frequency to 440Hz
    sw $t1, 0($t0) 
    lw $t2, 0($t0) 
    addi $t0, $0, 0xFFAC
    li $t1, 127 # Set volume to max 
    sw $t1, 0($t0) 
    lw $t2, 0($t0) 
    j main 