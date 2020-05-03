INCLUDE Irvine32.inc
.data
	Msg0 BYTE "輸入六個點: ", 0
	Msg1 BYTE "面積: ", 0

	Op0 BYTE "X = ", 0
	Op1 BYTE "Y = ", 0
	Op2 BYTE ".5", 0
	Op3 BYTE ".0", 0

	arryX DWORD 100 DUP(0)
	arryY DWORD 100 DUP(0)

	X DWORD 0
	Y DWORD 0
	F DWORD 0
.code
main PROC
	MOV edx, OFFSET Msg0
	CALL WriteString
	CALL Crlf
	;===========輸入============
	MOV esi, 0
	MOV ecx, 6
	L1:
		MOV edx, OFFSET Op0
		CALL WriteString
		CALL ReadInt
		MOV arryX[esi*4], eax
		MOV edx, OFFSET Op1
		CALL WriteString
		CALL ReadInt
		MOV arryY[esi*4], eax
		INC esi
		loop L1
	MOV eax, arryX
	MOV arryX[esi * 4], eax
	MOV eax, arryY
	MOV arryY[esi * 4], eax
	;===========矩陣============
	MOV esi, 0
	L2:
		MOV eax, arryX[esi * 4]
		IMUL arryY[esi * 4 + 4]
		ADD x, eax
		MOV eax, arryX[esi * 4 + 4]
		IMUL arryY[esi * 4]
		ADD y, eax
		INC esi
		CMP esi, 6
		JB L2
	;===========除二============
	MOV edx, OFFSET Msg1
	CALL WriteString
	MOV eax, x
	SUB eax, y
	MOV edx, 0		;餘數
	MOV ebx, 2		;除數
	IDIV ebx 			;有號
	MOV F, edx
	CALL WriteDec
	CMP edx, 0
	JE L3
	MOV edx, OFFSET Op2
	CALL WriteString
	JMP L4
	L3:
	MOV edx, OFFSET Op3
	CALL WriteString
	L4:
exit
main ENDP
END main
