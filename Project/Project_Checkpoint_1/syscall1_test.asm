.data
    _heap_test: .word 128
    _char_to_print: .word 65
    _test_melody: .word 262, 294, 330, 349, 392, 440, 494, 523, 0, 1

.text
.globl main

# Main logic
main:
    # Test syscall 1: Print Integer
    addi $a0, $zero, -12345   # Load test integer into $a0
    addi $v0, $zero, 1        # Load syscall code 1 (print integer)
    syscall