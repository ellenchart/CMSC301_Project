.data
.text
.globl main
main:
addi $t0, $0, 67108720
sw $0, 0($t0)
sw $0, 0($t0)
lw $t1, 0($t0)
addi $t0, $0, 67108720
sw $0, 0($t0)
