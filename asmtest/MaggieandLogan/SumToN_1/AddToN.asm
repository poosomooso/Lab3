# add up all the numbers to N 

addi $a0, $zero, 10		# this is the one you want to add up to 

addi $t1, $zero, 1
addi $a1, $zero, 1

addmore: 
addi $a1, $a1, 1		# n = n-1 
add $t1, $t1, $a1
bne $a0, $a1, addmore	# determines if you're done 

addi $v1, $zero, 1		# make this a 1 when you are finished: like a "done" flag 

li $v0, 10 		# is you assign v0 to 10, you stop maybe if you do 4 you print? unclear. 
syscall 
