; Hello world

.global main
main:
  MOV R7, #4        ; Select write syscall
  MOV R0, #1        ; Select STD_OUT file descriptor
  MOV R2, #11       ; String length
  LDR R1, =string   ; String pointer
  SWI 0             ; Call kernel

  MOV R7, #1        ; select exit Syscall
  SWI 0             ; Call kernel

.data
    string: .ascii "Hello World"