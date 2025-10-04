
.386
.model flat, stdcall
option casemap:none

include Irvine32.inc
includelib Irvine32.lib
includelib kernel32.lib
includelib user32.lib

GCD PROTO a:DWORD, b:DWORD    ; returns EAX = gcd(a,b)

;----------------------------------------------
; Data
;----------------------------------------------
.data
gcdStr      BYTE "gcd(",0
commaStr    BYTE ", ",0
eqStr       BYTE ") = ",0

;----------------------------------------------
; Code
;----------------------------------------------
.code
main PROC
    ; gcd(6,24)
    mov     edx, OFFSET gcdStr
    call    WriteString
    mov     eax, 6
    call    WriteDec
    mov     edx, OFFSET commaStr
    call    WriteString
    mov     eax, 24
    call    WriteDec
    mov     edx, OFFSET eqStr
    call    WriteString
    INVOKE  GCD, 6, 24
    call    WriteDec
    call    Crlf

    ; gcd(24,6)
    mov     edx, OFFSET gcdStr
    call    WriteString
    mov     eax, 24
    call    WriteDec
    mov     edx, OFFSET commaStr
    call    WriteString
    mov     eax, 6
    call    WriteDec
    mov     edx, OFFSET eqStr
    call    WriteString
    INVOKE  GCD, 24, 6
    call    WriteDec
    call    Crlf

    ; gcd(11,7)
    mov     edx, OFFSET gcdStr
    call    WriteString
    mov     eax, 11
    call    WriteDec
    mov     edx, OFFSET commaStr
    call    WriteString
    mov     eax, 7
    call     WriteDec
    mov     edx, OFFSET eqStr
    call    WriteString
    INVOKE  GCD, 11, 7
    call    WriteDec
    call    Crlf

    ; gcd(432,226)
    mov     edx, OFFSET gcdStr
    call    WriteString
    mov     eax, 432
    call    WriteDec
    mov     edx, OFFSET commaStr
    call    WriteString
    mov     eax, 226
    call    WriteDec
    mov     edx, OFFSET eqStr
    call    WriteString
    INVOKE  GCD, 432, 226
    call    WriteDec
    call    Crlf

    ; gcd(24,13)
    mov     edx, OFFSET gcdStr
    call    WriteString
    mov     eax, 24
    call    WriteDec
    mov     edx, OFFSET commaStr
    call    WriteString
    mov     eax, 13
    call    WriteDec
    mov     edx, OFFSET eqStr
    call    WriteString
    INVOKE  GCD, 24, 13
    call    WriteDec
    call    Crlf

    ; gcd(28,13)
    mov     edx, OFFSET gcdStr
    call    WriteString
    mov     eax, 28
    call    WriteDec
    mov     edx, OFFSET commaStr
    call    WriteString
    mov     eax, 13
    call    WriteDec
    mov     edx, OFFSET eqStr
    call    WriteString
    INVOKE  GCD, 28, 13
    call    WriteDec
    call    Crlf

    exit
main ENDP

GCD PROC a:DWORD, b:DWORD
    ; base case: if (b == 0) return a
    mov     eax, b
    test    eax, eax
    jnz     Recur
    mov     eax, a
    ret

Recur:
    ; Compute r = a mod b
    mov     ecx, b          ; ECX = b
    mov     eax, a          ; EAX = a
    xor     edx, edx        ; zero high part for unsigned DIV
    div     ecx             ; EDX = remainder (a % b), EAX = a / b

    ; Recurse: gcd(b, r)
    ; (INVOKE pushes right-to-left, preserves our EDX value when pushing)
    INVOKE  GCD, ecx, edx
    ret
GCD ENDP

END main
