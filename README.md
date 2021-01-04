# x86組合語言指令集
## ● 摘要:
x86是組合語言的其中一種，在組合語言裡所有的運算都必須透過暫存器來計算，在這邊整理了組合語言的指令範例方便大家學習使用。

## ● 框架
在組合語言裡分為兩個部分，分別為資料與運行得程式碼。在資料(.data)裡就如同宣告一個變數一樣，在程式碼(.code)內就是你所要執行的內容。
```
INCLUDE Irvine32.inc 	;函式庫
.data
    ;資料
.code
main PROC
    ;運行的程式碼
exit
main ENDP
```

## ● 資料大小與暫存器
### ◆ 指令與資料大小
在宣告變數時你還需要指定這個變數的大小，因此你必須了結每個指令所對應的位元數。

指令    | 位元 |
-----  | --- |
BYTE   | 8-bit無號整數
SBYTE  | 8-bit有號整數
WORD   | 16-bit無號整數
SWORD  | 16-bit有號整數
DWORD  | 32-bit無號整數
SDWORD | 32-bit有號整數
FWORD  | 48-bit整數
QWORD  | 64-bit整數
TBYTE  | 80-bit整數
REAL4  | 32-bit (4 byte)  IEEE短實數
REAL8  | 64-bit (8 byte)  IEEE長實數
REAL10 | 80-bit (10 byte) IEEE延伸實數

### ◆ 暫存器
在組合語言裡所有的運算都必須透過暫存器運算完後在放回變數內。

指令    | 暫存器 |
-----  | --- |
BYTE  	| 8位元通用暫存器:  AH、AL、BH、BL、CH、CL、DH、DL
WORD  	| 16位元通用暫存器: AX、BX、CX、DX、SI、DI、SP、BP
DWORD 	| 32位元通用暫存器: EAX、EBX、ECX、EDX、ESI、EDI、ESP、EBP


## ● 資料宣告

```
.data
Msg BYTE "hello ASM world!", 0
array DWORD 100 DUP(0)                  ;空陣列
ID BYTE 100 DUP (0)                     ;空字串
asec DWORD 0                            ;變數
```

## ● 移動資料

```
mov eax, 10	                            ;eax = 10
mov ebx, eax                            ;ebx = eax
movzx al, eax                           ;較小值移至到較大值
```

## ● 運算範例
### ◆ 根號
mid為要被開根號的值。

```
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
```

### ◆ 乘法
5 * 5 = 25

```
mov ebx, 5
mov eax, 5
imul ebx 	 	;有號
mul ebx 		;無號
call WriteDec 	;eax = 25	
```

### ◆ 除法
10 / 5 = 2 
相除完後的餘數會放在edx這個暫存器內，所以如果你列印edx他會顯示0。

```
mov edx, 0		;餘數
mov eax, 10		;商
mov ebx, 5		;除數
idiv ebx 		;有號
div ebx 		;無號
call WriteDec	;ans = 2
```

### ◆ 減法
10 - 5 = 5
兩數相減。

```
mov eax, 10
mov ebx, 5
sub eax, ebx 	;小數
sbb eax, ebx 	;大數
call WriteDec	;ans = 5
```

### ◆ 加法
10 + 5 = 15
兩數相加。

```
mov eax, 10
mov ebx, 5
add eax, ebx 	;小數
adc eax, ebx 	;大數
call WriteDec	;ans = 15
```

### ◆ 加一
你可以使inc來對暫存器直接加一，又或者用sub這個指令來作加一的動作。
```
mov eax, 1
add eax, 1
inc eax
call WriteDec 	;ans = 2
```

### ◆ 減一
你可以使用dec來對暫存器直接減一，又或者用sub這個指令來作減一的動作。

```
mov eax, 2
sub eax, 1 
dec eax
call WriteDec 	;ans = 1
```

## ● 輸入與輸出
### ◆ 換行

```
call Crlf
```

