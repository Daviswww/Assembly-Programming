;=====================================================
;======================ASM沒什麼======================
;=====================================================
;框架
	INCLUDE Irvine32.inc 	;函式庫
	.data
		;傳參數的副函式
		hanoi PROTO ,
		Wa:DWORD, StrA:PTR BYTE, 
		;資料
		Aa BYTE 100 DUP(0)
	.code
	main PROC
		;程式碼
		MOV edx, OFFSET Aa
		MOV ecx, (SIZEOF Aa) - 1
		CALL ReadString
		INVOKE Prime0, 1, Aa 	;有傳參數
		CALL Prime 	;呼叫副函式
	exit
	main ENDP
	Prime0 PROTO ,
	Wa:DWORD, StrA:PTR BYTE
		mov edx, StrA
		call WriteString

		mov eax, Wa
		call WriteDec
	ret
	Prime0 ENDP
	END main
	Prime PROC USES ESI EAX ECX EBX 	;不改變主函式暫存器內存的值
		;副函式
	ret
	Prime ENDP
	END main
;=====================================================
;資料型態
	指令	位元
	BYTE	8-bit無號整數
	SBYTE	8-bit有號整數
	WORD	16-bit無號整數
	SWORD	16-bit有號整數
	DWORD	32-bit無號整數
	SDWORD	32-bit有號整數
	FWORD	48-bit整數
	QWORD	64-bit整數
	TBYTE	80-bit整數
	REAL4	32-bit (4 byte)  IEEE短實數
	REAL8	64-bit (8 byte)  IEEE長實數
	REAL10	80-bit (10 byte) IEEE延伸實數
;=====================================================
;暫存器
	BYTE  eag8	8位元通用暫存器:  AH、AL、BH、BL、CH、CL、DH、DL
	WORD  eag16	16位元通用暫存器: AX、BX、CX、DX、SI、DI、SP、BP
	DWORD eag32	32位元通用暫存器: EAX、EBX、ECX、EDX、ESI、EDI、ESP、EBP
;=====================================================
;資料宣告
	.data
	Msg BYTE "hello ASM world!", 0
	array DWORD 100 DUP(0)					;空陣列
	ID BYTE 100 DUP (0)						;空字串
	asec DWORD 0							;變數
;=====================================================
;移動資料
	mov eax, 10								;eax = 10
	mov ebx, eax   							;ebx = eax
	movzx al, eax
;=====================================================
;根號
	mid要被開根號的值
	mov ebx, 2
	W1:
		mov eax, ebx
		imul ebx
		cmp mid, eax
		JB W2
		inc ebx	
		jmp W1
	W2:
	dec ebx
	mov eax, ebx
	call WriteDec	;eax = 開完根號的值
;=====================================================
;乘法
    mov ebx, 5
    mov eax, 5
    imul ebx 	 	;有號
    mul ebx 		;無號
	call WriteDec 	;eax = 25	
;=====================================================
;除法
	mov edx, 0		;餘數
	mov eax, 10		;商
	mov ebx, 5		;除數
	idiv ebx 		;有號
	div ebx 		;無號
	call WriteDec	;ans = 2
;=====================================================
;減法
	mov eax, 10
	mov ebx, 5
	sub eax, ebx 	;小數
	sbb eax, ebx 	;大數
	call WriteDec	;ans = 5
;=====================================================
;加法
	;兩數相加
	mov eax, 10
	mov ebx, 5
	add eax, ebx 	;小數
	adc eax, ebx 	;大數
	call WriteDec	;ans = 15
;=====================================================
;加一
	mov eax, 1
	add eax, 1
	inc eax
	call WriteDec 	;ans = 2
;=====================================================
;減一
	mov eax, 2
	sub eax, 1
	dec eax
	call WriteDec 	;ans = 1
;=====================================================
;換行
	call Crlf
