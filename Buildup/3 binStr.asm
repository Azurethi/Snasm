section .data
    msg1 db "My Null Terminated string",0
    len1 equ $-msg1

    binStrT db "################################",0xa
    binStrTEnd equ $-1

section .text
    global _start
    _start:

        mov eax, 0
        lp:
            call binStr
            cmp eax, 20
            jz lpd
            inc eax
            jmp lp 
        
        lpd:
        mov eax, 1
        int 0x80


    binStr: ; Convert eax to a binary string & print it
        push eax        ; can restore this later
        push ebx
        push ecx
        mov ecx, binStrT
        
        .loop:
            sal eax, 1
            mov bl, "1"
            jc  binStr.wasone
            mov bl, "0"
            .wasone:
            mov [ecx], bl
            inc ecx
            cmp ecx, binStrTEnd
            jz binStr.done
            jmp binStr.loop

        .done:
            pop ecx
            pop ebx
            pop eax
            mov ecx, binStrT
            mov edx, 33
            call stdout
            ret

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
            inc edx
            inc esi
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