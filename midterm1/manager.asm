global manager

extern fgets
extern stdin
extern strchr
extern printf
extern max
extern get_data
extern show_data

section .data

LF  equ 10
NUL equ 0

msg_enter_name db LF,
               db "Please enter your name: ", NUL

msg_enter_nums db LF,
               db "Please enter floating point numbers separated by ws to be stored in a array of size 6 cells.", LF,
               db "After the last input press <enter> followed by <control+d>.", LF, NUL

msg_largest_f db LF,
              db "The largest value in the array is %lf", LF, NUL

msg_show_pre db LF,
             db "These numbers are stored in the array", LF, NUL

num_namebuf_len equ 256
num_numbuf_len  equ 6

section .bss

ptr_namebuf     resb 256
ptr_numbuf      resq 6
ptr_numread     resq 1
ptr_has_invalid resb 1

section .text

manager:
        push rbp
        mov  rbp, rsp

        push rdi
        push rsi
        push rdx
        push r11
        push r12                       ; v safe to use
        push r13
        push r14
        push r15

; Print the full name prompt.
        mov  rax, 0
        mov  rdi, msg_enter_name       ; arg1: message
        call printf                    ; printf()

; Read the name from stdin by slurping the entire line.
        mov  rax, 0
        mov  rdi, ptr_namebuf          ; arg1: name buffer
        mov  rsi, num_namebuf_len      ; arg2: name buffer length
        mov  rdx, [stdin]              ; arg3: stdin
        call fgets                     ; rax = fgets()

; Trim the trailing new line. We do this by seeking for the new line byte in
; the string that fgets just read onto.
        mov  rax, 0
        mov  rdi, ptr_namebuf          ; arg1: name buffer
        mov  rsi, LF                   ; arg2: new line character
        call strchr                    ; rax = strchr()

; The value returned by strchr is actually a pointer to the first occurrence
; of the new line character. We'll just set the byte at that address to NUL
; to terminate the string without the new line.
        mov byte [rax], 0

; Print the super long prompt asking for numbers.
        mov  rax, 0
        mov  rdi, msg_enter_nums       ; arg1: message
        call printf                    ; printf()

; Call get_data.
        mov  rax, 0
        mov  rdi, ptr_numbuf           ; arg1: ptr to double array
        mov  rsi, num_numbuf_len       ; arg2: size of array
        mov  rdx, ptr_has_invalid      ; arg3: ptr to has_invalid bool
        call get_data                  ; rax = get_data()
        mov  [ptr_numread], rax        ; *ptr_numread = rax

; Print the message.
        mov  rax, 0
        mov  rdi, msg_show_pre         ; arg1: f-string
        call printf                    ; printf()

; Call show_data.
        mov  rax, 0
        mov  rdi, ptr_numbuf           ; arg1: ptr to double array
        mov  rsi, [ptr_numread]        ; arg2: size of array
        call show_data                 ; show_data()

; Call max.
        mov  rax, 0
        mov  rdi, ptr_numbuf           ; arg1: ptr to double array
        mov  rsi, [ptr_numread]        ; arg2: size of array
        call max                       ; xmm0 = max()

; Borrow xmm12 for the max.
%define max xmm12
        movsd max, xmm0

; Print the largest value.
        mov   rax, 1
        mov   rdi, msg_largest_f       ; arg1: f-string
        movsd xmm0, max                ; arg2: largest value (to xmm0)
        call  printf                   ; printf()

; Return the full name.
        mov rax, ptr_namebuf           ; rax = ptr_namebuf

; Bye.
        pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop rdx
        pop rsi
        pop rdi

        pop rbp
        ret 


