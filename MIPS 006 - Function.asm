.data

.text
	main:
		addi $a1, $0, 50
		addi $a2, $0, 100
		
		jal addNum
		li $v0, 1
		addi $a0, $v1, 0
		syscall
		
	li $v0, 10
	syscall
		
	addNum:
		add $v1, $a1, $a2
		
		jr $ra