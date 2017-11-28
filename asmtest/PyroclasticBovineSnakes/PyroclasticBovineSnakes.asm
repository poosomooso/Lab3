addi $a0, $zero, 7
addi $a1, $zero, 13
addi $a2, $zero, 41
addi $a3, $zero, 53

sub $t0, $a1, $a0 # 13-7 = 6
xori $t0, $t0, 0xffff # 65529

add $t1, $zero, $a3
add $s1, $zero, $zero #130 by the end

iterate:
slt $t3, $t0, $a3
bne $t3, $zero, end
sub $t0, $t0, $t1
add $t1, $t1, $a0
addi $s1, $s1, 1
j iterate

end:
add $s0 $zero, $t0 #-56