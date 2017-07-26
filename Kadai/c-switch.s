  .text
  .globl main
main:

  # set PC and SP in FCB1
  la $t1,REGS1
  la $t0,fun1
  sw $t0,0($t1) # PC save area
  move $t0,$sp
  addi $t0,$t0,-0x100
  sw $t0,116($t1) # stack save area

  # set PC and SP in FCB2
  la $t1,REGS2
  la $t0,fun2
  sw $t0,0($t1) # pc saver area
  move $t0,$sp
  addi $t0,$t0,-0x100
  sw $t0,116($t1) # stack save area

  # set FCB1 in QUEUE
  la $t0,CURRENT
  la $t1,FCB1
  sw $t1,0($t0)

  # Switch to TOP  in QUEUE
  la $t0,CURRENT
  lw $t0,0($t0) # $t0 <- FCBx
  lw $t0,0($t0)
  lw $t1,0($t0) #
  mtc0 $t1,$14  # EPC <- PC in FCB
  lw $t1,116($t0)
  move $sp,$t1  # $sp <- SP in FCB

  .set noat
  move $1,$zero
  move $2,$zero
  move $3,$zero
  move $4,$zero
  move $5,$zero
  move $6,$zero
  move $7,$zero
  move $8,$zero
  move $9,$zero
  move $10,$zero
  move $11,$zero
  move $12,$zero
  move $13,$zero
  move $14,$zero
  move $15,$zero
  move $16,$zero
  move $17,$zero
  move $18,$zero
  move $19,$zero
  move $20,$zero
  move $21,$zero
  move $22,$zero
  move $23,$zero
  move $24,$zero
  move $25,$zero
#  move $26,$zero # $k0
#  move $27,$zero # $k1
  move $28,$zero
#  move $29,$zero # $sp
  move $30,$zero
  move $31,$zero

  # set up a timer
  li $k0, 5 # get a timer interrupt every second
  mtc0 $k0, $11  # set up compare register
  mtc0 $zero, $9

  # allow hardware interrupts
  mfc0 $k0, $12   # get status register
  ori $k0, $t0, 0xff01
  mtc0 $k0, $12

  eret  # PC <- EPC
########################################
#  user function 1 and 2
fun1:
  li $v0, 4    # print a message
  la $a0, msg1
  syscall
  add $s0,$zero, 100000
fun1loop:
  addi $s0, $s0, -1   # 1,2,3,4,...
  bne $s0,$zero fun1loop
  beq $zero,$zero, fun1

fun2:
  li $v0, 4    # print a message
  la $a0, msg2
  syscall
  add $s0,$zero, 100000
fun2loop:
  addi $s0, $s0, -1   # 1,2,3,4,...
  bne $s0,$zero fun2loop
  beq $zero,$zero, fun2

  .data
  msg1: .asciiz ".1."
  msg2: .asciiz ".2."

########################################














    .kdata
CURRENT:.word  QUEUE
QUEUE:
FCB1: .word REGS1
      .word FCB2
FCB2: .word REGS2
      .word FCB1
REGS1:  .space 128
REGS2:  .space 128

    .ktext 0x80000180
    .set noat
# context_switch:
  move $k1,$at
  la $k0,CURRENT
  move $at,$k1
  lw $k1,0($k0)
  lw $k1,0($k1)
# Save CURRENT To FCBx
  mfc0 $k0,$14
  sw $k0,0($k1)
  sw $1,4($k1)
  sw $2,8($k1)
  sw $3,12($k1)
  sw $4,16($k1)
  sw $5,20($k1)
  sw $6,24($k1)
  sw $7,28($k1)
  sw $8,32($k1)
  sw $9,36($k1)
  sw $10,40($k1)
  sw $11,44($k1)
  sw $12,48($k1)
  sw $13,52($k1)
  sw $14,56($k1)
  sw $15,60($k1)
  sw $16,64($k1)
  sw $17,68($k1)
  sw $18,72($k1)
  sw $19,76($k1)
  sw $20,80($k1)
  sw $21,84($k1)
  sw $22,88($k1)
  sw $23,92($k1)
  sw $24,96($k1)
  sw $25,100($k1)
  #sw $26,104($k1)
  #sw $27,108($k1)
  sw $28,112($k1)
  sw $29,116($k1)
  sw $30,120($k1)
  sw $31,124($k1)

  # reset timer
  li $t0, 100   # get a timer interrupt every second
  mtc0 $t0, $11 # set up compare register
  mtc0 $zero, $9

  # Context Switch
  la $k0,CURRENT
  lw $k1,0($k0)
  lw $k1,4($k1)
  sw $k1,0($k0)
  lw $k1,0($k1)

  lw $1,4($k1)
  lw $2,8($k1)
  lw $3,12($k1)
  lw $4,16($k1)
  lw $5,20($k1)
  lw $6,24($k1)
  lw $7,28($k1)
  lw $8,32($k1)
  lw $9,36($k1)
  lw $10,40($k1)
  lw $11,44($k1)
  lw $12,48($k1)
  lw $13,52($k1)
  lw $14,56($k1)
  lw $15,60($k1)
  lw $16,64($k1)
  lw $17,68($k1)
  lw $18,72($k1)
  lw $19,76($k1)
  lw $20,80($k1)
  lw $21,84($k1)
  lw $22,88($k1)
  lw $23,92($k1)
  lw $24,96($k1)
  lw $25,100($k1)
  #lw $26,104($k1)
  #lw $27,108($k1)
  lw $28,112($k1)
  lw $29,116($k1)
  lw $30,120($k1)
  lw $31,124($k1)

  lw $k0,0($k1)
  mtc0 $k0,$14

  mtc0 $zero $13  # Clear Cause register
  mfc0 $k0 $12    # Set Status register
  ori  $k0 0x1    # Interrupts enabled
  mtc0 $k0 $12
  eret
