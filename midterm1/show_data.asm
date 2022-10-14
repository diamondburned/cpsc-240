global show_data

extern printf

section .data

LF  equ 10
NUL equ 0

msg_double_f db "%lf", LF, NUL

sizeof_long_int equ 8
sizeof_double   equ 8

section .text

; void show_data(double ptr[], long int len)
show_data:
        push rbp
        mov  rbp, rsp

        push  rdi
        push  rsi
        push  rdx
        push  r11
        push  r12
        push  r13
        push  r14
        push  r15
        pushf 

%define ptr r12 ; arg
%define len r13 ; arg 
        mov ptr, rdi
        mov len, rsi

%define endptr r14
        mov rax, sizeof_long_int
        mul len
        mov endptr, rax
        add endptr, ptr

        sub rsp, 8                     ; fix stack alignment

do_print:
        mov   rax, 1
        mov   rdi, msg_double_f        ; arg1: f-string
        movsd xmm0, [ptr]              ; arg2: ptr[idx]
        call  printf                   ; printf()

        add ptr, sizeof_double

; Bound-check.
        cmp ptr, endptr
        jne do_print

        add rsp, 8                     ; undo stack alignment

        popf 
        pop  r15
        pop  r14
        pop  r13
        pop  r12
        pop  r11
        pop  rdx
        pop  rsi
        pop  rdi

        pop rbp
        ret 


