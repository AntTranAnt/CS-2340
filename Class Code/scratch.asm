# practice problem 7
# move the loop to a subroutine
# while (s2[i] = s1[i] != '/0') i++; 
	.data
s1:	.asciiz	"hi"
	.align	2
s2:	.space	4

	.text
main:	
la $a1, s1
la $a2, s2
jal copy

exit:	li	$v0, 10
	syscall
	
copy:
add $t1, $a1, $0
add $t2, $a2, $0
loop:
lbu $t3, ($t1)
sb $t3, ($t2)
beq $t3, $zero, return
addi $t2, $t2, 1
addi $t1, $t1, 1
j loop

return: jr $ra