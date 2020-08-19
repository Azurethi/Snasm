section .data

    startupMsg db "Type in some stuff",10
    startupMsg_len equ $-startupMsg

    youTyped db 10,"You typed:",10
    youTyped_len equ $-youTyped

    timeval:
        tv_sec  dd 0
        tv_usec dd 0

section .bss

    buf resb 10

section .text
    global _start
    _start:

    mov eax, 4  ;write
    mov ebx, 1  ;stdout
    mov ecx, startupMsg
    mov edx, startupMsg_len
    int 128

    ;setup time structure
    mov dword [tv_sec], 5   ;5 seconds
    mov dword [tv_usec], 0
    mov eax, 162            ;setup sys_nanosleep call
    mov ebx, timeval
    mov ecx, 0
    int 128                 ;call

    ;stop read from blocking if no chars in stdin buffer
    mov eax,    55           ; fcntl
    mov ebx,    0
    mov ecx,    4            ; F_SETFL
    mov edx,    2048         ; O_RDONLY|O_NONBLOCK
    int 128

    mov eax, 3  ;read
    mov ebx, 0  ;stdin
    mov ecx, buf
    mov edx, 10
    int 128

    mov eax, 4  ;write
    mov ebx, 1  ;stdout
    mov ecx, youTyped
    mov edx, youTyped_len
    int 128

    mov eax, 4  ;write
    mov ebx, 1  ;stdout
    mov ecx, buf
    mov edx, 10
    int 128

    mov eax, 1  ;exit
    mov ebx, 0  ;    (0)
    int 128