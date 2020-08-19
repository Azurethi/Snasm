section .data

    timeval:
        tv_sec  dd 5
        tv_usec dd 0

    Info db "Simple input test, w to increase, s to decrease, c to exit",10,0
    update db  27,"[H",27,"[2J","Our Number:  "
    number db "5",0

section .bss

    readbuf resb 1

section .text
    global _start
    _start:

    mov ecx, Info
    call echo

    call noblock_setup

    MainLoop:
        mov al, [number]
        cmp al, "0"
        jb exit
        cmp al, "9"
        ja exit
        mov ecx, update
        call echo
        inc al
        mov [number], al
        call sleep
        jmp MainLoop

    exit:
        mov eax, 1  ;exit
        mov ebx, 0  ;    (0)
        int 128

    sleep:
        ;mov dword [tv_sec], 5   ;5 seconds
        ;mov dword [tv_usec], 0
        mov eax, 162            ;setup sys_nanosleep call
        mov ebx, timeval
        mov ecx, 0
        int 128                 ;call
        ret

    readchar:
        mov eax, 3  ;read
        mov ebx, 0  ;stdin
        mov ecx, readbuf
        mov edx, 1
        int 128
        ret

    noblock_setup:
        ;stop read from blocking if no chars in stdin buffer
        mov eax,    55           ; fcntl
        mov ebx,    0
        mov ecx,    4            ; F_SETFL
        mov edx,    2048         ; O_RDONLY|O_NONBLOCK
        int 128
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