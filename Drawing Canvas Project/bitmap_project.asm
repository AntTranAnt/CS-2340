#Anthony Tran
#CS 2340.502
#4/20/23

#Overview
#This bitmap project is a simulation of a drawing canvas app where 
#the user can draw using pixels. The canvas space consists of a 64x60 bitmap 
#space, with the bottom 4 rows reserved for the tool bar. Cursor position 
#and commands are utilized with the keyboard (instructions below).

#Instructions
#Program to incorporate keyboard and bitmap to pixel drawing app
#set pixel to 4x4
#set width and height to 256x256
#set base address as $gp

#Warnings/hints
#Since you cannot see the cursor position, you can fill in a pixel with a different color from the background to see the current position.
#Do not input keys too quickly or the keyboard might crash.
#You can hold movement keys and draw pixel keys, but do not hold both at same time.
#After using the clear command, select a color before using the draw pixel or fill command.
#If you don’t close out or reset the bitmap, you can stop and start the program again, and the bitmap will still be there.


.eqv WIDTH 64
.eqv HEIGHT 64

# colors
.eqv	RED 	0x00FF0000
.eqv	GREEN 	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv 	CYAN 	0x0000FFFF
.eqv 	PURPLE  0x00A020F0
.eqv 	BLACK	0x00000000
.eqv 	BROWN 	0x00964B00
.eqv 	ORANGE 	0x00FFA500
.eqv 	GREY 	0x00808080

.data
colors: .word 	RED, ORANGE, YELLOW, GREEN, BLUE, CYAN, PURPLE, WHITE, BLACK, BROWN
intro_msg: .asciiz "Welcome to the Drawing Canvas!\nHere are the list of controls:\n- WASD to move\n- 0-9 to change colors"
intro_msg2: .asciiz "\n- P to fill canvas\n- L to clear canvas"

.text
main:
	#prints intro to program
	li $v0, 59
	la $a0, intro_msg
	la $a1, intro_msg2
	syscall
#draw tool bar at bottom of bitmap
toolbar:
	li $t0, 10 #number of colors
	li $t1, 0 #counter
	la $t2, colors #load address of color
	addi $a0, $0, 1 #set coordinate at bottom left of bitmap
	addi $a1, $0, HEIGHT
	addi 	$a0, $a0, -1
	addi	$a1, $a1, -1
	tool_loop2:
		#draws 2x2 square of same color
		lw $a2, ($t2)
		jal draw_pixel
		addi $a0, $a0, 1
		jal draw_pixel
		addi $a1, $a1, -1
		jal draw_pixel
		addi $a0, $a0, -1
		jal draw_pixel
		
		addi $a0, $a0, 2 #increment X
		addi $a1, $a1, 1 #reset Y
		addi $t2, $t2, 4 #point to next color
		addi $t1, $t1, 1 #increment counter
		bne $t0, $t1, tool_loop2
		
#Draw border to separate toolbar from canvas space
draw_border:
	addi $a0, $0, 1 #sets coordinate to be above toolbar
	addi $a1, $0, HEIGHT
	addi $a0, $a0, -1
	addi $a1, $a1, -4
	addi $a2, $a0, GREY
	li $t0, 1 #counter
	li $t1, WIDTH #end condition
	border_loop:
		jal draw_pixel
		addi $t0, $t0, 1 #increment counter
		addi $a0, $a0, 1 #increment x-cord
		bne $t0, $t1, border_loop
	#second row of grey border
	li $t0, 0
	border_loop2:
		jal draw_pixel
		addi $t0, $t0, 1 #increment counter
		addi $a0, $a0, 1 #increment x-cord
		bne $t0, $t1, border_loop2
	jal draw_pixel
	#third row of grey border
	addi $a0, $a0, 21
	li $t0, 20
	border_loop3:
		jal draw_pixel
		addi $t0, $t0, 1 #increment counter
		addi $a0, $a0, 1 #increment x-cord
		bne $t0, $t1, border_loop3
	#fourth row of grey border
	addi $a0, $a0, 20
	li $t0, 20
	border_loop4:
		jal draw_pixel
		addi $t0, $t0, 1 #increment counter
		addi $a0, $a0, 1 #increment x-cord
		bne $t0, $t1, border_loop4
		
