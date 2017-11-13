main:
addi $t0, $zero, 3
addi $t1, $zero, 2
addi $t2, $zero, 7
addi $t3, $zero, 9
addi $t4, $zero, 5
sw $t0, ($gp)
sw $t1, 4($gp)
sw $t2, 8($gp)
sw $t3, 12($gp)
sw $t4, 16($gp)
add $s0, $zero, $gp
addi $a0, $zero, 0
addi $a1, $zero, 4
jal partition
j end

# $v0 = return val
# $s0 = arr*
# $a0 = start
# $a1 = end
# $a2 = arr index (calcMemAddr)
# $t0 = pivot
# $t1 = addr (for data address calculations)
# $t2 = multiply counter temporary
# $t3 = branch check temporary (for xori and slt)
# $t4 = i (counter)
# $t5 = j (counter)
# $t6 = arr[i] val
# $t7 = arr[j] val

partition:
addi $sp, $sp, -4
sw $ra, ($sp)
# -----------------------------------------------------------------
## int pivot = arr[end]
## int i = start - 1;

# set arr index to end and call calcMemAddr
add $a2, $zero, $a1
jal calcMemAddr

# set reg pivot to mem[arr[end]]
lw $t0, ($t1)

# set i to start - 1
sub $t4, $a0, 1

# -----------------------------------------------------------------
## for (int j = start; j < end; j++) {
##     if (arr[j] <= pivot) {
##       i++;
##       int temp = arr[i];
##       arr[i] = arr[j];
##       arr[j] = temp;
##     }
##  }

# set j to start and jump to check
add $t5, $zero, $a0
j forcheck
forloop:

# set arr index to j and call calcMemAddr
add $a2, $zero, $t5
jal calcMemAddr

# set reg arr[j] to mem[arr[j]]
lw $t7, ($t1)

# check if arr[j] <= pivot
addi $t0, $t0, 1
slt $t3, $t7, $t0
addi $t0, $t0, -1

# execute swap if slt is true
bne $t3, $zero, swap
j increment
swap:
# i++
addi $t4, $t4, 1

# set arr index to i and call calcMemAddr
add $a2, $zero, $t4
jal calcMemAddr

# set reg arr[i] to mem[arr[i]]
lw $t6, ($t1)

# set arr index to j and call calcMemAddr
add $a2, $zero, $t5
jal calcMemAddr

# set reg arr[j] to mem[arr[j]]
lw $t7, ($t1)

# store in opposite places
sw $t6, ($t1)
# set arr index to i and call calcMemAddr
add $a2, $zero, $t4
jal calcMemAddr
sw $t7, ($t1)

# increment j
increment:
addi $t5, $t5, 1
# break for loop when j = end
forcheck:
bne $t5, $a1, forloop

# -----------------------------------------------------------------
## int temp = arr[i + 1];
## arr[i + 1] = arr[end];
## arr[end] = temp;
## return i + 1;

# set i to i + 1, arr index to i + 1 and call calcMemAddr
addi $t4, $t4, 1
add $a2, $zero, $t4
jal calcMemAddr

# set reg arr[i] to mem[arr[i + 1]]
lw $t6, ($t1)
# store pivot at mem[arr[i + 1]]
sw $t0 ($t1)

# set arr index to end and call calcMemAddr
add $a2, $zero, $a1
jal calcMemAddr

# store reg arr[i] (holding arr[i + 1]) into mem[arr[end]]
sw $t6, ($t1)

#return i + 1
add $v0, $zero, $t4
lw $ra, ($sp)
addi $sp, $sp, 4
jr $ra


calcMemAddr:
# set addr to arr* and mult counter to 0
add $t1, $zero, $s0
addi $t2, $zero, 0
pivotcalc:
# add index to addr, 1 to mult counter
add $t1, $t1, $a2
addi $t2, $t2, 1
# if mult counter != 4, loop
xori $t3, $t2, 4
bne $t3, $zero, pivotcalc
jr $ra


end:
