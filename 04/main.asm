; https://nasm.us/doc/nasmdoc4.html
; https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html
; https://www.felixcloutier.com/x86/index.html
; https://filippo.io/linux-syscall-table/
; https://linux.die.net/man/2/
; https://www.cs.uaf.edu/2012/fall/cs301/lecture/11_02_other_float.html
; https://www.nasm.us/xdoc/2.10.09/html/nasmdoc3.html
; http://unixwiz.net/techtips/x86-jumps.html
; Syscall reference: rax (inst), rdi, rsi, rdx, r10, r8, r9
global _start

%use fp
%include "_lib.asm"
%include "_math.asm"

section .data

LF  equ 10
NUL equ 0

stdin  equ 0
stdout equ 1

sys_read  equ 0
sys_write equ 1
sys_exit  equ 60

msg_welcome db  "Welcome to Accurate Cosines by Diamond Dinh.", LF, LF
len_welcome equ $ - msg_welcome

msg_timeis_1 db  "The time is now "
len_timeis_1 equ $ - msg_timeis_1

msg_timeis_2 db  " tics", LF, LF
len_timeis_2 equ $ - msg_timeis_2

msg_prompt_angle db  "Please enter an angle in degrees and press enter: "
len_prompt_angle equ $ - msg_prompt_angle

msg_invalid db  "You entered an invalid input. The program will now halt.", LF, LF
            db  "Have a nice day. Bye.", LF
len_invalid equ $ - msg_invalid

msg_entered_deg db  "You entered "
len_entered_deg equ $ - msg_entered_deg

msg_entered_rad db  "The equivalent radians is "
len_entered_rad equ $ - msg_entered_rad

msg_entered_cos db  "The cosine of those degrees is "
len_entered_cos equ $ - msg_entered_cos

msg_bye db  "Have a nice day. Bye.", LF
len_bye equ $ - msg_bye

msg_1lf db  LF
len_1lf equ $ - msg_1lf

msg_2lf db  LF, LF
len_2lf equ $ - msg_2lf

len_sample equ 100

section .bss

buf_sample resb len_sample

section .text

_start:
; Print the welcome message.
        @print msg_welcome, len_welcome

; Print the current time in ticks.
        @print      msg_timeis_1, len_timeis_1
        @print_tics 
        @print      msg_timeis_2, len_timeis_2

; Prompt for our angle into the sample buffer.
        @print msg_prompt_angle, len_prompt_angle
        @scan  buf_sample, len_sample
        mov    r14, rax                ; keep strlen in r14
        @print msg_1lf, len_1lf

; Convert the sample buffer string into a float64 in xmm0.
        @atof buf_sample, r14
        movsd xmm11, xmm0              ; keep degrees in xmm11

; Check if the float inputted is valid. atof will return a NaN if it receives an
; invalid input. According to ucomisd's documentation, the unordered flag is set
; if the source operand is NaN, so we check that.
        ucomisd xmm11, xmm11
; This is kind of peculiar. I've tried looking everywhere for a "jump if
; unordered", but that is simply not a thing. Instead, the documentation states
; that the PF flag is changed depending on unordered-ness, and JP is used to
; test for that flag. That's actually the right instruction to use.
        jp .invalid                    ; (j)ump if (parity)

; Confirm the angle entered.
        @print       msg_entered_deg, len_entered_deg
        @ftoa        xmm11, buf_sample, len_sample
        @print_float xmm11
        @print       msg_2lf, len_2lf

; Convert to radians and tell the user.
        @deg2rad     xmm11
        movsd        xmm12, xmm0       ; keep radians in xmm12
        @print       msg_entered_rad, len_entered_rad
        @print_float xmm12
        @print       msg_2lf, len_2lf

; Calculate the cosine into xmm0.
        @cos         xmm12
        movsd        xmm13, xmm0       ; keep cosine in xmm13
        @print       msg_entered_cos, len_entered_cos
        @print_float xmm13
        @print       msg_2lf, len_2lf

; Print the current time again in ticks.
        @print      msg_timeis_1, len_timeis_1
        @print_tics 
        @print      msg_timeis_2, len_timeis_2

; Bye.
        @print msg_bye, len_bye
        @exit  0

.invalid:
        @print msg_invalid, len_invalid
        @exit  1


