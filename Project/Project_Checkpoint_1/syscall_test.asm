.data
# Data for heap allocation (_syscall9) testing
test_bytes: .word 20

# Data for _syscall13 testing (e.g., a melody stored as frequency values)
melody: .word 262, 294, 330, 349, 392, 440, 494, 523, 0  # Example melody (frequencies of notes in Hz)

.text
main:
    # Test syscall 0: Initialization
    addi $v0, $0, 0
    jal _syscallStart_

    # Test syscall 1: Print Integer
    li $a0, -12345    # Load test integer into $a0
    addi $v0, $0, 1   # Syscall code for _syscall1
    jal _syscallStart_

    # Test syscall 5: Read Integer
    addi $v0, $0, 5   # Syscall code for _syscall5
    jal _syscallStart_
    # Value read will be stored in $v0; you can use it for further tests.

    # Test syscall 9: Heap Allocation
    lw $a0, test_bytes  # Load number of bytes to allocate
    addi $v0, $0, 9     # Syscall code for _syscall9
    jal _syscallStart_
    # Pointer to allocated heap block will be in $v0.

    # Test syscall 11: Print Character
    li $a0, 65         # ASCII code for 'A'
    addi $v0, $0, 11   # Syscall code for _syscall11
    jal _syscallStart_

    # Test syscall 12: Read Character
    addi $v0, $0, 12   # Syscall code for _syscall12
    jal _syscallStart_
    # Character read will be stored in $v0.

    # Test syscall 13: Play Melody
    la $a0, melody     # Load address of the melody data
    addi $v0, $0, 13   # Syscall code for _syscall13
    jal _syscallStart_

    # End Program
    addi $v0, $0, 10   # Syscall code for _syscall10
    jal _syscallStart_
