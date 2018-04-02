.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
# TBD: Complete it
addi	$sp, $sp, -64
	sw	$s0, 64($sp)
	sw	$s1, 60($sp)
	sw	$s2, 56($sp)
	sw	$s3, 52($sp)
	sw	$s4, 48($sp)
	sw	$s5, 44($sp)
	sw	$s6, 40($sp)
	sw	$s7, 36($sp)
	sw	$t0, 32($sp)
	sw	$t1, 28($sp)
	sw	$t2, 24($sp)
	sw	$t4, 20($sp)
	sw	$t5, 16($sp)
	sw	$t6, 12($sp)
	sw	$t7,  8($sp)

	beq $a2, 0x2B, addition_logical
	beq $a2, 0x2D, subtraction_logical
	beq $a2, 0x2A, multiplication_logical
	beq $a2, 0x2F, division_logical
	
addition_logical:
	move $t0, $a0
	move $t1, $a1

LOOP:	
	and $t3, $t0, $t1
	xor $t2, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, LOOP
	move $v0, $t0
	j done
	
subtraction_logical:
	not $t0, $a1
	move $t1, $zero
	ori $t1, 1
	
NEGATIVE:
	and $t3, $t0, $t1
	xor $t2, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATIVE 
	move $t1, $t0
	move $t0, $a0

SUBTRACT:	
	and $t3, $t0, $t1
	xor $t2, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, SUBTRACT	
	move $v0, $t0
	j done
	
multiplication_logical:
	or $s6, $a0, $zero
	or $s7, $a1, $zero
	or $t8, $zero, $zero
	
CHECK_FIRST_NUM_MULT:
	bgez $a0, FIRST_NONE_NEG_MULT
	not $t0, $s6
	ori $t1, $zero, 1
	
NEGATE_FIRST_NUM_MULT:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATE_FIRST_NUM_MULT
	move $s6, $t0
	bgtz $a1, ONE_IS_NEGATIVE_MULT
	j BOTH_NEGATIVE
	
FIRST_NONE_NEG_MULT:
	bgtz $a1, START_MULT
	
BOTH_NEGATIVE:
	not $t0, $s7
	ori $t1, $zero,1
	
NEGATE_SECOND_NUM_MULT:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATE_SECOND_NUM_MULT
	move $s7, $t0
	blez $a0, START_MULT
	
ONE_IS_NEGATIVE_MULT:
	ori $t8, $zero, 1
	
START_MULT:
	or $a0, $s6, $zero
	or $a1, $s7, $zero
	ori $t4, $zero, 1
	ori $t3, $zero, 31
	
	beqz $s7, END_MULT
	andi $t7, $s7, 1
	beqz $t7, MAIN_MULT
	or $t6, $zero, $s6
	
MAIN_MULT:
	beqz $s7, END_MULT
	srl $s7, $s7, 1
	andi $t7, $s7, 1
	beqz $t7, INCREMENT_POS
	sllv $s0, $a0, $t4
	move $s1, $s0 
	move $s2, $t6
	
ADD_C_TO_LO:
	xor $s3, $s1, $s2
	and $s4, $s1, $s2
	sll $s4, $s4, 1
	move $s1, $s3
	move $s2, $s4
	bnez $s2, ADD_C_TO_LO
	bgeu $s1, $t6, SET_NEW_TOTAL
	move $s2, $t5 
	ori $s3, $zero, 1
ADD_C_TO_HI: 
	xor $s3, $s1, $s2
	and $s4, $s1, $s2
	sll $s4, $s4, 1
	move $s1, $s3
	move $s2, $s4
	bnez $s2, ADD_C_TO_HI
	or $t5, $zero, $s1
ADD_ONE_TO_HI: 
	xor $s4, $s2, $s3
	and $s5, $s2, $s3
	sll $s5, $s5, 1
	move $s2, $s4
	move $s3, $s5
	bnez $s3, ADD_ONE_TO_HI
	or $t5, $zero, $s2
SET_NEW_TOTAL: 
	or $t6, $zero, $s1
	srlv $s0, $a0, $t3
	move $s1, $s0
	move $s2, $t5
INCREMENT_POS:
	move $s1, $t4 
	ori $s2, $zero, 1
