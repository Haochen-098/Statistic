# AUTHOR: HAOCHEN GOU

# cubestats use to calculate the average for positive and negative number divide

	.text 
CubeStats:
    	li  	$t1, 0          # initial the t1
    	li  	$t2, 1          # initial the t2

	# set up frame
	subu	$sp, $sp, 4 	
	sw	$fp, 0($sp)     
	move	$fp, $sp

	# grow the stack
    	subu	$sp, $sp, 24 	
	sw	$ra, -4($fp)	# store the ra 
    	sw 	$a0, -8($fp)	# store the a0
    	sw	$a2, -12($fp)	# store the a2
    	sw	$a1, -16($fp)	# store the a1
    	bgt 	$a0, $t2, loop	# if dimension > 1 then go to loop
    	
# basecase for the case that dimension is one

basecase:
    	lw	$t0, 0($a2)	# load address from to t0
    	bgtz	$t0, posnum	# check if the number positive go to posnum
	bltz	$t0, negnum	# check if the number negative go to negnum
	 
    	#unwind the stack
	addu	$sp, $sp, 24
	lw	$fp, 0($sp)
	addu	$sp, $sp, 4
    	jr	$ra

# loop for recursive
loop:
	lw 	$a0, -8($fp)	# restore the a0
	lw 	$a2, -12($fp)	# restore the a2
    	beq	$t1, $a3, quit	# if i = edge then quit
    	subu    $a0, $a0, 1 	# dimension = dimension - 1
   	
	jal	power2		# use power2 to calculate the power
	
	move	$t5, $v0	# get the power
	mul     $t6, $t1, $t5	# get power*i
	sll	$t6, $t6, 2	# value times 4 to get the next address
	add	$a2, $a2, $t6 	# add value to get the next number 
	addi	$t1, $t1, 1	# i= i+1
	sw	$t1, -20($fp)	# store the i in the stack
    	jal     CubeStats	# recursive return
	lw	$t1, -20($fp)	# restore the i from the stack
	j	loop				

quit:
    	lw	$s5, countPos       # load value of countPos to s5
	beq 	$s5, $zero, Pempty  # check if there no positive number  
	lw	$s7, countNeg       # load value of countNeg to s7
	beq	$s7, $zero, Nempty  # check if there no negative number 

# use to solve the situation that no positive or negaive number
Pempty:
    	li	 $s5, 1          
    	j 	 div1              # jump to div1
Nempty:
    	li	$s7, 1
    	j	div1		# jump to div1
div1:    
	lw	$s4, totalPos   # load value of totalPos to s4
	div	 $s4, $s5       # calculate the division
    	mflo	 $v1            # get the value
	lw	$s6, totalNeg   # load value of totalNeg to s6
	div	$s6, $s7        # calculate the division
	mflo 	$v0 		# get the value   
	mfhi	$t8		# get the remainder
	beq	$t8, $zero, l1	# check the remainder
	addi	$v0, $v0, -1	# result minus 1 when remainder not zero
l1:			        				
	lw	$ra, -4($fp)	# load the ra 
    	lw 	$a0, -8($fp)	# load the a0
    	lw	$a2, -12($fp)	# load the a2
    	lw	$a1, -16($fp)	# load the a1

	#unwind the stack
	addu	$sp, $sp, 24
	lw	$fp, 0($sp)
	addu	$sp, $sp, 4
	jr  	$ra             # return back
	


# count the positive number	
posnum:	
	lw	$t3, totalPos	# lowd value of total positive number to t3
	addu	$t3, $t3, $t0	# add the number together
	sw	$t3, totalPos	# store the value in the totalPos
	lw	$t4, countPos	# lowd value of total positive number to t3
	addi	$t4, $t4, 1	# add the number together
	sw	$t4, countPos	# store the value in the totalPos

	#unwind the stack
	addu	$sp, $sp, 24
	lw	$fp, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra		# return the basecase
	
# count the negative number
negnum:
	lw	$t3, totalNeg	# lowd value of total negative number to t3
	addu	$t3, $t3, $t0	# add the number together
	sw	$t3, totalNeg	# store the value in the totalNeg
	lw	$t4, countNeg	# lowd value of total negative number to t3
	addi	$t4, $t4, 1	# add the number together
	sw	$t4, countNeg	# store the value in the totalNeg

	#unwind the stack
	addu	$sp, $sp, 24
	lw	$fp, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra		# return the basecase

# calculate the power of the size 
power2:
	li	$t7, 1		# store 1 in t7

ploop2:
	beqz	$a0, pdone2	# check if the loop terminate 
	mul	$t7, $t7, $a1	# multipy the size 
	subu	$a0, $a0, 1	
	j	ploop2		# continue the loop
pdone2:
 	jr	$ra		# return value
