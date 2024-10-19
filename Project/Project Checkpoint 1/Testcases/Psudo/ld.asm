.data
.align 3  # Align the data to a double-word boundary
double_word_data: .double 123.456  # Example double word to load

.text
.align 2
.globl main 

init:
    # Load the address of the double word into $s0
    la $s0, double_word_data

main:
    # Load the double word from memory into $f0 using the address in $s0
    ld $f0, 0($s0)

    # Print the loaded double word (using a floating-point syscall)
    li $v0, 3  # Floating-point print syscall
    mov.d $f12, $f0
    syscall  # Should print 123.456

    # Exit
    li $v0, 10
    syscall
