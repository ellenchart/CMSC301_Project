.data
my_func_addr: .word func1 func2
.text

j main
func1:
    addi $v0, $0, 1
    jr $ra

main:
    jal func1
    add $s0, $0, $v0
    la $t0, my_func_addr
    lw $t0, 4($t0)
    jalr $t0
    add $s1, $0, $v0
    j end

func2:
    addi $v0, $0, 2
    jr $ra

end:
    addi $v0, $zero, 10
    syscall #End the program

