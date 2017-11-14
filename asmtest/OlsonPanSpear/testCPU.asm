addi $a0, $zero, 0
addi $a1, $zero, 6
j jumpAndCheck
incrementBoth:
	addi $a0, $a0, 1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	jr $ra
jumpAndCheck:
	jal incrementBoth
	bne $a0, $a1, incrementBoth
#------------------------------------------------------------------------------
# Jump loop to end execution, so we don't fall through to .data section
program_end:
	j    program_end

	