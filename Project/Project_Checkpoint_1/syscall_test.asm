.data
heap_test: .word 128      # Number of bytes to allocate for syscall9
char_to_print: .word 65   # ASCII 'A' for syscall11
test_melody: .word 262, 294, 330, 349, 392, 440, 494, 523, 0  # Melody for syscall13

.text

# Entry point
j main

# Define label for equal case
equal:
    add $t4, $zero, $zero  # Reset $t4 to 0
    j end                  # Jump to the end

# Main logic
main:
    # Test syscall 0: Initialization
    addi $v0, $zero, 0     # Load syscall code 0 (initialize)
    jal _syscallStart_

    # Test syscall 1: Print Integer
    addi $a0, $zero, -12345   # Load test integer into $a0
    addi $v0, $zero, 1        # Load syscall code 1 (print integer)
    jal _syscallStart_

    # Test syscall 5: Read Integer
    addi $v0, $zero, 5        # Load syscall code 5 (read integer)
    jal _syscallStart_
    # Check $v0 for the value read.

    # Test syscall 9: Heap Allocation
    lw $a0, heap_test         # Load number of bytes to allocate
    addi $v0, $zero, 9        # Load syscall code 9 (heap allocation)
    jal _syscallStart_

    # Test syscall 11: Print Character
    lw $a0, char_to_print     # Load ASCII character into $a0
    addi $v0, $zero, 11       # Load syscall code 11 (print character)
    jal _syscallStart_

    # Test syscall 12: Read Character
    addi $v0, $zero, 12       # Load syscall code 12 (read character)
    jal _syscallStart_

    # Test syscall 13: Play Melody
    la $a0, test_melody       # Load address of the melody into $a0
    addi $v0, $zero, 13       # Load syscall code 13 (play melody)
    jal _syscallStart_

    # End program
    addi $v0, $zero, 10       # Load syscall code 10 (end program)
    syscall                   # End program

end:
    addi $v0, $zero, 10       # Load syscall code 10 (end program)
    syscall
