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

        segment .text
floating_point_io:
        push rbp                       ; begin new function stack frmae
        mov rbp, rsp                   ; bp = back ptr, sp = stack ptr

        mov rdi, msg_please_enter      ; arg1, f-string
        call printf                    ; printf(...)

; ; mov rax, 0                     ; tell scanf there's no xmm instructions involved
; mov rdi, msg_float_f           ; arg1, f-string
; push qword 0                   ; push a new float64 (qword) onto the stack (rsp)
; mov rsi, rsp                   ; arg2, addr of stack
; call scanf                     ; scanf(...)
; movsd xmm12, [rsp]             ; use movsd (single double) for float64, not mov; [rsp] = *rsp
; pop rax

; Alternatively, scanf %s and atof it.
        mov rdi, msg_str_f             ; arg1, f-string
        sub rsp, 1024                  ; grow a 1024-byte stack
        mov rsi, rsp                   ; arg2, make scanf output to stack pointer
        call scanf                     ; scanf(...), how does scanf know to use rsp?

; Validate input
        mov rax, 0                     ; zero out rax; this is used for returns
        mov rdi, rsp                   ; arg1, use stack pointer as argument
        call isfloat

; Exit if not float
        cmp rax, 0                     ; rax == 0
        je throw_invalid_float         ; if rax == 0 (FALSE); then goto exit_1

; Call atof to get a float
        mov rdi, rsp                   ; arg1, become the 1024-byte stack
        call atof
        movsd xmm12, xmm0              ; save to xmm12

; This is for testing, but we need to use xmm0 as the register for the return value.
; mov rax, 0                     ; copy 0 to rax
; push rax                       ; put that on top of the stack
; movsd xmm0, [rsp]              ; xmm0 = *rsp
; pop rax                        ; undo rax

finish:
        add rsp, 1024                  ; clean up the 1024-byte grow
        pop rbp                        ; undo function stack
        ret                            ; return, this will use xmm0

throw_invalid_float:
        mov rdi, msg_invalid_float     ; arg1, invalid float message
        call printf                    ; printf(...)
        movsd xmm0, [num_neg_1]        ; write -1 to be returned
        jmp finish                     ; return

        segment .data
num_neg_1:
        dq 0xBFF0000000000000
msg_n:
        db 0xA, 0
msg_str_f:
        db "%s", 0
msg_float_f:
        db "%lf", 0
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
