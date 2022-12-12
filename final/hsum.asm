; Diamond Dinh
; CPSC 240-01
; Final Program Test
; diamondburned@csu.fullerton.edu

global hsum

section .text

; double hsum(double* a, unsigned long len)

; hsum calculates the harmonic sum of a.
hsum:
        push rbp
        mov  rbp, rsp

        push r10
        push r11
        push r12
        push r13
        push r14
        push r15

        mov r14, rdi                   ; arg1: array pointer
        mov r15, rsi                   ; arg2: array length

        mov  rax, __float64__(0.0)
        movq xmm14, rax                ; use xmm14 as sum accumulator

        mov r12, 0                     ; use r9 as array index

.loop:
        cmp r12, r15                   ; length check
        jge .done                      ; break if done

        mov   rax, __float64__(1.0)
        movq  xmm0, rax                ; xmm0 = 1.0
        movq  xmm1, [r14 + (r12*8)]    ; xmm1 = array element
        divsd xmm0, xmm1               ; xmm0 = 1.0 / array_element
        addsd xmm14, xmm0              ; xmm14 += xmm0

        inc r12                        ; increment array index
        jmp .loop

.done:
        movsd xmm0, xmm14              ; return accumulator in xmm0

        pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10

        pop rbp
        ret 


