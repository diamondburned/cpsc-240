global exit

section .data

sys_exit equ 60

section .text

; void exit(int status);
exit:
        mov     rax, sys_exit
        syscall 


