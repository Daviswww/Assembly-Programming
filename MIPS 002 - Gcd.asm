.data
.text
#GCD
	addi $s1, $zero, 1701
	addi $s2, $zero, 3768
	addi $s3, $zero, 0

	L1:
		div $t0, $s2, $s1
		mul $t1, $s1, $t0
		sub $t2, $s2, $t1
		add $s2, $zero, $s1
		add $s1, $zero, $t2
		bne $s1, $s3, L1
	#print
	addi $t1, $s2, 0 
	li $v0, 1
	addi $a0, $t1, 0
	syscall