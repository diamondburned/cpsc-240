; Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

global dtoa

extern itoa

section .text

dtoa:

        test    rsi, rsi
        je      ?_014
        push    rbp
        mov     rdx, rsi
        mov     rbp, rsp
        push    r15
        push    r14
        push    r13
        push    r12
        push    rbx
        mov     rbx, rdi
        sub     rsp, 40
        ucomisd xmm0, xmm0
        jpo     ?_003
        cmp     rsi, 3
        jg      ?_002
?_001:
        xor eax, eax
        jmp ?_013

?_002:
        mov dword [rdi], 5136718
        mov eax, 3
        jmp ?_013

?_003:
        cvttsd2si eax, xmm0
        mov       rsi, rbx
        movsd     qword [rbp-48H], xmm0
        movsxd    rdi, eax
        mov       r15d, eax
        call      itoa
        test      rax, rax
        jz        ?_001
        cvtsi2sd  xmm1, r15d
        movsd     xmm0, qword [rbp-48H]
        subsd     xmm0, xmm1
        xorps     xmm1, xmm1
        comisd    xmm1, xmm0
        jbe       ?_004
        xorps     xmm0, oword [rel LC1]
?_004:
        xorps     xmm1, xmm1
        comisd    xmm0, xmm1
        jbe       ?_013
        mov       byte [rbx+rax], 46
        lea       r13, [rbp-37H]
        inc       rax
        mov       edx, 7
        mulsd     xmm0, qword [rel LC2]
        mov       rsi, r13
        mov       r12, rsp
        mov       r15, rax
        cvttsd2si r14, xmm0
        mov       rdi, r14
        call      itoa
        test      rax, rax
        je        ?_013
        xor       ecx, ecx
        test      r14, r14
        jle       ?_009
?_005:
        cmp  r14, 99999
        jg   ?_006
        imul r14, r14, 10
        inc  rcx
        jmp  ?_005

?_006:
        dec rax
        lea rdx, [r13+rcx]
?_007:
        test rax, rax
        js   ?_008
        mov  sil, byte [r13+rax]
        mov  byte [rdx+rax], sil
        dec  rax
        jmp  ?_007

?_008:
        xor   eax, eax
        test  rcx, rcx
        mov   rdi, r13
        cmovs rcx, rax
        mov   al, 48
        rep   stosb
        mov   eax, 6
?_009:
        mov rdx, rax
        cmp rax, 1
        jle ?_010
        cmp byte [r13+rdx-1H], 48
        lea rax, [rax-1H]
        jz  ?_009
?_010:
        mov rax, r15
?_011:
        mov    ecx, eax
        lea    rsi, [rbx+rax]
        sub    ecx, r15d
        movsxd rcx, ecx
        cmp    rcx, rdx
        jge    ?_012
        mov    cl, byte [rbp+rcx-37H]
        mov    byte [rbx+rax], cl
        inc    rax
        jmp    ?_011

?_012:
        mov byte [rsi], 0
        mov rsp, r12
?_013:
        lea rsp, [rbp-28H]
        pop rbx
        pop r12
        pop r13
        pop r14
        pop r15
        pop rbp
        ret 

?_014:

        xor eax, eax
        ret 

section .data

section .bss

section .rodata

        ALIGN 16
LC1:

section .rodata

LC2:
 dq 412E848000000000H


