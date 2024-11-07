          .data #This is boilerplate stuff to get QTSPIM to read this file the right way
          .text
          .align 2
          .globl main 

#testing lw, sw, j, jal, jr, jalr, bne, beq


main:
addi $t0, $zero, 1
addi $t1, $zero, 2 
addi $t2, $zero, 3
addi $t3, $zero, 3

while:
beq $t1, $0, beqWorks
sub $t1, $t1, $t0   #2->1->0
j while

#note: t1 is 0 now

beqWorks:
while2: 
bne $t2, $t3, bneWorks
add $t2, $t2, $t1  #3 + 1 
j while2

#note: t2 = 4

bneWorks:
jal jalWorks

jalr jalrWorks

jalWorks:
addi $s0, $0, 0
sw $t3, 4($s0)
lw $t4, 4($s0)  #t4 should = $t3
jr $ra

jalrWorks:

j end

end:
    addi $v0, $0, 10
    syscall