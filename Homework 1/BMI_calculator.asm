#Anthony Tran
#CS 2340-502
#2-4-23
#Program designed to ask for a,b,c values from user and perform arithmetic operations

.data
name: .space 20
height: .space 4
weight: .space 4
BMI: .float 4
underweightBMI: .float 18.5
normalBMI: .float 25
overweightBMI: .float 30

namePrompt: .asciiz "What is your name? "
heightPrompt: .asciiz "Please enter your height in inches: "
weightPrompt: .asciiz "Now enter your weight in pounds (round to a whole number): "
nameResultPrompt: .asciiz "your bmi is: "
underweight: .asciiz "This is considered underweight. \n"
normal: .asciiz "This is considered normal. \n"
overweight: .asciiz "This is considered overweight. \n"
obese: .asciiz "This is considered obese. \n"
testing: .asciiz "I got here"
newline: .asciiz "\n"

.text
main: 
	#print prompt
	li $v0, 4
	la $a0, namePrompt
	syscall
	
	#input name
	li $v0, 8
	li $a1, 20
	la $a0, name
	syscall
	
	#input height
	li $v0, 4
	la $a0, heightPrompt
	syscall
	li $v0, 5
	syscall
	sw $v0, height
	
	#input weight
	li $v0, 4
	la $a0, weightPrompt
	syscall
	li $v0, 5
	syscall
	sw $v0, weight
	
	#multiply weight
	lw $t1, weight
	li $t3, 703
	mul $t2, $t1, $t3
	sw $t2, weight
	
	 #multiply height
	lw $t1, height
	mul $t2, $t1, $t1
	sw $t2, height
	
	#calculate bmi
	lw $t1, weight
	mtc1 $t1, $f4
	
	lw $t2, height
	mtc1 $t2, $f2
	
	div.s	$f12, $f4, $f2
	swc1	$f12, BMI
	
	#print name and BMI
	li	$v0, 4
	la 	$a0, name
	syscall
	
	li	$v0, 4
	la	$a0, nameResultPrompt
	syscall
	
	lwc1	$f12, BMI
	li $v0, 2
	syscall
	
	li	$v0, 4
	la	$a0, newline
	syscall
	
	#Branch and print message depending on BMI type
	lwc1	$f2, BMI
	
	#branch if less than 18.5
	lwc1 $f3, underweightBMI
	c.lt.s 	$f2, $f3
	bc1t underweightPrint
	
	#branch if less than 25
	lwc1 $f3, normalBMI
	c.lt.s	$f2, $f3
	bc1t normalPrint
	
	#branch if less than 30
	lwc1 $f3, overweightBMI
	c.lt.s $f2, $f3
	bc1t overweightPrint
	
	#branch to obese if everything else false
	j obesePrint
	
	underweightPrint:
		la $a0, underweight
		j print
	normalPrint:
		la $a0, normal
		j print
	overweightPrint:
		la $a0, overweight
		j print
	obesePrint:
		la $a0, obese
		
	print:
		li $v0, 4
		syscall
	
#Test case 1
#What is your name? ant
#Please enter your height in inches: 69
#Now enter your weight in pounds (round to a whole number): 160
#ant
#your bmi is: 23.625288
#This is considered normal.

#test case 2
#What is your name? Anthony
#Please enter your height in inches: 60
#Now enter your weight in pounds (round to a whole number): 160
#Anthony
#your bmi is: 31.244444
#This is considered obese. 
	
	
