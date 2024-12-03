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

#Order:
#beq (doesnt branch)
#sub t1 = 2-1 = 1
#j while jump 
#beq 1!= 0 (doesnt branch)
#sub t1 = 1-1 = 0
#j while jump
#beq 0 = 0 (branch to beqWorks)

beqWorks:
while2: 
bne $t2, $t3, bneWorks
add $t2, $t2, $t0  #3 + 1
j while2

#Order:
#bne 3=3 (doesnt branch)
#add $t2 = 3+1 = 4
#j while jump
#bne 4 != 3 (branches to bneWorks)

bneWorks:
jal jalWorks

#Order: 
#jal (goes to jalWorks)

jalr jalrWorks

jalWorks:
addi $s0, $0, 0
sw $t3, 4($s0)
lw $t4, 4($s0)  #t4 should = $t3
jr $ra

#Order
#adds the address
#stores $t3 = 3 to address at $s0
#loads $t3 to $t4 #note t3 = t4
#jr brings us back to jal

#now we go to jalrWorks
#jalWorks ends the file


jalrWorks:

j end

end:
    addi $v0, $0, 10
    syscall