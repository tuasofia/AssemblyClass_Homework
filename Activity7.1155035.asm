
.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
ExitProcess PROTO :DWORD

.stack 4096

.data
aName    BYTE "ABCDEFGHIJKLMNO",0
nameSize = ($ - aName) - 1

.code
main PROC

    ; Push the name on the stack (one char per dword, as original did).
    mov     ecx, nameSize
    mov     esi, 0
L1:
    movzx   eax, BYTE PTR aName[esi]    ; get character (in AL)
    ; --- fake push eax ---
    lea     esp, [esp-4]
    mov     DWORD PTR [esp], eax
    inc     esi
    loop    L1

    ; Pop the name from the stack (reverse) into aName.
    mov     ecx, nameSize
    mov     esi, 0
L2:
    ; --- fake pop into EAX ---
    mov     eax, DWORD PTR [esp]
    lea     esp, [esp+4]
    mov     aName[esi], al              ; store character back
    inc     esi
    loop    L2

    ; ExitProcess(0) without PUSH
    xor     eax, eax                    ; exit code = 0
    lea     esp, [esp-4]
    mov     DWORD PTR [esp], eax
    call    ExitProcess                 ; stdcall: callee cleans

main ENDP
END main
