main:
addi $sp, $zero, 0x00003ffc
la $s0, array
addi $a0, $zero, 0
addi $a1, $zero, 9
jal quicksort
j done


quicksort:
# $s0 = arr*
# $a0 = start
# $a1 = end
# $t0 = pivot
# $t1 = branch check temporary (for xori and slt)


# if start < end, run quicksort
slt $t1, $a0, $a1
bne $t1, $zero, run
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

add $t0, $zero, $v0

# push frame onto stack
addi $sp, $sp, -16
sw $ra, 12($sp)
sw $a0, 8($sp)
sw $a1, 4($sp)
sw $t0, ($sp)

# quicksort(arr, start, pivot - 1)
addi $a1, $t0, -1

jal quicksort

# pop frame from stack
lw $ra, 12($sp)
lw $a0, 8($sp)
lw $a1, 4($sp)
lw $t0, ($sp)
addi $sp, $sp, 16

# push frame onto stack
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $a0, 4($sp)
sw $a1, ($sp)

# quicksort(arr, pivot + 1, end)
add $a0, $t0, 1

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
# $a0 = start
# $a1 = end
# $a2 = arr index (calcMemAddr)
# $s0 = arr*
# $s1 = pivot
# $s2 = i (counter)
# $s3 = j (counter)
# $s4 = arr[i] val
# $s5 = arr[j] val
# $t0 = branch check temporary (for xori and slt)
# $t3 = arr[end] addr
# $t4 = arr[i] addr
# $t5 = arr[j] addr

addi $sp, $sp, -4
sw $ra, ($sp)
# -----------------------------------------------------------------
## int pivot = arr[end]
## int i = start - 1;

# set arr index to end and call calcMemAddr
add $a2, $zero, $a1
jal calcMemAddr
# set arr[end] addr
add $t3, $zero, $v0

# set reg pivot to mem[arr[end]]
lw $s1, ($t3)

# set i to start - 1
sub $s2, $a0, 1

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
add $s3, $zero, $a0
j forcheck
forloop:

# set arr index to j and call calcMemAddr
add $a2, $zero, $s3
jal calcMemAddr
# set arr[j] addr
add $t5, $zero, $v0

# set reg arr[j] to mem[arr[j]]
lw $s5, ($t5)

# check if arr[j] <= pivot
addi $s1, $s1, 1
slt $t0, $s5, $s1
addi $s1, $s1, -1

# execute swap if slt is true
bne $t0, $zero, swap
j increment
swap:
# i++
addi $s2, $s2, 1

# set arr index to i and call calcMemAddr
add $a2, $zero, $s2
jal calcMemAddr
# set arr[i] addr
add $t4, $zero, $v0

# set reg arr[i] to mem[arr[i]]
lw $s4, ($t4)

# store in opposite places
sw $s4, ($t5)
sw $s5, ($t4)

# increment j
increment:
addi $s3, $s3, 1
# break for loop when j = end
forcheck:
bne $s3, $a1, forloop

# -----------------------------------------------------------------
## int temp = arr[i + 1];
## arr[i + 1] = arr[end];
## arr[end] = temp;
## return i + 1;

# set i to i + 1, arr index to i + 1 and call calcMemAddr
addi $s2, $s2, 1
add $a2, $zero, $s2
jal calcMemAddr

# set reg arr[i] to mem[arr[i + 1]]
lw $s4, ($v0)
# store pivot at mem[arr[i + 1]]
sw $s1, ($v0)

# store reg arr[i] (holding arr[i + 1]) into mem[arr[end]]
sw $s4, ($t3)

#return i + 1
add $v0, $zero, $s2
lw $ra, ($sp)
addi $sp, $sp, 4
jr $ra


calcMemAddr:
# $v0 = addr (return)
# $t0 = multiply counter temporary
# $t1 = branch check temporary (for xori and slt)

# set addr to arr* and mult counter to 0
add $v0, $zero, $s0
addi $t0, $zero, 0
calc:
# add index to addr, 1 to mult counter
add $v0, $v0, $a2
addi $t0, $t0, 1
# if mult counter != 4, loop
xori $t1, $t0, 4
bne $t1, $zero, calc
jr $ra


done:
j done
# addi $v0, $zero, 10
# syscall

.data
array:
0x00000009
0x00000005
0x00000003
0x00000006
0x00000002
0x00000008
0x00000007
0x00000003
0x00000001
0x00000004
