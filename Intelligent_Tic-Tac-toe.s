######################################################
#                                                    #
# Name: Assignment #6                                #
#                                                    #
# Description: Tic-tac-toe Game against the computer,#
#  it implements a basic game with wloops to detect  #
#  a win or loose state. It uses a MIN-Max Algoithm  #
#  in order to decide which position to take. Its a  #
#  simple recusive decition tree based on C++        #
#  pre based fucntions and then integrated into MIPS.#
#                                                    #
# Date: July 1th, 2020                               #
#                                                    #
# Author: Luciano Zavala IT Student                  #
######################################################

                .data
MSG1:           .asciiz "Welcome to the Tic Tac Toe Game\n\n"
MSG2:           .asciiz "Play in a cell by selecting the following cell number.\n\n"
PLAYERSIM:      .asciiz "\nYou will play as O.\n\n"
MSG3:           .asciiz "Choose a cell to play (1-9): "
row:		    .asciiz "\n------------------\n"
RowLine:	    .asciiz "\n------------------\n"
sep:		    .asciiz " | "
x:		        .asciiz "  X "
o:		        .asciiz "  O "
empty:		    .asciiz "    "
row1:		    .asciiz "  1  |  2  |  3  "
row2:		    .asciiz "  4  |  5  |  6  "
row3:		    .asciiz "  7  |  8  |  9  \n"
ComputerMove:   .asciiz "Computer's Turn.\n\n"
PlayerMove:	    .asciiz "It's your turn.\n"
cWin:		    .asciiz "Computer wins!\n"
pWin:		    .asciiz "Player wins.\n"
aTie:		    .asciiz "It was a tie.\n"
nlnl:		    .asciiz "\n\n"
nl:		        .asciiz "\n"
                .align  2
board:		    .word   0, 0, 0, 0, 0, 0, 0, 0, 0			                                            # Board's initial state
cBoard1:	    .space  36							                                                    # space for the copy of the board
win:		    .word   1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 4, 7, 2, 5, 8, 3, 6, 9, 1, 5, 9, 3, 5, 7		    # All winning combinations
cBoard2: 	    .space  36						                                                	    # space for the copy of the board
                .text
                .globl main

####################################################
##                   Main Routine                 ##
####################################################

main:
		li $v0, 4
        la $a0, MSG1
		syscall			    	# Welcome message
		
		li $v0, 4
		la $a0, MSG2
		syscall				    # Grid explanations
		
		li $v0, 4
		la $a0, row1            # Diplays the first row of the grid
		syscall
		
		li $v0, 4
		la $a0, RowLine         # Diplays row line
		syscall
		
		li $v0, 4
		la $a0, row2            # Displays the middle part of the board
		syscall
		
		li $v0, 4
		la $a0, RowLine         # Diplay the row line
		syscall	
		
		li $v0, 4
		la $a0, row3
		syscall				    # Display numbered board

		li $v0, 4
		la $a0, nl
		syscall

		addi $s4, $zero, 4		# Random number generation



########################################################
##           Dificulty assignation-medium             ##
########################################################


difficultyMedium:
		
		add $s5,$s5,5		    # Difficulty register set to 5

		li $v0, 4
		la $a0, PLAYERSIM
		syscall			     	# Display which letter user plays with
		
                                # Random number generation T1, T2 and T4
		addi $t1, $zero, 8
        addi $t4, $zero, 7
		addi $t2, $zero, 3
		
		add $t0, $zero, $s4
		
		mul $t0, $t0, $t1       # Multiply $t1
		add $t0, $t0, $t2       # Add $t2
		div $t0, $t4            # Divide $t4
		mfhi $t0			    # End the random number generation
		
		la $s0, board			# Load the  address of game board

		li $s1, 1			    # 1 = x

		li $s2, 2			    # 2 = o

		li $s3, 0			    # 0 = empy cell


#########################################################################################
##                               Game starts                                           ##
#########################################################################################

################################
##   Computer's first Move    ##
################################


FirstMove:
		
		mul $t0, $t0, 4			# Cell entries
		add $s0, $s0, $t0		# Move the pointer to computer's first move

		sw $s1, 0($s0)			# Place x in the chosen cell by the computer
		sub $s0, $s0, $t0		# Move the pointer to back of the start of board

		li $v0, 4
		la $a0, ComputerMove
		syscall				    # Display the message that it's computer's move,

		add $a0, $s0, $zero     
		jal displayBoard		# Display current state of board


#################################
##       Player's Turn         ##
#################################

NextMoves:

		li $v0, 4
		la $a0, PlayerMove
		syscall			    	# Display that it's the user's turn

