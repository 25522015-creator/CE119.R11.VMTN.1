# $s0: Lưu dia chi mảng A chứa các mức cao nhất của từng bậc
# $s1: Lưu dia chi mảng B chứa các đơn giá của từng bậc
# $s2: Lưu giá trị mức cao nhất của bậc trước đó
# $s3: Lưu sô tiền điện
# $s4: Lưu biến đếm i
# $s5: Lưu x kwh

.data
	A_bac: .word 50, 100, 200, 300, 400, 9999
	B_gia: .word 1700, 1760, 2050, 2600, 2950, 3100
	CIN: .asciiz "Nhap so kWh (0..9999): "
	Error: .asciiz "Gia tri khong hop le, nhap lai\n"
	COUT1: .asciiz "Tien dien: "
	COUT2: . asciiz " dong\n" 
.text
.globl main
main: 
	la $s0, A_bac
	la $s1, B_gia
	li $s2, 0
	li $s3, 0
	li $s4, 0
	
ERROR:
	li $v0, 4
	la $a0, CIN
	syscall
	
	li $v0, 5
	syscall
	move $s5, $v0
	
	slti $t0, $s5, 10000
	bne $t0, $zero, ELSE
		li $v0, 4
		la $a0, Error
		syscall
	j ERROR
ELSE:
	move $t8, $s0
	move $t9, $s1

loop:
 	lw $t2, 0($t8)
 	
 	ble $s5, $t2, DONE
 		lw $t3, 0($t9)
 		
 		sub $t1, $t2, $s2
 		mult $t1, $t3
 		
 		mflo $t1
 		
 		add $s3, $s3, $t1
 		add $s2, $t2, $zero
 		addi $t8, $t8, 4
 		addi $t9, $t9, 4
 	j loop
 DONE:
 	sll $t0, $s4, 2
 	add $t1, $t0, $s1
 	lw $t3, 0($t1)
	
	sub $t1, $s5, $s2
 	mult $t1, $t3	
 	mflo $t1
 	
 	add $s3, $s3, $t1
 	
 	li $v0, 4
 	la $a0, COUT1
 	syscall
 	
 	li $v0, 1
 	move $a0, $s3
 	syscall
 	
 	li $v0, 4
 	la $a0, COUT2
 	syscall
 	
 	li $v0, 10
 	syscall
