.data
.text
#LCM
addi $s1, $zero, 8		#a
addi $s2, $zero, 12		#b
addi $s3, $zero, 0		#i
addi $s4, $zero, 0		#cmp

L1:
	addi $s3, $s3, 1
	mul $s2, $s2, $s3
	div $t0, $s2, $s1
	mul $t1, $t0, $s1
	sub $t1, $t1, $s2
	bne $t1, $s4, L1
mul $t2, $s1, $t0
li $v0, 1
addi $a0, $t2, 0
syscall