#Anthony Tran
#CS 2340-502
#2-4-23
#Program designed to ask for a,b,c values from user and perform arithmetic operations

.data
name: 	.space 	20
a: 	.space 	4
b: 	.space 	4
c: 	.space 	4
ans1: 	.space 	4
ans2: 	.space 	4
ans3: 	.space 	4
name_prompt:	.asciiz 	"Please enter your name: "
int_prompt: 	.asciiz 	"Please enter an integer between 1-100: "
result_prompt: 		.asciiz 	"your answers are: "


.text
main:
	#print prompt
	li $v0, 4
	la $a0, name_prompt
	syscall
	
	#input name
	li $v0, 8
	li $a1, 20
	la $a0, name
	syscall
	
	#input integer
	li $v0, 4
	la $a0, int_prompt
	syscall
	li $v0, 5
	syscall
	sw $v0, a
	li $v0, 4
	la $a0, int_prompt
	syscall
	li $v0, 5
	syscall
	sw $v0, b
	li $v0, 4
	la $a0, int_prompt
	syscall
	li $v0, 5
	syscall
	sw $v0, c
	
	#integer arithmetic
	lw $a0, a
	lw $a1, b
	lw $a2, c
	add $t0, $a0, $a0
	sub $t1, $t0, $a2
	add $v0, $t1, 4
	sw $v0, ans1
	
	sub $t0, $a1, $a2
	sub $t1, $a0, 2
	add $v0, $t0, $t1
	sw $v0, ans2
	
	add $t0, $a0, 3
	sub $t1, $a1, 1
	add $t2, $a2, 3
	sub $t3, $t0, $t1
	add $v0, $t3, $t2
	sw $v0, ans3
	
	#print result
	li $v0, 4
	la $a0, name
	syscall
	li $v0, 4
	la $a0, result_prompt
	syscall
	li $v0, 1
	lw $a0, ans1
	syscall
	li $v0, 11
	li $a0, ' '
	syscall
	li $v0, 1
	lw $a0, ans2
	syscall
	li $v0, 11
	li $a0, ' '
	syscall
	li $v0, 1
	lw $a0, ans3
	syscall
exit:
	li $v0, 10
	syscall

#SAMPLE RUN 1	
#Please enter your name: Anthony
#Please enter an integer between 1-100: 34
#Please enter an integer between 1-100: 25
#Please enter an integer between 1-100: 65
#Anthony
#your answers are: 7 -8 81
#-- program is finished running --

#SAMPLE RUN 2
#Please enter your name: Anthony
#Please enter an integer between 1-100: 1
#Please enter an integer between 1-100: 2
#Please enter an integer between 1-100: 3
#Anthony
#your answers are: 3 -2 9
#-- program is finished running --
