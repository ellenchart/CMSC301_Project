.data
    _heap_test: .word 20 40
.text
.globl main

# Main logic
main:
# Test syscall 9: Heap Allocation
    la $t0, _heap_test # Load number of bytes to allocate
    lw $a0, 0($t0)
    addi $v0, $zero, 9 # Load syscall code 9 (heap allocation)
    syscall 

    addi $a0, $v0, 0
    addi $v0, $zero, 9 
    syscall