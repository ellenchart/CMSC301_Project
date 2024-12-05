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

    #Error state - this should never happen - treat it like an end program
    j _syscall10

#Do init stuff
_syscall0:
    # Initialization goes here
    # set initial value of the stack pointer -4096
    addi $sp, $0, -4096
    la $v0, _END_OF_STATIC_MEMORY_ 
    sw $v0, -4092($0)
    j _syscallEnd_

#Print Integer
_syscall1:
    # # Print Integer code goes here
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    bge $a0, $0, _PositiveSyscall1
    addi $t0, $0, 45 #negative int you need to print "-" (45)
    sw $t0, -256($0)
    addi $t0, $0, -1 #make positive
    mult $a0, $t0 
    mflo $t0 

    _PositiveSyscall1:
    add $t0, $a0, $0
    # while $t0 > 0 
    _WhilePositiveSyscall1:
    ble $t0, $0, _EndWhilePositiveSyscall1
    addi $t1, $0, 10
    div $a0, $t1 
    # remainder 
    mfhi $t1
    sw $t1 -256($0)
    mflo $t0 # floor division 
    j _WhilePositiveSyscall1

    _EndWhilePositiveSyscall1:
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    jr $k0

#Read Integer
_syscall5:
    # Read Integer code goes here
    addi $sp, $sp, -72
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)
    sw $t5, 20($sp)
    sw $t6, 24($sp)
    sw $t7, 28($sp)
    sw $s0, 32($sp)
    sw $s1, 36($sp)
    sw $s2, 40($sp)
    sw $s3, 44($sp)
    sw $s4, 48($sp)
    sw $s5, 52($sp)
    sw $s6, 56($sp)
    sw $s7, 60($sp)
    sw $v1, 64($sp)

    addi $t0, $0, 48 # ascii 0
    addi $t1, $0, 49 # ascii 1
    addi $t2, $0, 50 # ascii 2
    addi $t3, $0, 51 # ascii 3
    addi $t4, $0, 52 # ascii 4
    addi $t5, $0, 53 # ascii 5
    addi $t6, $0, 54 # ascii 6
    addi $t7, $0, 55 # ascii 7
    addi $s0, $0, 56 # ascii 8
    addi $s1, $0, 57 # ascii 9
    addi $s2, $0, 45 # ascii -
    addi $s3, $0, 0 # temp keyboard register 
    addi $s4, $0, 45 # temp negative register 
    addi $s5, $0, 0 # count of putting inputs on stack
    addi $s6, $0, 10 # base for exponent
    addi $s7, $0, 0 # count for exponent
    addi $v0, $0, 0 # answer
    addi $v1, $0, 0 # inside math counter 


    # special number to check when keyboard input is done ****************** 
    #addi $s5, $0, 89238
    #sw $s5, 68($sp)

    # first time through loop check if digit or "-"
    lw $s3, -240($0) # check keyboard status
    beq $s3, $0, _syscall5None # if no char ready go to none 
    lw $s3, -236($0) # else read char from -236
    beq $s3, $s2, _syscall5Negative

    # any value in keyboard 
    _syscall5WhileIfDigit:
    # check if digit 
    beq $s3, $t0, _syscall5DigitZero
    beq $s3, $t1, _syscall5DigitOne
    beq $s3, $t2, _syscall5DigitTwo 
    beq $s3, $t3, _syscall5DigitThree
    beq $s3, $t4, _syscall5DigitFour
    beq $s3, $t5, _syscall5DigitFive
    beq $s3, $t6, _syscall5DigitSix
    beq $s3, $t7, _syscall5DigitSeven
    beq $s3, $s1, _syscall5DigitEight
    beq $s3, $s2, _syscall5DigitNine
    j _syscall5None

    # any other not if not digit break 



    _syscall5Negative:
    addi $s4, $0, -1 
    j _syscall5WhileIfDigit


    _syscall5DigitZero:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 0
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitOne:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 1
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit
    
    _syscall5DigitTwo:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 2
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitThree:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 3
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitFour:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 4
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitFive:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 5
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitSix:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 6
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitSeven:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 7
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitEight:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 8
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    _syscall5DigitNine:
    # put zero on stack and j to _syscall5WhileIfDigit 
    addi $sp, $sp, -4
    addi $s3, $s3, 9
    sw $s3, 0($sp)
    addi $s5, $s5, 1
    j _syscall5WhileIfDigit

    # loop through stack to find special num and counter 
    _syscall5LoopThroughStack:
    lw $s3, 0($sp) # where stack is   
    addi $sp, $sp, 4
    beq $s5, $0, _syscall5None # if found special num
    # else keep looping through and to do math (answer += (digit * 10^(counter )))
    addi $v1, $s7, 0
    addi $s7, $s7, 1
    addi $s5, $s5, -1
    _syscall5DigitMath: 
    # v0 is answer, s6 is 10, s7 is count final, 
    beq $v1, $0, _syscall5DigitMathDone
    mult $s3, $s6
    mflo $s3
    addi $v1, $v1, -1 # increment count 
    j _syscall5DigitMath

    _syscall5DigitMathDone:
    add $v0, $v0, $s3
    j _syscall5LoopThroughStack

    _syscall5None:
    # branch if s4 is 45 -- that means there was not a negative sign
    beq $s4, $s2, _syscall5MakePositiveOne
    addi $s4, $0, 1
    _syscall5MakePositiveOne:

    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $t4, 16($sp)
    lw $t5, 20($sp)
    lw $t6, 24($sp)
    lw $t7, 28($sp)
    lw $s0, 32($sp)
    lw $s1, 36($sp)
    lw $s2, 40($sp)
    lw $s3, 44($sp)
    lw $s4, 48($sp)
    lw $s5, 52($sp)
    lw $s6, 56($sp)
    lw $s7, 60($sp)
    lw $v1, 64($sp)
    addi $sp, $sp, 68

    mult $v0, $s4
    mfhi $v0

    # check to make sure above sp is correct, did we deallocate the special number twice?
    jr $k0

