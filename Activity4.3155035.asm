; x86 / 32-bit, flat model, MASM
.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
ExitProcess PROTO :DWORD

.data
    ; 8-bit inputs (change for your tests)
    var1    BYTE    27h
    var2    BYTE    96h

    ; results of point 2
    RES1    DWORD   ?
    RES2    DWORD   ?
    RES3    DWORD   ?
    RES4    DWORD   ?
    RES5    DWORD   ?

    ; two's complement of each RES (point 4)
    TC1     DWORD   ?
    TC2     DWORD   ?
    TC3     DWORD   ?
    TC4     DWORD   ?
    TC5     DWORD   ?

    ; low byte of each TC (point 5)
    LB1     BYTE    ?
    LB2     BYTE    ?
    LB3     BYTE    ?
    LB4     BYTE    ?
    LB5     BYTE    ?

.code
main PROC
    ; ------------------------------------------------------------
    ; RES1 = (var1 + var2) AND 55h
    movzx   eax, BYTE PTR var1
    movzx   ebx, BYTE PTR var2
    add     eax, ebx
    and     eax, 55h
    mov     RES1, eax

    ; two's complement of RES1, then keep low byte
    mov     eax, RES1
    not     eax
    inc     eax
    mov     TC1, eax
    mov     al, BYTE PTR TC1
    mov     LB1, al

    ; ------------------------------------------------------------
    ; RES2 = (var1 + var2) OR var2
    movzx   eax, BYTE PTR var1
    movzx   ebx, BYTE PTR var2
    add     eax, ebx
    or      eax, ebx
    mov     RES2, eax

    mov     eax, RES2
    not     eax
    inc     eax
    mov     TC2, eax
    mov     al, BYTE PTR TC2
    mov     LB2, al

    ; ------------------------------------------------------------
    ; RES3 = (var1 AND var2) XOR E9h
    movzx   eax, BYTE PTR var1
    movzx   ebx, BYTE PTR var2
    and     eax, ebx
    xor     eax, 0E9h
    mov     RES3, eax

    mov     eax, RES3
    not     eax
    inc     eax
    mov     TC3, eax
    mov     al, BYTE PTR TC3
    mov     LB3, al

    ; ------------------------------------------------------------
    ; RES4 = (var1 OR 39E7h) + (var2 XOR 9696h)
    ; use 32-bit regs so the 16-bit immediates are valid
    movzx   eax, BYTE PTR var1
    or      eax, 39E7h          ; 000039E7h immediate in 32-bit
    movzx   ebx, BYTE PTR var2
    xor     ebx, 9696h          ; 00009696h immediate in 32-bit
    add     eax, ebx
    mov     RES4, eax

    mov     eax, RES4
    not     eax
    inc     eax
    mov     TC4, eax
    mov     al, BYTE PTR TC4
    mov     LB4, al

    ; ------------------------------------------------------------
    ; RES5 = var1 + (var2 XOR 0B7AAh)
    movzx   eax, BYTE PTR var2
    xor     eax, 0B7AAh
    movzx   ebx, BYTE PTR var1
    add     eax, ebx
    mov     RES5, eax

    mov     eax, RES5
    not     eax
    inc     eax
    mov     TC5, eax
    mov     al, BYTE PTR TC5
    mov     LB5, al

    ; exit
    push    0
    call    ExitProcess
main ENDP
END main
