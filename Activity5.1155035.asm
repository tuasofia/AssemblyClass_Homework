.386
.model flat, stdcall
option casemap:none
includelib kernel32.lib
ExitProcess PROTO :DWORD
.data
value BYTE 0FFh ; 8-bit variable to test
isEqual BYTE 0 ; result: 1 if value == 0FFh, else 0
.code
main PROC
mov al, value ; load the byte
cmp al, 0FFh ; compare to 0FFh
jne NotEqual
mov isEqual, 1
jmp Done
NotEqual:
mov isEqual, 0
Done:
invoke ExitProcess, 0
main ENDP
END main