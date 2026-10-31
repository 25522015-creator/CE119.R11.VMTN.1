#Thanh ghi $s0 dùng để lưu địa chị mảng grade_tab
#Thanh ghi $s1 dùng để lưu địa chỉ mảng hist
#Thang ghi $s2 dùng để lưu địa chỉ mảng Diem
.data 
	grade_tab: .byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x02, 0x02, 0x03, 0x03
	.align 2
	hist: .word 0x0, 0x0, 0x0, 0x0
	.align 2
	Diem: .word 0:100
	Cin1: .asciiz "Nhap so luong sinh vien: "
	Cin2: .asciiz "Nhap diem cua hoc: "
	Cout1: .asciiz "min = "
	Cout2: .asciiz " max = "
	Cout3: .asciiz "\n"
	Cout4: .asciiz "g"
	Cout5: .asciiz " = "
	Cout6: .asciiz " "
	Cout7: .asciiz ": "
	Cout8: .asciiz "| "
.text
main:
	la $s0, grade_tab
	la $s1, hist
	la $s2, Diem
	
	li $v0, 4
	la $a0, Cin1
	syscall
	
	li $v0, 5
	syscall
	move $s3, $v0
	jal Input
	jal Hist
	jal Min_Max
	
	li $v0, 4
	la $a0, Cout1
	syscall
			
	li $v0, 1
	move $a0, $t4
	syscall
	
	li $v0, 4
	la $a0, Cout2
	syscall
			
	li $v0, 1
	move $a0, $t5
	syscall
	
	li $v0, 4
	la $a0, Cout3
	syscall
	
	
	li $v0, 10
	syscall
#Tham số đầu vào: Mảng điểm và só lượng học sinh
#Trả về mảng đã được nhập điểm
#Các thanh ghi sử dụng: 
#$t0 dùng để lưu mảng điểm
#$t1 dùng để lưu số lượng sinh viên
#$v0 và $a0 dùng để kết hợp với syscall dùng để xuất string và nhập giá trị
#$zero dùng làm đối số trong lệnh beq
Input: 
	move $t0, $s2
	move $t1, $s3
	loop:
		beq $t1, $zero, end_loop
			li $v0, 4
			la $a0, Cin2
			syscall
			
			li $v0, 5
			syscall
			sw $v0, 0($t0)
			
			addi $t0, $t0, 4
			addi $t1, $t1, -1
			j loop
	end_loop:
	jr $ra
#Tham số đầu vao: Mảng điểm, mảng grade_tab, mảng Hist, số lượng học sinh, địa chỉ của lệnh kế tiếp sau khi sử dụng jal Hist
#Trả về mảng Hist và đồng thới xuất mảng Hist bằng thủ tục draw_hist
#Thanh ghi được sử dụng:
#$a0 lưu mảng điểm
#$a1 lưu số lượng sinh viên
#$a2 lưu mảng grade_tab
#$a3 lưu mảng hist
#$t4 dùng lưu giá trị phần tử trong các mảng và sau đó được trong lw để lưu vào mảng hist
#$t6 lưu địa chỉ lệnh kế tiếp
#$zero dùng làm đối só trong lênh beq

Hist:
	move $a0, $s2
	move $a1, $s3
	move $t6, $ra
	loop2: 	
		beq $a1, $zero, end_loop2
			move $a2, $s0
			move $a3, $s1
			
			lw $t4, 0($a0)
			add $a2, $a2, $t4
			lb $t4, 0($a2)
			
			sll $t4, $t4, 2
			add $a3, $a3, $t4
			lw $t4, 0($a3)
			
			addi $t4, $t4, 1
			sw $t4, 0($a3)
			
			addi $a0, $a0, 4
			addi $a1, $a1, -1
			j loop2
	end_loop2:
	jal draw_hist
	jr $t6

#Tham số đầu vào mảng điểm và số lượng học sinh
#Trả về giá trị điểm cao nhât và thấp nhât trong mảng điểm
#Thanh ghi được sử dụng:
#$a0 lưu mảng điểm
#$a1 lưu số lượng sinh viên
#$t2 dùng để lưu phần tử trong mảng điểm trong khi duyệt
#$t4 và $t5 lần lượt được dùng để lưu min và max
#$zero dùng làm đối số trong lênh beq

Min_Max:
	move $a0, $s2
	move $a1, $s3
	lw $t4, 0($a0)
	lw $t5, 0($a0)
	loop3:
		beq $a1, $zero, end_loop3
			lw $t2, 0($a0)
			ble $t2, $t4 Else
				j end
			Else:
				move $t4, $t2
			end:
			ble $t2, $t5 Else1
				move $t5, $t2
			Else1:
			addi $a0, $a0, 4
			addi $a1, $a1, -1
		j loop3
		end_loop3:
	jr $ra

#Tham số đầu vào: Mảng Hist và địa chỉ câu lệnh kế tiếp sau khi thực hiện jal draw_hist
#Thủ tục không trả về giá trị, mà chỉ biểu diễn số lượng các học sinh thuộc mỗi nhóm trên mars massage
#Các thanh ghi được sử dụng:
#$a0 lưu mảng điểm
#$t0 dùng để lưu địa chỉ mảng điểm (nhầm để tránh việc giá trị trong $a0 bị thay đổi khi sử dụng syscall)
#$t1 Lưu giá trị phần tử trong mảng Điểm
#$t5 lưu địa chỉ lệnh kế tiếp
#$v0 và $a0 đườc kèm với syscall để xuất ra mars massage
#$zero dùng làm đối số trong lệnh beq

draw_hist:
	move $a0, $s1
	li $a1, 4
	li $a2, 0 
	move $t0, $a0
	move $t5, $ra
	loop4:
		beq $a1, $zero, end_loop4
			li $v0, 4
			la $a0, Cout4 
			syscall
			
			li $v0, 1
			move $a0, $a2
			syscall
			
			li $v0, 4
			la $a0, Cout7
			syscall
			 
			lw $t1, 0($t0)
			
			jal draw
			
			addi $t0, $t0, 4
			addi $a1, $a1, -1
			addi $a2, $a2, 1
		j loop4
	end_loop4:
	jr $t5

#Tham số đầu vào: giá trị phần tử trong mảng hist được lưu trong thanh ghi $t1
#giá trị trả về: không có giá trị trả về, mà chỉ hổ trợ thủ tục draw_hist để biểu diễn mảng hist trên mars massage
#Các thanh ghi được sử dụng:
#$t1 lưu giá trị phần tử thứ i của mảng hist
#$a0, $v0 được dung kết hợp với syscall để xuất ra mars massage
#$ra dùng để lưu địa chỉ lệnh kế tiếp sau khi thực hiện jal draw
		
draw:
	loop5:
		beq $t1, $zero, end_loop5
			li $v0, 4
			la $a0, Cout8
			syscall
			
			addi $t1, $t1, -1
		j loop5
	end_loop5:
	li $v0, 4
	la $a0, Cout3
	syscall
	
	jr $ra
