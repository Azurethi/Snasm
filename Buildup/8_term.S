.global main

.text
    main:
        
        ldr r1, =str
        bl echo

        //mov r1, #21505  //TCGETS
        //ldr r2, =t_orig
        //bl ioctl
        
        //Should replace second syscall with memcpy
        mov r1, #21505  //TCGETS
        ldr r2, =t_new_iflag
        bl ioctl

        ldr r1, =str
        bl echo
        
        ldr r1, =t_new_iflag
        ldr r0, [r1]
        bl binstr
        ldr r1, =t_new_oflag
        ldr r0, [r1]
        bl binstr
        ldr r1, =t_new_cflag
        ldr r0, [r1]
        bl binstr
        ldr r1, =t_new_lflag
        ldr r0, [r1]
        bl binstr
        ldr r1, =t_new_c_line
        ldr r0, [r1]
        bl binstr
        ldr r1, =t_new_c_ccarr
        ldr r0, [r1]
        bl binstr

        //ldr r0, =t_new_iflag
        //ldr r1, [r0]
        //bic r1, r1, number

        b exit


    ioctl:                  // expects r1 = CMD, r2 = arg*
        mov r7, #29         //syscall #
        mov r0, #0          //std_in fd
        //mov r1, #21505    //TCGETS
        //mov r1, #21506    //TCSETS
        //ldr r2, =t_orig   // pointer to obj
        swi 0               //call kernel
        bx lr

    binstr:                 //expects R0 = number
        mov r2, #0          //Counter
        ldr r1, =template
        bsloop:
            movs r0, r0, LSL #1  // Shift r0 left 1
            movcc r3, #48       // if carry clear, r3="0"
            movcs r3, #49       // if carry set, r3="1"
            strb r3, [r1,r2]
            add r2, r2, #1      // inc counter
            cmp r2, #32
            bne bsloop

        push {lr}
        bl echo
        pop {lr}
        bx lr

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

.bss
    t_orig: .skip 36

    t_new_iflag:   .skip 4
    t_new_oflag:   .skip 4
    t_new_cflag:   .skip 4
    t_new_lflag:   .skip 4
    t_new_c_line:  .skip 1
    t_new_c_ccarr: .skip 19

.data

    str:        .asciz "Trying to get term flags... [i|o|c|l]flag:\n"
    template:   .asciz "################################\n"
