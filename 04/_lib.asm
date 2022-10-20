; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

%ifndef _lib

extern exit
extern atof
extern ftoa
extern itoa
extern scan
extern print
extern print_int
extern print_float

; @atof(str, len) -> xmm0
%macro @atof 2
        mov  rdi, %1
        mov  rsi, %2
        call atof
%endmacro

; @ftoa(num:xmm0, str, len) -> rax
%macro @ftoa 3
        movsd xmm0, %1
        mov   rdi, %2
        mov   rsi, %3
        call  ftoa
%endmacro

; @itoa(num, str, len) -> rax (parsed length)
%macro @itoa 3
        mov  rdi, %1
        mov  rsi, %2
        mov  rdx, %3
        call itoa
%endmacro

; @scan(str, len)
%macro @scan 2
        mov  rdi, %1
        mov  rsi, %2
        call scan
%endmacro

; @print(msg, len)
%macro @print 2
        mov  rdi, %1
        mov  rsi, %2
        call print
%endmacro

; @print_int(int)
%macro @print_int 1
        mov  rdi, %1
        call print_int
%endmacro

; @print_float(float:xmm?)
%macro @print_float 1
        movsd xmm0, %1
        call  print_float
%endmacro

; @print_time()
%macro @print_time 0
        rdtsc                          ; read time-stamp counter into rax
        @print_int rax                 ; print that counter
%endmacro

; @exit(signal)
%macro @exit 1
        mov  rdi, %1
        call exit
%endmacro

%endif


