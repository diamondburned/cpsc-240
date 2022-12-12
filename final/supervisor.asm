; Diamond Dinh
; CPSC 240-01
; Final Program Test
; diamondburned@csu.fullerton.edu

global supervisor

; Local
extern random_fill_array ; void random_fill_array(double *array, int64_t size)
extern display_array     ; void display_array(double *array, size_t start, size_t len)
extern hsum              ; double hsum(double *array, int64_t size)

; C stdlib
extern calloc ; void *calloc(size_t nmemb, size_t size)
extern printf ; void printf(const char *format, ...)
extern scanf  ; int scanf(const char *format, ...)
extern abort  ; void abort()
extern free   ; void free(void *ptr)

section .data

LF  equ 10
NUL equ 0

stdin  equ 0
stdout equ 1

str_lf      db LF, NUL
str_strf    db "%s", NUL
str_longf   db "%ld", NUL
str_doublef db "%.9lf", NUL

str_lenprompt db "Please input the count of number of data items to be placed "
              db "into the array with maximum 1 million: ", NUL

str_filled db "The array has been filled with non-deterministic random 64-bit "
           db "float numbers.", LF, NUL

str_display db "Here are the values in the array:", LF, NUL

str_hsumf  db "The harmonic sum is %.9lf", LF, NUL
str_hmeanf db "The harmonic mean is %.9lf", LF, NUL

str_return db "The supervisor will return the mean to the caller.", LF, NUL

str_throw db "An unexpected error has occurred.", LF
          db "The program will now exit.", LF, NUL

max_len equ 10000000

section .bss

len_array resq 1 ; long int
ptr_array resq 1 ; double*

section .text

; @print(msg)
%macro @print 1
        mov  rdi, str_strf
        mov  rsi, %1
        mov  rax, 0
        call printf
%endmacro

; @display(array, start, len)
%macro @display 3
        mov  rdi, %1
        mov  rsi, %2
        mov  rdx, %3
        mov  rax, 0
        call display
%endmacro

supervisor:
        push rbp
        mov  rbp, rsp

        push r10
        push r11
        push r12
        push r13
        push r14
        push r15

; Prompt for the array length.
        @print str_lenprompt

; Scan the array length.
        mov  rax, 0
        mov  rdi, str_longf
        mov  rsi, len_array
        call scanf
        cmp  rax, 1                    ; validate input
        jne  .panic                    ; panic if input is invalid

        @print str_lf

; Check that the inputted length is valid.
        cmp qword [len_array], max_len
        jg  .panic

; Allocate the array on the heap using calloc.
        mov  rax, 0
        mov  rdi, [len_array]
        mov  rsi, 8
        call calloc
        mov  [ptr_array], rax

; Fill the array with random numbers.
        mov    rax, 0
        mov    rdi, [ptr_array]
        mov    rsi, [len_array]
        call   random_fill_array
        @print str_filled
        @print str_lf

; Print the array.
        @print str_display
        mov    rax, 0
        mov    rdi, [ptr_array]
        mov    rsi, 0
        mov    rdx, [len_array]
        call   display_array
        @print str_lf

; Calculate and print the harmonic sum (xmm14).
        mov   rax, 0
        mov   rdi, [ptr_array]
        mov   rsi, [len_array]
        call  hsum
        movsd xmm14, xmm0

        mov    rax, 1
        mov    rdi, str_hsumf
        movsd  xmm0, xmm14
        call   printf
        @print str_lf

; Calculate and print the harmonic mean (xmm15). We calculate hmean as
; count/hsum.
        mov      rax, [len_array]      ; type long
        cvtsi2sd xmm15, rax            ; convert long to double (xmm15)
        divsd    xmm15, xmm14          ; xmm15 = xmm15 / xmm14 = count / hsum

        mov    rax, 1
        mov    rdi, str_hmeanf
        movsd  xmm0, xmm15
        call   printf
        @print str_lf

; Done. Print and return our harmonic mean.
        @print str_return
        @print str_lf
        movsd  xmm0, xmm15

        pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10

        pop rbp
        ret 

.panic:
        @print str_throw
        call   abort


