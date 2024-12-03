#According to ChatGPT what it recommends to do; I will go through 
#later and figure out what's going on
#_____________________________________________
.text
.globl syscall_load_song

syscall_load_song:
    la   $t0, song_buffer        # Load buffer address
    move $t1, $a0                # Song data address
    li   $t2, 0                  # Initialize index

load_loop:
    lw   $t3, 0($t1)             # Load frequency
    sw   $t3, 0($t0)             # Store in buffer
    lw   $t3, 4($t1)             # Load duration
    sw   $t3, 4($t0)             # Store in buffer
    addi $t0, $t0, 8             # Advance buffer
    addi $t1, $t1, 8             # Advance song data
    bne  $t3, $zero, load_loop   # Continue until end marker (0, 0)

    jr   $ra                     # Return
#______________________________________________
.text
.globl syscall_play_song

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
.text
.globl main

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
