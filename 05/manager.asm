global manager

extern monotonic_getnanosecs ; long monotonic_getnanosecs()
extern nanosecs_to_double    ; double nanosecs_to_double(long nanosecs)
extern random_fill_array     ; void random_fill_array(double *array, int64_t size)
extern display               ; void display(double *array, size_t start, size_t len)
extern calloc                ; void* calloc(size_t n, size_t size)
extern printf                ; void printf(const char *format, ...)
extern scanf                 ; int scanf(const char *format, ...)
extern fsort                 ; void fsort(double *farray, size_t arraylen)
extern abort                 ; void abort()
extern free                  ; void free(void *ptr)

section .data

LF  equ 10
NUL equ 0

stdin  equ 0
stdout equ 1

str_lf      db LF, NUL
str_strf    db "%s", NUL
str_longf   db "%ld", NUL
str_doublef db "%lf", NUL

str_lenprompt db "Please input the count of number of data items to be placed "
              db "into the array with maximum 10 million: ", NUL

str_filled db "The array has been filled with non-deterministic random 64-bit "
           db "float numbers.", LF, NUL

str_beginning_numbers db "Here are 10 numbers of the array at the beginning of "
                      db "the array.", LF, NUL

str_middle_numbers db "Here are 10 numbers of the array at the middle of the "
                   db "array.", LF, NUL

str_ending_numbers db "Here are 10 numbers of the array at the end of the "
                   db "array.", LF, NUL

str_begin_sortingf db "The time is now %ld nanoseconds. ",
                   db "Sorting will begin.", LF, NUL

str_end_sortingf db "The time is now %ld nanoseconds. ",
                 db "Sorting has finished.", LF, NUL

str_sort_timef db "Total sort time is %ld nanoseconds which equals %lf seconds."
               db LF, NUL

str_done db "The benchmark time will be returned to the driver.", LF, NUL

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

manager:
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

%macro @print_array 0
; Print the first 10 numbers of the array.
        @print   str_beginning_numbers
        @display [ptr_array], 0, 10
        @print   str_lf

; Calculate the midpoint and print the middle 10 numbers of the array.
        @print   str_middle_numbers
        mov      r12, [len_array]
        shr      r12, 1                ; divide length by 2
        sub      r12, 10/2             ; subtract to get the first index
        @display [ptr_array], r12, 10
        @print   str_lf

; Print the last 10 numbers of the array.
        @print   str_ending_numbers
        mov      r12, [len_array]
        sub      r12, 10
        @display [ptr_array], r12, 10
        @print   str_lf
%endmacro

; Call our print array macro.
        @print_array 

; Report current time before we start sorting.
        mov  rax, 0
        call monotonic_getnanosecs
        mov  r12, rax                  ; keep start time in r12

        mov  rax, 0
        mov  rdi, str_begin_sortingf
        mov  rsi, r12
        call printf

        @print str_lf

; Actually do the sorting.
        mov  rax, 0
        mov  rdi, [ptr_array]
        mov  rsi, [len_array]
        call fsort

; Report current time again after we finished sorting.
        mov  rax, 0
        call monotonic_getnanosecs
        mov  r13, rax                  ; keep end time in r13

        mov  rax, 0
        mov  rdi, str_end_sortingf
        mov  rsi, r13
        call printf

        @print str_lf

; Convert start and end times to seconds.
        mov   rdi, r12
        call  nanosecs_to_double
        movsd xmm12, xmm0              ; keep start seconds in xmm12

        mov   rax, 0
        mov   rdi, r13
        call  nanosecs_to_double
        movsd xmm13, xmm0              ; keep end seconds in xmm13

; Calculate the difference between the start and end times and print it.
        sub   r13, r12                 ; runtime in nanoseconds is in r13
        subsd xmm13, xmm12             ; runtime in seconds is in xmm13

        mov   rax, 1
        mov   rdi, str_sort_timef
        mov   rsi, r13
        movsd xmm0, xmm13
        call  printf

        @print str_lf

; Call our print array macro.
        @print_array 

; We're done. Print a message and exit.
        @print str_done
        @print str_lf

; Free our dynamically allocated array.
        mov  rax, 0
        mov  rdi, [ptr_array]
        call free

; Return our runtime in seconds to the caller.
        movsd xmm0, xmm13

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


