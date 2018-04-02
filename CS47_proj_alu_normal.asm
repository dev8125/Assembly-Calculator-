.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
# TBD: Complete it
 	beq $a2, 0x2B, add_normal
	beq $a2, 0x2D, sub_normal
	beq $a2, 0x2A, mult_normal
	beq $a2, 0x2F, div_normal
	
add_normal:
	add $v0, $a0, $a1
	j done

sub_normal:
	sub $v0, $a0, $a1
	j done

mult_normal:
	mul $v0, $a0, $a1
	mfhi $v1
	j done 
	
div_normal:
	div $a0, $a1
	mflo $v0
	mfhi $v1
		
done:
	jr	$ra