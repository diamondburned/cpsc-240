; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

global print

section .data

stdout equ 1

sys_write equ 1

section .text

print:
        push r12
        push r13

        mov r12, rdi
        mov r13, rsi

        mov     rax, sys_write
        mov     rdi, stdout
        mov     rsi, r12
        mov     rdx, r13
        syscall 

        pop r13
        pop r12
        ret 


