INCLUDE Irvine32.inc
.data
	Msg1 BYTE "輸入N: ", 0
	Msg2 BYTE "輸入數字: ", 0
	Msg3 BYTE "Position: ", 0
	Msg4 BYTE "Temp LIS: ", 0
	Msg5 BYTE "LIS: ", 0
	Op BYTE " ", 0
	temp DWORD 25 DUP(0)
	point DWORD 25 DUP(0)
	max DWORD 25 DUP(0)

	n DWORD 0			;次數
	pt DWORD 0			;位子
	k DWORD 0			;長度
.code
main PROC
	;===========N===========
	MOV edx, OFFSET Msg1
	CALL WriteString
	CALL ReadDec
	MOV n,eax
	;===========Array=======
	MOV edx, OFFSET Msg2
	CALL WriteString
	CALL Crlf
	MOV ecx, n
	MOV esi, 0
	L1:
		CALL ReadDec
		MOV temp[esi*4], eax
		INC esi
		LOOP L1
	;===========Position=====
	MOV edx, OFFSET Msg3
	CALL WriteString
	CALL Position
	mov ecx, n
	mov esi, 0
	L2:
		MOV eax, point[esi*4]
		CALL WriteDec
		MOV edx, OFFSET Op
		CALL WriteString
		INC esi
		LOOP L2
	CALL Crlf
	;===========LIS========
	MOV edx, OFFSET Msg5
	CALL WriteString
	
	MOV esi, n
	MOV ebx, k
	L3:
		DEC esi
		MOV eax, point[esi*4]
		CMP ebx, eax
		JNE L4
		MOV eax, temp[esi*4]
		PUSH eax
		DEC ebx
		L4:
		CMP esi, 0
		JA L3
	;===========pint=======
	MOV esi, 0
	L5:
		POP eax
		CALL WriteDec
		MOV edx, OFFSET Op
		CALL WriteString
		INC esi
		CMP esi, k
		JBE L5
	CALL Crlf
exit
main ENDP
	Position PROC
		MOV esi, 0
		MOV edi, 0
		MOV eax, temp[esi*4]
		MOV max[esi*4], eax
		MOV point[esi*4], esi
		INC esi
		P1:
			MOV eax, temp[esi*4]
			CMP eax, temp[esi*4-4]
			JA P2
			MOV edi, 0
			P3:
				CMP eax, max[edi*4]
				JA P4
				MOV max[edi*4], eax
				MOV point[esi*4], edi
				JMP P7
				P4:
					CMP edi, pt
					JE P5
					INC edi
					JMP P3
					P5:
						INC edi
						MOV pt, edi
						MOV max[edi*4], eax
						MOV point[esi*4], edi
						JMP P7
				CMP edi, pt
				JBE P3
				JMP P7
			P2:
				MOV ebx, pt
				INC ebx
				MOV max[ebx*4], eax
				MOV point[esi*4], ebx
				MOV pt, ebx
			P7:
			MOV eax, point[esi*4]
			CMP eax, k
			JB P8
			MOV k, eax
		P8:
		INC esi
		CMP esi, n
		JB P1
	ret
	Position ENDP
END main