userInput:

		li $v0, 4
		la $a0, MSG3
		syscall				    # Asks which cell player wants to play in

		li $v0, 5
		syscall			     	# read the input into the cell number

		add $t0, $v0, $zero		# Asign $t0
		add $t1, $v0, $zero     # Assgn #t1
		addi $t0, $t0 -1        # Iterate

		mul $t0, $t0, 4			# Cells are alligned into the word
		add $s0, $s0, $t0		# Moves $t0 into the chosen cell
		lw $s3, 0($s0)			# Loads the cell value
		sub $s0, $s0, $t0		# Returns pointer to the back of the cell
		

#####################################################
##                Input valiudation                ##
#####################################################

		bnez $s3, userInput     # If cell is not equal to zero
		blez $t1, userInput     # If input s less than zero
		bge $t1, 10, userInput  # branch if input is invalid


# If validation is passed:

Valid:

		add $s0, $s0, $t0		# Next move to the chosen cell
		sw $s2, 0($s0)			# Put O
		sub $s0, $s0, $t0		# Start the pointer back to the array
		
		li $v0, 4
		la $a0, nl
		syscall				    # New line

		add $a0, $s0, $zero     # Procedure to print the board
		jal displayBoard		# Display the state of the board
		
		add $a0, $s0, $zero
		jal gameOver            # Jump to Gameover if its over
		add $t0, $v0, $zero

#########################################
##          Winning Validation         ##
#########################################

		beq $t0, 10, IsWin      # Check if someone won
		beq $t0, -10, IsWin     # check if someone won
		beq $t0, 0, IsWin		# check if tie happened

Notfinished:

		add $a0, $s0, $zero
		add $a1, $zero, $zero
		jal max	                # Jump to minimax Function
		add $t0, $v0, $zero

		mul $t0, $t0, 4			# Cells become aligned
		add $s0, $s0, $t0		# Moves to the chosen cell
		sw $s1, 0($s0)			# place the O
		sub $s0, $s0, $t0		# take the pointer back to the beggining of the aray

ComputerTurn:

		li $v0, 4
		la $a0, ComputerMove
		syscall			    	# prints that it's the user's move
		
		add $a0, $s0, $zero
		jal displayBoard		# Jump to display the state of the board
		
		add $a0, $s0, $zero
		jal gameOver			# Checks if the game is over
		add $t0, $v0, $zero

#########################################
##          Winning Validation         ##
#########################################

		beq $t0, 10, IsWin      # check if the's a win
		beq $t0, -10, IsWin
		beq $t0, 0, IsWin		# If win or tie occured, branch
	
		j NextMoves			    # Bakc to the loop

IsWin:						    # Checks if an end-game state has occured, check for win or tie
		li $v0, 4
		la $a0, nl              # SPACE
		syscall
		
		bne $t0, 10, CompNotWin # Check if computer did not won
		li $v0, 4
		la $a0, cWin            # Load adress to computer wins
		syscall

CompNotWin:

		bne $t0, -10, NextTest	# Checks if user did not win
		li $v0, 4
		la $a0, pWin            # load adress to palyer wins
		syscall

NextTest:

		bne $t0, 0, exitG		# if it is not a tie, branch
		li $v0, 4
		la $a0, aTie            # load adress to tie
		syscall
exitG:
        jr  $ra


EndLoop:

		beq $t0, 9, doneClear	# Check if the board is clear for a new game
		sw $t1, 0($s0)			# save the empty cell value = 0
		addi $t0, $t0, 1	    # adds one to the counter ($t0)
		addi $s0, $s0, 4	    # move's the pointer to next element posible
		j EndLoop

doneClear:
		addi $s0, $s0, -36		# Rearrange pointer back to the beginning of the array
		addi $s4, $s4, 7		# Gets the random number assigned
		j difficultyMedium      # Jumps back to the difficulty assignation Algorithm

notAgain:	j exit				# Exit the game


############################################################################
##                                                                        ##
##                         Display Board Function                         ##
##                                                                        ##
############################################################################


displayBoard:
        add $t0, $a0, $zero              # Load thes address of board into $t0
        li $t1, 0                        # Starts the counter


###################################
##         Display Loop          ##
###################################

displayWhile:

        beq $t1, 9, disWhileDone         # While loop until there's no more possible moves
        
        lb $t2, 0($t0)                   # get the first entry in cell
         
        bne $t1, 3, FourthSpace          # brach if there is a vlaue in the fourth entry

        li $v0, 4
        la $a0, row
        syscall                          # Prints row seperation if at fourth entry

# Pass to the next row:

FourthSpace:

        bne $t1, 6, SeventhSpace         # Bracnh if there is a vlue in the seventh row

        li $v0, 4
        la $a0, row
        syscall                          # Display the row line seperation if it's at seventh entry

# Pass to next row:

