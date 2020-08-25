.altmacro
.macro callBinstr reg
    ldr r1, =debug_template_r\reg
    bl binstr
.endm

.macro setReg i
    mov r\i, #\i
.endm

.macro callBinstrR reg
    mov r0, r\reg
    callBinstr \reg
.endm

.global main
main:
    
    bl unblockRead

    ldr r1, =str  	// String pointer
    bl echo

    bl sleep

    bl read

    ldr r1, =readBuf
    bl echo

    b exit

debug:
    push {r0-r10,lr}
    push {r4-r6}
    mov r4, r1
    mov r5, r2
    mov r6, r3


    callBinstr 0
    mov r0, r4
    callBinstr 1
    mov r0, r5
    callBinstr 2
    mov r0, r6
    callBinstr 3
    pop {r4-r6}

    .set i, 4
    .rept 7
        callBinstrR %i
        .set i, i+1
    .endr

    ldr r1, =debug_template
    bl echo

    pop {r0-r10,lr}
    bx lr

binstr:                 //expects R0 = number
    mov r2, #0          //Counter
    //ldr r1, =template
    bsloop:
        movs r0, r0, LSL #1  // Shift r0 left 1
        movcc r3, #48       // if carry clear, r3="0"
        movcs r3, #49       // if carry set, r3="1"
        strb r3, [r1,r2]
        add r2, r2, #1      // inc counter
        cmp r2, #32
        bne bsloop
    bx lr

echo:               //Expects R1 = string ptr
    mov r2, #0      // zero len counter
    lenLoop:
        ldrb r0, [r1,r2]// Load byte at r1+r2 => r0
        add r2,r2,#1    // Increment length counter 
        cmp r0, #0      // cmp to null
        bne lenLoop

write:  			// Expect R2 = StrLen, R1 = String ptr
    mov r7, #4      // Select write syscall
    mov r0, #1      // Select STD_OUT file descriptor
    swi 0           // Call kernel
    bx  lr          // Return to addr stored by BL

unblockRead:
    mov r7, #55     // fcntl syscall
    mov r0, #0      // std_in
    mov r1, #4      // F_setfl sub-funct
    mov r2, #2048   // flags: O_RDONLY|O_NONBLOCK
    swi 0           // call kernel
    bx  lr          // return

read:
    mov r7, #3      // read Syscall
    mov r0, #0      // std_in fd
    ldr r1, =readBuf// storage for input
    mov r2, #10     // #bytes to read
    swi 0           // call kernel
    bx  lr          // return

sleep:
    mov r7, #162    // nanosleep syscall
    ldr r0, =time   // time struct ptr
    mov r1, #0      // unused arg
    swi 0           // call kernel
    bx  lr          // return

exit:
    mov r7, #1      // select exit Syscall
    swi 0           // Call kernel


.data
    str: .asciz "Sleep before read."
    debug_template:     .ascii "\n#REG_DEBUG:\nR0 : "
    debug_template_r0:  .ascii "################################\nR1 : "
    debug_template_r1:  .ascii "################################\nR2 : "
    debug_template_r2:  .ascii "################################\nR3 : "
    debug_template_r3:  .ascii "################################\nR4 : "
    debug_template_r4:  .ascii "################################\nR5 : "
    debug_template_r5:  .ascii "################################\nR6 : "
    debug_template_r6:  .ascii "################################\nR7 : "
    debug_template_r7:  .ascii "################################\nR8 : "
    debug_template_r8:  .ascii "################################\nR9 : "
    debug_template_r9:  .ascii "################################\nR10: "
    debug_template_r10: .asciz "################################\n"

    readBuf: .asciz "##########"

    time:
    time_s:     .long 1
    time_us:    .long 0
    
