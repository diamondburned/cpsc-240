global monotonic_getnanosecs
global cputime_getnanosecs
global nanosecs_to_double

extern clock_gettime

section .data

; Taken from <time.h>.
; https://elixir.bootlin.com/linux/v6.0/source/include/uapi/linux/time.h#L49
CLOCK_REALTIME           equ 0
CLOCK_MONOTONIC          equ 1
CLOCK_PROCESS_CPUTIME_ID equ 2
CLOCK_THREAD_CPUTIME_ID  equ 3
CLOCK_MONOTONIC_RAW      equ 4
CLOCK_REALTIME_COARSE    equ 5
CLOCK_MONOTONIC_COARSE   equ 6

secs_in_ns_ld equ 1000000000
secs_in_ns_lf equ __float64__(1000000000.0)

section .text

; monotonic_getnanosecs() -> int64
monotonic_getnanosecs:

        mov  rdi, CLOCK_MONOTONIC_RAW
        call clock_getnanosecs

; clock_getnanosecs(clockType) -> int64
clock_getnanosecs:

        push rbp
        mov  rbp, rsp

        push rdx
        push rsi
        push rdi
        push r12
        push r13
        push r14
        push r15

        mov r14, rdi                   ; CLOCK_* constant argument

        sub rsp, 16                    ; allocate sizeof(timespec)
        mov r15, rsp

        mov  rax, 0
        mov  rdi, r14
        mov  rsi, r15
        call clock_gettime

; The time_t is stored in r15, and the nanoseconds is stored in r15+8.
; Assuming POSIX-compliant system, time_t is an epoch timestamp in seconds.
; We can convert time_t to nanoseconds then add the nanoseconds.
        mov rax, [r15]
        mov rdx, secs_in_ns_ld
        mul rdx                        ; convert seconds to nanoseconds
        add rax, [r15+8]               ; add nanoseconds

; We're returning rax, so leave it be.

        add rsp, 16

        pop r15
        pop r14
        pop r13
        pop r12
        pop rdi
        pop rsi
        pop rdx

        pop rbp
        ret 

section .text

; nanosecs_to_double(nanosecs) -> double
nanosecs_to_double:

        cvtsi2sd xmm0, rdi             ; xmm0 = (double)arg1
        mov      rax, secs_in_ns_lf    ; load double constant to rax
        movq     xmm1, rax             ; load double constant to xmm1
        divsd    xmm0, xmm1            ; xmm0 /= secs_in_ns 

        ret 


