# Problem statement: Find the smallest element in array

# Preconditions: 
#    Array base address stored in register $t0
#    Array size (# of words) stored in register $t1
la 	$t0, my_array		# Store array base address in register (la pseudoinstruction)
addi	$t1, $zero, 16		# 16 elements in array

# Solution pseudocode:
#    i = 0;
#    smallest = array[0]
#    while i < 16 {
#	if smallest > array[i]
#		smallest = array[i]
findmin:
# Allocate enough space in stack to store the final result
# addi  $sp, $sp, -4	# Allocate one word on stack for one push
# sw    $ra, 0($sp)	# Push ra on the stack (will be overwritten by Fib function calls)

# Initialize variables
addi	$t2, $zero, 0		# i, the current array element being accessed
addi	$t3, $t0, 0		# address of my_array[i] (starts from base address for i=0)
addi	$t4, $t3, 0		# SMALLEST element of the array. Starts off as first element of array
addi	$t5, $zero, 0		# stupid slt feature where you have to assign a boolean to signify true or not
LOOPSTART:
beq 	$t2, $t1, LOOPEND	# if i == 16: GOTO DONE

lw	$t6, 0($t3)		# temp = my_array[i]		{LOAD FROM MEMORY}
slt	$t5, $t6, $t4		# see if the the current element is smaller than our current smallest
bne	$t5, 0, reassign	# if $t5 isn't equal to 0, go to a label that reassigns $t4

# if $t5 is equal to 0, we want to continue incrementing i
addi	$t2, $t2, 1		# increment i counter
addi	$t3, $t3, 4		# increment address by 1 word
j	LOOPSTART		# GOTO start of loop

reassign:
addi	$t4, $t6, 0		# reassign the smallest value to the current element
j 	LOOPSTART

LOOPEND:
add   	$v0, $zero, $t4		# assign final minimum to v0



#------------------------------------------------------------------------------
# Jump loop to end execution, so we don't fall through to .data section
program_end:
j    program_end



# Pre-populate array data in memory
#  Note that I have given the data values a distinctive pattern to help with debugging
.data 
my_array:
0x11110000	# my_array[0]
0x22220000
0x33330000
0x44440000
0x55550000
0x66660000
0x00000000
0x77770000
0x88880000
0x99990000
0xAAAA0000
0xBBBB0000
0xCCCC0000
0xDDDD0000
0xEEEE0000
0xFFFF0000

# Null-terminated string to print as part of result
result_str: .asciiz "\nMinimum Value = "

