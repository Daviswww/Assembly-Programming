INCLUDE Irvine32.inc
.data
	Msg BYTE "LCS ", 0
	Msg1 BYTE "GCD ", 0
	Msg2 BYTE "terativeFactor ", 0

	Op1 BYTE " + ", 0
	Op2 BYTE " = ", 0
	Op3 BYTE " => ", 0
	Op4 BYTE "LCS => (", 0
	Op5 BYTE "GCD => (", 0
	Op6 BYTE ") =>", 0
	Op7 BYTE " , ", 0
	;==========LCS==========
	Str1  BYTE 11 DUP(0)
	Str2  BYTE 11 DUP(0)
	DeleatStr1  DWORD 10 DUP(0)
	DeleatStr2  DWORD 10 DUP(0)
	StrSize1 DWORD 0
	StrSize2 DWORD 0
	Number1 DWORD 0
	Number2 DWORD 0
	DP DWORD 121 DUP(0)
	AA BYTE 0
	Count DWORD 0
	Temp DWORD 0
	;==========GCD==========
	gcc DWORD 0
	box DWORD 0
	boz DWORD 0
	;=========PrimeNum======
	prime DWORD 0
	sum DWORD 0
.code
main PROC
	MOV sum, 0
	MOV prime, 0	
;=======LCS=========
		Mov EDX,OFFSET Str1
		Mov ECX,10
		Call ReadString
		Mov StrSize1,EAX

		Mov EDX,OFFSET Str2
		Mov ECX,10
		Call ReadString
		Mov StrSize2,EAX

		Mov EDX,OFFSET Op4
		Call WriteString
		Mov EDX,OFFSET Str1
		Call WriteString
		Mov EDX,OFFSET Op7
		Call WriteString
		Mov EDX,OFFSET Str2
		Call WriteString
		Mov EDX,OFFSET Op6
		Call WriteString
		Call LCS
		Call Tack

		Mov EDX,OFFSET Op5
		Call WriteString
		Mov EAX,Number1
		Call WriteDec
		Mov EDX,OFFSET Op7
		Call WriteString
		Mov EAX,Number2
		Call WriteDec
		Mov EDX,OFFSET Op6
		Call WriteString
		Mov ESI,Number1
		Mov EDI,Number2
;=======GCD========
		mov box, esi
		mov boz, edi

	GCD1:
;=======GCD判斷======
		mov eax, boz
		CMP box, eax
		JE LL3
		CALL GCD
		JMP LL4
	LL3:
		;兩者相同則輸出
		mov gcc, eax
	LL4:
		;GCD若一則直接輸出
		CMP gcc, 1
		JE RRR
		mov eax, gcc
		CALL WriteDec
		CALL crlf
;========PrimeNum========
		MOV EDX, OFFSET Msg2
		CALL WriteString	
		CALL crlf
		MOV gcc, eax 
;=======判斷=========
		CALL PrimeNum			;判斷是否質數
		CMP edi, 0				;零為質數，一為非質數
		JE Pri0
;=======非質數========
	RPri:
		MOV EDX, OFFSET Op3
		CALL WriteString	
	NPri:
		CALL PrimeNum
		CMP edi, 0		
	JE Pri1
		MOV ebx, eax			;儲存原本數字
		MOV esi, 1
	V1:
		INC esi
		MOV edx, 0
		MOV eax, ebx
		IDIV esi
		CMP edx, 0			;判斷是否整除
		JNE V1
		CMP esi, prime		;檢查一樣則不加
		JE NPri
		;----------------------------------
		MOV box, eax
		MOV eax, esi
		CALL WriteDec
		MOV EDX, OFFSET Op1
		CALL WriteString
		MOV eax, box
		;----------------------------------
		MOV prime, esi
		ADD sum, esi
	JMP NPri
;=========輸出質數=========
	Pri0:
		MOV EDX, OFFSET Op3
		CALL WriteString	
		CALL WriteDec
		JMP ENDING
	RRR:
		MOV eax, 1
		CALL WriteDec
		CALL crlf
		MOV EDX, OFFSET Msg2
		CALL WriteString
		CALL crlf
		MOV EDX, OFFSET Op3
		CALL WriteString
		MOV eax, 1
		CALL WriteDec
	JMP ENDING
;=========輸出總和=========
	Pri1:
		CMP prime, eax	;檢查
		JE CK
		CALL WriteDec
		ADD sum, eax
		JMP NCK
	CK:
		MOV eax, 0
		CALL WriteDec
	NCK:
		MOV EDX, OFFSET Op2
		CALL WriteString
		MOV eax, sum
		MOV sum, 0
		CALL WriteDec
		CALL crlf
		CALL PrimeNum
		CMP edi, 0
		JNE RPri
	ENDING:
	CALL crlf
exit
main ENDP
;=============================================
LCS PROC USES ECX EBX ESI EDI

	Mov ESI,-1							;用來控制Str1
	Mov EDI,0							;用來控制Str2
	Mov Temp,48
	Mov ECX,0
	Mov Count,0
