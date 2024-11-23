.data
.text
.globl main
main:
    addi $t0, $0, -244
    addi $t1, $0, -248
    addi $t2, $0, -252
    addi $t3, $0, 400 # frequency value 400Hz
    sw $t3, 0($t0) # set frequency      
    lw $t4, 0($t0) # do nothing         
    addi $t3, $0, 127 # volume value
    sw $t3, 0($t2) # set volume
    lw $t4, 0($t2) # do nothing  
    sw $t4, 0($t1) # enable buzzer      
    lw $t4, 0($t1) # do nothing                 