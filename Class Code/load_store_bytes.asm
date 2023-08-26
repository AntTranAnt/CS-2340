.data
s1:	.byte   'a', 'b'
    .align  2
s2:	.space	2

.text
main:	
    la	$t1, s1		# $t1 points to s1
    la	$t2, s2		# $t2 points to s2
	
	# load/store first byte
    lbu	$t0, ($t1) #loads first byte into register t0
    sb	$t0, ($t2) #stores t0 at where t2 is pointing
	
	# load/store second byte
    lbu	$t0, 1($t1)
    sb	$t0, 1($t2)
		
exit:	
    li	$v0, 10
    syscall