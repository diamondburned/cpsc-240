global manager

extern printf

section .data

LF  equ 10
NUL equ 0

msg db "Welcome to the Party", LF,
    db "Happy Birthday Chris Sawyer.", LF,
    db "Have a wonderful birthday, Chris.", LF, NUL

section .text

manager:
        push rbp
        mov  rbp, rsp

        mov  rax, 0
        mov  rdi, msg
        call printf

        pop rbp
        ret 


