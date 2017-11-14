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
addi $sp, $sp, -12
sw   $ra, 8($sp)
sw   $a0, 4($sp)
sw   $a1, 0($sp)
slt  $t0, $a1, $a0 # if $a0 > $a1, $t0 = 1(psum=0)
bne  $t0, 0, R1

bne  $a0, $a1, R2 # if $a0 != $a1, go ot R2. else, psum = $a0
add $v0, $a0, $zero # psum = $a0
addi $sp, $sp, 12
jr $ra

R1:
addi $v0, $zero, 0 # psum = 0
addi $sp, $sp, 12
jr $ra

R2:
addi $a0, $a0, 1 
jal PSUM # call psum(n+1, m)
lw   $a1, 0($sp) 
lw   $a0, 4($sp)
lw   $ra, 8($sp)
addi $sp, $sp, 12
add  $v0, $v0, $a0 # n + psum(n+1,m)
jr   $ra

END:
