#Anthony Tran
#CS 2340.502
#3/26/23

#Program to incorporate keyboard and bitmap to create marque box simulation
#set pixel to 4x4
#set width and height to 256x256
#set base address as $gp

.eqv WIDTH 64
.eqv HEIGHT 64

# colors
.eqv	RED 	0x00FF0000
.eqv	GREEN 	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv 	CYAN 	0x0000FFFF
.eqv 	MAGENTA 0x00FF00FF

.data
colors: .word 	MAGENTA, CYAN, YELLOW, BLUE, GREEN, RED, WHITE

.text
main:
#Set starting condition at middle of bitmap
	li 	$s1, 0 #address counter
	li	$s3, 0 #color counter
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	la 	$s2, colors
	j 	loop

##################################
#Branch to draw pixel
color_reset:
	la 	$s2, colors
	li 	$s3, 0
	j	loop

#Draws top side of box
loop:
	beq 	$s3, 6, color_reset
	lw 	$a2, ($s2)
	jal 	draw_pixel
	addi 	$s1, $s1, 1 #i++
	addi 	$s3, $s3, 1 #color++
	addi 	$a0, $a0, 1 #increment X
	addi 	$s2, $s2, 4 #point to next color
	jal 	pause
	blt  	$s1, 7, loop

#Draws right side of box
main_right:
	addi	$s3, $s3, 1
	j 	loop_right

color_reset_right:
	la 	$s2, colors
	li 	$s3, 0
	j	loop_right

loop_right:
	beq 	$s3, 6, color_reset_right
	lw 	$a2, ($s2)
	jal 	draw_pixel
	addi 	$s1, $s1, 1 #i++
	addi 	$s3, $s3, 1 #color++
	addi 	$a1, $a1, 1 #increment X
	addi 	$s2, $s2, 4 #point to next color
	#jal 	pause
	blt  	$s1, 14, loop_right

#Draws bot side of box
main_bot:
	addi	$s3, $s3, 1
	j 	loop_bot

color_reset_bot:
	la 	$s2, colors
	li 	$s3, 0
	j	loop_bot

loop_bot:
	beq 	$s3, 6, color_reset_bot
	lw 	$a2, ($s2)
	jal 	draw_pixel
	addi 	$s1, $s1, 1 #i++
	addi 	$s3, $s3, 1 #color++
	addi 	$a0, $a0, -1 #increment X
	addi 	$s2, $s2, 4 #point to next color
	jal 	pause
	blt  	$s1, 21, loop_bot

#Draws left side of box
main_left:
	addi	$s3, $s3, 1
	j 	loop_left

color_reset_left:
	la 	$s2, colors
	li 	$s3, 0
	j	loop_left

loop_left:
	beq 	$s3, 6, color_reset_left
	lw 	$a2, ($s2)
	jal 	draw_pixel
	addi 	$s1, $s1, 1 #i++
	addi 	$s3, $s3, 1 #color++
	addi 	$a1, $a1, -1 #increment X
	addi 	$s2, $s2, 4 #point to next color
	#jal 	pause
	blt  	$s1, 28, loop_left

	#reset back to start
	li 	$s1, 0
	addi 	$s3, $s3, 1
	j 	loop
	
exit:	li	$v0, 10
	syscall

#################################
#subroutine to draw a pixel on screen
# $a0 = X
# $a1 = Y
# $a2 = color
draw_pixel:
	# s1 = address = $gp + 4*(x + y*width)
	mul	$t9, $a1, WIDTH   
	add	$t9, $t9, $a0	  
	mul	$t9, $t9, 4	  
	add	$t9, $t9, $gp	  
	sw	$a2, ($t9)	  
	jr 	$ra
	
###################################
#pause subroutine to waste a little time
# $a0 - amount to pause
pause:
	#save $ra
	addi 	$sp, $sp, -8
	sw 	$ra, ($sp)
	sw 	$a0, 4($sp)
	
	li 	$v0, 32
	li 	$a0, 5
	syscall
	
	#restore $ra
	lw 	$ra, ($sp)
	lw 	$a0, 4($sp)
	addi 	$sp, $sp, 8
	jr 	$ra
