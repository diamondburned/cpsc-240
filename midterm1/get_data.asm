global get_data

extern scanf

section .data

LF  equ 10
NUL equ 0

msg_scan_double_f db "%lf", NUL
msg_str_ignored_f db "%*s", NUL

sizeof_long_int equ 8

section .text

; long int get_data(double ptr[], long int len, bool *has_invalid) -> rax
get_data:
        push rbp
        mov  rbp, rsp

        push rdi
        push rsi
        push rdx
        push r11
        push r12                       ; v safe to use
        push r13
        push r14
        push r15

; Initialize our function arguments.
%define ptr r12
%define len r13
%define ptr_i r14
%define ptr_has_invalid r15
        mov ptr, rdi
        mov len, rsi
        mov ptr_i, 0
        mov ptr_has_invalid, rdx

read:
        mov  rax, 0
        mov  rdi, msg_scan_double_f    ; arg1: f-string
        mov  rsi, ptr                  ; arg2: ptr to double
        call scanf                     ; scanf()
        cdqe                           ; long int cast in rax

        cmp rax, 0                     ; scanf() == 0?
        jg  good_input                 ; 1 -> good input
        je  bad_input                  ; 0 -> bad input
        jl  eof                        ; -1 -> EOF

good_input:
; Increment counter.
        inc ptr_i

; Bound-check. If we've reached the end of the array, return.
        cmp ptr_i, len
        jge eof

; Increment pointer.
        add ptr, sizeof_long_int

; Continue.
        jmp read

bad_input:
; Mark input as invalid.
        mov byte [ptr_has_invalid], 1

; Un-read the invalid input from scanf's internal buffer.
        mov  rax, 0
        mov  rdi, msg_str_ignored_f    ; arg1: f-string
        call scanf                     ; scanf()

; Continue.
        jmp read

eof:
; Write our return value.
        mov rax, ptr_i

; Clean up and return.
        pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop rdx
        pop rsi
        pop rdi

        pop rbp
        ret 