SeventhSpace:

        bne $t1, 1, SecondSpace          # Branch if there is a vlue in the second space

        li $v0, 4
        la $a0, sep
        syscall                          # Display cell line seperation

# Pass to the first column:

SecondSpace:

        bne $t1, 2, ThirdSpace           # Branch if the is an element in the third space

        li $v0, 4
        la $a0, sep
        syscall                          # Display cell line seperation

# Pass to the second column:

ThirdSpace:

        bne $t1, 4, FifthSpace           # Branch if there is an element in the fifth space

        li $v0, 4
        la $a0, sep
        syscall                          # Display the cell seperation line

# pass to the first column:

FifthSpace:

        bne $t1, 5, SixthSpace           # Branch if there is an element in the sisth place

        li $v0, 4
        la $a0, sep
        syscall                          # Display cell seperation line

#pass to the second column:

SixthSpace:

        bne $t1, 7, EightSpace           # Branch if theres an element in the eight space

        li $v0, 4
        la $a0, sep
        syscall                          # Display cell line seperation

# Pass to the next column:

EightSpace:

        bne $t1, 8, NinthSpace           # Branch if theres is an element in the ninth space

        li $v0, 4
        la $a0, sep
        syscall                          # Display the cell seperation line

# Pass to the last column:

NinthSpace:

        bne $t2, 0, IsNotEmpty           # branch to check if cell is empty

        li $v0, 4
        la $a0, empty
        syscall                          #display empty cell

############################
##      Is not empty      ##
############################

IsNotEmpty:

        bne $t2, 1, IsNotX     # Check if is not X

        li $v0, 4
        la $a0, x
        syscall                # Display the X simbol if its not required an O

IsNotX:
        bne $t2, 2, IsNotO     # Check if its not O

        li $v0, 4
        la $a0, o
        syscall                # Display O symbol if its not requirted the X
IsNotO:
                                
        addi $t0, $t0, 4       # Moves the pointer to the next element in the board
        addi $t1, $t1, 1       # adds one to the counter ($t1 +1)

        j displayWhile         # Jumps back to the Board loop

disWhileDone:

        li $v0, 4
        la $a0, nlnl
        syscall                # prints a newline

        jr $ra                 # Jumps back to function



####################################################################################
##                                                                                ##
## Game Over State check Function:                                                ##
##  Checks if the game is under a state of  finished or not in order to continue  ##
##  the game loops.                                                               ##
##--------------------------------------------------------------------------------##
## Arguments:                                                                     ##
##  - $a0: Saves the adress of the board                                          ##
##  - $v0: Saves the number thatindicates the sate of the game                    ##
##                                                                                ##
####################################################################################

gameOver:

        la $t1, win               # Load address of the array that contains all winning states
        add $t2, $a0, $zero       # Load address of board into $t2 register
        li $t0, 0                 # Counter + 1

counterzero:

        li $t8, 0                 # Max X counter
        li $t9, 0                 # Max O counter

############################
##      Checks if win     ##
############################

WinTheGame:

        beq $t0, 8, noWin         # Checked for each state if the computer has won
        
        li $t5, 0                 # X counter = 0
        li $t6, 0                 # O counter = 0

#--------------------------------------------------------------------------------------

        lw $t3, 0($t1)            # Load the first winning position
        addi $t3, $t3, -1         # Decrement for the correct position in the array

        mul $t3, $t3, 4           # Numbers stored as a word  so it gets multiplied by 4 bytes
        add $t2, $t2, $t3         # Move pointer of board array to first win position
        
        lw $t4, 0($t2)            # Load the word stored in board
        sub $t2, $t2, $t3         # Moves the pointer back to first position (board Pointer)
        
        bne $t4, 1, IsXin1
        addi $t5, $t5, 1          # Check if found x

IsXin1:

        bne $t4, 2, IsInO1
        addi $t6, $t6, 1          # Check if found O

IsInO1:

#--------------------------------------------------------------------------------------

        lw $t3, 4($t1)            # Load the second winning position
        addi $t3, $t3, -1         # Decrement for position

        mul $t3, $t3, 4           # Numbers stored as word and multuplied by 4 bytes
        add $t2, $t2, $t3         # Move the pointer of the board array into the first winning position
        
        lw $t4, 0($t2)            # Load the word stored in board
        
        sub $t2, $t2, $t3         # Move  the pointer of board back
        bne $t4, 1, IsInX2
        addi $t5, $t5, 1          # Check if found X

IsInX2:

        bne $t4, 2, IsInO2
        addi $t6, $t6, 1          # Check if found O
IsInO2:

