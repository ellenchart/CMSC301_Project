.data
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
        .word 1                # End 
.text
.align 2
.globl main

main:
    # Load the song data
    #la $a0, songData
    addi $a0, $0, 0
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

    add $t0, $sp, $0        #put stackpointer into $t0
    add $t1, $a0, $0        #put a0 into $t1
    addi $t3, $0, 1         #set $t3 to end indicator
    loadLoop:
    lw $t2, 0($t1)          #load frequency from songData
    sw $t2, 0($t0)          #store frequency to stack 

    addi $t0, $t0, 4        #increase stackpointer
    addi $t1, $t1, 4        #go to next songData note

    bne $t2, $t3, loadLoop
          
    add $v0, $sp, $zero     #return the stackpointer of songData on stack
    jr $ra

