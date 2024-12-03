          .data #This is boilerplate stuff to get QTSPIM to read this file the right way
          .text
          .align 2
          .globl main 

#testing jal

main:
addi $t0, $0, 1
jal jumpTo
addi $t0, $0, 15
addi $t1 $0, 12
j end

jumpTo:
addi $t0, $0, 10
addi $t1 $0, 7
jr $ra

end:
addi $t2, $0, 5
addi $t3, $0, 6