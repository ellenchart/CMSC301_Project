.data
.text
.globl main
main:
    addi $t0, $0, 67108715
    addi $t1, $0, 67108716
    addi $t2, $0, 67108717
    addi $t3, $0, 400 # set frequency to 440Hz
    sw $t3, 0($t0)           
    lw $t4, 0($t0)           
    addi $t3, $0, 127 # set volume
    sw $t3, 0($t2)
    lw $t4, 0($t2)  
    addi $t4, $0, 1 # enable buzzer
    sw $t4, 0($t1)         
    lw $t4, 0($t1)                   