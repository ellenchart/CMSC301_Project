#joystickController test
.data
.text
.globl main

main:
addi $t0, $zero, -176   #x coordinate address
addi $t1, $zero, -172   #y coordinate address

lw $t2, 0($t0)              #load X data
lw $t3, 0($t1)              #load Y data

sw $t2, 0($t0)              #we don't want it to do this if we = 1
sw $t3, 0($t1)              #we don't want it to do this if we = 1


addi $t4, $zero, -164  #fake address

lw $t2, 0($t4)              #this should not write anything to DataToBus
