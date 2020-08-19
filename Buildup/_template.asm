section .data

section .bss

section .text
    global _start
    _start:


    mov eax, 1  ;exit
    mov ebx, 0  ;    (0)
    int 128