.data
	a: .space 10
	b: .space 400
	ii: .word 0
	jj: .word 0
	kk: .word 0
	temp: .word 4
.text
	lw $s2, ii			#s2 = i
	lw $s3, jj			#s3 = j
	lw $s4, kk			#s4 = k
	lw $s5, temp		#s5 = temp
	
	mul $s4, $s4, 10	#kk *= 10
	add $t0, $s3, $s4	#t0 = jj + kk
	
	lb $s1, b($t0)		#s1 = b[t0] 
	add $t1, $s5, $s1	#t1 = tmp + s1
	mul $t1, $t1, 10	#t1 *= 10
	
	lb $s0, a($s0)		#s0 = a[s2]
	sub $t1, $s0, $t1	#t1 = s0 - t1
	sb $t1, b($t0)		#b[t0] = t1
	
	#print
	lb $t6, b($t0)
	li $v0, 1
	addi $a0, $t6, 0
	syscall
