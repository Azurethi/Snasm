section .data ; Setup data to be written to memory when our program starts
 
    ; Message variable & associated length
    msg db 'Hello, world!',0xa
    len equ $ - msg

section .text ; Actual code for our program
    global _start               ; Tells GCC where the start of our code is
    _start:                     ; Tells Linker when the start of our code is
 
    ;Write call
        mov eax, 4                  ; select write syscall
                                    ;   expects (FileDescriptor, MessagePointer, MessageLength)
        mov ebx, 1                  ; select Stdout file descriptor
        mov ecx, msg                ; set ecx register to start pointer of message in memory
        mov edx, len                ; set edx register to length of message in memory
        int 0x80                    ; ask kernel to execute our setup (write in this case)
 
    ;Exit call
        mov eax, 1                  ; select exit syscall (no expected data)
        int 0x80                    ; ask kernel to execute (exit in this case)

        