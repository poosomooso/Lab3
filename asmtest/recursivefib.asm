addi $a0, $zero, 7

jal fib
add $s0, $zero, $v0

addi $v0, $zero, 10
syscall 

fib:
    ble $a0, 2, base	# if base case
    
    # push current a0 and ra
    addi $sp, $sp, -8
    sw $a0, 4($sp)
    sw $ra, 0($sp)
    # recurse a0-1
    addi $a0, $a0, -1
    jal fib
    
    # push additional result to stack
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    # recurse a0-2
    addi $a0, $a0, -1
    jal fib

    # load from stack
    lw $t0, 0($sp)	# previous result
    lw $ra, 4($sp)	# current ra
    lw $a0, 8($sp)	# current a0
    addi $sp, $sp, 12

    # get result
    add $v0, $v0, $t0

    j end
base:
    addi $v0, $zero, 1

end:
    jr $ra