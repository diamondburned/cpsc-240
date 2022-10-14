global max

section .data

sizeof_double equ 8

section .text

; double max(double array[], long int size) -> xmm0
max:
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

%define ptr r12
%define len r13
        mov ptr, rdi                   ; arg1
        mov len, rsi                   ; arg2

; Calculate end pointer into rax.
        mov rax, sizeof_double         ; rax = 8
        mul len                        ; rax = len * 8
        add rax, ptr                   ; rax = len * 8 + ptr

; Use xmm0 to store the max value. xmm1 will hold our current value.
%define max xmm0
%define cur xmm1

        movsd cur, [ptr]               ; cur = *ptr
        movsd max, cur                 ; max = cur

        add ptr, sizeof_double         ; ptr++

; Enter loop.
loop:
        movsd cur, [ptr]               ; cur = *ptr

        comisd cur, max                ; cur <=> max
        jbe    not_max                 ; if cur <= max, skip

        movsd max, cur                 ; max = cur

not_max:
        add ptr, sizeof_double         ; ptr++

; Bound-check.
        cmp ptr, rax                   ; ptr == rax?
        jne loop                       ; if not, loop

; Clean up. Our xmm0 will be used for the return.
        popf 
        pop  r15
        pop  r14
        pop  r13
        pop  r12
        pop  r11
        pop  rdi
        pop  rsi
        pop  rdx
        pop  rbp
        ret  


