######################################################
#                                                    # 
# Name: Assignment5                                  #
#                                                    # 
# Description: Calculates the sum, mean, min, max    # 
# and variance of a series of numbers.               #
#                                                    # 
# Date: June 23th, 2020                              #
#                                                    #
# Author: Luciano Zavala IT Student                  #
######################################################
	.data
MSG1:	.asciiz		"Enter integer values, one per line, terminated by a negative value.\n"
ERROR:	.asciiz		"Error\n"
AEO:	.asciiz		"\n"
SUM:	.asciiz		"Sum is: "
MIN:	.asciiz		"Min is: "
MAX:	.asciiz		"Max is: "
AVG:	.asciiz		"Mean is: "
VAR:	.asciiz		"Variance is: "
x:	.word		100
	.text
	.globl	main
main:	
	li	$v0,4
	la	$a0,MSG1		# main routne prints the welcome message
	syscall
	

	li	$v0,5			# reads an Integer
	syscall
	move	$t1,$v0
	bltz	$t1,BADN		# If its less tha zero passes to the fucntion BADN
	move	$s0,$t1			#min
	move	$s1,$t1			#max

	add	$t3,$t3,$t1		# performs addition
	mul	$t4,$t1,$t1		# performs multiplication
	add	$t7,$t7,$t4		# adds the multiplication to the sum
	add	$t2,$t2,$t4
	add	$t6,$t6,1		# The counter
	
	

loop:					# loop starts
	li	$v0,5			# reads an Integer
	syscall
	move	$t1,$v0			# assigns a location to the integer
	bgtz	$t1,min
	bgt	$t1,$s1,max
	
	bltz	$t1,BADN		# If its less tha zero passes to the fucntion BADN
next:	
	add	$t3,$t3,$t1		# performs addition
	mul	$t4,$t1,$t1		# performs multiplication
	add	$t7,$t7,$t4
	add	$t2,$t2,$t4
	add	$t6,$t6,1		# The counter
	bgtz	$t1,loop		# Returns to the loop




BADN:	
	#add	$t3,$t3,1
	#sub	$t6,$t6,1
					# Printing Function
	li	$v0,4			# prints the sum
	la	$a0,SUM	
	syscall

	li	$v0,1
	move	$a0,$t3			# Moves the address of the Int to print
	syscall

	li	$v0,4
	la	$a0,AEO			# SPACE
	syscall

	li	$v0,4			# prints the message of the Mean
	la	$a0,AVG
	syscall


#################################################
	mtc1	$t3,$f1                         #
	cvt.s.w	$f1,$f1				#
						#<--- INTEGER TO FLOAT (propper implementation)
	mtc1	$t6,$f2				#
	cvt.s.w	$f2,$f2	

	mtc1	$t7,$f5				#
	cvt.s.w	$f5,$f5				#
#################################################
	
	

	div.s	$f3,$f1,$f2
					# Computes the mean FLOAT
	li	$v0,2
	mov.s	$f12,$f3		# prints the result FLOAT
	syscall


	li	$v0,4
	la	$a0,AEO			# SPACE
	syscall

	li	$v0,4			# Prints the Min message
	la	$a0,MIN
	syscall

	li	$v0,1			# Prints the min value
	move	$a0,$s0
	syscall

	li	$v0,4
	la	$a0,AEO			# SPACE
	syscall
	
	li	$v0,4			# Prints the Max message 
	la	$a0,MAX
	syscall	
	
	li	$v0,1
	move	$a0,$s1			# Prints the max value
	syscall

	li	$v0,4
	la	$a0,AEO			# SPACE
	syscall

	li	$v0,4
	la	$a0,VAR			# Prints the variance message
	syscall

	mul.s	$f4,$f1,$f1		# 
	div.s	$f4,$f4,$f2		#<-- Variance Computation
	sub.s	$f5,$f5,$f4		#
	div.s	$f6,$f5,$f2		#


	li	$v0,2
	mov.s	$f12,$f6		# Prints the variance
	syscall
	

	
	jr	$ra

#########################
# Min and Max functions #
#########################

min:
	blt	$s0,$t1,min2
min2:
	move	$s0,$t1
	j	next
max:
	move	$s1,$t1
	j	next


