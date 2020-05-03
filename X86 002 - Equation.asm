INCLUDE Irvine32.inc
.data
	AA DWORD ?
	BB DWORD ?
	CC DWORD ?
	P DWORD 2
	Input BYTE "計算一元二次方程式",0
	Input1 BYTE "A:",0
	Input2 BYTE "B:",0
	Input3 BYTE "C:",0
	Oupt1 BYTE "無限多解",0
	Oput2 BYTE "無解",0
	Oput3 BYTE "一組解 X = ",0
	Oput4 BYTE "一組同根 X = ",0
	Oput5 BYTE "兩組解 X 1= ",0
	Oput6 BYTE "兩組共軛解 X1 = ",0
	Oput56 BYTE "  X2 = ",0
	Oputi BYTE "i",0
	Oput BYTE "輸入的一元二次方程式:",0
	Oputx2 BYTE "x^2",0
	Oputx BYTE "x",0
	OputFL BYTE ".",0
	OputM BYTE "-",0
	OputP BYTE "+",0
.code
main PROC
	Start:
;-----------------輸入-------------
		Mov EDX,Offset Input
		Call WriteString
		Call Crlf
	    Mov EDX,Offset Input1
		Call WriteString
		Call ReadInt
		Mov AA,EAX
	    Mov EDX,Offset Input2
		Call WriteString
		Call ReadInt
		Mov BB,EAX
	    Mov EDX,Offset Input3
		Call WriteString
		Call ReadInt
		Mov CC,EAX
;---------------顯示式子-----------
		Call PrintEQuation;顯示式子
;-------------A=0-------------------------	
		Cmp AA,0 ;判斷A=0?
		Je AEQZ ;A=0
		Jmp ANEQZ ;A!=0
		AEQZ: ;A=0
			Cmp BB,0 ;判斷B=0?
			Je BEQZ
			Mov EAX,CC
			Mov EBX,BB
			Imul EAX , -1
			Call CheakZero
			Mov EDX,Offset Oput3
			Call WriteString
			Call PrintFloat
			Jmp ENDING
		BEQZ: ;B=0
			Cmp CC,0 ;判斷C=0?
			Je CEQZ
			Mov EDX,Offset Oput2
			Call WriteString
			Jmp ENDING
		CEQZ: ;C=0
			Mov EDX,Offset Oupt1
			Call WriteString
			Jmp ENDING
;------------------A!=0-------------------------------
		ANEQZ:
			Mov EAX,BB
			Imul EAX,EAX     ;B^2
			Mov EBX,AA   
			Imul EBX,CC      ;A*C
			Imul EBX,4       ;4*A*C
			Sub  EAX,EBX     ;EAX = B^2-4*A*C

			Cmp EAX,0
			Je A1           ;B^2-4*A*C=0 
			Jg A2           ;B^2-4*A*C>0 
			Jl A3           ;B^2-4*A*C<0 
		A1: ;B^2-4*A*C=0 
			Mov EAX,BB
			Imul EAX,-1     ;EAX=-B
			Call CalEAX2A   ;EAX=-B/2A
			Mov EDX,Offset Oput4
			Call WriteString
			Call PrintFloat
			Jmp ENDING
		A2: ;B^2-4*A*C>0 
			Call Sqrt       ;EAX = Sqrt(B^2-4*A*C)
			Push EAX
			Sub EAX,BB      ;EAX = Sqrt(B^2-4*A*C)-B
			Call CalEAX2A   ;EAX = (Sqrt(B^2-4*A*C)-B)/2A
			Mov EDX,Offset Oput5
			Call WriteString
			Call PrintFloat
			Pop EAX         ;EAX = Sqrt(B^2-4*A*C)
			Imul EAX,-1     ;EAX = -Sqrt(B^2-4*A*C)
			Sub EAX,BB      ;EAX = -Sqrt(B^2-4*A*C)-B
			Call CalEAX2A   ;EAX = (-Sqrt(B^2-4*A*C)-B)/2A
			Mov EDX,Offset Oput56
			Call WriteString
			Call PrintFloat
			Jmp ENDING
		A3:                ;B^2-4*A*C<0 
			Imul EAX,-1    ;EAX = 4*A*C-B^2
			Call Sqrt      ;EAX = Sqrt(4*A*C-B^2)
			Call CalEAX2A  ;EAX = Sqrt(4*A*C-B^2)/2A

			Push EAX
			Push ECX
			Push ESI

			Imul EAX,BB ,-1  ;EAX=-B

			Call CalEAX2A  ;EAX=-B/2A

			Mov EDX,Offset Oput6
			Call WriteString
			Call PrintFloat

			PoP ESI
			Pop ECX
			Pop EAX


			Call PrintFloat
			Mov EDX,Offset Oputi
			Call WriteString

			;x1結束
			;sqrt(4ac-b^2) / 2a 

			Push EAX
			Push ECX
			Push ESI

			Imul EAX, BB, -1
			Call CalEAX2A
			Mov EDX,Offset Oput56
			Call WriteString
			Call PrintFloat

			Pop ESI
			Pop ECX
			Pop EAX

			Imul ESI,-1
			Call PrintFloat
			Mov EDX,Offset Oputi
			Call WriteString
		ENDING:
			Call Crlf;換行
			Call WaitMsg
			Call Crlf;換行
			Jmp Start
