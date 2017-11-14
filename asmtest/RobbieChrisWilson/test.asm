# Function adds sum of N integers. 1 + 2 + ... +

main:
	li $a0, 0 # Counter
	li $v0, 0 # Sum
	li $a1, 4 # N
	jal loop
	
	# Save answer to $s0
	addi $s0, $v0, 0
	
	li $a0, 0
	li $v0, 0
	li $a1, 3
	jal loop
	
	# Save answer to $s0
	addi $s1, $v0, 0
	
	li $v0, 10
	syscall 

loop:	addi $a0, $a0, 1 # Counter ++
	add $v0, $v0, $a0 # Add sums
	bne $a1, $a0, loop # End of loop
	j end

end:	
	jr $ra
