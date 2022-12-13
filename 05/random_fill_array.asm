global random_fill_array

section .text

; void random_fill_array(double *array, int64_t size)
random_fill_array:
        push rbp
        mov  rbp, rsp

        push r12
        push r13
        push r14
        push r15

        mov r14, rdi                   ; arg1: array pointer
        mov r15, rsi                   ; arg2: array size

        mov r13, 0                     ; initialize index

.loop:
; Length check.
        cmp r13, r15
        jge .done

; Generate random number using rdrand.
        mov    rax, 0
        rdrand rax

; Cast to double and store in xmm0.
        movq xmm0, rax

; Assert that it's not NaN, regenerate if it is.
        ucomisd xmm0, xmm0             ; if NaN, then parity flag is set
        jp      .loop                  ; (j)ump if (p)arity

; Store random float number in array.
        movsd [r14 + (r13 * 8)], xmm0

; Increment index and reloop.
        inc r13
        jmp .loop

.done:
        pop r15
        pop r14
        pop r13
        pop r12

        pop rbp
        ret 