#set starting position
	addi 	$a0, $0, WIDTH
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT
	sra 	$a1, $a1, 1

#ask user for input
loop:
	lw $s0, 0xffff0000
    	beq $s0, 0, loop
	
	# process input
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit	# input space
	beq	$s1, 119, up 	# input w
	beq	$s1, 115, down 	# input s
	beq	$s1, 97, left  	# input a
	beq	$s1, 100, right	# input d
	beq 	$s1, 118, draw #input v
	beq 	$s1, 48, red_color #input 0
	beq 	$s1, 49, orange_color #input 1
	beq 	$s1, 50, yellow_color #input 2
	beq 	$s1, 51, green_color #input 3
	beq 	$s1, 52, blue_color #input 4
	beq 	$s1, 53, cyan_color #input 5
	beq 	$s1, 54, purple_color #input 6
	beq 	$s1, 55, white_color #input 7
	beq 	$s1, 56, black_color #input 8
	beq 	$s1, 57, brown_color #input 9
	beq 	$s1, 112, fill #input p
	beq 	$s1, 108, clear #input l
	j	loop
	

up:
	#prevents cursor from going out of bounds top
	beq 	$a1, $0, loop
	addi	$a1, $a1, -1
	j	loop

down:
	#prevents cursor from leaving canvas space and into border
	addi 	$s3, $0, HEIGHT
	addi 	$s3, $s3, -5
	beq 	$s3, $a1, loop
	addi	$a1, $a1, 1
	j	loop
	
left:
	addi	$a0, $a0, -1
	j	loop
	
right:
	addi	$a0, $a0, 1
	j	loop
draw:
	#draws pixel using current color
	jal draw_pixel
	j	loop

#sets color according to input
red_color:
	addi $a2, $0, RED
	j draw_current_color
orange_color:
	addi $a2, $0, ORANGE
	j draw_current_color
yellow_color:
	addi $a2, $0, YELLOW
	j draw_current_color
blue_color:
	addi $a2, $0, BLUE
	j draw_current_color
cyan_color:
	addi $a2, $0, CYAN
	j draw_current_color
purple_color:
	addi $a2, $0, PURPLE
	j draw_current_color
white_color:
	addi $a2, $0, WHITE
	j draw_current_color
black_color:
	addi $a2, $0, BLACK
	j draw_current_color
brown_color:
	addi $a2, $0, BROWN
	j draw_current_color
green_color:
	addi $a2, $0, GREEN
	j draw_current_color
fill:
	j fill_canvas
clear:
	addi $a2, $0, BLACK
	j fill_canvas

#Fills the canvas with current color
fill_canvas:
	#saves current location
	add $t2, $a0, $0
	add $t3, $a1, $0
	#sets coordinate to top left of bitmap.
	addi $a0, $0, 0
	addi $a1, $0, 0
	li $t4, 0 #counter
	li $t5, 3840 #stop condition
	fill_loop:
		jal draw_pixel
		addi $t4, $t4, 1
		addi $a0, $a0, 1
		bne $t4, $t5, fill_loop
	#set coordinate back to initial location
	add $a0, $t2, $0
	add $a1, $t3, $0
	j loop
	
#Shows current color at bottom right of bitmap
draw_current_color:
	#saves current location
	add $t2, $a0, $0
	add $t3, $a1, $0
	#sets coordinate to bottom right of bitmap.
	addi $a0, $0, WIDTH
	addi $a1, $0, HEIGHT
	addi $a0, $a0, -2
	addi $a1, $a1, -2
	#draws a 2x2 square of current color
	jal draw_pixel
	addi $a0, $a0, 1
	jal draw_pixel
	addi $a1, $a1, 1
	jal draw_pixel
	addi $a0, $a0, -1
	jal draw_pixel
	#set coordinate back to initial location
	add $a0, $t2, $0
	add $a1, $t3, $0
	j loop

	
exit:	li	$v0, 10
	syscall


###################
# Function to draw pixel
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
