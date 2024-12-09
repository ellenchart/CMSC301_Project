.data
.text
.globl main

# Main logic

main:
    # Test syscall 5: Read Integer
    addi $v0, $zero, 5        # Load syscall code 5 (read integer)
    syscall
end: 
    #addi $v0, $zero, 10
    #syscall