.data
.text
.globl main

# Main logic
main:
    # Test syscall 0: Initialization
    addi $v0, $zero, 0     # Load syscall code 0 (initialize)
    syscall