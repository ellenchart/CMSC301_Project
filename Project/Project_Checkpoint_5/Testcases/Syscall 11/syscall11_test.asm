.data
    _char_to_print: .word 65
.text
.globl main

# Main logic
main:
    # Test syscall 11: Print Character
    la $a0, _char_to_print     # Load ASCII character into $a0
    lw $a0, 0($a0)                     
    addi $v0, $zero, 11       # Load syscall code 11 (print character)
    syscall

end: 
    addi $v0, $zero, 10
    syscall