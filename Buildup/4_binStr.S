// Convert register to binary ascii string

.global main
main:
  
    ldr r1, =str  	// String pointer
    bl echo

    mov r0, #1234
    bl binstr

    b exit

binstr:                 //expects R0 = number
    mov r2, #0          //Counter
    ldr r1, =template
    bsloop:
        mov r0, r0, LSL #1  // Shift r0 left 1
        movcc r3, #48       // if carry clear, r3="0"
        movcs r3, #49       // if carry set, r3="1"
        strb r3, [r1,r2]
        add r2, r2, #1      // inc counter
        cmp r2, #30
        bne bsloop

    push {lr}
    bl echo
    pop {lr}
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

exit:
    mov r7, #1      // select exit Syscall
    swi 0           // Call kernel


.data
    str: .ascii "Hello World\nAttempting to convert register to binary string\n\n\0"
    template: .ascii "################################\0"
