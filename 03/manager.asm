; Name: Diamond Dinh
; Language(s): C, x86 Assembly
; Dates: 1 October, 2022 - 9 October, 2022
; File(s): display_array.cpp, input_array.asm, main.c, manager.asm, sum.asm
; Status: Done
; References:
;   https://nasm.us/doc/nasmdoc4.html
;   https://cs.lmu.edu/~ray/notes/nasmtutorial/
;   https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html
;   https://stackoverflow.com/questions/7607550/scanf-skip-variable
;   https://www.felixcloutier.com/x86
; Module Info:
;   File name: manager.asm
;   Language: x86 Assembly
; How to run:
;   build.sh
;   03.out (or whatever the folder name was + ".out")

global manager

extern printf
extern fgets
extern stdin
extern strchr

extern input_array
extern display_array
extern sum

section .data

LF  equ 10
NUL equ 0

msg_enter_name db "Please enter your name: ", NUL

msg_enter_sums db LF,
               db "This program will sum your array of integers.", LF,
               db "Enter a sequence of long integers separated by white space.", LF
               db "After the last input press enter followed by Control+D: ", LF, NUL

msg_warn_omitted db LF,
                 db "One or more numbers were invalid and were omitted from the array.", LF, NUL

msg_list_numbers db LF,
                 db "These number were received and placed into the array:", LF, NUL

msg_sum_f db LF,
          db "The sum of the %d numbers in this array is %d.", LF, NUL

msg_return db LF,
           db "This program will return execution to the main function.", LF, NUL

num_buf_name_len   equ 256
num_num_array_len  equ 50 ; about fiddy numbers
num_num_array_size equ 4 ; 32-bit integer; refer to input_array's documentation.

section .bss

buf_name  resb num_buf_name_len
num_array resd 256 ; dword, so int (4 bytes), also num_num_array_size

section .text

manager:
        push rbp
        mov  rbp, rsp

        push rdx
        push rsi
        push rdi
        push r11
        push r12
        push r13
        push r14
        push r15

; Print the full name prompt.
        mov  rax, 0
        mov  rdi, msg_enter_name       ; arg1: message
        call printf                    ; printf()

; Read the name from stdin by slurping the entire line.
        mov  rax, 0
        mov  rdi, buf_name             ; arg1: name buffer
        mov  rsi, num_buf_name_len     ; arg2: name buffer length
        mov  rdx, [stdin]              ; arg3: stdin
        call fgets                     ; rax = fgets()

; Trim the trailing new line. We do this by seeking for the new line byte in
; the string that fgets just read onto.
        mov  rax, 0
        mov  rdi, buf_name             ; arg1: name buffer
        mov  rsi, LF                   ; arg2: new line character
        call strchr                    ; rax = strchr()

; The value returned by strchr is actually a pointer to the first occurrence
; of the new line character. We'll just set the byte at that address to NUL
; to terminate the string without the new line.
        mov byte [rax], 0

; Print the super long prompt asking for numbers.
        mov  rax, 0
        mov  rdi, msg_enter_sums       ; arg1: message
        call printf                    ; printf()

; Define this for our next few blocks. It'll just be a temporary alias.
%define has_bad_input_ptr r12
%define read_count r13
; Reserve a boolean for us to know if we had bad input or not. We'll actually
; just reserve 16 bytes for alignment reasons.
        sub rsp, 16
        mov has_bad_input_ptr, rsp

; Prompt the numbers using our trusty Assembly function.
        mov  rax, 0
        mov  rdi, num_array            ; arg1: array pointer to store numbers to
        mov  rsi, num_num_array_len    ; arg2: array length
        mov  rdx, has_bad_input_ptr    ; arg3: pointer to boolean for bad input
        call input_array               ; input_array()
        mov  read_count, rax           ; Store the number of numbers read.

; Override the has_bad_input_ptr with the actual value. What this means is
; that we use the register to sture the 0 or 1 instead of a pointer to the
; stack.
%define has_bad_input has_bad_input_ptr
        mov has_bad_input, [has_bad_input_ptr]

; Unallocate the boolean pointer.
        add rsp, 16

; Check if we've had any bad inputs using the boolean pointer. Go straight to
; good_input if we don't have any.
        cmp has_bad_input, 0           ; if (has_bad_input == FALSE)
        je  good_input                 ;   goto good_input;

; Tell the user that the input is bad.
        mov  rax, 0
        mov  rdi, msg_warn_omitted     ; arg1: message
        call printf                    ; printf()

good_input:

; Print the prompt saying we will print the list of numbers.
        mov  rax, 0
        mov  rdi, msg_list_numbers     ; arg1: message
        call printf                    ; printf()

; Print the number list with the help of our C++ function disguised as a C
; function.
        mov  rax, 0
        mov  rdi, num_array            ; arg1: array pointer
        mov  rsi, read_count           ; arg2: what we've read so far
        call display_array             ; display_array()

; Use our trusty Assembly function to calculate the sum. Note that even though
; it returns a 4-byte int, it should still fit into an 8-byte register with
; no convesion required. Thanks, Little Endian!
        mov  rax, 0
        mov  rdi, num_array            ; arg1: array pointer
        mov  rsi, read_count           ; arg2: what we've read so far
        call sum                       ; sum()

; Steal has_bad_input_ptr to store our sum (as sum_num to avoid conflicts).
%define sum_num has_bad_input_ptr
        mov sum_num, rax

; Print the sum_num and the length.
        mov  rax, 0
        mov  rdi, msg_sum_f            ; arg1: message
        mov  rsi, read_count           ; arg2: what we've read so far
        mov  rdx, sum_num              ; arg3: sum
        call printf                    ; printf()

; Print the final goodbye message.
        mov  rax, 0
        mov  rdi, msg_return           ; arg1: message
        call printf                    ; printf()

; Before we exit, let's return the full name back to the caller.
        mov rax, buf_name

; We're done! Do our usual cleanup.
        pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop rdi
        pop rsi
        pop rdx

        pop rbp
        ret 


