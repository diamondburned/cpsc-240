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
;   File name: input_array.asm
;   Language: x86 Assembly
; How to run:
;   build.sh
;   03.out (or whatever the folder name was + ".out")

global input_array

extern abort
extern scanf
extern printf

section .data

LF  equ 10
NUL equ 0
EOF equ -1 ; scanf returns the EOF constant when the user triggers one. I don't
           ; really have the EOF constant within nasm, but glibc just uses -1.
           ; I can't really find any glibc documentation/manual on this, though.

msg_int_f         db "%d", NUL
msg_str_ignored_f db "%*s", NUL
msg_oob_exception db "panic: out of bounds exception", LF, NUL

int_item_size equ 4 ; sizeof(int)

section .text

; Before we enter the program, let's reserve some higher registers and give
; them names just to make our lives easier. We can use macros for this.
; Note that DO NOT use r11 and below if we don't need to. C functions will
; override them, so be careful!
%define array_ptr r12
%define array_len r13
%define had_bad_input_ptr r14
%define nums_read r15

; Here's the plan. We're accepting a pointer to a fixed-sized array of
; integers, which will be our buffer to read onto.
;  
; We're also accepting the array length as another argument. Just like C.
;  
; We're also accepting a third argument that is whether or not there had been
; a bad input from the user. This value is initialized to FALSE by the function.
;  
; We'll return the number of integers that we have successfully read.
;  
; Note that the function will take care of zeroing out the given array. The
; caller need not to initialize it to all zeros.
;  
; In C terms, this would look like
;  
;    int input_array(int *array, int array_len, bool* has_bad_input);
;  
; For example, the function can be used like this:
;  
;    int array[10];
;    bool had_bad_input;
;    int n = input_array(array, 10, &had_bad_input);
;    if (had_bad_input) {
;        printf("had bad input\n");
;    } else {
;        printf("good input\n");
;    }
;    printf("we've read %d numbers:\n", n);
;    for (int i = 0; i < n; i++) {
;        printf("%d ", array[i]);
;    }
;  
input_array:
        push rbp
        mov  rbp, rsp

        push rdx
        push rsi
        push rdi
        push r10
        push array_ptr
        push array_len
        push had_bad_input_ptr
        push nums_read

; Read the arguments given to us. The first argument is just the array pointer,
; so we store that into our register.
        mov array_ptr, rdi

; Then, we read the length. Note that we're not actually going to be working
; with a length. Instead, we'll just keep track of the end of the array then
; compare that to the current pointer. Also, we're subtracting 1 from the
; length, since we want to reserve space for the NUL-terminator.
        mov array_len, rsi             ; Put the length to the end pointer for
                                       ; now.

; The third argument is a pointer to a boolean that indicates whether or not
; there had been a bad input. This one points to a bool, so it's ONE byte!
        mov had_bad_input_ptr, rdx
        mov byte [had_bad_input_ptr], 0

; We've read nothing. Initialize it as such.
        mov nums_read, 0

do_read:
        mov  rax, 0
        mov  rdi, msg_int_f            ; arg1: format string
        mov  rsi, array_ptr            ; arg2: array pointer to read into
        call scanf                     ; rax = fscanf()
        mov  r10, rax                  ; Store the result into r10.

; We have to check scanf's return value now. If 0 is returned, then the user
; didn't enter anything properly. If -1 is returned, then we got an EOF. If 1
; is returned, then the user followed our instructions competently :)
;  
; In short, compare r10. If:
;  
;    > 0  =>  1  =>  We scanned something.
;    = 0  =>  0  =>  User typed something bad.
;    < 0  => -1  =>  User hit EOF.
;  
; We have to use r10d here instead of r10, even though we did mov r10, rax. This
; is because scanf() returns a 32-bit int, while r10 is a 64-bit register. We
; use r10d to tell the CPU to only use the lower 32 bits of r10.
        cmp r10d, 0
        jg  good_input                 ; We scanned something.
        je  bad_input                  ; User typed something bad.
        jl  eof                        ; User hit EOF.

good_input:

; Count this input by incrementing the number of integers tracker.
        inc nums_read

; BE SAFE! Check that we're not going to read past the end of the array.
; If we are, explode the whole program. The user must not continue!
        cmp nums_read, array_len
        jge oob_exception

; Increment the array pointer index.
        add array_ptr, int_item_size

; Keep reading.
        jmp do_read

bad_input:

; Keep track of whether or not we inputted anything wrong.
        mov byte [had_bad_input_ptr], 1

; scanf didn't actually consume the erroneous number (probably because they
; cache it), so we just slurp the erroneous word ourselves.
        mov  rax, 0
        mov  rdi, msg_str_ignored_f
        call scanf

; Keep reading.
        jmp do_read

oob_exception:

; Notify the user of the out of bounds exception.
        mov  rax, 0
        mov  rdi, msg_oob_exception    ; arg1: message string
        call printf                    ; printf()

; Explode.
        mov  rax, 0
        call abort

eof:

; Write our return value into rax.
        mov rax, nums_read

; We can proceed to clean up and exit the program.
        pop nums_read
        pop had_bad_input_ptr
        pop array_len
        pop array_ptr
        pop r10
        pop rdi
        pop rsi
        pop rdx

        pop rbp
        ret 


