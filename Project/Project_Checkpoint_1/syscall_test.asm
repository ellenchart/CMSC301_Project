.data
    _heap_test: .word 128
    _char_to_print: .word 65
    _test_melody: .word 262, 294, 330, 349, 392, 440, 494, 523, 0, 1

.text
.globl main

# Main logic
main:
    # Test syscall 0: Initialization
    addi $v0, $zero, 0     # Load syscall code 0 (initialize)
    syscall

    # Test syscall 1: Print Integer
    addi $a0, $zero, -12345   # Load test integer into $a0
    addi $v0, $zero, 1        # Load syscall code 1 (print integer)
    syscall

    # Test syscall 5: Read Integer
    addi $v0, $zero, 5        # Load syscall code 5 (read integer)
    syscall
    # Check $v0 for the value read.
    add $t0, $v0, $zero

    # Test syscall 9: Heap Allocation
    la $a0, _heap_test         # Load number of bytes to allocate
    lw $a0, 0($t1)                     
    addi $v0, $zero, 9        # Load syscall code 9 (heap allocation)
    syscall
    add $t2, $v0, $zero

    # Test syscall 11: Print Character
    la $a0, _char_to_print     # Load ASCII character into $a0
    lw $a0, 0($t3)                     
    addi $v0, $zero, 11       # Load syscall code 11 (print character)
    syscall

    # Test syscall 12: Read Character
    addi $v0, $zero, 12       # Load syscall code 12 (read character)
    syscall
    add $t4, $v0, $zero

    # Test syscall 13: Play Melody
    la $a0, _test_melody       # Load address of the melody into $a0
    addi $v0, $zero, 13       # Load syscall code 13 (play melody)
    syscall

    # End program
    addi $v0, $zero, 10       # Load syscall code 10 (end program)
    syscall                   # End program