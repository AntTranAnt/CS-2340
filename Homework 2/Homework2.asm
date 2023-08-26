#Anthony Tran
#February 17, 2023
#homework 2
#Program to input a string from user and 
#determine the amount of chars and words
#inputted. Limit of 100 chars assumed
#########################################

.data
message: .space 100
msgLimit: .word 100

counter: .word 0
numWords: .word 0
numSpace: .word 0

input_msg: .asciiz "Enter some text:"
result1: .asciiz " words "
result2: .asciiz " characters\n"
exit_msg: .asciiz "Goodbye, thanks for coming!"

.text

loop:
#inputs string from user
#string limit of 100
li $v0, 54
la $a0, input_msg
la $a1, message
lw $a2, msgLimit
syscall

#jumps to exit if cancel chosen or zero string
li $t1, -2
li $t2, -3
beq $a1, $t1, exit
beq $a1, $t2, exit

#calls countString function
la $a0, message
jal countString
sw $v0, counter
sw $v1, numSpace

#prints string
li $v0, 4
la $a0, message
syscall

#prints words
lw $t1, numSpace
addi $t2, $t1, 1
sw $t2, numWords

li $v0, 1
lw $a0, numWords
syscall
li $v0, 4
la $a0, result1
syscall

#prints counter
li $v0, 1
lw $a0, counter
syscall
li $v0, 4
la $a0, result2
syscall

j loop

exit:
#system calls goodbye msg
li $v0, 59
la $a0, exit_msg
syscall
li $v0, 10
syscall


#function 
# $a0 contains address of input string
# use loop to count each char in string, return in $v0
# use num char to calculate words, return in $v1
countString:
	li $t1, '\0'
	li $t4, ' '
	li $v1, 0 #space variable
	la $t2, ($a0)
	li $s1, 0 #counter variable
	addi $sp, $sp, -4
	sw $s1, ($sp)
countLoop:
	lbu $t3, ($t2)
	beq $t3, $t1, ex2 #branch to ex2 if equal '\0'
	bne $t3, $t4, else #branch to else if not equal ' '
	addi $v1, $v1, 1
else:
	addi $t2, $t2, 1
	lw $s1, ($sp)
	addi $s1, $s1, 1
	sw $s1, ($sp)
	j countLoop

ex2:
	#restores stack
	lw $s1, ($sp)
	add $v0, $s1, -1
	addi $sp, $sp, 4
	jr $ra
