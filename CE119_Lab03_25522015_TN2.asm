.data
	chuoi: .byte 0:100
	cout1: .asciiz "Nhap chuoi muon in: "
	cout2: .asciiz "Chuoi sau khi xu ly: "
.text
.globl main

main:
	li $v0, 4
	la $a0, cout1
	syscall
	
	li $v0, 8
	la $a0, chuoi
	li $a1, 100
	syscall
	
	la $a0, chuoi
	jal reverse_words
	
	li $v0, 4
	la $a0, cout2
	syscall
	
	li $v0, 4
	la $a0, chuoi
	syscall
	
	li $v0, 10
	syscall

# Thủ tục: reverse_words
# Tham số: $a0 = địa chỉ đầu chuỗi
# Thanh ghi $s sử dụng: $s0 (độ dài), $s1 (địa chỉ gốc),
#                       $s2 (vị trí đầu từ), $s3 (biến đếm i)
reverse_words:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)

	move $s1, $a0          
	jal strlen
	move $s0, $v0        

	addi $t0, $s0, 1
	srl $t0, $t0, 1
	
	li $t1, 0 
loop1: 
	bge $t1, $t0, end_loop1
	add $t2, $s1, $t1
	lb $t5, 0($t2)
	
	addi $t3, $s0, -1
	sub $t3, $t3, $t1 
	add $t3, $t3, $s1
	lb $t4, 0($t3)
	
	sb $t5, 0($t3)
	sb $t4, 0($t2)
	
	addi $t1, $t1, 1
	j loop1
end_loop1:
	
	li $s2, 0              
	li $s3, 0             
	addi $s0, $s0, 1       
loop2:
	bge $s3, $s0, end_loop2
	
	add $t2, $s1, $s3
	lb $t2, 0($t2)
	
	li $t5, 0x20           
	bne $t2, $t5, else1
		add $a0, $s2, $s1
		addi $t3, $s3, -1
		add $a1, $t3, $s1
		jal rev_range
		addi $s2, $s3, 1
else1:
	li $t6, 0x0A           
	bne $t2, $t6, else2
		add $a0, $s2, $s1
		addi $t3, $s3, -1
		add $a1, $t3, $s1
		jal rev_range
		addi $s2, $s3, 1
else2:
	addi $s3, $s3, 1 
	j loop2
end_loop2:
	lw $s3, 0($sp)
	lw $s2, 4($sp)
	lw $s1, 8($sp)
	lw $s0, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra                 

# Thủ tục: strlen (Hàm lá - Leaf procedure)
# Tham số: $a0 = địa chỉ đầu chuỗi
# Trả về:  $v0 = độ dài chuỗi (không tính '\n')
#Thanh ghi sử dụng: $t0-$t2
strlen:
	li $t0, 0
	li $t2, 10             
loop:
	add $t1, $a0, $t0
	lb $t1, 0($t1)
	beq $t1, $t2, end_loop
	addi $t0, $t0, 1
	j loop
end_loop:
	move $v0, $t0          
	jr $ra

# Thủ tục: rev_range (Hàm lá - Leaf procedure)
# Tham số: $a0 = địa chỉ đầu từ, $a1 = địa chỉ cuối từ
# Thanh ghi su dung: $t3, $t7, $t8
rev_range:
loop3:
	sub $t3, $a1, $a0
	ble $t3, $zero, end_loop3
	lb $t7, 0($a0)
	lb $t8, 0($a1)
	sb $t7, 0($a1)
	sb $t8, 0($a0)
	addi $a0, $a0, 1
	addi $a1, $a1, -1
	j loop3
end_loop3:
	jr $ra
