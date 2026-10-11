# $s0: Luu dia chi mang Cao_do chua chi so cao do cua 15 not
# $s1: Luu dia chi mang Do_dai chua do dai cua 15 not
# $s3: Luu bien dem i
# $s4: Luu tong thoi gian du kien
# $s5: luu do dai don vi nhip
# $t5: Luu do lon cua 2 mang
# $t0: Luu i*4
# $t1: Luu lan luot dia chi Cao_do[i] va Do_dai[i] trong 1 vong lap
# $t2: Luu gia tri Cao_do[i]
# $t3: Luu gia tri Do_dai[i]

.data
	Cao_do: .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
	Do_dai: .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
	space: .asciiz " "
	down: .asciiz "\n"
	COUT1: .asciiz "Tong du kien (ms): "
	COUT2: .asciiz "\nThoi gian do duoc (ms): "
.text
.globl main
main:
	la $s0, Cao_do
	la $s1, Do_dai
	li $s3, 0
	li $s4, 0
	li $s5, 160
	li $t5, 15
	li $v0, 30
	syscall
	move $t6, $a0
loop:
	beq $s3, $t5 Done
		sll $t0, $s3, 2
		add $t1, $t0, $s0
		lw $t2, 0($t1)
		
		add $t1, $t0, $s1
		lw $t3, 0($t1)
		
		li $v0, 1
		move $a0, $t2
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		li $v0, 1
		move $a0, $t3
		syscall
		
		li $v0, 4
		la $a0, down
		syscall
		
		mult $t3, $s5
		mflo $t0
		
		add $s4, $s4, $t0
		
		li $v0, 33
		move $a0, $t2
		move $a1, $t0
		li $a2, 24
		li $a3, 100
		syscall
		
		#li $v0, 32
		#move $a0, $t0
		#syscall
		
		addi $s3, $s3, 1
	j loop
Done:
	li $v0, 30
	syscall
	sub $t6, $a0, $t6
	
	li $v0, 4
	la $a0, COUT1
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall

	li $v0, 4
	la $a0, COUT2
	syscall
	
	li $v0, 1
	move $a0, $t6
	syscall	
	li $v0, 10
	syscall