#--------------------------------------------------------------------------------------

        lw $t3, 8($t1)            # Load the next position from the word of winning positions
        addi $t3, $t3, -1         # Substract 1 to $t3 to get the array position
        mul $t3, $t3, 4           # multiply to get the position (multiply by 4 bytes)
        add $t2, $t2, $t3         # Move the pointer to $t2
        lw $t4, 0($t2)            # Load what is stored in the board
        
        sub $t2, $t2, $t3         # Move  the pointer of board back to first position
        bne $t4, 1, IsXin3        # check the move
        addi $t5, $t5, 1          # If X is found

IsXin3:

        bne $t4, 2, IsOin3
        addi $t6, $t6, 1          # If O is found

IsOin3:

        bne $t5, 3, XNotWon       # Check if O won
        li $v0, 10                # Returns 10 if x wins
        jr $ra

XNotWon:

        bne $t6, 3, ONotWon       # Checks if O won
        li $v0, -10               # Returns -10 if O wins
        jr $ra

ONotWon:
        
        add $t1, $t1, 12          # Move the pointer to next group of position wins
        addi $t0, $t0, 1          # Counter + 1
        
        j WinTheGame              #<---- Jump Out if the game is Won

noWin:
    
         li $t0, 0                # Counter = 0



####################################################
##              Check for a Tie                   ##
####################################################
        

Validation:

        beq $t0, 9, Tie           # Check if all spaces are full and what are the state of them
        lw $t3, 0($t2)            # Loads the word to get the element on the board
        beqz $t3, notTie          # Checks if its not a tie
        
        addi $t2, $t2, 4          # Moves the pointer to  the next posible element in  the array
        addi $t0, $t0, 1          # Counter + 1
        j Validation              # Jumps back to the Validation loop

# If its not a Tie:

notTie:

        la $t1, win               # Load the address of the array with winning states
        add $t2, $a0, $zero       # Load the  address of board stored in $t2
        li $t0, 0                 # Counter = 0
        li $s6, 0                 # Points Counter ($t6 = 0)
        li $s7, 0                 # Points counter ($t7 = 0)

LoopCheck:

        beq $t0, 8, DoneCheck     # if checked for each win state and none found
        li $t5, 0                 # x counter = 0
        li $t6, 0                 # o counter = 0

#-----------------------------------------------------------------------------------------

        lw $t3, 0($t1)            # Load word to get first win position
        addi $t3, $t3, -1         # Substract to get the correct position
        mul $t3, $t3, 4
        add $t2, $t2, $t3         # Moves the pointer o thef board array to first winning position
        lw $t4, 0($t2)            # Load value stored in board array
        
        sub $t2, $t2, $t3         # Move the pointer of the board to the first position
        bne $t4, 1, IsXin1Tie     # Checks if position is found
        addi $t5, $t5, 1          # X is found

IsXin1Tie:

        bne $t4, 2, IsOin1Tie
        addi $t6, $t6, 1          # O is found

IsOin1Tie:

#------------------------------------------------------------------------------------------

        lw $t3, 4($t1)            # Loads the adress of the word to get the second winning position
        addi $t3, $t3, -1         # Substarct to get the array position
        mul $t3, $t3, 4
        add $t2, $t2, $t3         # Moves the pointer of the board array to the first winning position
        lw $t4, 0($t2)            # Loads value stored in board
        
        sub $t2, $t2, $t3         # Move the pointer of the board back to the first position
        bne $t4, 1, IsXin2Tie     # Check if x is found
        addi $t5, $t5, 1          # add 1 to $t5 if x is found

IsXin2Tie:

        bne $t4, 2, IsOin2Tie
        addi $t6, $t6, 1          # ad 1 to $t7 if O is found

IsOin2Tie:

#--------------------------------------------------------------------------------------------

        lw $t3, 8($t1)            # Loads the wpord of the third winning position
        addi $t3, $t3, -1         # Substract to get the correct array position
        mul $t3, $t3, 4
        add $t2, $t2, $t3         # Moves the pointer of the board to the first winning position
        lw $t4, 0($t2)            # Loads the value stored in board
         
        sub $t2, $t2, $t3         # Moves the  pointer of the board
        bne $t4, 1, IsXin3Tie
        addi $t5, $t5, 1          # X is found and 1 is added to $t5

IsXin3Tie:

        bne $t4, 2, IsOin3Tie
        addi $t6, $t6, 1          # O is found and 1 is added to $t6

IsOin3Tie:

        mul $t8, $t5, $t6         # Multiply both conters and store them in $t8
        add $t9, $t5, $t6         # adds both counters together into $t9


#######################################
##      Final Tie Check Procedure    ##
#######################################

CheckProc:

        bnez $t8, ProductDiff0
        bne $t9, 2, SumIsNot2         # Checks if the product is  = to 0 and sum is  = 2
        bne $t5, 2, IsNot2inX         # Checks if there are 2 x's in a row with no O's
        addi $v0, $zero, 7            # Return 7 as a value
        jr $ra

