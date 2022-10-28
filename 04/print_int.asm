; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

global print_int

%include "_lib.asm"
%include "_math.asm"

section .data

; We can have up to 20 digits according to
; https://go.dev/play/p/6gbd6YP21vF.
print_int_buflen equ 20

section .bss

print_int_buf resb print_int_buflen

section .text

print_int:
        @itoa  rdi, print_int_buf, print_int_buflen
        @print print_int_buf, rax
        ret    


