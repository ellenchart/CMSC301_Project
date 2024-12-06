.data
# Test data for syscalls
heap_test: .word 128      # Number of bytes to allocate for syscall9
char_to_print: .word 65   # ASCII 'A' for syscall11
test_melody: .word 262, 294, 330, 349, 392, 440, 494, 523, 0  # Melody for syscall13

.text
main:
    # Test syscall 0: Initialization
    addi $v0, $0, 0        # Load syscall code 0 (initialize)
    jal _syscallStart_

    # Test syscall 1: Print Integer
    addi $a0, $0, -12345   # Load test integer into $a0
    addi $v0, $0, 1        # Load syscall code 1 (print integer)
    jal _syscallStart_

    # Test syscall 5: Read Integer
    addi $v0, $0, 5        # Load syscall code 5 (read integer)
    jal _syscallStart_
    # Check $v0 for the value read (may involve terminal input).

    # Test syscall 9: Heap Allocation
    lw $a0, heap_test      # Load number of bytes to allocate from memory
    addi $v0, $0, 9        # Load syscall code 9 (heap allocation)
    jal _syscallStart_
    # $v0 will hold the heap pointer for the allocated block.

    # Test syscall 11: Print Character
    lw $a0, char_to_print  # Load ASCII character to print into $a0
    addi $v0, $0, 11       # Load syscall code 11 (print character)
    jal _syscallStart_

    # Test syscall 12: Read Character
    addi $v0, $0, 12       # Load syscall code 12 (read character)
    jal _syscallStart_
    # $v0 will hold the character read from input.

    # Test syscall 13: Play Melody
    la $a0, test_melody    # Load address of the melody into $a0
    addi $v0, $0, 13       # Load syscall code 13 (play melody)
    jal _syscallStart_

    # End program
    addi $v0, $0, 10       # Load syscall code 10 (end program)
    jal _syscallStart_
