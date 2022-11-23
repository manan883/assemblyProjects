.data
scores: .word 32 56 78 66 88 90 93 100 101 82
size: .word 10
welcome: .asciiz "Welcome to project 2 task 2\n"
output0: .asciiz "The Grade for "
output1: .asciiz " is "



.text
# printG will take 2 inputs, the score and the grade letter then format them as a string and print it. it has its own data section to allow the grade input to be printed
.macro printG(%i,%g)
	la $a0,output0
	li $v0,4
	syscall
	.data
	gr: .asciiz %g
	.text
	move $a0,%i
	li $v0,1
	syscall
	la $a0,output1
	li $v0,4
	syscall	
	la $a0,gr
	li $v0,4
	syscall
# it adds to the loop counter and the array counter here and not in the loop label
	addi $t2,$t2,1
	addi $t0,$t0,4
	j loop
	
.end_macro
# print welcome message then load scores into t0 an size into t1. t2 is the loop counter
main:
	la $a0, welcome
        li $v0,4
        syscall
	la $t0,scores
	lw $t1,size
	li $t2,0	
loop:
# checks counter against the size, then checks the value from the array index and branches to the correct label	
	beq $t2,$t1,exit
	lw $a0,($t0)
	#a0 has the element from the array, move it to t9	
	move $t7,$a0
	bgt $t7,100,aA
	bge $t7,90,a
	bge $t7,80,b 
	bge $t7,70,c
	bge $t7,60,d
	bge $t7,0,f
# each label calls printG with the proper grade and input
aA:
	printG($t7,"A with extra credit\n")
a:
	printG($t7,"A\n")
b:
	printG($t7,"B\n")
c:
	printG($t7,"C\n")
d:
	printG($t7,"D\n")
f:
	printG($t7,"F\n")

exit:
	li $v0,10
	syscall
# since there is no input, a .ktext is not needed here 
 

 
