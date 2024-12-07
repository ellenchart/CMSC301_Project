.data
.text
.globl main

# Main logic
main:
    # Test syscall 1: Print Integer
    addi $a0, $zero, -12345   # Load test integer into $a0
    addi $v0, $zero, 1        # Load syscall code 1 (print integer)
    syscall