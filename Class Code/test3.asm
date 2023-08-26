# practice program 1
# if (a < 0) a = -a
	.data
a:	.word	4

	.text
main:		
lw 	$t1, a
bge	$t1, $zero, exit
sub 	$t1, $zero, $t1
sw 	$t1, a




exit:	li	$v0, 10
	syscall
	

# practice program 2
# if (a > 0) a = -a
	.data
a:	.word	4	# change to negative to test


	.text
main:	
# your code here




exit:	li	$v0, 10
	syscall
	
# practice program 3
# if (a <= b) c = b else c = a  
	.data
a:	.word	5
b:	.word	6
c:	.word	0

	.text
main:	
lw	$t0, a
lw 	$t1, b
lw 	$t2, c
bgt 	$t0, $t1, else
add	$t2, $zero, $t1
else:
add 	$t2, $zero, $t0

exit:	li	$v0, 10
	syscall
	
	
# practice program 4
# for (i=0; i<10; i++) c +=5;  # use immediate load/add instructions

	.data
c:	.word	0

	.text
main:	
lw 	$t0, c
li 	$t1, 0 #counter
li 	$t2, 10 #limit

loop:
addi 	$t0, $t0, 5
addi 	$t1, $t1, 1
blt 	$t1, $t2, loop

sw 	$t0, c

exit:	li	$v0, 10
	syscall
	
# practice program 5
# for (i=0; i<10; i++) a[i] +=5; 
	.data
a:	.word	5, 9, 2, 1, 4, 6, 3, 9, 2, 1
len:	.word	10

	.text
main:	
la 	$t0, a
li 	$t1, 0
lw 	$t2, len

loop:
bge 	$t1, $t2, len
lw 	$t3, ($t0)
addi 	$t3, $t3, 5
sw 	$t3, ($t0)
addi 	$t0, $t0, 1
addi 	$t1, $t1, 4
j 	loop

exit:	li	$v0, 10
	syscall
	
	
# practice program 6
# while (s2[i] = s1[i] != '/0') i++; 
	.data
s1:	.asciiz	"hi"
	.align	2
s2:	.space	4

	.text
main:	
la 	$t1, s1
la 	$t2, s2

loop:
lbu 	$t5, ($t1)
sb 	$t5, ($t2)
beq 	$t5, $zero, exit
addi 	$t1, $t1, 1
addi 	$t2, $t2, 1
j 	loop


exit:	li	$v0, 10
	syscall
	
	
# practice problem 7
# move the loop to a subroutine
# while (s2[i] = s1[i] != '/0') i++; 
	.data
s1:	.asciiz	"hi"
	.align	2
s2:	.space	4

	.text
main:	
jal 	copy

copy:
jr 	$ra

exit:	li	$v0, 10
	syscall
