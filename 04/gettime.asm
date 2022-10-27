global gettimeofday
global clock_gettime

section .data

NUL equ 0

sys_gettimeofday  equ 96
sys_clock_gettime equ 228

; Defined at <bits/time.h>.
CLOCK_REALTIME           equ 0
CLOCK_MONOTONIC          equ 1
CLOCK_PROCESS_CPUTIME_ID equ 2
CLOCK_THREAD_CPUTIME_ID  equ 3

; type td struct {
;   secs  uint64
;   nsecs uint64
; }
;  
; sizeof(td) = 16 bytes

section .text

; gettimeofday() -> rax
;  
; gettimeofday returns the time in seconds using the system time.
gettimeofday:
        push r12
        push r13
        push r14
        push r15

        mov r12, rdi                   ; arg1

; We allocate 16 bytes for the kernel to use the above structure.
        sub rsp, 16
        mov r13, rsp

        mov     rax, sys_gettimeofday
        mov     rdi, r13               ; arg1: *struct timespec
        mov     rsi, NUL               ; arg2: *struct timezone (unused)
        syscall 

; Get the seconds component, which is the first field. We'll be returning that.
        mov rax, qword [r13]

        add rsp, 16
        pop r15
        pop r14
        pop r13
        pop r12
        ret 

; clock_gettime(clock_type) -> rax
clock_gettime:
        push r12
        push r13
        push r14
        push r15

        mov r12, rdi                   ; arg1

; We allocate 16 bytes for the kernel to use the above structure.
        sub rsp, 16
        mov r13, rsp

        mov     rax, sys_clock_gettime
        mov     rdi, r12               ; arg1: clock type
        mov     rsi, r13               ; arg2: *struct timespec
        syscall 

; Get the seconds component, which is the first field. We'll be returning that.
        mov rax, qword [r13]

        add rsp, 16
        pop r15
        pop r14
        pop r13
        pop r12
        ret 


