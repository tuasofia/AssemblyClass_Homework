.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
includelib ucrt.lib
includelib vcruntime.lib
includelib legacy_stdio_definitions.lib

ExitProcess PROTO :DWORD
printf      PROTO C :PTR SBYTE, :VARARG
scanf       PROTO C :PTR SBYTE, :VARARG

.data
promptA  BYTE "Enter first non-negative integer: ",0
promptB  BYTE "Enter second non-negative integer: ",0
fmtIn    BYTE "%u",0
fmtOut   BYTE "gcd(%u, %u) = %u",13,10,0

A        DWORD 0
B        DWORD 0
origA    DWORD 0
origB    DWORD 0
GCD      DWORD 0

.code
main PROC
    ; --- read A ---
    push OFFSET promptA
    call printf
    add  esp, 4

    push OFFSET A
    push OFFSET fmtIn
    call scanf
    add  esp, 8

    ; --- read B ---
    push OFFSET promptB
    call printf
    add  esp, 4

    push OFFSET B
    push OFFSET fmtIn
    call scanf
    add  esp, 8

    ; save originals for printing
    mov  eax, A
    mov  origA, eax
    mov  eax, B
    mov  origB, eax

    ; Euclidean algorithm (unsigned)
    mov  ebx, origA        ; ebx = a
    mov  ecx, origB        ; ecx = b

    ; if a==0 and b==0 -> gcd=0
    test ebx, ebx
    jne  StartLoop
    test ecx, ecx
    jne  StartLoop
    mov  GCD, 0
    jmp  PrintResult

StartLoop:
    ; while (b != 0) { t = a % b; a = b; b = t; }
LoopTop:
    test ecx, ecx
    je   DoneLoop

    mov  eax, ebx          ; EDX:EAX / ECX
    xor  edx, edx
    div  ecx               ; EAX = a / b, EDX = a % b

    mov  ebx, ecx          ; a = b
    mov  ecx, edx          ; b = remainder
    jmp  LoopTop

DoneLoop:
    mov  GCD, ebx          ; gcd = a

PrintResult:
    ; printf("gcd(%u, %u) = %u\n", origA, origB, GCD)
    push GCD
    push origB
    push origA
    push OFFSET fmtOut
    call printf
    add  esp, 16

    invoke ExitProcess, 0
main ENDP
END main
