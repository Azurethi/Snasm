// Hello world

.global main
main:
  
  LDR R1, =str  	// String pointer
  LDR R2, =strlen   // String length
  bl write

  bl exit

write:  			// Expect R2 = StrLen, R1 = String ptr
    MOV R7, #4      // Select write syscall
    MOV R0, #1      // Select STD_OUT file descriptor
    SWI 0           // Call kernel
    BX  lr          // Return to addr stored by BL

exit:
    MOV R7, #1      // select exit Syscall
    SWI 0           // Call kernel


.data
    str: .ascii "Hello World\n\0"
	strLen = .-str
