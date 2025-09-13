
.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
includelib msvcrt.lib
includelib ucrt.lib
includelib vcruntime.lib
includelib legacy_stdio_definitions.lib

ExitProcess PROTO :DWORD
printf      PROTO C :PTR SBYTE, :VARARG
scanf       PROTO C :PTR SBYTE, :VARARG

.data
prompt    BYTE "Enter a non-negative integer: ",0
fmtIn     BYTE "%u",0
fmtPrime  BYTE "%u is prime.",13,10,0
fmtNot    BYTE "%u is NOT prime (divisible by %u).",13,10,0

N             DWORD 0
isPrime       BYTE  0
firstDivisor  DWORD 0

.code
main PROC
    ; prompt
    push OFFSET prompt
    call printf
    add  esp, 4

    ; scanf("%u", &N)
    push OFFSET N
    push OFFSET fmtIn
    call scanf
    add  esp, 8

    mov  ebx, N            ; EBX = N

    ; N < 2 -> not prime
    cmp  ebx, 2
    jb   NotPrime
    ; N == 2 -> prime
    je   Prime

    ; even? -> not prime, divisor=2
    test ebx, 1
    jz   EvenCase

    mov  ecx, 3            ; i = 3
CheckLoop:
    mov  eax, ebx          ; EAX = N
    xor  edx, edx
    div  ecx               ; EAX = N/i, EDX = N%i

    cmp  ecx, eax
    ja   Prime             ; tested up to sqrt(N)

    test edx, edx
    jz   FoundDiv          ; divisible by i

    add  ecx, 2            ; next odd
    jmp  CheckLoop

EvenCase:
    mov  isPrime, 0
    mov  firstDivisor, 2
    jmp  Report

FoundDiv:
    mov  isPrime, 0
    mov  firstDivisor, ecx
    jmp  Report

NotPrime:
    mov  isPrime, 0
    mov  firstDivisor, 0
    jmp  Report

Prime:
    mov  isPrime, 1
    mov  firstDivisor, 0

Report:
    cmp  isPrime, 0
    jne  SayPrime

    ; "%u is NOT prime (divisible by %u)\n"
    push firstDivisor
    push N
    push OFFSET fmtNot
    call printf
    add  esp, 12
    jmp  Done

SayPrime:
    ; "%u is prime\n"
    push N
    push OFFSET fmtPrime
    call printf
    add  esp, 8

Done:
    invoke ExitProcess, 0
main ENDP
END main
