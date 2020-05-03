INCLUDE Irvine32.inc
.data
	Msg0 BYTE "輸入六個點: ", 0
	Msg1 BYTE "面積: ", 0

	Mas2 BYTE "X = ", 0
	Mas3 BYTE "Y = ", 0

	Op0 BYTE ".5", 0
	Op1 BYTE ".0", 0
	arryX DWORD 100 DUP(0)
	arryX1 DWORD 100 DUP(0)
	arryX2 DWORD 100 DUP(0)
	arryY DWORD 100 DUP(0)
	arryY1 DWORD 100 DUP(0)
	arryY2 DWORD 100 DUP(0)
	SizeX1 DWORD 0
	SizeX2 DWORD 0

	X DWORD 0
	Y DWORD 0

	Max DWORD -99999
	Min DWORD 99999
	Balance DWORD 0

.code
main PROC
	Mov EDX, OFFSET Msg0
	Call WriteString
	Call Crlf
	Mov ESI, 0
	Mov EDI, 0
	Mov ECX, 6
	L1:
		MOV EDX, OFFSET Mas2
		CALL WriteString
		CALL ReadInt
		MOV arryX[ESI*4], eax
		MOV EDX, OFFSET Mas3
		Call WriteString
		Call ReadInt
		MOV arryY[ESI*4], eax
		;找最高和最低
		Cmp EAX,Max
		Jng L11
		Mov Max,EAX
		L11:
		Cmp EAX,Min
		Jnl L12
		Mov Min,EAX
		L12:
		Inc ESI
		loop L1
		;==========算平均============
		Mov EAX,Max
		Add EAX,Min
		Mov EDX, 0
		CDQ
		Mov EBX, 2
		iDiv EBX
		Mov Balance,EAX
		;==========分上下=============
		Mov ECX,6
		Mov EAX,0
		Mov ESI,0
		Mov EDI,0
		L2:
			Mov EBX,arryY[EAX*4]
			Cmp EBX,Balance
			JL L21
				Mov EBX,arryY[EAX*4]
				Mov arryY1[ESI*4],EBX
				Mov EBX,arryX[EAX*4]
				Mov arryX1[ESI*4],EBX
				Inc ESI
				Inc Sizex1
				Jmp L22
			L21:
				Mov EBX,arryY[EAX*4]
				Mov arryY2[EDI*4],EBX
				Mov EBX,arryX[EAX*4]
				Mov arryX2[EDI*4],EBX
				Inc EDI	
				Inc Sizex2
			L22:
				Inc EAX
		Loop L2

		Mov ECX,4
		Mov EDI,0
		LL:
		Mov EAX,arryX1[EDI*4]
		Inc EDI
		Loop LL
		;============上由大到小===========
		Call Sort1
		;============下由小到大===========
		Call Sort2
		;===========合成一個陣列===========
		Mov ECX,Sizex2
		Mov ESI,Sizex1
		Mov EDI,0
	L3:
		Mov EAX,arryX2[EDI*4]
		Mov arryX1[ESI*4],EAX
		Mov EAX,arryY2[EDI*4]
		Mov arryY1[ESI*4],EAX
		Inc ESI
		Inc EDI
		Loop L3

	MOV eax, arryX1
	MOV arryX1[esi * 4], eax
	MOV eax, arryY1
	MOV arryY1[esi * 4], eax
	;===========矩陣============
	MOV esi, 0
	L33:
		MOV eax, arryX1[esi * 4]
		IMUL arryY1[esi * 4 + 4]
		ADD x, eax
		MOV eax, arryX1[esi * 4 + 4]
		Imul arryY1[esi * 4]
		Add y, eax
		Inc esi
		Cmp esi, 6
		Jb L33
	;===========除二============
	MOV edx, OFFSET Msg1
	CALL WriteString
	MOV eax, x
	SUB eax, y
	mov edx, 0		;餘數
	mov ebx, 2		;除數
	idiv ebx 		;有號
	CALL WriteDec
	CMP edx, 0
	JE F1
	MOV edx, OFFSET Op0
	CALL WriteString
	JMP F2
	F1:
	MOV edx, OFFSET Op1
	CALL WriteString
	F2:
exit
main ENDP
Sort1 PROC
	Mov ESI,0
	S1:
		Mov EDI,0
	S2:
		Mov EAX,arryX1[ESI*4]
		Cmp EAX,arryX1[EDI*4]
		Jg S3
		Mov EAX,arryX1[ESI*4]
		Cmp EAX,arryX1[EDI*4]
		Jne S4
		Mov EAX,arryY1[ESI*4]
		Cmp EAX,arryY1[EDI*4]
		Jg S3
		Jmp  S4
		S3:
			Mov EAX,arryX1[ESI*4]
			Mov EBX,arryX1[EDI*4]
			Mov arryX1[EDI*4],EAX
			Mov arryX1[ESI*4],EBX
			Mov EAX,arryY1[ESI*4]
			Mov EBX,arryY1[EDI*4]
			Mov arryY1[EDI*4],EAX
			Mov arryY1[ESI*4],EBX
		S4:
		Inc EDI
		Cmp EDI,SizeX1
		Jb S2
		Inc ESI
		Cmp ESI,SizeX1
		Jb S1
		ret
Sort1 ENDP
;============排序==========
Sort2 PROC
	Mov ESI,0
	S1:
		Mov EDI,0
	S2:
		Mov EAX,arryX2[ESI*4]
		Cmp EAX,arryX2[EDI*4]
		Jl S3
		Mov EAX,arryX2[ESI*4]
		Cmp EAX,arryX2[EDI*4]
		Jne S4
		Mov EAX,arryY2[ESI*4]
		Cmp EAX,arryY2[EDI*4]
		Jl S3
		Jmp  S4
		S3:
			Mov EAX,arryX2[ESI*4]
			Mov EBX,arryX2[EDI*4]
			Mov arryX2[EDI*4],EAX
			Mov arryX2[ESI*4],EBX
			Mov EAX,arryY2[ESI*4]
			Mov EBX,arryY2[EDI*4]
			Mov arryY2[EDI*4],EAX
			Mov arryY2[ESI*4],EBX
		S4:
		Inc EDI
		Cmp EDI,SizeX2
		Jb S2
		Inc ESI
		Cmp ESI,SizeX2
		Jb S1
		ret
Sort2 ENDP
END main