;-----------建表----------
LC1:											;for (int i=1; i<=n1; i++)
	Mov EDI,0							;將str2的指標歸零
	Mov EDX,Temp					;將DP的指標指向像一行
	Add Temp,44						;將Temp往下行加
	Inc ESI									;將Str1的指標指向下一個
	Cmp ESI,StrSize1
	Jae LCEND							;判斷是否結束
	LC2:										;for (int j=1; j<=n2; j++)
		Mov AL,Str1[ESI]
		;if (s1[i] == s2[j])
		Cmp AL,Str2[EDI]
		Jne LC3
		;length[i][j] = length[i-1][j-1] + 1
		Mov EBX,DP[EDX-48]		
		Inc EBX
		Mov DP[EDX],EBX
		Jmp LC4
		;else	
		LC3:
			Mov EBX,DP[EDX-4]
			;length[i][j] = max(length[i-1][j], length[i][j-1])
			Cmp EBX,DP[EDX-44]
			Ja L1
			Mov EBX,DP[EDX-44]
			Mov DP[EDX],EBX
			Jmp LC4
		L1:
			Mov DP[EDX],EBX	
		;結束判斷
		LC4:
			Add EDX,4
			Mov Count,EDX
			Inc EDI
			Cmp EDI,StrSize2
			Jb LC2
			Jmp LC1
	LCEND:
ret
LCS ENDP
Tack PROC
	Mov ESI,StrSize1
	Dec ESI
	Mov EDI,StrSize2
	Dec EDI
	Mov EDX,Count
	Sub EDX,4
	L0:
		Mov AL,Str1[ESI]
		Cmp AL,Str2[EDI]
		Je L
			Mov EAX,DP[EDX-44]
			Cmp EAX,DP[EDX-4]
		Jae L11
			Sub EDX,4
			DEC EDI
			Jmp L2
		L11:
			Sub EDX,44
			DEC ESI
			Jmp L2
		L:
			Mov DeleatStr1[ESI*4],1
			Mov DeleatStr2[EDI*4],1
			DEC EDI
			DEC ESI
			Sub EDX,48
		L2:
			Cmp EDI,0
			Jl Lend
			Cmp ESI,0
			Jl Lend
			Jmp L0
		Lend:
;-----------------------------------------------
	Mov ESI,0
	Mov EDI,0
	Mov EBX,0
	Mov Number1,0
	Mov ECX,StrSize1
	LC5:
		Cmp DeleatStr1[ESI*4],0
		Jne LC7
		Mov AL,Str1[ESI]
		Mov EBX,Number1
		Imul EBX,10
		Movzx EAX,AL
		Sub EAX,'0'
		Add EBX,EAX
		Mov Number1,EBX
		Jmp LC7
	LC7:
		Inc ESI
		Loop LC5

	Mov ESI,0
	Mov EDI,0
	Mov EBX,0
	Mov Number2,0
	Mov ECX,StrSize2
	LCZ5:
		Cmp DeleatStr2[ESI*4],0
		Jne LCZ6
		Mov AL,Str2[ESI]
		Mov EBX,Number2
		Imul EBX,10
		Movzx EAX,AL
		Sub EAX,'0'
		Add EBX,EAX
		Mov Number2,EBX
		Jmp LCZ7
	LCZ6:
		Mov AL,Str2[ESI]
		Call WriteChar
		Inc EDI
	LCZ7:
		Inc ESI
		Loop LCZ5
		Call Crlf
ret
Tack ENDP
;----------------------------------------------------
GCD PROC USES ESI EAX ECX EBX
	mov count, 0
	;比較大小由小的做起
	CMP box, eax
	JL GC1
		mov esi, boz
		JMP GC2
	GC1:
		mov esi, box
	GC2:
		mov edx, 0
		mov eax, box
		mov ebx, esi
		IDIV ebx
		mov count, edx
		mov edx, 0
		mov eax, boz
		mov ebx, esi
		IDIV ebx
		dec esi
		;都整除跳出
		CMP edx, 0
		JNE GC2
		CMP count, 0
		JNE GC2
		inc esi
		mov gcc, esi
ret
GCD ENDP
PrimeNum PROC USES ESI EAX ECX EBX
		MOV edi, 1			;判斷
		MOV count, 0		;整除次數
		MOV esi, 1			;計數器
		MOV ebx, eax		;最大值
	L1:
		INC esi
		MOV edx, 0
		MOV eax, ebx
		IDIV esi
		CMP edx, 0			;判斷是否整除
		JNE L1
		INC count			;整除則加一
		CMP count, 1		;一個以上的話則不是質數
		JG L2
		CMP esi, ebx		;小於EBX則跳回L1
		JL L1
		MOV edi, 0			;如果是質數則為零
	L2:
ret
PrimeNum ENDP
END main
