.data
welcome: .asciiz "Welcome to mips hangman! This is a 2 player game in which player 1 chooses a word then player 2 tries to guess within 6 guesses\nTo procede choose one of the options\n(1)New Game\n(2)Exit"
msg0: .asciiz "\nPlayer 1 enter the word your thinking of "
# reserve 64 bytes for the word with .space
word: .space 64

errorMSG: .asciiz "INVALID INPUT"
.text

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

.macro isItRight()
	.data
	msg0: .asciiz "Player 2 enter a letter "
	msg1: .asciiz "In which spaces "
.end_macro 
main:
# t0 is used for the first user input from introMSG
	introMsg()
	beq $t0,1,game
	beq $t0,2,exit

game:
#s1 is the word
	la $a0, msg0
	li $v0,4
	syscall
	li $v0,8
	la $a0, word
    	li $a1, 64
	syscall
	move $s1,$v0
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
	