#------------------------------------
IsNot2inX:

        bne $t6, 2, SumIsNot2         # Check if there are 2 O's in a row with no x
        addi $v0, $zero, -9           # if passes the validation returns -9
        jr $ra

#------------------------------------
SumIsNot2:

        bne $t9, 1, ProductDiff0
        bne $t5, 1, IsNot1inX         # Check if there is alone x in any row or columns and if its the case store the possible return value
        addi $s6, $zero, 5
        j ProductDiff0

#------------------------------------
IsNot1inX:

        bne $t6, 1, ProductDiff0      # Checksif there is one alone o in row  or columns
        addi $s6, $zero, -5

#------------------------------------
ProductDiff0:

        bne $t8, 1, ProductDiff1       # Checkif there is one x and one o in rows or columns
        addi $s7, $zero, 1

#-------------------------------------
ProductDiff1:

        bne $t9, 3, SumIsNot3          #if row is filled in R or C, store possible return value
        addi $s7, $zero, 1

#-------------------------------------
SumIsNot3:
                                                                    
        add $t1, $t1, 12               # gets the pointer to the next triple of winning positions
        addi $t0, $t0, 1               # Counter + 1
        
        j LoopCheck

####################################################
##              Done Check Statement              ##
####################################################

DoneCheck:

        beqz $s6, lowP                 # Checks if higher points situation found and return that.
        add $v0, $zero, $s6
        jr $ra
lowP:
        add $v0, $zero, $s7            # adds the lower point regiter to printing
        jr $ra

#########################################
##       Tie or Not Tie Response       ##
#########################################

Tie:
        li $v0, 0                       #return 0 if there is a tie
        jr $ra


##################################################################################
##                                                                              ##
##                                                                              ##
## MINI-MAX Algorithm:                                                          ##
##  The Algorithm is based on a recursive three that generates psoibilities     ##
##  for game moves. To do so, we can just choose the node with best evaluation  ##
##  score. To make the process smarter, we also look a little ahead and evaluate##
##  potential opponent's moves.                                                 ##
##------------------------------------------------------------------------------##
## Arguments:                                                                   ##
##   $s0: As the adress of the board                                            ##
##   $a1: As the depth of the chances                                           ##
##   $v0: Gets the best position to play                                        ##
##################################################################################

#################################################################################################################
## Resources for the bulding of the code in MIPS and C++ code examples from:                                   ##
##                                                                                                             ##
##    - https://towardsdatascience.com/tic-tac-toe-creating-unbeatable-ai-with-minimax-algorithm-8af9e52c1e7d  ##
##    - https://www.geeksforgeeks.org/minimax-algorithm-in-game-theory-set-1-introduction/                     ##
##    - https://github.com/Jhertz2/MIPS_Algorithims/blob/master/MinMaxMedianMode.asm                           ##
##-------------------------------------------------------------------------------------------------------------##
## A Compiler translator was used to test functions built in C++ and then help to re arange them in MIPS:      ##
##  (Just for the MIn-Max Algorithm)                                                                           ##
##                                                                                                             ##
##    - https://godbolt.org/z/RQC8rbj                                                                          ##
##                                                                                                             ##
#################################################################################################################



max:
		add $t0, $a0, $zero		# Loads the address of the array into $t0
		add $t1, $a1, $zero		#load depth into $t1


############################################################
##                                                        ##
## In order to acomplish this we load the values          ##
##  to get a posible chance.  For this we create an stack ##
##  and geenrate values to then de alocate the memory.    ##
############################################################
		
		addi $sp, $sp, -44		# Allocates space on the new stack (list)

		sw $t0, 0($sp)          # $t0 = 0
		sw $t1, 4($sp)          # $t1 = 4
		sw $t2, 8($sp)          # $t2 = 8
		sw $t3, 12($sp)         # $t3 = 12

		sw $t4, 16($sp)         # $t4 = 16
		sw $t5, 20($sp)         # $t5 = 20
		sw $t6, 24($sp)         # $t6 = 24

		sw $t7, 28($sp)         # $t7 = 28
		sw $t8, 32($sp)         # $t8 = 32
		sw $t9, 36($sp)         # $t9 = 36

Pback:

		sw $ra, 40($sp)			# Push al the elements
        jal gameOver			# Check if game is over with the function gameOver
		
		lw $ra, 40($sp)         # Pop all elements
		lw $t9, 36($sp)
		lw $t8, 32($sp)

		lw $t7, 28($sp)
		lw $t6, 24($sp)
		lw $t5, 20($sp)         #<---- Deallocation of elements
		lw $t4, 16($sp)
		lw $t3, 12($sp)

		lw $t2, 8($sp)
		lw $t1, 4($sp)
		lw $t0, 0($sp)

