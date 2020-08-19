section .data
    msg1 db "My Null Terminated string",0
    len1 equ $-msg1

    debugT db "Debug Registers:",10,"eax:"
    debugT_eax db "################################",10,"ebx:"
    debugT_ebx db "################################",10,"ecx:"
    debugT_ecx db "################################",10,"edx:"
    debugT_edx db "################################",10,"esi:"
    debugT_esi db "################################",10,"edi:"
    debugT_edi db "################################",10,"-----",10,0

    UI db "======================",10
       db "=                    =",10
       db "=                    =",10
       db "=                    =",10
       db "=                    =",10
       db "=                    =",10
       db "=                    =",10
       db "=                    =",10
       db "=                    =",10
       db "=                    =",10
       db "======================",10,0

    inputTest db "this is a test"
    inputTestL equ $-inputTest

section .text
    global _start
    _start:

        mov ecx, UI
        call echo

        mov eax, 3
        mov ebx, 2
        mov ecx, inputTest
        mov edx, 4
        int 128

        mov ecx, inputTest
        mov edx, inputTestL
        call stdout

        mov eax, 1
        mov ebx, 0
        int 128


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
        int 128
        pop ebx
        pop eax
        ret