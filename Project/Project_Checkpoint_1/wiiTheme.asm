#According to ChatGPT what it recommends to do; I will go through 
#later and figure out what's going on
.data
#written where each eighth note is one
    songData:
        .word 185            # F#, 1 
        .word 0              # rest, 1
        .word 220            # A, 1
        .word 277            # C#, 1
        .word 0              # rest, 1
        .word 220            # A, 1
        .word 0              # rest, 1
        .word 185            # F#, 1
        .word 147            # D, 1
        .word 147            # D, 1
        .word 147            # D, 1
        .word 0              # rest, 4
        .word 0
        .word 0
        .word 0
        .word 277             # C#, 1
        .word 147             # D, 1
        .word 185             # F#, 1
        .word 220             # A, 1
        .word 277             # C#, 1
        .word 0               # rest, 1
        .word 220             # A, 1
        .word 0               # rest, 1
        .word 185             # F#, 1
        .word 165             # E, 3
        .word 165
        .word 165
        .word 156             # Eb, 1
        .word 147             # D, 1
        .word 0                 # End 
.text
.align 2 
.globl main

main:
    # Load the song data
    la $a0, songData
    jal loadSong
    #return address of songData into $v0
    add $s0, $v0, $zero             #store songData address into $s0
    
    # Start Song 
    addi $v0,$0, 13               # Syscall 13: Start song
    syscall

    end: 
        addi $sp, $sp, 200      #deallocate memory
        addi $v0, $zero, 10     #Syscall 10
        syscall

#functions:

#a0 = address of songData
#return $v0 with the address where the song data is stored
loadSong:
    #allocate space:
    add $sp, $sp, -200      
    #-200 because we have 25 words ---> 25 * 4 bits (bc word) * 2 items (duration and frequency)        
    
    addi $v0, $0, 9
    syscall

    add $t0, $sp, $0        #store stackpointer into $t0
    
    loadLoop:
    lw $t1, 0($a0)          #load frequency from songData
    sw $t1, 0($t0)          #store frequency to stack 

    addi $t0, $t0, 8

    bne $t2, $zero, loadLoop      
    add $v0, $sp, $zero     #return the stackpointer of songData on stack
    jr $ra

