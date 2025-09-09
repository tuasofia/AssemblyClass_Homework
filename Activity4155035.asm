; main.asm — MASM 32-bit (Win32) sin macros, imprime con WriteConsoleA

.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
includelib user32.lib

ExitProcess     PROTO :DWORD
GetStdHandle    PROTO :DWORD
WriteConsoleA   PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
lstrlenA        PROTO :DWORD
wsprintfA       PROTO C :DWORD, :DWORD, :VARARG

STD_OUTPUT_HANDLE EQU -11

.data
; valores de ejemplo
var1    WORD 1234h
var2    WORD 0ABCDh

RES1    WORD ?
RES2    WORD ?
RES3    WORD ?
RES4    WORD ?
RES5    WORD ?

fmt1    db "RES1=%04X",13,10,0
fmt2    db "RES2=%04X",13,10,0
fmt3    db "RES3=%04X",13,10,0
fmt4    db "RES4=%04X",13,10,0
fmt5    db "RES5=%04X",13,10,0

outbuf  db 64 dup(?)
nWrote  DWORD ?
hOut    DWORD ?

.code
main PROC
    ; handle de consola
    push    STD_OUTPUT_HANDLE
    call    GetStdHandle
    mov     hOut, eax

    ; RES1 = (var1 + var2) AND 55h
    mov     ax, var1
    add     ax, var2
    and     ax, 55h
    mov     RES1, ax

    ; RES2 = (var1 + var2) OR var2
    mov     ax, var1
    add     ax, var2
    or      ax, var2
    mov     RES2, ax

    ; RES3 = (var1 AND var2) XOR 0E9h
    mov     ax, var1
    and     ax, var2
    xor     ax, 0E9h
    mov     RES3, ax

    ; RES4 = (var1 OR 39E7h) + (var2 XOR 9696h)
    mov     ax, var1
    or      ax, 39E7h
    mov     bx, var2
    xor     bx, 9696h
    add     ax, bx
    mov     RES4, ax

    ; RES5 = var1 + (var2 XOR 0B7AAh)
    mov     ax, var2
    xor     ax, 0B7AAh
    add     ax, var1
    mov     RES5, ax

    ; ---- imprimir RES1
    movzx   eax, RES1
    push    eax
    push    OFFSET fmt1
    push    OFFSET outbuf
    call    wsprintfA           ; cdecl, limpia el caller
    add     esp, 12

    push    OFFSET outbuf
    call    lstrlenA            ; stdcall, limpia el callee
    mov     ecx, eax            ; longitud
    push    0
    push    OFFSET nWrote
    push    ecx
    push    OFFSET outbuf
    mov     eax, hOut
    push    eax
    call    WriteConsoleA

    ; ---- imprimir RES2
    movzx   eax, RES2
    push    eax
    push    OFFSET fmt2
    push    OFFSET outbuf
    call    wsprintfA
    add     esp, 12

    push    OFFSET outbuf
    call    lstrlenA
    mov     ecx, eax
    push    0
    push    OFFSET nWrote
    push    ecx
    push    OFFSET outbuf
    mov     eax, hOut
    push    eax
    call    WriteConsoleA

    ; ---- imprimir RES3
    movzx   eax, RES3
    push    eax
    push    OFFSET fmt3
    push    OFFSET outbuf
    call    wsprintfA
    add     esp, 12

    push    OFFSET outbuf
    call    lstrlenA
    mov     ecx, eax
    push    0
    push    OFFSET nWrote
    push    ecx
    push    OFFSET outbuf
    mov     eax, hOut
    push    eax
    call    WriteConsoleA

    ; ---- imprimir RES4
    movzx   eax, RES4
    push    eax
    push    OFFSET fmt4
    push    OFFSET outbuf
    call    wsprintfA
    add     esp, 12

    push    OFFSET outbuf
    call    lstrlenA
    mov     ecx, eax
    push    0
    push    OFFSET nWrote
    push    ecx
    push    OFFSET outbuf
    mov     eax, hOut
    push    eax
    call    WriteConsoleA

    ; ---- imprimir RES5
    movzx   eax, RES5
    push    eax
    push    OFFSET fmt5
    push    OFFSET outbuf
    call    wsprintfA
    add     esp, 12

    push    OFFSET outbuf
    call    lstrlenA
    mov     ecx, eax
    push    0
    push    OFFSET nWrote
    push    ecx
    push    OFFSET outbuf
    mov     eax, hOut
    push    eax
    call    WriteConsoleA

    push    0
    call    ExitProcess
main ENDP
END main
