; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

%ifndef _lib

extern exit
extern atod
extern itoa
extern scan
extern print
extern print_int

; @atod(str, len) -> xmm0
%macro @atod 2
        mov  rdi, %1
        mov  rsi, %2
        call atod
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

; @exit(signal)
%macro @exit 1
        mov  rdi, %1
        call exit
%endmacro

%endif


