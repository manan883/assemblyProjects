.data
welcome: .asciiz "Welcome to mips hangman! Try to guess the word within 6 guesses\nTo procede choose one of the options\n(1)New Game\n(2)Exit"
word1: .asciiz "button"
word2: .asciiz "pocket"
word3: .asciiz "smooth"
word4: .asciiz "fought"
word5: .asciiz "planet"
listWords: .word word1 word2 word3 word4 word5
savedWord: .asciiz "      "
errorMSG: .asciiz "INVALID INPUT"
current: .asciiz "Current correct guesses are: "
.text
################ reg's to what place, $s1 is the current user guess t2 is counter, t3 is 5
# macros
.macro introMsg()
	la $a0, welcome
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t0,$v0
.end_macro

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

.macro enterLetter()
	.data
	msg0: .asciiz "Player 2 enter a letter "
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
.macro loopThroughGuess()
.text
	li $t2,0
	li $t3,6
	la $t0,word1
	la $t5,savedWord 
	
loop:
	beq $t2,$t3,end
	lb $t4,0($t0)
	#t4 has the letter call macro that beq's and updates the board
	updateGame()
	addi $t2,$t2,1
	addi $t0,$t0,1
	addi $t5,$t5,1
	la $a0,savedWord
	beq $a0,$t0,exit
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
main:
# t0 is used for the first user input from introMSG
	introMsg()
	beq $t0,1,game
	beq $t0,2,exit

game:
#s1 is the word
	
	li $t2,0 #counter
	li $t3,6 #total loops
	j hideWord
	
hideWord:
	beq $t2,$t3,continue
	li $a0,'_'
	li $v0,11
	syscall
	li $a0, ' '
	li $v0,11
	syscall
	addi $t2,$t2,1
	li $t7,6 #guesses
	j hideWord
continue:
	beq $t7,0,exit
	li $t1,6
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
	