INCREMENT_LO:
	xor $s3, $s1, $s2
	and $s4, $s1, $s2
	sll $s4, $s4, 1
	move $s1, $s3
	move $s2, $s4
	bnez $s2, INCREMENT_LO
	move $t4, $s1 
	bgt $s1, 31, END_MULT
	move $s1, $t3
	ori, $s2, $zero, -1
DECREMENT_HI:
	xor $s3, $s1, $s2
	and $s4, $s1, $s2
	sll $s4, $s4, 1
	move $s1, $s3
	move $s2, $s4
	bnez $s2, DECREMENT_HI
	move $t3, $s1
	j MAIN_MULT
END_MULT:
	beqz $t8, END_MULT_FINAL
	not $t5, $t5
	not $t0, $t6
	ori $t1, $zero, 1
NEGATE_MULT_FINAL:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATE_MULT_FINAL
	or $t6, $zero, $t0
END_MULT_FINAL:
	move $v0, $t6
	move $v1, $t5
	j done    
	
division_logical:
	or $s5, $zero, $zero 
	or $t8, $zero, $zero
	or $s6, $a0, $zero
	or $s7, $a1, $zero
	
CHECK_FIRST_NUMBER_DIV:
	bgez $a0, FIRST_NOT_NEGATIVE_DIV 
	not $t0, $s6
	ori $t1, $zero, 1
	
NEGATE_FIRST_NUM_DIV:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATE_FIRST_NUM_DIV
	move $s6, $t0
	bgtz $a1, ONE_IS_NEGATIVE_DIV
	j BOTH_NEGATIVE_DIV
	
FIRST_NOT_NEGATIVE_DIV:
	bgtz $a1, INITIATE_DIV
	
BOTH_NEGATIVE_DIV:
	not $t0, $s7
	ori $t1, $zero, 1
	
NEGATE_SECOND_NUM_DIV:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATE_SECOND_NUM_DIV
	move $s7, $t0 
	blez $a0, INITIATE_DIV
	
ONE_IS_NEGATIVE_DIV:
	ori $t8, $zero, 1
	
INITIATE_DIV:
	bge $s6, $s7, SECOND_IS_SMALLER_DIV
	move $v0, $zero
	move $v1, $a0
	j done	
		
SECOND_IS_SMALLER_DIV:
	not $t0, $s7
	ori $t1, $zero, 1
	
GET_SECOND_NEGATIVE:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, GET_SECOND_NEGATIVE
	move $s4, $t0
	
MAIN_DIV:
	move $t0, $s6
	move $t1, $s4
	
DIV_LOOP:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, DIV_LOOP
	move $s6, $t0
	move $t0, $s5
	ori $t1, $zero, 1
	
INCREMENT_QUOTIENT:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, INCREMENT_QUOTIENT
	move $s5, $t0
	move $t0, $s6
	move $t1, $s4
	
CHECK_REM:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, CHECK_REM
	bgez $t0, MAIN_DIV

END_DIV:
	beqz $t8, END_DIV_FINAL
	not $t0, $s5
	ori $t1, $zero, 1
	
NEGATE_DIV_FINAL:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATE_DIV_FINAL
	move $s5, $t0
	beqz $s6, END_DIV_FINAL
	not $t0, $s6
	ori $t1, $zero, 1
	
NEGATE_DIV_REM:
	xor $t2, $t0, $t1
	and $t3, $t0, $t1
	sll $t3, $t3, 1
	move $t0, $t2
	move $t1, $t3
	bnez $t1, NEGATE_DIV_REM
	move $s6, $t0
			
END_DIV_FINAL:
	move $v0, $s5 
	move $v1, $s6
	j done    
	
done:
	lw	$s0, 64($sp)
	lw	$s1, 60($sp)
	lw	$s2, 56($sp)
	lw	$s3, 52($sp)
	lw	$s4, 48($sp)
	lw	$s5, 44($sp)
	lw	$s6, 40($sp)
	lw	$s7, 36($sp)
	lw	$t0, 32($sp)
	lw	$t1, 28($sp)
	lw	$t2, 24($sp)
	lw	$t4, 20($sp)
	lw	$t5, 16($sp)
	lw	$t6, 12($sp)
	lw	$t7,  8($sp)
	addi	$sp, $sp, 64
	jr 	$ra
