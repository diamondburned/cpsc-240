; Name: Diamond Dinh
; Language(s): C++, x86 Assembly
; Dates: 22 August, 2022 ~ 31 August, 2022
; File(s): main.asm, main.cpp, isfloat.cpp
; Status: Done
; References:
;   https://www.cs.uaf.edu/2003/fall/cs301/doc/nasmdoc0.html
;   https://www.nasm.us/xdoc/2.10.09/html/nasmdoc3.html
;   https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/library-software/isfloat?authuser=0
;   https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/x86-examples/floating-io?authuser=0
; Module Info:
;   File name: main.asm
;   Language: x86 Assembly
;   How to compile:
;     #!/usr/bin/env bash
;     set -e
;     rm -f -- *.o *.lis *.out
;  
;     for f in *.asm; do
;         nasm -f elf64 -o "$f.o" "$f"
;     done
;     for f in *.cpp; do
;         g++ -g -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o "$f.o" "$f"
;     done
;  
;     g++ -g -m64 -std=c++14 -fno-pie -no-pie -o "$(basename "$PWD").out" *.o

        extern printf
        extern scanf
        extern atof
        extern isfloat

        global floating_point_io

; |          |
; |==========| <- rsp (stack pointer)
; |==========|
; |==========|
; |__________| <- rbp (back pointer)

; rax - accumulator, return data sometimes

; Writing 0 to rax is just something that you should just do. If you don't, the
; program may randomly SEGFAULT. This is fun :)

        segment .text
floating_point_io:
        push rbp                       ; begin new function stack frmae
        mov rbp, rsp                   ; bp = back ptr, sp = stack ptr

        push rdx
        push rsi
        push rdi
        push r12
        push r13

        mov rax, 0
        mov rdi, msg_please_enter      ; arg1, f-string
        call printf                    ; printf(...)

; Grow the stack for 2 strings into r12 and r13.
        sub rsp, [num_scanf_buflen]    ; grow a 1024-byte stack ONCE for do_scan
        mov r12, rsp                   ; store to r12 for future use

        sub rsp, [num_scanf_buflen]    ; grow the stack again for the second string
        mov r13, rsp                   ; store to r13 for future use

; We should scanf %s and atof it, just so we can use isfloat().
; Call scanf with 2 1024-byte stack buffers. Not too sure what happens if it overflows, lol.
        mov rax, 0
        mov rdi, msg_str2_f            ; arg1, f-string for 2 %s
        mov rsi, r12                   ; arg2, make scanf output to stack pointer
        mov rdx, r13                   ; arg3, another buffer
        call scanf                     ; scanf(...), how does scanf know to use rsp?

; Validate input r12
        mov rax, 0                     ; zero out rax; this is used for returns
        mov rdi, r12                   ; arg1, use stack pointer as argument
        call isfloat                   ; rax = isfloat(...)
; Exit if not float
        cmp rax, 0                     ; rax == 0
        je throw_invalid_float         ; if above, then jump

; Validate input r13
        mov rax, 0                     ; zero out rax; this is used for returns
        mov rdi, r13                   ; arg1, use stack pointer as argument
        call isfloat                   ; rax = isfloat(...)
; Exit if not float
        cmp rax, 0                     ; rax == 0
        je throw_invalid_float         ; if above, then jump

; Call atof to get the first float
        mov rax, 0
        mov rdi, r12                   ; arg1, first string
        call atof
        movsd xmm12, xmm0              ; write to xmm12

; Call atof to get the second float
        mov rax, 0
        mov rdi, r13                   ; arg1, second string
        call atof
        movsd xmm13, xmm0              ; write to xmm13

; We're done scanning.
        ucomisd xmm12, xmm13           ; compare xmm12 and xmm13
        ja xmm12_gt_13                 ; 12 > 13
        jmp xmm12_lt_13                ; else

; We try to use xmm11 here, just because it's safer to be used. Hopefully we
; can keep stuff in here.
xmm12_gt_13:
        movsd xmm11, xmm12             ; use 12
        jmp done

xmm12_lt_13:
        movsd xmm11, xmm13             ; use 13

done:
        sub rsp, 8                     ; workaround to realign the stack for C std to work.
        mov rax, 1                     ; 1 xmm arg needed
        mov rdi, msg_larger_number_f   ; arg1: f-string
        movsd xmm0, xmm11              ; use xmm0
        call printf
        add rsp, 8                     ; undo workaround

return:
        movsd xmm0, xmm11
        add rsp, [num_scanf_buflen]    ; clean up the 1024-byte grow
        add rsp, [num_scanf_buflen]    ; clean up the 1024-byte grow
        pop r13                        ; unwind
        pop r12
        pop rdi
        pop rsi
        pop rdx
        pop rbp                        ; undo function stack
        ret                            ; return, this will use xmm0

throw_invalid_float:
        mov rdi, msg_invalid_float     ; arg1, invalid float message
        call printf                    ; printf(...)
        movsd xmm0, [num_neg_1]        ; write -1 to be returned
        jmp return

        segment .data
num_neg_1:
        dq 0xBFF0000000000000
num_scanf_buflen:
        dq 1024
msg_n:
        db 0xA, 0
msg_str2_f:
        db "%s %s", 0
msg_str_f:
        db "%s", 0
msg_please_enter:
        db "Please enter two float numbers separated by white space. Press enter after the second input.", 0xA, 0
msg_confirm_entered:
        db "These numbers were entered:", 0xA, 0
msg_larger_number_f:
        db "The larger number is %1.15lf", 0xA, 0
msg_ret_to_driver:
        db "This assembly module will now return execution to the driver module.", 0xA, "The smaller number will be returned to the driver.", 0
msg_invalid_float:
        db "An invalid input was detected. You may run this program again", 0xA, 0
