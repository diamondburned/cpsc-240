; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

global print_int

%include "_lib.asm"
%include "_math.asm"

section .data

print_float_buflen equ 50

section .bss

print_float_buf resb print_float_buflen

section .text

print_float:
        @ftoa  xmm0, print_float_buf, print_float_buflen
        @print print_float_buf, rax
        ret    