### ◆ 輸入字串
#### 多個字串輸入

```
lea EDX, ID[ESI]
mov ECX, ( SIZEOF ID ) - 1 
call ReadString
add esi, 10			;移動10格
```

#### 單一字串輸入

```
mov edx, OFFSET ID
mov ecx, (SIZEOF ID) - 1
call ReadString	
call WriteDec		;字串長度會暫存EAX
```

### ◆ 輸出字串
在這邊記得要依照陣列宣告的大小做對應的移動，例如字串就是BYTE所以每一個字都是移動一格。
#### 多個字串輸出

```
lea EDX, ID[esi]
call WriteString
add esi, 12			;移動12格
```

#### 資料字串輸出

```
MOV EDX, OFFSET Msg1
call WriteString
```

### ◆ 輸入數字
#### 單一數字輸入

```
	call ReadDec		;暫存EAX
	call RedaInt		;帶正負號
```

#### 陣列數字輸入

```
	call ReadDec
	mov array2[esi*4], eax
	inc esi
```

### ◆ 輸出數字
#### 單一數字輸出

```
mov eax, 10
call WriteDec		;Output = 10
call WriteInt		;Output = +10
```

#### 陣列數字輸出

```
mov  eax, array2 [esi*4]
call WriteDec
inc esi
```

## ● 比較

```
L1:
    mov eax, 10
    mov ebx, 5
    cmp eax, ebx
    JA L1		;if(eax > ebx)則跳到L1
```

### ◆ 特殊的 flag 值
指令   | 運算 | 指標 
----- | --- | ---- 
JZ  | 若為零則跳        | ZF=1 
JNZ | 若為不零則跳       | ZF=0  
JC  | 若進位則跳     | CF=1
JNC  | 若不進位則跳    | CF=0
JO | 若溢位則跳         | OF=1 
JNO  | 若不溢位則跳    | OF=0
JS  | 若負號則跳        | SF=1
JNS | 若非負號則跳      | SF=0 
JP  | 同位(偶)則跳      | PF=1
JNP | 非同位(奇)則跳    | PF=0

### ◆ 兩運算元是否相等或(E)AX的值    
指令   | 運算 | 範例 
----- | --- | ---- 
JZ  | 相等則跳        | if(left == right)
JNZ | 不相等則跳       | if(left != right) 
JC  | 若 CX = 0 則跳     | 
JNC  | 若 ECX = 0 則跳    | 

### ◆ 無號運算元的比較
指令   | 運算 | 
----- | --- | 
JA  | 較大則跳        
JNBE | 不是較小或相等則跳(=JA)       
JAE  | 較大或相等則跳     
JNB  | 不是較小則跳(=JAE)   
JB | 較小則跳         
JNAE  | 不是較大或相等則跳(=JB)   
JBE  | 較小或相等則跳        
JNA | 不是較大則跳(=JBE)     


### ◆ 帶正負號運算元間的比較
指令   | 運算 | 
----- | --- | 
JG	 |	較大則跳
JNLE |	非較小或相等則跳(=JG)
JGE	 |	較大或相等則跳
JNL	 |	不是較小則跳(=JGE)
JL	 |	較小則跳
JNGE |	非較大或相等則跳(=JL)
JLE	 |	較小或相等則跳
JNG	 |	不是較大則跳(=JLE)

## ● 迴圈
### ◆ 32以內的迴圈
```
mov ecx, 5	;次數
L1:
    ;內容
loop L1
```

### ◆ 無限制迴圈
```
MOV EBX, 5	;次數
L1:
    ;內容
DEC EBX
JNE L1
```

### ◆ 無條件跳躍
```
L1:
    ;內容
JMP L1
```

### ◆ 巢狀迴圈
```
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
```

## ● 函式
由於組合語言並非一半高階語言一樣方便，因此重複的代碼會非常多，所以你可以宣告一些函式來簡化你的程式。

```
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
```
