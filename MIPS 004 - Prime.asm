.data
.text
#Prime
addi $s1, $zero, 13		#a
addi $s2, $zero, 2		#i
addi $s3, $zero, 0		#cmp

L1:
	addi $s2, $s2, 1
	div $t0, $s1, $s2
	mul $t1, $t0, $s2
	sub $t2, $s1, $t1
	bne $t2, $s3, L1
	
beq $s1, $s2, L2
	addi $t1, $zero, 0
	j L3
L2:
	addi $t1, $zero, 1
L3:
#print
li $v0, 1
addi $a0, $t1, 0
syscall
	