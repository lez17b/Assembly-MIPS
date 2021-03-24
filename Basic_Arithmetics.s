###################################################

#                                                                                                                                   #
#     Name: Luciano Zavala                                                                                                          #

#     Class: CDA 3100                                                                                                               #

#     Assignment:  #4 Read in two numbers  and find                                                                                 #

#      the sum, difference, product,                                                                                                #

#      and the quotient/remainder.                                                                                                  #

#                                                                                                                                   #

#####################################################
	.data
MSG1:	.asciiz		"Luciano Zavala, IT Student\n"
MSG2:	.asciiz		"Add, Subtract, Multiply and Divide two numbers\n"
MSG3:	.asciiz		"Enter the first number: "
MSG4:	.asciiz		"Enter the second number: "
MSG5:	.asciiz		"The program has stopped.. may the force be with you."
MSG6:	.asciiz		"*** Warning Will Robinson…The number is below 1. ***"
SP:	.byte		' '
SUM:	.byte		'+'
SUB:	.byte		'-'
EQUAL:	.byte		'='
DIV:	.byte		'/'
MULT:	.byte		'*'
SPACE:	.asciiz		"\n"
REM:	.ascii		" rem " 
	.text
	.globl	main
main:	li	$v0,4		#Tells syscall to print a string
	la	$a0,MSG1	#Gives the adress to the string
	syscall
	
	#Prints an space
	li      $v0,4
        la      $a0,SPACE
        syscall

	li	$v0,4		#Tells syscall to print a string
	la	$a0,MSG2	#Gives the adress to the string
	syscall
	
	#Prints space
	li      $v0,4
        la      $a0,SPACE
        syscall

	li	$v0,4		#Tells syscall to print a string
	la	$a0,MSG3	#Gives the adress to the string
	syscall
	li	$v0,5		#Tells the syscall to read an integer
	syscall
	move	$t0,$v0		#saves the integer
	blt	$t0,1,BADN	#Logic test to determine if its less than 1
	
	#Prints space
	li      $v0,4
        la      $a0,SPACE
        syscall

	li	$v0,4		#Tells syscall to print a string
	la	$a0,MSG4	#Gives the adress to the string
	syscall
	li	$v0,5		#Tells the syscall to read an integer
	syscall
	move	$t1,$v0		#Saves the integer in a temporary slot
	blt	$t1,1,BADN	#logic test to determine if its less than 1
	
	#Prints space
	li      $v0,4
        la      $a0,SPACE
        syscall
	
	add	$t3,$t0,$t1	#Performs addition
	sub	$t2,$t0,$t1	#Perfroms Substraction
	mul	$t4,$t0,$t1
	

	li	$v0,1		#Tells syscall to print an integer
	move	$a0,$t0
	syscall
	
	li	$v0,11
	lb	$a0,SP
	syscall
	
	li	$v0,11		#Tell syscall to print the byte
	lb	$a0,SUM
	syscall

	li      $v0,11
        lb      $a0,SP
        syscall

	li	$v0,1		#Tells the syscall to print an integer
	move	$a0,$t1
	syscall
	
	li	$v0,11		#Tells syscall to print a byte
	lb	$a0,EQUAL
	syscall

	li	$v0,1		#Tells syscall to print  an Integer
	move	$a0,$t3
	syscall
	
	#Prints space
	li	$v0,4
	la	$a0,SPACE
	syscall
	li      $v0,4
        la      $a0,SPACE
        syscall


	li      $v0,1           #Tells syscall to print an integer
        move    $a0,$t0
        syscall

	li    	$v0,11
        lb    	$a0,SP
        syscall

        li      $v0,11          #Tell syscall to print the byte
        lb      $a0,SUB
        syscall

	li      $v0,11
        lb    	$a0,SP
        syscall

        li      $v0,1           #Tells the syscall to print an integer
        move    $a0,$t1
        syscall

        li      $v0,11          #Tells syscall to print a byte
        lb      $a0,EQUAL
        syscall

        li      $v0,1           #Tells syscall to print  an Integer
        move    $a0,$t2
        syscall

	#Prints space
        li      $v0,4
        la      $a0,SPACE
        syscall
	li      $v0,4
        la      $a0,SPACE
        syscall

	li      $v0,1           #Tells syscall to print an integer
        move    $a0,$t0
        syscall

	li      $v0,11
        lb      $a0,SP
        syscall

        li      $v0,11          #Tell syscall to print the byte
        lb      $a0,MULT
        syscall

	li      $v0,11
        lb      $a0,SP
        syscall

        li      $v0,1           #Tells the syscall to print an integer
        move    $a0,$t1
        syscall

        li      $v0,11          #Tells syscall to print a byte
        lb      $a0,EQUAL
        syscall

        li      $v0,1           #Tells syscall to print  an Integer
        move	$a0,$t4
	syscall

	#Prints space
        li      $v0,4
        la      $a0,SPACE
        syscall
	li      $v0,4
        la      $a0,SPACE
        syscall

	div     $t0,$t1	

	li      $v0,1           #Tells syscall to print an integer
        move    $a0,$t0
        syscall
	
	li      $v0,11
        lb      $a0,SP
        syscall

        li      $v0,11          #Tell syscall to print the byte
        lb      $a0,DIV
        syscall
	
	li      $v0,11
        lb      $a0,SP
        syscall

        li      $v0,1           #Tells the syscall to print an integer
        move    $a0,$t1
        syscall

        li      $v0,11          #Tells syscall to print a byte
        lb      $a0,EQUAL
        syscall

        li      $v0,1           #Tells syscall to print  an Integer
        mflo    $a0
        syscall

	li	$v0,4		#Tells syscall to print an integer
	la	$a0,REM
	syscall

	li	$v0,1		#Print the answer of the division
	mfhi	$a0
	syscall

	#Prints space
        li      $v0,4
        la      $a0,SPACE
        syscall
	li      $v0,4
        la      $a0,SPACE
        syscall

	li	$v0,4		#Prints The goodbye message
	la	$a0,MSG5
	syscall
	
	jr	$ra

BADN:				#Function to come when values are less than 1
	li	$v0,4
	la	$a0,SPACE
	syscall

	li	$v0,4		#Error message
	la	$a0,MSG6
	syscall
	
	jr	$ra
