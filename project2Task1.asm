.data
welcome: .asciiz "\nWelcome to Project2 Task 1\n"
mainMenu: .asciiz "Main Menu\n(1) Get Letter grade\n(2) Exit\n"
input: .asciiz "Please enter an input: "
output: .asciiz "\nYour output is: "
errorMsg: .asciiz "\nERROR INVALID INPUT\n"
gradePrompt: .asciiz "\nPlease enter a score as an integer value: "
.text

main:
	la $a0,welcome
	li $v0,4
	syscall
	la $a0,mainMenu
	li $v0,4
	syscall
	la $a0,input
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $t0, $v0
	
	beq $t0,1,loop
	beq $t0,2,exit
	tgei $t0,2
	tlti $t0,1
loop:
	la $a0,gradePrompt
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t1,$v0
	# bge from 90 to 50 A to F
	bgt $t1,100,errorGrade
	bge $t1,90,a
	bge $t1,80,b
	bge $t1,70,c
	bge $t1,60,d
	bge $t1,0,f 
errorGrade:
	la $a0,errorMsg
	li $v0,4
	syscall
	jal loop
a:
	la $a0,output
	li $v0,4
	syscall
	la $a0,'A'
	li $v0,11
	syscall
	jal main

b:
	la $a0,output
        li $v0,4
        syscall
        la $a0,'B'
        li $v0,11
        syscall
        jal main
c:
	la $a0,output
        li $v0,4
        syscall
        la $a0,'C'
        li $v0,11
        syscall
        jal main
d:
	la $a0,output
        li $v0,4
        syscall
        la $a0,'D'
        li $v0,11
        syscall
        jal main
f:
	la $a0,output
        li $v0,4
        syscall
        la $a0,'F'
        li $v0,11
        syscall
        jal main


exit:
	li $v0,10
	syscall
.ktext 0x80000180
	la $a0,errorMsg
	li $v0,4
	syscall
	la $t5,1
	bnez $t5,main
	eret

		
