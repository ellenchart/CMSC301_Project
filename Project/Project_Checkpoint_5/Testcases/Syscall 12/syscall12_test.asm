.data
.text
.globl main

# Main logic
main:
# Test syscall 12: Read Character
    addi $v0, $zero, 12       # Load syscall code 12 (read character)
    syscall
