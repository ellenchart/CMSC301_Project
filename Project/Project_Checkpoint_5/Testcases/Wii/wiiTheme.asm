.data
    songData: .word 370, 0, 440, 554, 0, 440, 0, 370, 294, 294, 294, 0, 0, 0, 0, 554, 294, 370, 440, 554, 0, 440, 0, 370, 659, 659, 659, 622, 587, 0, 1
.text
.globl main

main:
    # Load the song data
    la $a0, songData
    #addi $a0, $0, 0
    #jal loadSong
    #return address of songData into $v0
    add $s0, $v0, $zero             #store songData address into $s0
    
    # Start Song 
    addi $v0,$0, 13                 # Syscall 13: Start song
    syscall

    end: 
        #addi $sp, $sp, 128          #deallocate memory
        addi $v0, $zero, 10         #Syscall 10
        syscall

#functions:

#a0 = address of songData
#return $v0 with the address where the song data is stored
loadSong:
    #allocate space:
    #addi $sp, $sp, -128      
    #-200 because we have 31 words ---> 31 * 4 bits (bc word)        
    
    #addi $v0, $0, 9
    #syscall

    # add $t0, $sp, $0        #put stackpointer into $t0
    # add $t1, $a0, $0        #put a0 into $t1
    # addi $t3, $0, 1         #set $t3 to end indicator
    # loadLoop:
    # addi $v0, $v0, 0
    # addi $v0, $v0, 0

    # lw $t2, 0($t1)          #load frequency from songData
    # sw $t2, 0($t0)          #store frequency to stack 

    # addi $t0, $t0, 4        #increase stackpointer
    # addi $t1, $t1, 4        #go to next songData note

    #bne $t2, $t3, loadLoop

    #add $v0, $sp, $zero     #return the stackpointer of songData on stack 
    jr $ra

