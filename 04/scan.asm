; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

global scan

section .data

LF  equ 10
NUL equ 0

stdin equ 0

sys_read equ 0

section .text

scan:
        push r12
        push r13
        push r14
        push r15

        mov r12, rdi                   ; buffer (*byte)
        mov r13, rsi                   ; length (int)

        sub rsp, 8                     ; allocate 1 byte padded for reading
        mov r14, rsp                   ; r14: pointer to this 1 byte buffer

        mov r15, 0                     ; r15 will be the number of bytes read

.loop:
        mov     rax, sys_read
        mov     rdi, stdin
        mov     rsi, r14
        mov     rdx, 1
        syscall                        ; read(stdin, r14, 1)

        mov al, [r14]                  ; copy the byte from the stack pointer
        mov [r12 + r15], byte al       ; store the byte read into the buffer
        inc r15                        ; increment index

        cmp r15, r13                   ; buffer bound check
        jae .done                      ; (j)ump (a)bove (e)qual

        cmp al, LF                     ; check if newline
        je  .wnul                      ; write a null terminator

        cmp al, NUL                    ; check if null
        je  .done

        jmp .loop                      ; no checks satisfied, read more

.wnul:
        dec r15                        ; unread our new line character
        mov [r12 + r15], byte 0        ; write a null byte there
.done:
        mov rax, r15                   ; return number of bytes read
        add rsp, 8                     ; unallocate our buffer

        pop r15
        pop r14
        pop r13
        pop r12
        ret 


