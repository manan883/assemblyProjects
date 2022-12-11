.data
welcome: .asciiz "Welcome to mips hangman! Try to guess the word within 15 guesses\nTo procede choose one of the options\n(1)New Game\n(2)Exit"
word1: .asciiz "button"
word2: .asciiz "pocket"
word3: .asciiz "smooth"
word4: .asciiz "fought"
word5: .asciiz "planet"
listWords: .word word1 word2 word3 word4 word5
default: .asciiz "      "
savedWord: .asciiz "      "
errorMSG: .asciiz "INVALID INPUT"
current: .asciiz "Current correct guesses are: "
.text
################ reg's to what place, $s1 is the current user guess t2 is counter, t3 is 5
# macros
#this macro randomizes an int and chooses the word based on the int. to randomize an int you need to generate the seed first which is done using syscall 30 and 40
.macro randomize()
				# get the time
	li	$v0, 30		# get time in milliseconds (as a 64-bit value), mars syscall
	syscall

	move	$t0, $a0	# save the lower 32-bits of time
	li	$a0, 1		# random generator id (will be used later)
	move 	$a1, $t0	# seed from time
	li	$v0, 40		# seed random number generator syscall
	syscall
	li	$a0, 1		# as said, this id is the same as random generator id
	li	$a1, 6		# upper bound of the range
	li	$v0, 42		# random int range
	syscall
	#choose the word by doing int*4 and lw the list of words
	la $t0,listWords
	mul $a0,$a0,4
	move $t1,$a0
	add $t0,$t0,$t1
	lw $s5,0($t0)
	move $a0,$s5
	li $v0,4
	syscall
.end_macro
#intro message and grab input from the user on what they want to do
.macro introMsg()
	la $a0, welcome
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t0,$v0
.end_macro
#take in an argument and print the statement you have x guesses left
.macro printAmountGuesses(%guess)
	.data
	msg1: .asciiz "\nYou have "
	msg2: .asciiz " guesses left"
	.text
	la $a0,msg1
	li $v0,4
	syscall
	move $a0 %guess
	li $v0,1
	syscall	
	la $a0,msg2
	li $v0,4
	syscall
	la $a0,'\n'
	li $v0,11
	syscall
.end_macro
#this grab the user input for the guess, it will read in an char and save it to s1
.macro enterLetter()
	.data
	msg0: .asciiz "Player enter a letter "
	.text
	la $a0,msg0
	li $v0,4
	syscall
	li $v0,12
	syscall
	move $s1,$v0  # s1 is user guess
	li $a0,'\n'
	li $v0,11
	syscall
.end_macro 
#this method will check the user guess vs the current byte that is loaded into the register, 
# if it matches it prints the guess and saves it to the final word. else it prints a _ and doesnt change the final word
.macro updateGame()
	check:
		move $a0,$s1
		move $t9,$t4
	change:
		bne $a0,$t9,print_
		beq $a0,$t9,printGuess
	printGuess:
		sb $a0,0($t5)
		li $v0,11
		syscall
		addi $s2,$s2,1
		j exit
	print_:
		li $a0, ' ' 
		li $v0,11
		syscall
		li $a0,'_'
		li $v0,11
		syscall
	exit:
		
		
		
.end_macro 
#this macro will loop through the specific word and then call updateGame to do the check on the current position vs user input
.macro loopThroughGuess()
.text
	li $t2,0
	li $t3,6
	#this moves the word that is to be guessed into t0 from s5 which was saved in the random macro
	move $t0,$s5
	la $t5,savedWord 
	
loop:
	beq $t2,$t3,end
	lb $t4,0($t0)
	#t4 has the letter call macro that beq's and updates the board
	updateGame()
	addi $t2,$t2,1
	addi $t0,$t0,1
	addi $t5,$t5,1
	j loop
end:
	li $a0,'\n'
	li $v0,11
	syscall
	la $a0,current
	li $v0,4
	syscall
	la $a0,savedWord
	li $v0,4
	syscall
	li $a0,'\n'
	li $v0,11
	syscall

	
	
.end_macro 

#not working rn
.macro resetGame()
	la $t0,savedWord
	li $t1,0
loop:	
	beq $t0,6,end
	li $t4,' '
	sb $t4,0($t0)
	addi $t0,$t0,1
	addi $t1,$t1,1
	# j loop
end:
	
	
.end_macro
######

main:
# t0 is used for the first user input from introMSG
	randomize()
	introMsg()
	beq $t0,1,game
	beq $t0,2,exit

game:	
	li $t2,0 #counter
	li $t3,6 #total loops
	j hideWord
	
hideWord:
#this will print out _ plus a space for how long the word is, in this case 6 letters so it will look like _ _ _ _ _ _
	beq $t2,$t3,continue
	li $a0,'_'
	li $v0,11
	syscall
	li $a0, ' '
	li $v0,11
	syscall
	addi $t2,$t2,1
	li $t7,15 #guesses
	li $s2,0 #correct guesses
	j hideWord
continue:
	beq $s2,6,exit
	beq $t7,0,exit
	enterLetter()
	loopThroughGuess()
	addi $t7,$t7,-1
	printAmountGuesses($t7)
	j continue
	
exit:
	li $v0,10
	syscall	




.ktext 0x80000180
	la $a0, errorMSG
	li $v0,4
	syscall
	la $t9,1
	bnez $t9,main
	eret
	