DeAllocate:

		addi $sp, $sp, 44		# De-allocate memory on the stack
		add $t2, $v0, $zero		# Put the returned value into $t2. This represents the win/loss state
		abs $t3, $t2			# Takes the  absolute value of the returned value. this sis done for easier comparison purposes
		
		beq $t3, 10, over       # Branch if its over
		beq $t3, 0, over        # Branch if its not over
		bgt $t1, $s5, over		# Cehcks if  the game is over or the depth is larger than max depth
		j notOver

######################################################
##      Check if max conter is yet done             ##
######################################################

over:

        add $v0, $t2, $zero         # Returns win/loss state
        jr $ra

######################################################
##      Check if max conter is not yet done         ##
######################################################

notOver:

		addi $t3, $zero, -20		# Checks max = -infinity
		add $t4, $zero, $zero		# initialize the coeunter counter



###########################################
#  For loop starts to load all the board  #
###########################################

CopyforLoop:

		beq $t4, 9, EndForLoop  # Check if the loop is over  $t4 = 9
		lw $t5, 0($t0)			# Loads word to get an  element from the board
		bne $t5, 0, endIf		# checks if cell is not empty
		la $t5, cBoard1			# Loads adress to get array space for copied array
Init:
		add $t6, $zero, $zero   # Initialize  the counter $t6 = zero
		mul $t7, $t4, 4			
		sub $t0, $t0, $t7		# Moves the pointer to begining of array ($t0)


#############################################
##         Copy the array sub-routine      ##
#############################################

copy:

		beq $t6, 9, copied		# Loop for copying the board

		lw $t7, 0($t0)			# Load the word element from board
		sw $t7, 0($t5)			# Copy the element to the board

		addi $t0, $t0, 4		# moves the pointer into next element
		addi $t5, $t5, 4		# Copies the array
		addi $t6, $t6, 1		# Add one to the counter
        
		j copy                  # If its not still fully copied jump back


# Array is already copied:

copied:

		addi $t0, $t0, -36
		addi $t5, $t5, -36		# Move the pointers to begining of both of the arrays

#------------------------------------------------------------------------------------

        mul $t7, $t4, 4
		add $t0, $t0, $t7		# Moves the pointer back to the first position
		add $t5, $t5, $t7		# Moves the pointer to the position taht is relative
putS:
		sw $s1, 0($t5)			# Puts X in that position
		sub $t5, $t5, $t7		# Returnt he pointer to position

#------------------------------------------------------------------------------------

		addi $sp, $sp, -80
		add $t6, $zero, $zero	# Starts the counter to zero
		mul $t7, $t4, 4			# Multiply to get the adress by 4 bytes
		sub $t0, $t0, $t7		# Move pointer of $t0 to begining of array


##########################################
##       Push Method for the Stack      ##
##########################################


Push:
		beq $t6, 9, Pushed		# Push the board onto the stack
		lw $t7, 0($t0)			# Loads the adress of element from the board
		sw $t7, 0($sp)			# Push the  element on the stack
pS:
		addi $t0, $t0, 4		# Moves the pointer to the next element
		addi $sp, $sp, 4		# push array on stack
		addi $t6, $t6, 1		# Counter + 1
		j Push                  # Loop again

# If its already Pushed:

Pushed:
		addi $t0, $t0, -36
		addi $sp, $sp, -36		# Move the pointers to the beginings of the array
		mul $t7, $t4, 4
		add $t0, $t0, $t7		# Moves back to original position


#-----------------------------------------------------------------------------------
loadElements:

		sw $t0, 36($sp)         # $t0 = 36
		sw $t1, 40($sp)         # $t1 = 40
		sw $t2, 44($sp)         # $t2 = 44
		sw $t3, 48($sp)         # $t3 = 48

		sw $t4, 52($sp)         # $t4 = 52
		sw $t5, 56($sp)         # $t5 = 56
		sw $t6, 60($sp)         # $t6 = 60
		sw $t7, 64($sp)         # $t7 = 64

		sw $t8, 68($sp)         # $t8 = 68
		sw $t9, 72($sp)         # $t9 = 72

		sw $ra, 76($sp)			# Push all the elements

# Once elements are checked if pushed:

PassArgs:

		add $a0, $t5, $zero
		addi $a1, $t1, 1		# Pass the arguments adding $t1 + 1
		jal min				    # Calls the next min fucntion

# Re loacate the elements loading the words:

LocateElements:

		lw $ra, 76($sp)
		lw $t9, 72($sp)
		lw $t8, 68($sp)
		lw $t7, 64($sp)

		lw $t6, 60($sp)
		lw $t5, 56($sp)         #<---- Deallocation of elements
		lw $t4, 52($sp)
		lw $t3, 48($sp)

		lw $t2, 44($sp)
		lw $t1, 40($sp)
		lw $t0, 36($sp)


