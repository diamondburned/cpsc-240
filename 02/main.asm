extern printf
extern scanf
extern fgets
extern stdin
extern strchr

; https://stackoverflow.com/questions/30286671/receiving-input-using-fgets-in-assembly
; https://stackoverflow.com/questions/58863145/segmentation-fault-error-when-using-fgets-in-assembly
; https://stackoverflow.com/questions/53112333/nasm-x86-64-remove-new-line-character-and-add-0-at-the-end-of-string
; https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/x86-examples/string-io-demonstration-1-5?authuser=0
; https://github.com/hyqneuron/assembler/blob/master/doc/manual/nasm-language.txt#pseudo-instructions
; https://www.felixcloutier.com/x86
global entrypoint

segment .data

LF  equ 10
NUL equ 0

num_buflen equ 256

num_neg1 dq -1

msg_lf db LF, NUL

msg_str_f db "%s", NUL

msg_strln_f db "%s", LF, NUL

msg_enter_last db "Please enter your last name: ", NUL

msg_enter_title db "Please enter your title (Mr, Ms, Nurse, Engineer, etc.): ", NUL

msg_enter_trisides   db "Please enter the sides of your triangle separated by ws: ", NUL
msg_input_trisides_f db "%lf %lf", NUL

msg_enter_hypot_f db "The length of the hypotenuse is %lf units.", LF, NUL

msg_final_f db "Please enjoy your triangles %s %s.", LF, NUL

msg_invalid db "Invalid input. Exiting assembly.", LF, NUL

segment .bss

buf_last_name resb num_buflen
buf_title     resb num_buflen
buf_side1     resq 1
buf_side2     resq 1
buf_hypot     resq 1

segment .text

entrypoint:
        push rbp
        mov  rbp, rsp

        push rax
        push rdx
        push rsi
        push rdi

; Print the enter last name message.
        mov  rax, 0
        mov  rdi, msg_str_f            ; arg1
        mov  rsi, msg_enter_last       ; arg2
        call printf                    ; printf()

; Call fgets() to get the line, which will include LF.
        mov  rax, 0
        mov  rdi, buf_last_name        ; arg1: r12, last name buffer
        mov  rsi, num_buflen           ; arg2: buffer length
        mov  rdx, [stdin]              ; arg3: stdin
        call fgets                     ; fgets()

; Trim the new line off the buffer.
        mov  rax, 0
        mov  rdi, buf_last_name        ; arg1: last name buffer
        mov  rsi, LF                   ; new line char
        call strchr                    ; strchr(), returns a pointer to the new line
        mov  byte [rax], NUL           ; write a NUL over the new line to trim it

; Print the enter title message.
        mov  rax, 0
        mov  rdi, msg_str_f            ; arg1
        mov  rsi, msg_enter_title      ; arg2
        call printf                    ; printf()

; Call fgets() to get the line, which will include LF.
        mov  rax, 0
        mov  rdi, buf_title            ; arg1: r13, title buffer
        mov  rsi, num_buflen           ; arg2: buffer length
        mov  rdx, [stdin]              ; arg3: stdin
        call fgets                     ; fgets()

; Trim the new line off the buffer.
        mov  rax, 0
        mov  rdi, buf_title            ; arg1: title buffer
        mov  rsi, LF                   ; new line char
        call strchr                    ; strchr(), returns a pointer to the new line
        mov  byte [rax], NUL           ; write a NUL over the new line to trim it

; Print the triangle sides message.
        mov  rax, 0
        mov  rdi, msg_str_f            ; arg1
        mov  rsi, msg_enter_trisides   ; arg2
        call printf                    ; printf()

; Read the two sides length using scanf(). We'll use its rax return to determine
; if the read is successful.
        mov  rax, 0
        mov  rdi, msg_input_trisides_f ; arg1
        mov  rsi, buf_side1            ; arg2: double ptr
        mov  rdx, buf_side2            ; arg3: double ptr
        call scanf                     ; scanf()
        cmp  rax, 0                    ; if (scanf() == NULL)
        je   invalid                   ; then goto invalid

; Formula for the hypotenuse: sqrt(pow(a, 2) + pow(b, 2))
; Translated into C then Assembly:
        movsd  xmm11, [buf_side1]      ; xmm11      = *buf_side1
        movsd  xmm12, [buf_side2]      ; xmm12      = *buf_side2
        mulsd  xmm11, xmm11            ; xmm11      *= xmm11
        mulsd  xmm12, xmm12            ; xmm12      *= xmm12
        addsd  xmm11, xmm12            ; xmm11      += xmm12
        sqrtsd xmm13, xmm11            ; xmm13      = sqrtsd(xmm11)
        movsd  [buf_hypot], xmm13      ; *buf_hypot = xmm13

        mov   rax, 1
        mov   rdi, msg_enter_hypot_f
        movsd xmm0, [buf_hypot]
        call  printf

; Print the final message.
        mov  rax, 0
        mov  rdi, msg_final_f          ; arg1
        mov  rsi, buf_title            ; arg2
        mov  rdx, buf_last_name        ; arg3
        call printf                    ; printf()

; Ensure we return the hypotenuse.
        movsd xmm0, [buf_hypot]

return:
        pop rdi                        ; cleanup
        pop rsi
        pop rdx
        pop rax

        pop rbp
        ret 

invalid:
        mov  rax, 0
        mov  rdi, msg_invalid          ; arg1
        call printf                    ; printf()

        movsd xmm0, [num_neg1]         ; Write garbage float.
        jmp   return                   ; return


