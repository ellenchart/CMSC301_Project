.data
.text
.globl main
main:
addi $t0, $0, 10 
sw $t0, -224($0) # x-coord = 10
sw $t0, -220($0) # y-coord = 10
addi $t1, $0, 16 # red
sw $t1, -216($0) # set color
sw $t0, -212($0) # write pixel

