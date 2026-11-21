.data
	cin: .asciiz "Nhap so n: "
	cout: .asciiz "Gia tri f(n) su dung fib_rec: "
.text
.globl main

main: 
	li $v0, 4
	la $a0, cin
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0
	
	li $v0, 4
	la $a0, cout
	syscall
	
	move $a0, $s1
	jal fib_rec
	move $t0, $v0
	li $v0, 1
	move $a0, $t0
	syscall
	
	
	li $v0, 10
	syscall
# fib_rec: Tinh F(n) bang de quy
# Tham so : $a0 = n    Tra ve : $v0 = F(n)
# Thanh ghi: 
#	+) $t0-$t2 	
fib_rec:
	
	bne $a0, $zero, else
	move $v0, $zero
	
	jr $ra
else:
	li $t1, 1
	bne $a0, $t1, else1
	move $v0, $t1
	
	jr $ra
else1:	
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	
	move $s0, $a0
	sw $s0, 0($sp)
	
	addi $a0, $s0, -1
	jal fib_rec
	lw $s0, 0($sp)
	move $t2, $zero
	add $t2, $t2, $v0
	sw $t2, 0($sp)
	
	addi $a0, $s0, -2
	jal fib_rec
	lw $t2, 0($sp)
	add $t2, $t2, $v0
	move $v0, $t2
	addi $sp, $sp, 4

	lw $t0, 0($sp)
	addi $sp, $sp, 4
	jr $t0
