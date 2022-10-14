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
;   File name: sum.asm
;   Language: x86 Assembly
; How to run:
;   build.sh
;   03.out (or whatever the folder name was + ".out")

global sum

section .data

LF  equ 10
NUL equ 0

msg_sum_f db "The sum of the %d numbers in this array is %d.", LF, NUL

num_sizeof_int equ 4

section .text

; sum is a function with two parameters: the first one is the pointer to the
; number array that is to be summed, and the second one is the size of the
; given array. It returns the sum. The number type is int, so 4-byte.
;  
; In C, this function would look like this:
;  
;    int sum(int *array, int size);
;  
sum:
        push rbp
        mov  rbp, rsp

        push rdx
        push rsi
        push rdi
        push r12
        push r13
        push r14
        push r15

; Let's slurp our arguments into r12 and r13 first.
%define array_ptr r12
%define array_size r13
        mov array_ptr, rdi
        mov array_size, rsi

; In order to simplify what we have to do during the loop, we will just
; calculate the end pointer right here. Let's borrow r14 for that.
%define end_ptr r14
        mov rax, num_sizeof_int        ; rax = 4 (bytes)
        mul array_size                 ; rax = rax * array_size (bytes)
        add rax, array_ptr             ; rax = rax + array_ptr (pointer)
        mov end_ptr, rax               ; end_ptr = rax (bytes)

; We'll steal array_ptr and increment that by num_sizeof_int to move this
; pointer over to the next element as we go. We don't need that anymore after
; this, so we're good.
;  
; Remember that we have to keep array_size as it is, because we'll be printing
; it later.

; Let's use eax to keep track of the sum. Initialize it to 0. Since we're using
; eax, this implies that we're working with 4-byte integers.
        mov eax, 0

sum_loop:
        add eax, [array_ptr]           ; rax = rax + *array_ptr

; Increment our array pointer by an element.
        add array_ptr, num_sizeof_int
; Bound-check. Continue if we're not there yet.
        cmp array_ptr, end_ptr
        jne sum_loop

; We're done. Our return value is already in eax, which is also rax because of
; Little Endian magic.

; Clean up.
        pop r15
        pop r14
        pop r13
        pop r12
        pop rdi
        pop rsi
        pop rdx

        pop rbp
        ret 


