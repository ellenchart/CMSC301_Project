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
end: 
    addi $v0, $zero, 10
    syscall
 