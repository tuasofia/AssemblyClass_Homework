
.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
ExitProcess PROTO :DWORD

.data
value   BYTE 10110010b   ; example byte 
LSB     BYTE 0           ; bit 0 -> 0 or 1
MSB     BYTE 0           ; bit 7 -> 0 or 1
R1      BYTE 0           ; greater of LSB/MSB
R2      BYTE 0           ; smaller of LSB/MSB

.code
main PROC
    ; load value
    mov     al, value

    ; LSB = bit0
    mov     bl, al
    and     bl, 1
    mov     LSB, bl

    ; MSB = bit7
    mov     dl, al
    shr     dl, 7
    and     dl, 1
    mov     MSB, dl

    ; if (LSB > MSB) R1=LSB, R2=MSB; else R2=LSB, R1=MSB
    cmp     bl, dl
    ja      LsbGreater

    mov     R2, bl      ; MSB >= LSB
    mov     R1, dl
    jmp     Done

LsbGreater:
    mov     R1, bl
    mov     R2, dl

Done:
    invoke  ExitProcess, 0
main ENDP
END main
