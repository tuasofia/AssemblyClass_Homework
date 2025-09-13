.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
ExitProcess PROTO :DWORD

.data
A        BYTE 35          
B        BYTE 120         
isEqual  BYTE 0           ; 1 if A == B
isGreater BYTE 0          ; 1 if A > B
isLess   BYTE 0           ; 1 if A < B
result   SBYTE 0          ; -1 if A<B, 0 if A==B, +1 if A>B

.code
main PROC
    ; compare A and B as UNSIGNED bytes
    mov  al, A
    mov  bl, B
    cmp  al, bl
    je   DoEqual
    ja   DoGreater        ; unsigned A > B
    ; else A < B
DoLess:
    mov  isLess, 1
    mov  isEqual, 0
    mov  isGreater, 0
    mov  result, -1
    jmp  Done

DoGreater:
    mov  isGreater, 1
    mov  isEqual, 0
    mov  isLess, 0
    mov  result, 1
    jmp  Done

DoEqual:
    mov  isEqual, 1
    mov  isGreater, 0
    mov  isLess, 0
    mov  result, 0

Done:
    invoke ExitProcess, 0
main ENDP
END main
