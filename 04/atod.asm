; This code is taken from StackOverflow. Code taken from StackOverflow are
; licensed under CC BY-SA 3.0. See
; https://creativecommons.org/licenses/by-sa/3.0/ for more information.
;  
; Source Link: https://stackoverflow.com/a/4392789/5041327

; atod converts a string to a double.
global atod

section .text

atod:

        movsxd rsi, esi
        movsd  xmm1, qword [rel LC1]
        add    rsi, rdi
        cmp    byte [rdi], 45
        jnz    ?_001
        movsd  xmm1, qword [rel LC0]
        inc    rdi
?_001:
        movsd xmm2, qword [rel LC3]
        xor   edx, edx
        xorps xmm0, xmm0
?_002:
        cmp   rdi, rsi
        jnc   ?_006
        movsx eax, byte [rdi]
        cmp   al, 46
        jz    ?_004
        sub   eax, 48
        cmp   eax, 9
        ja    ?_005
        test  edx, edx
        jz    ?_003
        divsd xmm1, xmm2
?_003:
        mulsd    xmm0, xmm2
        cvtsi2sd xmm3, eax
        addsd    xmm0, xmm3
        jmp      ?_005

?_004:
        mov edx, 1
?_005:
        inc rdi
        jmp ?_002

?_006:

        mulsd xmm0, xmm1
        ret   

section .data

section .bss

section .rodata

LC0:
 dq 0BFF0000000000000H

LC1:
 dq 3FF0000000000000H

LC3:
 dq 4024000000000000H


