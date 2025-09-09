; Multiply var1 * var2 using ADD/INC (repeated addition)

.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
ExitProcess PROTO :DWORD

.data
    var1    DWORD   7       ; change values to test
    var2    DWORD   9
    RES     DWORD   0       ; result = var1 * var2

.code
main PROC
    ; EAX will hold the running sum (the product)
    ; EBX = multiplicand (var1)
    ; ECX = loop counter (0 .. var2-1)

    mov     eax, 0          ; EAX = 0
    mov     ebx, var1       ; EBX = var1
    mov     ecx, 0          ; ECX = 0

mul_loop:
    cmp     ecx, var2       ; while (ECX < var2)
    jae     done
    add     eax, ebx        ;   EAX += var1
    inc     ecx             ;   ECX++
    jmp     mul_loop

done:
    mov     RES, eax        ; store product
    push    0
    call    ExitProcess
main ENDP
END main
