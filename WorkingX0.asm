# Tic?Tac?Toe Game FINAL PROJECT - using the MARS MIPS assembler 
# Author1: 	Christopher McGill 	100745212	
# Author2: 	Franklin Muhuni 	100744901	
# Author3: 	Shriji Shah 		100665031	shriji.shah@ontariotechu.net
# Date:		Winter 2020
# University:	University of Ontario Institute of Technology
# Course:	Computer Architecture INFR 2810U


.data 

pos:		.word 0:10
used:		.word 0:10
dash: 		.asciiz " - "
x:		.asciiz " X "
o: 		.asciiz " O "
nl:		.asciiz "\n"
player1: 	.asciiz "\nPlayer 1, please enter your move (1 - 9): "
player2:	.asciiz"\nPlayer 2, please enter your move (1 - 9): "
option1: 	.asciiz "\nPlayer 1, do you want to be X (1) or O(0)?: "
usedPos:	.asciiz "\nThat position has already been played, please choose another."
oWin: 		.asciiz "\nO WINS!"
xWinL: 		.asciiz "\nX WINS!"
draw: 		.asciiz "\nDraw game, play again? (1) YES (0) NO: "

.text

main:
	li $t0, 0 #iterator
	li $t1, 36 #constant
	li $t2, 9 #turn counter
	li $t5, 2
	li $t9, 0 #reset thing
	
	##########################
	###### Internal Grid #####
	##########################
	#######  4   8  12 #######
	####### 16  20  24 #######
	####### 28  32  36 #######
	##########################
	
	##########################
	###### Default Grid ######
	##########################
	######## -  -  - #########
	######## -  -  - #########
	######## -  -  - #########
	##########################
	
	##########################
	####### Input Grid #######
	##########################
	#######  1   2   3 #######
	#######  4   5   6 #######
	#######  7   8   9 #######
	##########################
	
	
loop:
	beq $t0, $t1, loopend

	add $t0, $t0, 4
	
	lw $t3, pos($t0)
	
	beq $t3, 0, dashP
	beq $t3, 1, xP
	beq $t3, 4, oP
	
	beq $t2, 0, drawP
	
	j loopend




dashP:
	la $a0, dash
	li $v0, 4
	syscall 
	
	beq $t0, 12, nlP
	beq $t0, 24, nlP
	beq $t0, 36, nlP
	
	j loop

nlP:
	la $a0, nl
	li $v0, 4
	syscall
	
	j loop

xP:
	la $a0, x
	li $v0, 4
	syscall
	
	beq $t0, 12, nlP
	beq $t0, 24, nlP
	beq $t0, 36, nlP
	
	j loop

oP:
	la $a0, o
	li $v0, 4
	syscall
	
	beq $t0, 12, nlP
	beq $t0, 24, nlP
	beq $t0, 36, nlP
	
	j loop

loopend:
	beq $t2, 0, drawP
	
	beq $t5, 2, player1M
	beq $t5, 1, player2M
	
	
	j player1M

player1M:
	li $t0, 1
	li $s5, 1
	la $a0,player1
	li $v0,4
	syscall

	li $v0,5
	syscall
	
	mul $t7, $v0, 4
	mflo $t7
	
	lw $s6, used($t7)
	
	beq $s6, $s5, usedSpotP1
	
	sw $s5, used($t7)

	sw $t0, pos($t7)
	li $t0, 0
	
	add $t5, $t5, -1
	
	add $t2, $t2, -1

	jal TopWin
	jal MidRowWin
	jal BotWin
	jal LeftWin
	jal MidColumnWin
	jal RightWin
	jal DiagWin1
	jal DiagWin2
	j loop
	
usedSpotP1:
	la $a0, usedPos
	li $v0, 4
	syscall
	
	j player1M
	
