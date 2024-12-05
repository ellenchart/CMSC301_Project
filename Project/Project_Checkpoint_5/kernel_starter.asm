#This is starter code, so that you know the basic format of this file.
#Use _ in your system labels to decrease the chance that labels in the "main"
#program will conflict

.data
.text
_syscallStart_:
    beq $v0, $0, _syscall0 #jump to syscall 0

    addi $k1, $0, 1
    beq $v0, $k1, _syscall1 #jump to syscall 1

    addi $k1, $0, 5
    beq $v0, $k1, _syscall5 #jump to syscall 5

    addi $k1, $0, 9
    beq $v0, $k1, _syscall9 #jump to syscall 9

    addi $k1, $0, 10
    beq $v0, $k1, _syscall10 #jump to syscall 10

    addi $k1, $0, 11
    beq $v0, $k1, _syscall11 #jump to syscall 11

    addi $k1, $0, 12
    beq $v0, $k1, _syscall12 #jump to syscall 12

    # Add branches to any syscalls required for your stars.
    addi $k1, $0, 13
    beq $v0, $k1, _syscall13

    addi $k1, $0, 14
    beq $v0, $k1, _sycall14

    #Error state - this should never happen - treat it like an end program
    j _syscall10

#Do init stuff
_syscall0:
    # Initialization goes here
    # set initial value of the 
    stack pointer -4096
    addi $sp, $0, -4096
    j _syscallEnd_

#Print Integer
_syscall1:
    # Print Integer code goes here
    jr $k0

#Read Integer
_syscall5:
    # Read Integer code goes here
    jr $k0

#Heap allocation
_syscall9:
    # Heap allocation code goes here
    # request a number of bytes in register $a0
    # project 1
    la $v0,_END_OF_STATIC_MEMORY_ 
    sw $v0, -4092($0)
    jr $k0

#"End" the program
_syscall10:
    j _syscall10

#print character
_syscall11:
    # print character code goes here
    lw $k1, -240($0) # check keyboard status
    beq $k1, $0, none # if no char ready go to none 
    lw $v0, -236($0) # else read char from -236 
    sw $0, -240($0) # reset keyboard status to 0
    j done 
    none:
    addi $v0, $0, 0 # if no char return 0 
    done:
    jr $k0

#read character
_syscall12:
    # read character code goes here
    jr $k0 # return from sys call

#extra challenge syscalls go here?

#Load Song 
_syscall13:
    


#needs to load song and return it things into V0

#Start Song
_syscall14:




_syscallEnd_: