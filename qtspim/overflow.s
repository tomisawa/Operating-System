.text
.globl __start
__start:
li $s0,0x7fffffff
addi $s0,$s0,1
nop
li $v0 10
syscall			# syscall 10 (exit)

	.kdata
s1:	.word 0
s2:	.word 0

.ktext 0x80000180
	sw $v0, s1		# Not re-entrant and we can't trust $sp
	sw $a0, s2		# But we need to use these registers
#
	mfc0 $k0, $13		# Cause register
	srl $a0, $k0, 2		# Extract ExcCode Field
	andi $a0, $a0, 0x1f
	bne $a0, $zero, ret		# 0 means exception was an interrupt
#
# Interrupt-specific code
#
	mfc0	$k0, $14			# Bump EPC register
	addiu	$k0, $k0, -4		# unSkip faulting instruction
	mtc0	$k0, $14
#
# Non Interrupt-specific code
ret:
	mfc0 $k0, $14		# Bump EPC register
	addiu $k0, $k0, 4		# Skip faulting instruction
	mtc0 $k0, $14
#
	lw $v0, s1		# Restore other registers
	lw $a0, s2
	mtc0 $0, $13		# Clear Cause register
	mfc0 $k0, $12		# Set Status register
	ori  $k0, 0x1		# Interrupts enabled
	mtc0 $k0, $12
	eret