;=====================================================
;輸入字串
	(1)多個字串輸入
	lea EDX, ID[ESI]
	mov ECX, ( SIZEOF ID ) - 1 
	call ReadString
	add esi, 10			;移動10格

	(2)單一字串輸入
	mov edx, OFFSET ID
	mov ecx, (SIZEOF ID) - 1
	call ReadString	
	call WriteDec		;字串長度會暫存EAX
;=====================================================
;輸出字串
	(1)多個字串輸出
	lea EDX, ID[esi]
	call WriteString
	add esi, 12			;移動12格

	(2)資料字串輸出
	MOV EDX, OFFSET Msg1
	call WriteString
;=====================================================
;輸入數字
	(1)單一數字輸入
	call ReadDec		;暫存EAX
	call RedaInt		;帶正負號

	(2)陣列數字輸入
	call ReadDec
	mov array2[esi*4], eax
	inc esi
;=====================================================
;輸出數字
	(1)單一數字輸出
	mov eax, 10
	call WriteDec		;Output = 10
	call WriteInt		;Output = +10
	
	(2)陣列數字輸出
	mov  eax, array2 [esi*4]
	call WriteDec
	inc esi
;=====================================================
;比較
	L1:
		mov eax, 10
		mov ebx, 5
		cmp eax, ebx
		JA L1		;if(eax > ebx)則跳到L1
;-----------------------------------------------------
	◆特殊的 flag 值
	JZ	若為零則跳		ZF=1
	JNZ	若為不零則跳		ZF=0
	JC	若進位則跳		CF=1
	JNC	若不進位則跳		CF=0
	JO	若溢位則跳		OF=1
	JNO	若不溢位則跳		OF=0
	JS	若負號則跳		SF=1
	JNS	若非負號則跳		SF=0
	JP	同位(偶)則跳		PF=1
	JNP	非同位(奇)則跳	PF=0
;-----------------------------------------------------
    ◆兩運算元是否相等或(E)AX的值             
	JE		相等則跳			if(left == right)
	JNE		不相等則跳 		if(left != right)
	JCXZ	若 CX = 0 則跳
	JECXZ	若 ECX = 0 則跳
;-----------------------------------------------------
    ◆無號運算元的比較
	JA		較大則跳
	JNBE	不是較小或相等則跳(=JA)
	JAE		較大或相等則跳
	JNB		不是較小則跳(=JAE)
	JB		較小則跳
	JNAE	不是較大或相等則跳(=JB)
	JBE		較小或相等則跳
	JNA		不是較大則跳(=JBE)
;-----------------------------------------------------
    ◆ 帶正負號運算元間的比較
	JG		較大則跳
	JNLE	非較小或相等則跳(=JG)
	JGE		較大或相等則跳
	JNL		不是較小則跳(=JGE)
	JL		較小則跳
	JNGE	非較大或相等則跳(=JL)
	JLE		較小或相等則跳
	JNG		不是較大則跳(=JLE)
;=====================================================
;迴圈
	(1)32以內的迴圈
	mov ecx, 5	;次數
	L1:
		;內容
	loop L1
;-----------------------------------------------------
	(2)無限制迴圈
	MOV EBX, 5	;次數
	L1:
		;內容
	DEC EBX
	JNE L1
;-----------------------------------------------------
	(3)無條件跳躍
	L1:
		;內容
	JMP L1
;-----------------------------------------------------
	(4)巢狀迴圈
	.data
		count DWORD 0
	.code
	mov ecx, 5
	;外迴圈
	L1:
		mov count, ecx 	;儲存上一個外迴值
		mov ecx, 10 	;內迴值
		;內迴圈
		L2:
			;內容
		loop L2
		mov ecx, count 	;放回外迴值
	loop L1