player2M:
	li $t0, 4
	li $s5, 1
	la $a0,player2
	li $v0,4
	syscall

	li $v0,5
	syscall
	
	mul $t7, $v0, 4
	mflo $t7
	
	lw $s6, used($t7)
	beq $s6, $s5, usedSpotP2
	sw $s5, used($t7)

	sw $t0, pos($t7)
	li $t0, 0
	
	add $t5, $t5, 1
	
	add $t2, $t2, -1
	

	jal TopWin
	jal MidRowWin
	jal BotWin
	jal LeftWin
	jal MidColumnWin
	jal RightWin
	jal DiagWin1
	jal DiagWin2
	j loop

usedSpotP2:
	la $a0, usedPos
	li $v0, 4
	syscall
	
	j player2M

drawP:
	la $a0, draw
	li $v0, 4
	syscall 
	
	li $v0, 5
	syscall
	
	beq $v0, 1, clmain
	beq $v0, 0, end
	
#######################################################################	
clmain:   # CHANGE TEH FUCK OUT OF THE THIS
	la $a0, pos
   	add $a2, $zero, $zero
loop2:   
	slti $t1, $a2, 10
  	 beq $t1, $zero, main
loop4:   
	lw $a1, 0($a0)
   	addi $a2, $a2, 1   #Counter for clearing data.
   	add $a1, $zero, $zero
  	 sw $a1, 0($a0)
   	addi $a0, $a0, 4   #Move to the next address.
   
   	j loop2
########################################################################	

# win1 used to determine X wins	
win1:  
   	la $a0, xWinL
	li $v0, 4
	syscall
	j end

# win2 used to determine O wins	
win2:   
	la $a0, oWin
	li $v0, 4
	syscall
	j end


TopWin:   
	#####################
	####### 1 1 1 #######
	####### 0 0 0 #######
	####### 0 0 0 #######
	#####################

	
   	# each X value is counted as 1 and each O value counts as 4	
	# checks top row for win condition
	la $a0, pos
	lw $s1, 4($a0)   
	lw $s2, 8($a0)
	lw $s3, 12($a0)
   
   	# adding each value of the speficed win condition
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   	
   	
   	# if $s4 adds to 3, it means 3 Xs
	beq $s4, 3, win1
   	# if $s4 adds to 12, it means 3 Os
	beq $s4, 12, win2
	
	jr  $ra
MidRowWin:   
	#####################
	####### 0 0 0 #######
	####### 1 1 1 #######
	####### 0 0 0 #######
	#####################

	la $a0, pos
	lw $s1, 16($a0)   
	lw $s2, 20($a0)
	lw $s3, 24($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
BotWin:   
	#####################
	####### 0 0 0 #######
	####### 0 0 0 #######	
	####### 1 1 1 #######
	#####################

	la $a0, pos
	lw $s1, 28($a0)  
	lw $s2, 32($a0)
	lw $s3, 36($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
LeftWin:   
	#####################
	####### 1 0 0 #######
	####### 1 0 0 #######
	####### 1 0 0 #######
	#####################

	la $a0, pos
	lw $s1, 4($a0)  
	lw $s2, 16($a0)
	lw $s3, 28($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
MidColumnWin:   
	#####################
	####### 0 1 0 #######
	####### 0 1 0 #######
	####### 0 1 0 #######
	#####################

	la $a0, pos
	lw $s1, 8($a0)  
	lw $s2, 20($a0)
	lw $s3, 32($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
RightWin:   
	#####################
	####### 0 0 1 #######
	####### 0 0 1 #######
	####### 0 0 1 #######
	#####################

	la $a0, pos
	lw $s1, 12($a0)  
	lw $s2, 24($a0)
	lw $s3, 36($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
DiagWin1:  
	#####################
	####### 0 0 1 #######
	####### 0 1 0 #######
	####### 1 0 0 #######
	#####################


	la $a0, pos
	lw $s1, 4($a0)  
	lw $s2, 20($a0)
	lw $s3, 36($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
DiagWin2:   
	#####################
	####### 1 0 0 #######
	####### 0 1 0 #######
	####### 0 0 1 #######
	#####################
	
	la $a0, pos
	lw $s1, 12($a0)   
	lw $s2, 20($a0)
	lw $s3, 28($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
end:
	nop