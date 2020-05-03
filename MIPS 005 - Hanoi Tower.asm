.data
inputStr: .ascii "enter number"
colon: .asciiz ": "
nextLine: .asciiz "\n"
space_: .asciiz " "
number: .asciiz "number: "
arrow: .asciiz " --> "
resultStr: .space 256
count: .word 0


.macro itoa (%number ,%targetStart)	
	addi $t5 ,$0 ,10
	add $t6 ,$0 ,%number 
	
	add $t7 ,$0 ,$0
	add $t1 ,$0 ,$t6
numDigits:
	divu $t1 ,$t5
	mflo $t1
	mfhi $t2
	beq $t1 ,$0 ,cal
	addi $t7 ,$t7 ,1
	j numDigits							#cal number of digits store in t7
	
cal:	
	add %targetStart ,%targetStart ,$t7
	add $t1 ,$0 ,$t6
loop:
	divu $t1 ,$t5
	mflo $t1
	mfhi $t2
	addi $t2 ,$t2 ,'0'
	sb $t2 ,0(%targetStart)				#part of number
	
	beq $t1 ,$0 ,end
	addi %targetStart ,%targetStart ,-1 #backward
	j loop

end:	
	addi $t7 ,$t7 ,1
	add %targetStart ,%targetStart ,$t7
.end_macro
.macro copyStr (%sourceStr ,%targetStart)	
#$t0: targetStrCurrentPointer ,t1: sourceStr	,t3: counter
	add $t3 ,$0 ,$0			#counter		
	la $t1 ,%sourceStr		
	bne %targetStart ,$0 ,haveStart
	la $t0 ,resultStr
	
	j copyLoop
haveStart:	
	add $t0 ,$0 ,%targetStart	#register with target string start pointer
	
copyLoop:	
	lb $t2 ,0($t1)
	beq $t2 ,$0 ,finish			#get char in source string
	sb $t2 ,0($t0)
	addi $t0 ,$t0 ,1
	addi $t1 ,$t1 ,1
	
	addi $t3 ,$t3 ,1			#counter
	j copyLoop
	
finish:		
	sb $0 ,0($t0)				#end with \0 ?
.end_macro
.macro callHanoi (%A ,%B ,%C)	
 	add $t1 ,$0 ,%A
 	add $t2 ,$0 ,%B
 	add $t3 ,$0 ,%C
 	
	addi $a0 ,$a0 ,-1
	add $a1 ,$0 ,$t1
	add $a2 ,$0 ,$t2
	add $a3 ,$0 ,$t3
	
	jal hanoiFuc
	
	lw $a3 ,0($sp)				#revert argument
	lw $a2 ,4($sp)
	lw $a1 ,8($sp)
	lw $a0 ,12($sp)
.end_macro

.globl main
.text
main:
	li $v0 ,4
	la $a0 ,inputStr
	syscall
	
	li $v0 ,5
	syscall 
	
	add $a0 ,$0 ,$v0
	addi $a1 ,$0 ,'A'
	addi $a2 ,$0 ,'B'
	addi $a3 ,$0 ,'C'
	jal hanoiFuc
	
	li $v0 ,10
	syscall
#==================================================================================	
hanoiFuc:						#a0 = n ,a1 = A ,a2 = B ,a3 = C
	addi $sp ,$sp ,-20		 	#5 * 4
	sw $ra ,16($sp)
	sw $a0 ,12($sp)
	sw $a1 ,8($sp)
	sw $a2 ,4($sp)
	sw $a3 ,0($sp)
	beq $a0 ,1 ,moveDish	
	
	callHanoi ($a1 ,$a3 ,$a2) 	#hanoi(n - 1, A, C, B);
			
moveDish:
	jal printStr				#move the dish	
	beq $a0 ,1 ,end				#n = 1	
	
	callHanoi ($a2 ,$a1 ,$a3)	#hanoi(n - 1, B, A, C);
	
end:
	lw $ra ,16($sp)
	addi $sp ,$sp ,20
	jr $ra


#==================================================================================
printStr:						#a0 = n ,a1 = A ,a2 = B ,a3 = C
	addi $sp ,$sp ,-4
	sw $a0 ,0($sp)
	
	la $t0 ,resultStr
	lw $t1 ,count
	addi $t1 ,$t1 ,1
	sw $t1 ,count
	
	itoa($t1 ,$t0)
	#addi $t1 ,$t1 ,'0'	
	#sb $t1 ,0($t0)				#count number 
	#addi $t0 ,$t0 ,1	

	copyStr(colon ,$t0)			#add a colon		
	
	copyStr(number ,$t0)		#t0 is target string end pointer
	
	itoa($a0 ,$t0)
	#addi $t1 ,$a0 ,'0'
	#sb $t1 ,0($t0)				#dish number
	#addi $t0 ,$t0 ,1			
	
	copyStr(space_ ,$t0)		#add a space
	
	sb $a1 ,0($t0)				#start place
	addi $t0 ,$t0 ,1	
	
	copyStr(arrow ,$t0)			#add a arrow
		
	sb $a3 ,0($t0)				#target place 
	addi $t0 ,$t0 ,1	
	
	copyStr(nextLine ,$t0)		#nextLine
	
	li $v0 ,4
	la $a0 ,resultStr
	syscall
	
	lw $a0 ,0($sp)
	addi $sp ,$sp ,4
	jr $ra