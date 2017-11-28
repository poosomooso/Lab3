main: 
# take in a number
# want to add sum of all numbers up until that point
# number = number - 1
# when number = 1, add number to register A
# number = number + 1

# ex - let's start with number = 3
addi $a0, $zero, 5

# making space in register
addi  $sp, $sp, -12	# Allocate three words on stack at once for three pushes
sw    $s0, 8($sp)	# Push ra on the stack (will be overwritten by Fib function calls)
sw    $s1, 4($sp)	# Push s0 onto stack
sw    $s2, 0($sp)	# Push s1 onto stack

# this is hard coded
# add  $s2, $zero, $a0 # put a0 here - a0 is our original number 3
# subi $s1, $s2, 1 # put 2 in s1
# subi $s0, $s1, 1 # put 1 in s0 
# add $a0, $s0, $s1
# add $a0, $a0, $s2

# recursive
add $t2, $zero, $a0
subtract:
subi $t1, $t2, 1 # subtract 1 from s2, save that in s1
add  $t2, $zero, $t1 # save value of s1 into s2
bne $t2, 0, subtract # if s2 does not equal 1, subtract again


# if we have reached 1, then we'll start adding
add $t5, $zero, $t2 #save the value of s2 into s5
add $t6, $zero, $zero 
add $t7, $zero, $zero 

adding:
addi $t6, $t5, 1 # add s5 and s6 = s7
add $t5, $t6, $zero # add s6 + 1, save to s5
add $t7, $t5, $t7 # reassign s6 to s5
bne $a0, $t6, adding # if s6 does not equal the original number (3), do another addition
add $t4, $t7, $zero
sw $t5, ($s2)
li $v0, 10
syscall




