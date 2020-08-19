section .data
    debugT db "Debug Registers:",0xa,"eax:"
    debugT_eax db "################################",0xa,"ebx:"
    debugT_ebx db "################################",0xa,"ecx:"
    debugT_ecx db "################################",0xa,"edx:"
    debugT_edx db "################################",0xa,"esi:"
    debugT_esi db "################################",0xa,"edi:"
    debugT_edi db "################################",0xa,"-----",0xa,0

section .text
    global _start
    _start:

        mov eax, 12310001
        mov ebx, 12310002
        mov ecx, 12310003
        mov edx, 12310004
        mov esi, 12310005
        mov edi, 12310006
        call debug

        mov eax, 1
        mov ebx, 0
        int 0x80


    debug:  ; Update [debugT] with current values of all registers & print.
        push eax
        push ebx
        push ecx
        push edx
        push esi
        push edi

        push ecx
        mov ecx, debugT_eax
        call binStr

        mov eax, ebx
        mov ecx, debugT_ebx
        call binStr

        pop eax
        mov ecx, debugT_ecx
        call binStr

        mov eax, edx
        mov ecx, debugT_edx
        call binStr

        mov eax, esi
        mov ecx, debugT_esi
        call binStr

        mov eax, edi
        mov ecx, debugT_edi
        call binStr

        mov ecx, debugT
        call echo

        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret


    binStr: ; eax: value, ecx: storage*
        push eax        ; can restore this later
        push ebx
        push ecx
        ;mov ecx, binStrT
        mov bh, 0
        .loop:
            sal eax, 1
            mov bl, "1"
            jc  binStr.wasone
            mov bl, "0"
            .wasone:
            mov [ecx], bl
            inc ecx
            inc bh
            cmp bh, 32
            jz binStr.done
            jmp binStr.loop

        .done:
            pop ecx
            pop ebx
            pop eax
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