	# Program to calculate Ackermann's function such that A(m,n) 
	# terms "m" and "n" are >= 0, specified by user input (integers).
	# prompt user input, call ackman function, print out resulting value

	# Written by Kollen G


        .data
        .align  2
prmptM:.asciiz	"\nEnter m value to calculate A(m,n): "
prmptN:.asciiz	"\nEnter n value to calculate A(m,n): "
result:.asciiz	"\nAckermann's function with M and N = "

#--------------------------------
        .text
       	.globl	main
       	
main:
	move	$s0, $0		# s0 : computed A(m,n) value
	
	# get user input M
	la 	$a0, prmptM	#load prmpt for M
	li 	$v0, 4		#code to print string
	syscall			#print

	li 	$v0, 5		#take int input
	syscall
	move	$s1, $v0	# s1 = user input "m"
	# get user input N
	la 	$a0, prmptN	#load prmpt for N
	li 	$v0, 4		#code to print string
	syscall			#print
	
	li 	$v0, 5		#take int input
	syscall
	move	$s2, $v0	# s2 = user input "n"
	# call Ackman func
	move	$a0, $s1
	move	$a1, $s2
	jal	ackman
	move	$s0, $v0	# s0 = result from Ackman func

#------ Display results and exit ---------------------------------
	la 	$a0, result	#load display string
	li 	$v0, 4		#code to print string
	syscall			#print
	
	li 	$v0, 1		#code to print int
	move	$a0, $s0	#load computed A(m,n)
	syscall			#print

#----------------- Exit ---------------------
	li	$v0, 10
	syscall


	
#******************************************************************
	# ackman function
	#
	# a0 - user input "m"
	# a1 - user input "n"
    	#
    	# v0 - computed A(m,n)	
ackman:
#--------------- Usual stuff at function beginning  ---------------
        addi    $sp, $sp, -24
        sw	$ra, 20($sp)
        sw	$s0, 16($sp)
        sw	$s1, 12($sp)
        sw	$s2, 8($sp)
        sw	$s3, 4($sp)
        sw	$s4, 0($sp)
#-------------------------- function body -------------------------
	move    $s0, $a0        # s0 : "M"
	move	$s1, $a1	# s1 : "N"
	move	$s2, $0		# s2 : computed A(m,n)

        # base case if m = 0
        bne     $s0, 0, cont1   # if (M == 0)
        addi	$s2, $s1, 1	# s2 = (n+1)
        
        # else if m > 0 and n = 0
cont1:	ble	$s0, 0, cont2	# if (M > 0)
        bne	$s1, 0, cont2	# if (N == 0)
        addi	$a0, $s0, -1	# a0 : M = (m-1)
        addi	$a1, $0, 1	# a1 : N = 1
        jal	ackman		# compute
        move	$s2, $v0	# s2 = A(m-1,1)
        
        # else if m > 0 and n > 0 ----- A(m-1, A(m,n-1))
cont2:	ble	$s0, 0, done	# if (M > 0)
        ble	$s1, 0, done	# if (N > 0)
        #inner 
        move	$a0, $s0	# a0 : M = m
        addi	$a1, $s1, -1	# a1 : N = (n-1)
        jal	ackman
        move	$a1, $v0	# a1 : N = A(m,n-1)
        #outer
        addi	$a0, $s0, -1	# a0 : M = (m-1)
        jal	ackman		# compute
        move	$s2, $v0	# s2 = A(m-1, A(m,n-1))

done:	move	$v0, $s2

#-------------------- Usual stuff at function end -----------------
        lw  	$ra, 20($sp)
        lw	$s0, 16($sp)
        lw	$s1, 12($sp)
        lw	$s2, 8($sp)
        lw	$s3, 4($sp)
        lw	$s4, 0($sp)        
        addi	$sp, $sp, 24
        jr      $ra