#------------------------------------------------------------------------------------

InitMove:

		addi $t6, $zero, 9		# Counter = 0
		mul $t7, $t4, 4

reloc:
		sub $t0, $t0, $t7		# Move  the pointer located in $t0 to begining of  the array  bys subtracting

		addi $t0, $t0, 32
		addi $sp, $sp, 32       # Relocate the values


###################################################################
##                 Pop method from the Stack                     ##
###################################################################


PopMn:
		beq $t6, 0, PoppedMn    # Pop the elements using a for loop
		lw $t7, 0($sp)			# Load the word form the stack (pop)
		sw $t7, 0($t0)			# Alocate it into the board

mvptr:
		addi $t0, $t0 -4		# Moves the pointer one step back
		addi $sp, $sp -4		# Push  the array on the stack
		addi $t6, $t6, -1		# Counter - 1
		j PopMn                 # Back to the loop

#----------------------------------------------------------------------------

PoppedMn:

		addi $t0, $t0, 4
		addi $sp, $sp, 4		        # Relocate the pointer

mvptrbk:
		mul $t7, $t4, 4
		add $t0, $t0, $t7		        # gets the pointer to the original position
		addi $sp, $sp, 80		        # De-allocate the elements on the stack
		
		add $t6, $v0, $zero		        # gets the returned value sinto $t6

##############################################
##               validation !>              ##
##############################################

checkVerf:

		ble $t6, $t3, IsNotGreater    	# if (x > max)

		add $t3, $t6, $zero		        # max = x
		add $t8, $t4, $zero		        # maxMove = i

IsNotGreater:

endIf:	
		addi $t0, $t0, 4		        # Moves the pointer to the next element
		addi $t4, $t4, 1		        # Counter + 1
		
		j CopyforLoop                   # BAkc to Copyforloop

#-------------------------------------------------------------------------------

EndForLoop:

		beqz $t1, Resp0			# check if depth != 0
		add $v0, $t3, $zero
		jr $ra                  # Jump bakc and end


####################################################
##                Min sub Routine                 ##
####################################################


min:
        add $t0, $a0, $zero     # Loads the address of the array into $t0
        add $t1, $a1, $zero     # Loads the depth in $t1

        addi $sp, $sp, -44      # allocate space on stack
        sw $t0, 0($sp)          # $t0 = 0
        sw $t1, 4($sp)          # $t1 = 4
        sw $t2, 8($sp)          # $t2 = 8

        sw $t3, 12($sp)         # $t3 = 12
        sw $t4, 16($sp)         # $t4 = 16
        sw $t5, 20($sp)         # $t5 = 20
        sw $t6, 24($sp)         # $t6 = 24

        sw $t7, 28($sp)         # $t7 =28
        sw $t8, 32($sp)         # $t8 = 32
        sw $t9, 36($sp)         # $t9 = 36

        sw $ra, 40($sp)         # push all the elements
        
        jal gameOver            # jumps to game over if it is over


######################################################
##            Relocate min subroutine               ##
######################################################
		

		lw $ra, 40($sp)
		lw $t9, 36($sp)
		lw $t8, 32($sp)
		lw $t7, 28($sp)

		lw $t6, 24($sp)
		lw $t5, 20($sp)
		lw $t4, 16($sp)         #<----- de-allocate
		lw $t3, 12($sp)

		lw $t2, 8($sp)
		lw $t1, 4($sp)
		lw $t0, 0($sp)

		addi $sp, $sp, 44		# de-allocate memory on the stack

returnVal:

		add $t2, $v0, $zero		# Put the return state into $t2
		abs $t3, $t2			# Takes the absolute value in $t3

###################################
##        Over validation        ##
###################################

		beq $t3, 10, IsMinOver
		beq $t3, 0, IsMinOver

passT:
		bgt $t1, $s5, MinNover	# Checks if game is over or $t1 is larger than $s5
		j MinNover


IsMinOver:
		add $v0, $t2, $zero		#return win/loss state
		jr $ra


MinNover:

		addi $t3, $zero, 0		# $t3 = infinity
		add $t4, $zero, $zero	# Counter = 0


forLoopMin:

		beq $t4, 9, EMinLoop	# Loops start to chek if minis over
		lw $t5, 0($t0)			# Loads the element element from the board
        bne $t5, 0, endIfMin	# Check if element = 0
		
		la $t5, cBoard2			# Array space for copying purpusses
		add $t6, $zero, $zero   # Counter = 0

mvptr3:

		mul $t7, $t4, 4			
		sub $t0, $t0, $t7		# Moves the pointer of $t0 to the begining of the array


#########################################
##      Copy method from the stack     ##
#########################################


