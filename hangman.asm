.data
welcome: .asciiz "Welcome to mips hangman! Try to guess the word within 6 guesses\nTo procede choose one of the options\n(1)New Game\n(2)Exit"
word1: .asciiz "button"
word2: .asciiz "pocket"
word3: .asciiz "smooth"
word4: .asciiz "fought"
word5: .asciiz "planet"
listWords: .word word1 word2 word3 word4 word5
errorMSG: .asciiz "INVALID INPUT"
.text
################ reg's to what place, $s1 is the current user guess t2 is counter, t3 is 6
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
.macro updateGame(%a,%b)
	.data
		k: .byte %a
		l: .byte %b
	.text
	check:
		la $a0,k
		la $t9,l
		beq $a0,$t9,change
		bne $a0,$t9,exit
	change:
		
	exit:
		
		
.end_macro 
.macro loopThroughGuess()
.text
	li $t2,0
	li $t3,6
	la $t0,word1
	
loop:
	beq $t2,$t3,end
	lb $t4,0($t0)
	#t4 has the letter call macro that beq's and updates the board
	updateGame($s1,$t4)
	addi $t2,$t2,1
	addi $t0,$t0,1
	j loop
end:

	
	
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
	j hideWord
continue:
	li $t1,6
	printAmountGuesses($t1)	
	enterLetter()
	loopThroughGuess()
	
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
	
