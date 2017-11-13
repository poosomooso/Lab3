# $v0 = return val
# $s0 = arr*
# $a0 = start
# $a1 = end
# $t0 = pivot
# $t1 = addr (for data address calculations)
# $t2 = multiply counter temporary
# $t3 = branch check temporary (for xori and slt)
# $t4 = i (counter)
# $t5 = j (counter)
# $t6 = temp
# $t7 = arr[i]
# $t8 = arr[j]

partition:
# -----------------------------------------------------------------
## int pivot = arr[end]
## int i = start - 1;

# set addr to arr* and mult counter to 0
add $t1, $zero, $s0
addi $t2, $zero, 0
pivotcalc:
# add end to addr, 1 to mult counter
add $t1, $t1, $a1
addi $t2, $t2, 1
# if mult counter != 4, loop
xori $t3, $t2, 4
bne $t3, $zero, pivotcalc

# set pivot to mem[addr]
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

# set addr to arr* and mult counter to 0
add $t1, $zero, $s0
addi $t2, $zero, 0
arrjcalc:
# add j to addr, 1 to mult counter
add $t1, $t1, $t5
addi $t2, $t2, 1
# if mult counter != 4, loop
xori $t3, $t2, 4
bne $t3, $zero, arrjcalc

# set arr[j] to mem[addr]
lw $t8, ($t1)

# check if arr[j] <= pivot
addi $t0, $t0, 1
slt $t3, $t8, $t0
addi $t0, $t0, -1

# execute swap if slt is true
bne $t3, $zero, swap
j increment
swap:

# set addr to arr* and mult counter to 0
add $t1, $zero, $s0
addi $t2, $zero, 0
arricalc:
# add i to addr, 1 to mult counter
add $t1, $t1, $t4
addi $t2, $t2, 1
# if mult counter != 4, loop
xori $t3, $t2, 4
bne $t3, $zero, arricalc

# set arr[i] to mem[addr]
lw $t7, ($t1)

add $t6, $zero, $t7
##### working here

# increment j
increment:
addi $t5, $t5, 1
# break for loop when j = end
forcheck:
bne $t5, $a1, forloop
