.data
scores: .word 32,56,78,66,88,90,93,100,101,82
size: .word 10
welcome: .asciiz "Welcome to project 2 task 2\n"
output0: .asciiz "The Grade for "
output1: .asciiz " is "





.text
	la $a0, welcome
	li $v0,4
	syscall

# jal from print method to array loop method and jr val back to print

.macro print()
	la $a0,output0
        li $v0,4
        syscall
        jal loop
        move $a0,$t1
        li $v0,1
        syscall
        la $a0,output1
        li $v0,4
        syscall
        li $v0,10
        syscall
.end_macro

loop:
	li $t1,2
	jr $ra

.macro grades(%i)

.end_macro

# use macros to save time 
 

 
