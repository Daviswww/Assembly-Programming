INCLUDE Irvine32.inc
.data
	hanoi PROTO ,
	Wa:DWORD, StrA:PTR BYTE, StrB:PTR BYTE, StrC:PTR BYTE
	Msg1 BYTE "起始站: ", 0
	Msg2 BYTE "終點站: ", 0
	Msg3 BYTE "中繼站: ", 0
	Msg4 BYTE "數量: ", 0

	Op1 BYTE "(", 0
	Op2 BYTE ") -> ", 0

	Aa BYTE 10 DUP (0)
	Bb BYTE 10 DUP (0)
	Cc BYTE 10 DUP (0)

	n DWORD 0
.code
main PROC
	MOV EDX, OFFSET Msg1
	CALL WriteString
	MOV edx, OFFSET Aa
	MOV ecx, (SIZEOF Aa) - 1
	CALL ReadString

	MOV EDX, OFFSET Msg2
	CALL WriteString
	MOV edx, OFFSET Bb
	MOV ecx, (SIZEOF Bb) - 1
	CALL ReadString	

	MOV EDX, OFFSET Msg3
	CALL WriteString
	MOV edx, OFFSET Cc
	MOV ecx, (SIZEOF Cc) - 1
	CALL ReadString

	MOV EDX, OFFSET Msg4
	CALL WriteString
	CALL ReadDec
	MOV n, eax
	INVOKE hanoi, 1, ADDR Aa, ADDR Cc, ADDR Bb
exit
main ENDP
hanoi PROC ,
Wa:DWORD, StrA:PTR BYTE, StrB:PTR BYTE, StrC:PTR BYTE
	mov eax, Wa
	CMP eax, n
	JNE H1
		mov edx, StrA
		call WriteString
		mov edx, OFFSET Op1
		call WriteString
		mov eax, Wa
		call WriteDec
		mov edx, OFFSET Op2
		call WriteString
		mov edx, StrC
		call WriteString
		call crlf
	JMP H2
H1:
	mov eax, Wa
	inc eax
	INVOKE hanoi, eax,  StrA, StrC, StrB
	mov edx, StrA
	call WriteString
	mov edx, OFFSET Op1
	call WriteString
	mov eax, Wa
	call WriteDec
	inc eax
	mov edx, OFFSET Op2
	call WriteString
	mov edx, StrC
	call WriteString
	call crlf
	INVOKE hanoi, eax, StrB, StrA, StrC
H2:
ret
hanoi ENDP
END main
