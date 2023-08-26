.data
a:	.word   3
b:	.word	  4
c:	.word   9
d:	.word   9

.text
main:	
	# load a and b
    lw	$t1, a #stores 3 at t1
    lw	$t2, b #stores 4 at t2

	# store c and d
    sw	$t1, c #stores value in t1 at memory address c
    sw	$t2, d
		
exit:	
    li	$v0, 10
    syscall