INCLUDE Irvine32.inc
.data
	Msg1 BYTE "請輸入六筆學生資料: ", 0
	Msg2 BYTE "學生成績", 0
	Msg3 BYTE "學號       國文 英文 數學 總和 名次", 0
	ID BYTE 100 DUP (0)	;學生名字
	na BYTE "學號: ", 0
	nb BYTE "國文: ", 0 
	nc BYTE "英文: ", 0
	nd BYTE "數學: ", 0

	sep2 BYTE "  ", 0			;空二格
	sep3 BYTE "   ", 0			;空三格
	sep4 BYTE "    ", 0			;空四格

	array DWORD 100 DUP(0)	;總成績
	array2 DWORD 100 DUP(0)	;成績
	rank DWORD 100 DUP(0)		;排名

	asec DWORD 0		;總成績
	count1 DWORD 0	;存幾筆學號
	count2 DWORD 0	;存幾筆成績
	count3 DWORD 0	;存幾筆總分

	num DWORD 1		;排名
	tum DWORD 1		;計數
.code
main PROC
	MOV EDX, OFFSET Msg1
	call WriteString
	call crlf
	;===========輸入============
	MOV ESI, 0	;成績
	MOV EBX, 6	;幾筆
L1:
	MOV asec, 0					;歸零
	MOV EDX, OFFSET na
	call WriteString
	;學號
	mov esi, count1
	lea EDX, [ID + ESI]
	mov ECX, ( SIZEOF ID ) - 1 
	call ReadString
	add esi, 12
	mov count1, esi
	mov esi, count2			;存第幾格
	;國文
	MOV EDX, OFFSET nb
	call WriteString
    call ReadDec
	mov [array2 + esi], eax
	add asec, eax
	add esi, 4
	;英文
	MOV EDX, OFFSET nc
	call WriteString
    call ReadDec
	mov [array2 + esi], eax
	add asec, eax
	add esi, 4
	;數學
	MOV EDX, OFFSET nd
	call WriteString
    call ReadDec
	mov [array2 + esi], eax
	add asec, eax
	mov edx, asec
	add esi, 4
	mov [array2 + esi], edx
	add esi, 4
	mov count2, esi			;存第幾個成績
	;總分
	mov esi, count3
	mov edx, asec
	mov [array + esi], edx
	add esi, 4
	mov count3, esi			;存第幾個總分
DEC EBX
JNE L1
	;============排序=========	
	mov ecx, 5		;次數
	B1:
		push ecx
		mov esi, 0
	B2:
		mov eax, [array + esi]
		mov ebx, [array + esi+ 4]
		cmp ebx, eax
		JL B3	
		mov [array + esi], ebx				
		mov [array + esi + 4], eax
	B3:
		add esi, 4
	loop B2
		pop ecx
	loop B1
	;============排名==========
	mov ecx, 6		;次數
	mov esi, 0
	mov eax, 0
	mov num, 1		;名次
Ran:
	mov eax, num
	mov [rank + esi], eax
	mov eax, [array + esi]
	mov ebx, [array + esi + 4]
	add esi, 4
	cmp ebx, eax
	JE R1		;if(ebx == eax)
	mov ebx, tum
	mov eax, num
	add eax, ebx
	mov num, eax
	mov tum, 0
R1:
	inc tum
loop Ran
	;============列印==============
	MOV EDX, OFFSET Msg2
	call WriteString
	call crlf
	MOV EDX, OFFSET Msg3
	call WriteString
	call crlf
	;初始化
	mov count1, 0
	mov count2, 0
	mov count3, 0
	mov esi, 0						;學號
	mov ebx, 6						;幾筆
L2:
	;--------------輸出學號---------------
	mov esi, count1				;取回學號
	lea EDX, [ID + esi]
	call WriteString
	add esi, 12
	mov count1, esi				;暫存學號
	mov esi, count2				;取回成績
	MOV EDX, OFFSET sep2
	call WriteString
	;--------------輸出成績---------------
	mov ecx, 4
L3:
	mov eax, [array2 + esi]	;控制控白
	cmp eax, 10
	JB SS2
	cmp eax, 99
	JA SS1
	MOV EDX, OFFSET sep3	;空白3格
	call WriteString
	JMP top
	SS1:
	MOV EDX, OFFSET sep2	;空白2格
	call WriteString
	JMP top
	SS2:
	MOV EDX, OFFSET sep4	;空白4格
	call WriteString
	top:
	call WriteDec
	add esi, 4
loop L3
	mov count2, esi					;暫存成績
;--------------輸出排名---------------
	sub esi, 4								;回到上筆
	mov eax, [array2 + esi]		;存總成績
	mov esi, 0
	mov ecx, 6
L4:
	cmp eax, [array + esi]			;查看排名
	JE L5		;if(eax ==  [array + esi])
	add esi, 4
loop L4
L5:
	mov eax, [rank + esi]			;輸出排名
	MOV EDX, OFFSET sep4
	call WriteString
	call WriteDec
	call Crlf
DEC EBX
JNE L2
	ret
main ENDP
END main