exit
main ENDP
;------------
;EAX;傳入要開根號之值
;EAX:傳出開根號結果
;------------
Sqrt PROC
	Mov P,2
	Mov ESI,1
	MOV EDI,4

	L2:
		Cmp ESI,EAX
		Jle L3
		Jmp L4
		L3:
			Cmp EAX,EDI
			Je L6
			Jle L5
			Jmp L4
		L4:
			Inc p
			Mov ESI,EDI
			Mov EDI,P
			Imul EDI,EDI
			Jmp L2
	L5:
		Sub p,1
	L6:	Mov Eax,P
	ret
Sqrt ENDP

;------------
;計算EAX/2A
;EAX;傳入EAX
;EAX:傳出計算結果
;------------
CalEAX2A PROC
		imul EBX, AA, 2

		Call CheakZero
	ret
CalEAX2A ENDP
;------------
;印出一元二次方程式
;------------
PrintEQuation PROC
		Mov EDX,Offset Oput
		Call WriteString
		Cmp AA,0
		Jz P1
		Mov EAX,AA
		Call WriteInt
		Mov EDX,Offset Oputx2
		Call WriteString
		
		P1:
			Cmp BB,0
			Jz P2
			Mov EAX,BB
			Call WriteInt
			Mov EDX,Offset Oputx
			Call WriteString
		P2:
			Cmp CC,0
			Jz P3
			Mov EAX,CC
			Call WriteInt
		P3:
			Call Crlf;換行
			ret
PrintEQuation ENDP
;------------
;除法運算(到小數點第一位)
;傳入EAX/EBX
;傳出EAX=商
;傳出ECX=小數點後第一位
;------------
Division PROC
	Mov EDI,1
	Mov EDX,0
	Mov ECX,EAX
	Imul ECX,10
;-------------計算小數用----------
S2:
	Cdq
	Idiv EBX ;EAX為商 Q1
	Push EAX
	Mov EAX,ECX
	Cdq
	Idiv EBX ;EAX為商 Q2
	Mov ECX,EAX ; ECX為商 Q2
	Pop EAX ;EAX為商 Q1
	Push EAX
	Imul EAX,10 ;10*Q1
	Sub ECX,EAX ; ECX = Q2-10*Q1
	Pop EAX
	Cmp ECX, 0
	JG DivisionEND
	Imul ECX,-1
	DivisionEND:

	ret
Division ENDP
;------------
;印出小數點
;傳入EAX=整數部分
;傳入ECX=小數部分
;傳入ESI='0'正常,'1'為負號的0,'-1'為正號的0
;------------
PrintFloat PROC USES EAX ECX ESI EDX
	Cmp ESI ,0
	Jz Z0
	Jg z1
	mov edx,Offset Oputp
	call WriteString
	Call WriteDec
	Mov EDX,Offset OputFL
	Call WriteString
	Mov EAX,ECX
	Call WriteDec
	jmp ending
	z1:
	mov edx,Offset Oputm
	call WriteString
	Call WriteDec
	Mov EDX,Offset OputFL
	Call WriteString
	Mov EAX,ECX
	Call WriteDec
	jmp ending
	z0:
	Call WriteInt
	Mov EDX,Offset OputFL
	Call WriteString
	Mov EAX,ECX
	Call WriteDec

	ending:

	ret
PrintFloat ENDP

CheakZero PROC
;------------
;檢查正負0
;傳入EAX=被除數
;傳入EBX=除術
;傳出ESI='0'正常,'1'為負號的0,'-1'為正號的0
;傳出EAX=商
;傳出ECX=小數
;------------

push EAX

xor EAX, EBX
test EAX,80000000H
jnz L1
mov ESI, -1
jmp L3
L1:
mov ESI, 1

L3:

POP EAX

Call Division

cmp EAX, 0
jz L2
mov ESI, 0
L2:
	ret
CheakZero ENDP

END main
