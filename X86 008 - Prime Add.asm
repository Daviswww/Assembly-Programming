INCLUDE Irvine32.inc
.data
	Msg BYTE "輸入一個正整數 N，求出 N 的質因數相加", 0
	Msg1 BYTE "Ans: ", 0
	Msg2 BYTE "PrimeNum ", 0
	Op1 BYTE " + ", 0
	Op2 BYTE " = ", 0
	prime DWORD 0
	sum DWORD 0
	count DWORD 0
	box DWORD 0
.code
main PROC
Start:
	mov sum, 0
	mov prime, 0

	MOV EDX, OFFSET Msg
	CALL WriteString	
	CALL crlf
	CALL ReadDec
;=======判斷=========
	CALL PrimeNum		;判斷是否質數
	CMP edi, 0				;零為質數，一為非質數
	JE Pri0
;=======非質數========
	MOV EDX, OFFSET Msg1
	CALL WriteString
	NPri:
	CALL PrimeNum
	CMP edi, 0		
	JE Pri1
;----------------計算--------------
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
		MOV box, eax
		MOV eax, esi
		CALL WriteDec
		MOV EDX, OFFSET Op1
		CALL WriteString
		MOV eax, box
		MOV prime, esi
		ADD sum, esi
	JMP NPri
;=========輸出質數=========
	Pri0:
	MOV EDX, OFFSET Msg2
	CALL WriteString
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
		CALL WriteDec
	ENDING:
	Call crlf
	Call WaitMsg
	Call crlf
	Jmp Start
exit
main ENDP

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
		INC count				;整除則加一
		CMP count, 1		;一個以上的話則不是質數
		JG L2
		CMP esi, ebx			;小於EBX則跳回L1
		JL L1
		MOV edi, 0			;如果是質數則為零
		L2:
ret
PrimeNum ENDP
END main
