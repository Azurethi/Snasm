// Null Terminated string

.global main
main:
  
    ldr r1, =str  	// String pointer

    bl echo
    b exit

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
    str: .ascii "Hello World\n\0"
