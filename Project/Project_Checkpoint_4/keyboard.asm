.data
.text
.globl main
main:
# type two characters on keyboard first
lw $t0, -236($0) # get first char in t0
sw $0, -240($0)
lw $t1, -236($0) # get second char in $t1
sw $0, -240($0)
addi $t2, $0, 1 # set to non-zero to see change
lw $t2, -236($0) # no char, so set t2 to 0
