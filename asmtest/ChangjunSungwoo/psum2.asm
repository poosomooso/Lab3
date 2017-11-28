MAIN:
# test case 1
addi $a0, $zero, -222
addi $a1, $zero, 224
jal PSUM
bne $v0, 447, WRONG
# test case 2
addi $a0, $zero, 6691
addi $a1, $zero, 6690
jal PSUM
bne $v0, 0, WRONG
# test case 3
addi $a0, $zero, 83798
addi $a1, $zero, 83798
jal PSUM
bne $v0, 83798, WRONG
# test case 3
addi $a0, $zero, 83798
addi $a1, $zero, 83798
jal PSUM
bne $v0, 83798, WRONG
addi $t7, $zero, 13328 # if all test passes, set $t7 as 0x00003410
j END
WRONG:
addi $t7, $zero, 0
j END

PSUM: # sum of numbers between the parameter $a0 and $a1(including $a0 and $a1)
# save into stack
addi $v0, $zero, 0

WHILE:
slt  $t0, $a1, $a0 # if $a0 > $a1, loop ends
bne  $t0, 0, R
add $v0, $v0, $a0
addi $a0, $a0, 1
j WHILE

R:
jr $ra

END:
