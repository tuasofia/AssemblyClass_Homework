
.386
.model flat, stdcall
option casemap:none

include Irvine32.inc           
includelib Irvine32.lib        
includelib kernel32.lib
includelib user32.lib

;----------------------------------------------
; Prototypes
;----------------------------------------------
ProbClearZF PROTO nProb:DWORD

;----------------------------------------------
; Data
;----------------------------------------------
.data
prompt      BYTE "Enter probability (0..100): ",0
errRange    BYTE "Invalid. Please enter a value from 0 to 100.",0
callStr     BYTE "Call ",0
arrowStr    BYTE " -> ",0
zfStr       BYTE "ZF = ",0

; store result of ZF (0/1) so we can print after reading it
zfResult    BYTE 0

.code
main PROC
    call    Randomize                   ; seed RNG once

GetInput:
    mov     edx, OFFSET prompt
    call    WriteString
    call    ReadInt                     ; EAX <- user input

    ; validate 0..100
    cmp     eax, 0
    jl      BadInput
    cmp     eax, 100
    jg      BadInput

    mov     ebx, eax                    ; EBX = N (0..100)

    ; loop 10 calls
    mov     ecx, 10                     ; loop counter
    mov     esi, 1                      ; call index 1..10

TrialLoop:
    ; --- Call procedure (ZF decided inside) ---
    INVOKE  ProbClearZF, ebx            ; N in EBX

    ; Immediately read ZF before any other call trashes flags
    ; setz AL => AL=1 if ZF was set, AL=0 if ZF was clear
    setz    al
    mov     zfResult, al

    ; Now print: "Call i -> ZF = {0|1}"
    mov     edx, OFFSET callStr
    call    WriteString
    mov     eax, esi
    call    WriteDec

    mov     edx, OFFSET arrowStr
    call    WriteString

    mov     edx, OFFSET zfStr
    call    WriteString

    movzx   eax, zfResult
    call    WriteDec
    call    Crlf

    inc     esi
    loop    TrialLoop

    exit
BadInput:
    mov     edx, OFFSET errRange
    call    WriteString
    call    Crlf
    jmp     GetInput
main ENDP


ProbClearZF PROC USES eax ecx edx, nProb:DWORD
    ; Generate r in [0,99]
    mov     eax, 100
    call    RandomRange         ; EAX = 0..99

    mov     edx, nProb          ; EDX = N (0..100)

    ; if r < N => clear ZF
    cmp     eax, edx
    jb      MakeZF0

    ; else => set ZF
MakeZF1:
    xor     ecx, ecx            ; ECX=0
    cmp     ecx, 0              ; ZF=1
    ret
MakeZF0:
    xor     ecx, ecx            ; ECX=0
    cmp     ecx, 1              ; ZF=0
    ret
ProbClearZF ENDP

END main