;=====================================================
;排序
	;小到大排序
	.data
		array DWORD 100 DUP(0)		;資料
	.code
		mov ecx, 5					;幾筆減一
		B1:
			push ecx
			mov esi, 0
		B2:
			mov eax, array [esi]
			mov ebx, array[esi+ 4]
			cmp ebx, eax
			JG B3	
			mov array[esi], ebx				
			mov array[esi + 4], eax
		B3:
			add esi, 4
		loop B2
			pop ecx
		loop B1
;=====================================================
;質數判斷
	;EDI如果是0為質數1非質數
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
;=====================================================
;陣列加法
INCLUDE Irvine32.inc
.data
	Msg1 BYTE "輸入N: ", 0
	Msg2 BYTE "輸入數字: ", 0
	Msg3 BYTE "列印陣列: ", 0
	Msg4 BYTE "列印連加: ", 0
	Msg5 BYTE "列印總和: ", 0

	Op BYTE "  ", 0

	arry DWORD 100 DUP(0)
	n DWORD 0
	sum DWORD 0
.code
main PROC
	;===========N============
	MOV edx, OFFSET Msg1
	CALL WriteString
	CALL ReadDec
	MOV n, eax
	;=========輸入數字=========
	MOV edx, OFFSET Msg2
	CALL WriteString
	CALL Crlf

	MOV esi, 0

	L1:
		CALL ReadDec
		MOV arry[esi*4], eax
		INC esi
		CMP esi, n
		JB L1
	;=========列印陣列=========
	MOV edx, OFFSET Msg3
	CALL WriteString

	MOV esi, 0

	L2:
		MOV eax, arry[esi*4]
		CALL WriteDec
		MOV edx, OFFSET Op
		CALL WriteString
		INC esi
		CMP esi, n
		JB L2
	CALL Crlf
	;=========列印連加=========
	MOV edx, OFFSET Msg4
	CALL WriteString
	MOV esi, 0

	L3:
		MOV eax, arry[esi*4]
		ADD sum, eax
		MOV eax, sum
		CALL WriteDec
		MOV edx, OFFSET Op
		CALL WriteString
		INC esi
		CMP esi, n
		JB L3
	CALL Crlf
	;=========列印總和=========
	MOV edx, OFFSET Msg5
	CALL WriteString
	MOV eax, sum
	CALL WriteDec
	CALL Crlf
exit
main ENDP
END main
;=====================================================
;字串轉數字
	MOV box, 0					;轉出的數字
	MOV esi, 0
	MOV edi, 0
	;左字串
	A1:
		MOV al, input1[esi]		;輸入的字串
		SUB al, '0'				;減去ASCLL'0'
		MOVZX eax, al 			
		IMUL ebx, box, 10 		;乘十
		MOV box, ebx
		ADD box, eax 			;加起來
		INC esi
		CMP esi, left1 			;left1為字串長度，字串長度會存在EAX內不懂請往上看字串儲存
		JB A1
;=====================================================
;GCD
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
;=====================================================
;矩陣(逆時針輸入法)
INCLUDE Irvine32.inc
.data
	Msg0 BYTE "輸入N: ", 0
	Msg1 BYTE "輸入N個點: ", 0
	Msg0 BYTE "面積: ", 0

	Op0 BYTE "X = ", 0
	Op1 BYTE "Y = ", 0
	Op2 BYTE ".5", 0
	Op3 BYTE ".0", 0

	arryX DWORD 100 DUP(0)
	arryY DWORD 100 DUP(0)

	X DWORD 0
	Y DWORD 0
	F DWORD 0
	N DWORD 0
.code
main PROC
	MOV edx, OFFSET Msg0
	CALL WriteString
	CALL Crlf
	CALL ReadDec
	MOV N, eax
	;===========輸入============
	MOV edx, OFFSET Msg1
	CALL WriteString
	CALL Crlf
	MOV esi, 0
	MOV ecx, N
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
		CMP esi, N
		JB L2
	;===========除二============
	MOV edx, OFFSET Msg2
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
;=======================XING==========================
