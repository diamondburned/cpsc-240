; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

%ifndef _math

; @cmul(a, b) -> rax
%macro @cmul 2
        mov  rax, %1
        mov  rdi, %2
        imul rdi
%endmacro

; @cdiv(a, b) -> (rax, rdx)
%macro @cdiv 2
        mov  rax, %1                   ; idiv uses this
        mov  rdx, 0                    ; idiv also uses this (for remainder)
        mov  rdi, %2                   ; we use this on our own
        idiv rdi                       ; rax, rdx is implicitly set;
                                       ; div/idiv is very weird
%endmacro

%endif


