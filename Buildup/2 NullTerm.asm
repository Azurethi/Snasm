section .data
    msg1 db "My Null Terminated string",0
    len1 equ $-msg1
    
section .text
    global _start
    _start:
        mov ecx, msg1
        call echo

        mov eax, 1
        int 0x80

    echo: ; ecx: msg*
        push eax
        push edx
        push esi
        mov edx, 0     ; len = 0
        mov esi, ecx   ; create a copy of msg we can mess with
        .lenloop:
            mov al, [esi]
            cmp al, 0
            je echo.lenloop_done
            add edx, 1
            add esi, 1
            jmp echo.lenloop
        .lenloop_done:
            call stdout
            pop esi
            pop edx
            pop eax
            ret

    stdout: ; ecx: msg*, edx: len
        push eax
        push ebx
        mov eax, 4
        mov ebx, 1
        int 0x80
        pop ebx
        pop eax
        ret