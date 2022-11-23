.data
welcome: .asciiz "This program asks the user to input the value for 'x' and 'y'.\nThen it finds the value of x to the power of y.\nFor example 2 to the power of 3 is 8\n"
input0: .asciiz "Enter a number for 'x': "
input1: .asciiz "Enter a number for 'y': "
output: .asciiz " to the power of "
output1: .asciiz " is "
error: .asciiz "INVALID INPUT!\n"

.text

main:
# load welcome messages and grab user inputs. t0 is x, t1 is y and t2 is the loop counter, t3 is the end val starts at t0
	la $a0,welcome
	li $v0,4
	syscall
	la $a0,input0
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t0,$v0
	la $a0,'\n'
	li $v0,11
	syscall
	la $a0,input1
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t1,$v0
	li $t2,1
	la $t3,($t0)
# the loop checks the counter on y then multiplies the end val t3 with the x val t0. it then adds 1 to the counter t2 and jumps back to the loop
loop:
	beq $t2,$t1,next
	mul $t3,$t0,$t3	
	addi $t2,$t2,1
	j loop

next:
	# print the output
	move $a0,$t0
	li $v0,1
	syscall
	la $a0,output
	li $v0,4
	syscall
	move $a0,$t1
	li $v0,1
	syscall
	la $a0,output1
	li $v0,4
	syscall
	move $a0,$t3
	li $v0,1
	syscall
	j exit
exit:
	li $v0,10
	syscall
# this is the error handling for invalid inputs from the user, its then loads 1 for a random t register and bnez it to branch back to main since you cant use j format in a .ktext section
.ktext 0x80000180
	la $a0,error
	li $v0,4
	syscall
	la $t7 1
	bnez $t7,main
	eret
