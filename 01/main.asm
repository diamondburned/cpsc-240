        extern printf
        extern scanf
        extern atof
        extern isfloat
        extern exit

        global floating_point_io

; |          |
; |==========| <- rsp (stack pointer)
; |==========|
; |==========|
; |__________| <- rbp (back pointer)

; rax - accumulator, return data sometimes

; Writing 0 to rax is just something that you should just do. If you don't, the
; program may randomly SEGFAULT. This is fun :)

        segment .text
floating_point_io:
        push rbp                       ; begin new function stack frmae
        mov rbp, rsp                   ; bp = back ptr, sp = stack ptr

        push rsi
        push rdi
        push rdx
        push r12
        push r13

        mov rax, 0
        mov rdi, msg_please_enter      ; arg1, f-string
        call printf                    ; printf(...)

; We should scanf %s and atof it, just so we can use isfloat().
; Call scanf with 2 1024-byte stack buffers. Not too sure what happens if it overflows, lol.
        mov rax, 0
        mov rdi, msg_str2_f            ; arg1, f-string for 2 %s
        sub rsp, [num_scanf_buflen]    ; grow a 1024-byte stack ONCE for do_scan
        mov rsi, rsp                   ; arg2, make scanf output to stack pointer
        sub rsp, [num_scanf_buflen]    ; grow the stack again for the second string
        mov rdx, rsp                   ; arg3, another buffer
        call scanf                     ; scanf(...), how does scanf know to use rsp?

; Copy first string to r12, second to r13.
        mov r12, rsi
        mov r13, rdx

; Validate input r12
        mov rax, 0                     ; zero out rax; this is used for returns
        mov rdi, r12                   ; arg1, use stack pointer as argument
        call isfloat                   ; rax = isfloat(...)
; Exit if not float
        cmp rax, 0                     ; rax == 0
        je throw_invalid_float         ; if above, then goto exit_1

; Validate input r13
        mov rax, 0                     ; zero out rax; this is used for returns
        mov rdi, r13                   ; arg1, use stack pointer as argument
        call isfloat                   ; rax = isfloat(...)
; Exit if not float
        cmp rax, 0                     ; rax == 0
        je throw_invalid_float         ; if above, then goto exit_1

; Call atof to get the first float
        mov rax, 0
        mov rdi, r12                   ; arg1, first string
        call atof
        movsd xmm12, xmm0              ; write to xmm12

; Call atof to get the second float
        mov rax, 0
        mov rdi, r13                   ; arg1, second string
        call atof
        movsd xmm13, xmm0              ; write to xmm13

; We're done scanning.
        mov rax, 1                     ; 1 xmm arg needed
        mov rdx, msg_float_f           ; arg1: f-string
        movsd xmm0, xmm12              ; xmm0 = xmm13 for printf
        call printf

        mov rax, 1                     ; 1 xmm arg needed
        mov rdx, msg_float_f           ; arg1: f-string
        movsd xmm0, xmm13              ; xmm0 = xmm13 for printf
        call printf
; ucomisd

return:
        add rsp, num_scanf_buflen      ; clean up the 1024-byte grow
        add rsp, num_scanf_buflen      ; clean up the 1024-byte grow
        pop r13
        pop r12
        pop rdx
        pop rdi                        ; unwind
        pop rsi
        pop rbp                        ; undo function stack
        ret                            ; return, this will use xmm0

throw_invalid_float:
        mov rdi, msg_invalid_float     ; arg1, invalid float message
        call printf                    ; printf(...)
        movsd xmm0, [num_neg_1]        ; write -1 to be returned
        jmp return

        segment .data
num_neg_1:
        dq 0xBFF0000000000000
num_scanf_buflen:
        dq 1024
msg_n:
        db 0xA, 0
msg_str2_f:
        db "%s %s", 0
msg_str_f:
        db "%s", 0
msg_float_f:
        db "%1.15lf", 0
msg_please_enter:
        db "Please enter two float numbers separated by white space. Press enter after the second input.", 0xA, 0
msg_confirm_entered:
        db "These numbers were entered:", 0xA, 0
msg_largest_number_f:
        db "The larger number is %f", 0xA, 0
msg_ret_to_driver:
        db "This assembly module will now return execution to the driver module.", 0xA, "The smaller number will be returned to the driver.", 0
msg_invalid_float:
        db "An invalid input was detected. You may run this program again", 0xA, 0
