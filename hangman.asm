.data
welcome: .asciiz "Welcome to mips hangman! This is a 2 player game in which player 1 chooses a word then player 2 tries to guess within 6 guesses\nTo procede choose one of the options\n(1)New Game\n(2)Exit"
msg0: .asciiz "Player 1 enter the word your thinking of "


errorMSG: .asciiz "INVALID INPUT"
.text

# macros
.macro introMsg
	la $a0, welcome
	li $v0,4
	syscall
	la $a0, msg0
	li $v0,4
	syscall
	li $v0,8
	syscall
	move $t0,$v0
.end_macro

.macro printAmountGuesses(%guess)
	.data
	msg1: .asciiz "You have "
	msg2: .asciiz " guesses left"
	.text
	la $a0,msg1
	li $v0,4
	syscall
	la $a0 %guess
	li $v0,1
	syscall	
	la $a0,msg2
	li $v0,4
	syscall
	la $a0,'\n'
	li $v0,11
	syscall
.end_macro

.macro isItRight
	.data
	msg0: .asciiz "Player 2 enter a letter "
	msg1: .asciiz "In which spaces 

main:
# t0 is used for the first user input from introMSG
	introMSG()
	beq $t0,1,game
	beq $t0,2,exit

game:
	li $t1,6
	printAmountGuesses($t1)
	
	
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
	