CopyMinAlg:

		beq $t6, 9, CopiedAlgMin# Loops in order to copy the board
		lw $t7, 0($t0)			# gets an element from the board
		sw $t7, 0($t5)

mvptr4:

		addi $t0, $t0, 4		# Moves the pointer to the next element
		addi $t5, $t5, 4		# Copies the array
		addi $t6, $t6, 1		# Counter + 1
		j CopyMinAlg            # Jump back to loop

CopiedAlgMin:

		addi $t0, $t0, -36
		addi $t5, $t5, -36		# Move the pointers into the begining of arrays

# Move the array:

ARRmv:
		mul $t7, $t4,4
		add $t0, $t0, $t7		# Move the pointer back to the original position
		
		add $t5, $t5, $t7		# Moves the pointer to the position i
		sw $s2, 0($t5)			# Moves O to that position
		sub $t5, $t5, $t7		# Substract to get the pointer aligned
		
		addi $sp, $sp, -80
		add $t6, $zero, $zero	# Counter = 0
		mul $t7, $t4, 4			
		sub $t0, $t0, $t7		# Moves the pointer tot the beggining


###########################################
##       Pushing method for min          ##
###########################################

PushMStack:

		beq $t6, 9, PdMin	    # Loop until the board is pushed on to the stack
		lw $t7, 0($t0)			# Gets the element from the board

PE:
		sw $t7, 0($sp)			# push element onto stack
		addi $t0, $t0, 4		# Move pointer to the next element
		addi $sp, $sp 4			# Push array
		addi $t6, $t6, 1		# Counter + 1

		j PushMStack            # back to the loop


##############################################
##              Once Puched:                ##
##############################################


PdMin:
		addi $t0, $t0, -36
		addi $sp, $sp, -36		#move pointers to beginings of arrays

mvptr5:
		mul $t7, $t4, 4
		add $t0, $t0, $t7		#move pointer back to original position
		
		sw $t0, 36($sp)
		sw $t1, 40($sp)
		sw $t2, 44($sp)
		sw $t3, 48($sp)

		sw $t4, 52($sp)         #<--- Push elements to stack
		sw $t5, 56($sp)
		sw $t6, 60($sp)
		sw $t7, 64($sp)

		sw $t8, 68($sp)
		sw $t9, 72($sp)

		sw $ra, 76($sp)			# Push the elements
		
		add $a0, $t5, $zero
		addi $a1, $t1, 1		# Pass the arguments to the fucntion

# Subroutine calling:

		jal max				    # call the subroutine function
		
		lw $ra, 76($sp)
		lw $t9, 72($sp)
		lw $t8, 68($sp)
		lw $t7, 64($sp)
		lw $t6, 60($sp)
		lw $t5, 56($sp)         #<-------- De-allocate elements
		lw $t4, 52($sp)
		lw $t3, 48($sp)
		lw $t2, 44($sp)
		lw $t1, 40($sp)
		lw $t0, 36($sp)

initRou:

		addi $t6, $zero, 9		# Counter = 0
		mul $t7, $t4, 4

		sub $t0, $t0, $t7		# Moves the pointer of $t0 to the begining of the array
		addi $t0, $t0, 32
		addi $sp, $sp, 32


################################################
##          Pop Method for the Stack          ##
################################################

POPM:
		beq $t6, 0, PopdMin		# Loop in order to pop the board off of stack
		lw $t7, 0($sp)			# Pop element by element off of stack
		sw $t7, 0($t0)			# Place element
		addi $t0, $t0, -4		# Move the  pointer back
		addi $sp, $sp, -4		# Push the array on stack
		addi $t6, $t6, -1		# Counter - 1
		j POPM                  # Back to loop

# Once is popped:

PopdMin:
		addi $t0, $t0, 4
		addi $sp, $sp, 4		
		mul $t7, $t4, 4
		add $t0, $t0, $t7		# Moves the pointer back to the original position

# deallocate the stack:

deloc:
		addi $sp, $sp, 80		# De-allocates the stack
		add $t6, $v0, $zero		# put returned in $t6
		
		bge $t6, $t3, IsNotLessMin   # Check if x < min
		add $t3, $t6, $zero		# min = x

###########################
##  Not less validation  ##
###########################

IsNotLessMin:

# En if it les tha min:

endIfMin:
		addi $t0, $t0, 4		#move pointer to next element
		addi $t4, $t4, 1		#increment counter
		
		j forLoopMin

#-------------------------------------------------

EMinLoop:

		add $v0, $t3, $zero		#return min
		jr $ra

#-------------------------------------------------

Resp0:
        add $v0, $t8, $zero     # Check if depth is 0, return best move
        jr $ra

################################
Exit:                          #
        nop                    #<-- Exits the Printing Function
################################