#Heap allocation
_syscall9:
    # Heap allocation code goes here
    # request a number of bytes in register $a0
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    lw $t0, -4096($0) # heap pointer 
    # $a0, and you will provide a block of that many bytes returning a pointer in $v0
    add $v0, $t0, $a0 
    sw $v0, -4096($0) # updates the adress of heap pointer
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    jr $k0

#"End" the program
_syscall10:
    j _syscall10

#print character
_syscall11:
    # print character code goes here
    sw $a0, -256($0)
    jr $k0

#read character
_syscall12:
    # read character code goes here
    addi $sp, $sp, -8 
    sw $k0, 0($sp)
    sw $v0, 4($sp)
    lw $k1, -240($0) # check keyboard status
    beq $k1, $0, _syscall12None # if no char ready go to none 
    lw $v0, -236($0) # else read char from -236 
    sw $0, -240($0) # reset keyboard status to 0
    j _syscall12Done
    _syscall12None:
    addi $v0, $0, 0 # if no char return 0 
    _syscall12Done:
    lw $k0, 0($sp)
    lw $v0, 4($sp)
    addi $sp, $sp, 8 
    jr $k0

#extra challenge syscalls go here?
#Start Song
_syscall13:
    _savingOGValuesToStack:
    addi $sp, $sp, -16
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)

    _mainSyscall13:
    add $t0, $sp, $zero                 # t0 = stackpointer
    add $t3, $0, 200                    # Volume
    sw $t3, -252($0)                    # Set Volume

    _playLoop:
        lw $t1, 0($t0)                  # Load frequency
        beq $t1, $zero, _endLoop        # Exit if end marker (0, 0)

        addi $t2, $0, 1

        sw $t1, -244($0)                # Store frequency to address
        sw $t2, -248($0)                # Enable sound
        
        addi $t0, $t0, 8                # Go to next note
        j _playLoop
    _endLoop:
    _putBackOGValues:    
        lw $t0, 0($sp)
        lw $t1, 4($sp)
        lw $t2, 8($sp)
        lw $t3, 12($sp)
        addi $sp, $sp, 16
    _endPlay:
        jr   $k0                        # Return 

_syscallEnd_: