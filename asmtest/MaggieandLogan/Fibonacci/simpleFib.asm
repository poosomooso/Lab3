addi $t1, $zero, 1 
addi $t2, $zero, 1 

#add $t3, $t1, $t2
addi $a0, $zero, 5		# the n-th fibonacci number you are counting to 
add $a1, $zero, $a0		# the n-th fib number to calculate, preserved for you to look at at the end 

addmore: 
add $t1, $t2, $zero		# move t2 value to t1
add $t2, $t3, $zero 	# move t3 value to t2
add $t3, $t1, $t2		# make t3 the sum of 1 and 2 
addi $a1, $a1, -1
bne $a1, 0, addmore		# the thing you cont down from, like a while loop 

addi $v1, $zero, 1		# make this a 1 when you are finished: like a "done" flag 

li $v0, 10 		# is you assign v0 to 10, you stop maybe if you do 4 you print? unclear. 
syscall 
