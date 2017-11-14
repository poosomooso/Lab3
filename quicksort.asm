main:
addi $t0, $zero, 9
addi $t1, $zero, 5
addi $t2, $zero, 3
addi $t3, $zero, 6
addi $t4, $zero, 2
addi $t5, $zero, 8
addi $t6, $zero, 7
addi $t7, $zero, 3
addi $t8, $zero, 1
addi $t9, $zero, 4
sw $t0, ($gp)
sw $t1, 4($gp)
sw $t2, 8($gp)
sw $t3, 12($gp)
sw $t4, 16($gp)
sw $t5, 20($gp)
sw $t6, 24($gp)
sw $t7, 28($gp)
sw $t8, 32($gp)
sw $t9, 36($gp)
add $s0, $zero, $gp
addi $a0, $zero, 0
addi $a1, $zero, 9
jal quicksort
j done


quicksort:
# $s0 = arr*
# $s1 = pivot
# $a0 = start
# $a1 = end
# $t3 = branch check temporary (for xori and slt)


# if start < end, run quicksort
slt $t3, $a0, $a1
bne $t3, $zero, run
j end

run:
# push frame onto stack
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $a0, 4($sp)
sw $a1, ($sp)

# pivot = partition (arr, start, end)
jal partition

# pop frame from stack
lw $ra, 8($sp)
lw $a0, 4($sp)
lw $a1, ($sp)
addi $sp, $sp, 12

add $s1, $zero, $v0

# push frame onto stack
addi $sp, $sp, -16
sw $ra, 12($sp)
sw $a0, 8($sp)
sw $a1, 4($sp)
sw $s1, ($sp)

# quicksort(arr, start, pivot - 1)
addi $a1, $s1, -1

jal quicksort

# pop frame from stack
lw $ra, 12($sp)
lw $a0, 8($sp)
lw $a1, 4($sp)
lw $s1, ($sp)
addi $sp, $sp, 16

# push frame onto stack
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $a0, 4($sp)
sw $a1, ($sp)

# quicksort(arr, pivot + 1, end)
add $a0, $s1, 1

jal quicksort

# pop frame from stack
lw $ra, 8($sp)
lw $a0, 4($sp)
lw $a1, ($sp)
addi $sp, $sp, 12

end:
jr $ra


partition:
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
sw $t0, ($t1)

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


done:
addi $v0, $zero, 10
syscall
