#According to ChatGPT what it recommends to do; I will go through 
#later and figure out what's going on
.data
    songData:
        .word 185, 300             # F#, 300ms
        .word 0, 300               # rest, 300ms
        .word 220, 300             # A, 300ms
        .word 277, 300             # C#, 300ms
        .word 0, 300               # rest, 300ms
        .word 220, 300             # A, 300ms
        .word 0, 300               # rest, 300ms
        .word 185, 300             # F#, 300ms
        .word 147, 300             # D, 300ms
        .word 147, 300             # D, 300ms
        .word 147, 300             # D, 300ms
        .word 0, 1200              # rest, 1200ms
        .word 277, 300             # C#, 300ms
        .word 147, 600             # D, 300ms
        .word 185, 300             # F#, 300ms
        .word 220, 300             # A, 300ms
        .word 277, 300             # C#, 300ms
        .word 0, 300               # rest, 300ms
        .word 220, 300             # A, 300ms
        .word 0, 300               # rest, 300ms
        .word 185, 300             # F#, 300ms
        .word 165, 900             # E, 900ms
        .word 156, 300             # Eb, 300ms
        .word 147, 300             # D, 300ms
        .word 0, 0                 # End 
.text
.align 2 
.globl main

main:
    # Load the song data
    la $a0, songData
    jal syscallLoadSong
    #return address of songData into $v0
    add $s0, $v0, $zero             #store songData address into $s0
    
    # Start Song
    addi $v0,$0, 14               # Syscall 14: Start song
    syscall
    
    # Wait for song to complete
    
    wait_loop:
    li   $v0, 0xF               # Syscall 0xF = Syscall 15: Check status
        syscall
        bne  $v0, $zero, wait_loop  # Wait until playback is done

    end: 
        addi $sp, $sp, 200      #deallocate memory
        li   $v0, 10               
        syscall

#functions:

#a0 = address of songData
#return $v0 with the address where the song data is stored
syscallLoadSong:
    #allocate space:
    add $sp, $sp, -200      
    #-200 because we have 25 words ---> 25 * 4 bits (bc word) * 2 items (duration and frequency)        
    addi $v0, $0, 9
    syscall
    add $t0, $sp, $0        #store stackpointer into $t0
    add $t1, $a0, $0        #store address of songData into $t1
    
    loadLoop:
    lw $t2, 0($t1)          #load frequency from songData
    lw $t3, 4($t1)          #load duration from songData
    sw $t2, 0($t0)          #store frequency to stack 
    sw $t3, 4($t0)          #store duration to stack

    addi $t0, $t0, 8
    addi $t1, $t1, 8  

    bne $t3, $zero, loadLoop      
    add $v0, $sp, $zero     #return the stackpointer of songData on stack
    jr $ra





syscall_play_song:
    la   $t0, song_buffer        # Load buffer address

play_loop:
    lw   $t1, 0($t0)             # Load frequency
    lw   $t2, 4($t0)             # Load duration
    beq  $t1, $zero, end_play    # Exit if end marker (0, 0)

    # Generate waveform for this note
    move $a0, $t1                # Frequency
    move $a1, $t2                # Duration
    jal  generate_waveforms      # Generate waveforms on buzzers

    addi $t0, $t0, 8             # Advance to next note
    j    play_loop

end_play:
    jr   $ra                     # Return
*____________________________________________________________
.text
.globl syscall_check_status

syscall_check_status:
    # Assume a playback flag is updated during playback
    lw   $v0, playback_flag      # Load playback flag
    jr   $ra                     # Return
#______________________________________________________________
.text
.globl generate_square_wave

generate_square_wave:
    li   $t0, 1000             # 1000 ms in a second
    div  $t0, $t0, $a0         # Calculate period (in ms)
    mflo $t1                   # Store period in $t1
    srl  $t2, $t1, 1           # Half the period for toggling

toggle_loop:
    lw   $t3, GPIO_BASE        # Load current GPIO state
    xori $t3, $t3, 1           # Toggle bit
    sw   $t3, GPIO_BASE        # Store back

    # Wait for half period
    li   $v0, 32               # Syscall: delay in ms
    move $a0, $t2
    syscall

    addi $t4, $t4, 1           # Increment toggle counter
    bne  $t4, $t5, toggle_loop

    jr   $ra                   # Return
#_____________________________________________________________________
.data
song_buffer: .space 1024        # Allocate space for song data

song_data:
    .word 659, 300             # E5, 300ms
    .word 587, 300             # D5, 300ms
    .word 523, 300             # C5, 300ms
    .word 587, 150             # D5, 150ms
    .word 659, 150             # E5, 150ms
    .word 784, 300             # G5, 300ms
    .word 659, 300             # E5, 300ms
    .word 784, 300             # G5, 300ms
    .word 880, 600             # A5, 600ms
    .word 0, 0                 # End marker
#_______________________________________________________________________
main:
    # Load the song data
    la   $a0, song_data         # Address of song data
    li   $v0, 0x10              # Syscall 0x10: Load song
    syscall

    # Start playback
    li   $v0, 0x11              # Syscall 0x11: Start playback
    syscall

    # Wait for playback to complete
wait_loop:
    li   $v0, 0x12              # Syscall 0x12: Check status
    syscall
    bne  $v0, $zero, wait_loop  # Wait until playback is done

    # Exit program
    li   $v0, 10                # Exit syscall
    syscall
