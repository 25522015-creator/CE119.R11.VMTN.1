#Thanh ghi $s0 được lưu địa chỉ của mảng Chuoi
#Thannh ghi $s2, $s3 lần lượt được lưu giá trị của ascii của '(' và ')'
#Thannh ghi $s4, $s5 lần lượt được lưu giá trị của ascii của '[' và ']'
#Thannh ghi $s6, $s7 lần lượt được lưu giá trị của ascii của '{' và '}'
.data
    Chuoi:    .byte 0:100
    .align 2
    Cin1:     .asciiz "Nhap chuoi: "
    Correct1: .asciiz "Chuoi hop le (0, 0)\n"
    Msg_Err:  .asciiz "Loi tai vi tri $v0 = "
    Msg_Code: .asciiz ", Ma loi $v1 = "
    Newline:  .asciiz "\n"

.text
.globl main

#Tham số đầu vào: Không có
#Giá trị trả về: Không có
#Công dụng: Điểm bắt đầu chương trình, nhập chuỗi, gọi kiểm tra ngoặc và in thông báo lỗi nếu chuỗi không hợp lệ
#Thanh ghi sử dụng:
#   $v0, $a0: Thực hiện các cuộc gọi hệ thống (syscall) nhập/xuất chuỗi và số
#   $a1: Quy định độ dài tối đa của chuỗi nhập vào
#   $s0: Lưu vị trí ký tự lỗi ($v0) nhận từ check_brackets để in ra
#   $s1: Lưu mã lỗi ($v1) nhận từ check_brackets để in ra
main:    
    li   $v0, 4
    la   $a0, Cin1
    syscall
    
    li   $v0, 8
    la   $a0, Chuoi
    li   $a1, 100
    syscall 

    la   $a0, Chuoi
    jal  check_brackets

    beq  $v1, $zero, print_correct

    move $s0, $v0      
    move $s1, $v1    

    li   $v0, 4
    la   $a0, Msg_Err
    syscall

    li   $v0, 1        
    move $a0, $s0
    syscall

    li   $v0, 4
    la   $a0, Msg_Code
    syscall

    li   $v0, 1        
    move $a0, $s1
    syscall

    li   $v0, 4
    la   $a0, Newline
    syscall

    j    exit_program

#Tham số đầu vào: Không có
#Giá trị trả về: Không có
#Công dụng: In thông báo chuỗi hợp lệ ra màn hình
#Thanh ghi sử dụng:
#   $v0, $a0: Thực hiện cuộc gọi hệ thống (syscall 4) để xuất chuỗi Correct1
print_correct:
    li   $v0, 4
    la   $a0, Correct1
    syscall

#Tham số đầu vào: Không có
#Giá trị trả về: Không có
#Công dụng: Kết thúc chương trình
#Thanh ghi sử dụng:
#   $v0: Chứa mã lệnh thoát chương trình (syscall 10)
exit_program:
    li   $v0, 10
    syscall

#Tham số đầu vào: $a0 = địa chỉ của chuỗi ký tự nhập vào
#Giá trị trả về:
#   $v0 = vị trí xảy ra lỗi (hoặc 0 nếu chuỗi hợp lệ)
#   $v1 = mã lỗi tương ứng (0: Hợp lệ, 1: Không cùng loại, 2: Stack rỗng, 3: Dư ngoặc mở)
#Công dụng: Duyệt chuỗi và kiểm tra tính hợp lệ của các cặp ngoặc (), [], {} sử dụng ngăn xếp Stack
#Thanh ghi sử dụng:
#   $a0: Chứa địa chỉ chuỗi đầu vào
#   $sp: Con trỏ ngăn xếp dùng để lưu/lấy các ngoặc mở
#   $ra: Lưu địa chỉ quay về sau khi thực thi thủ tục
#   $v0: Chứa giá trị trả về thứ nhất (vị trí lỗi hoặc 0)
#   $v1: Chứa giá trị trả về thứ hai (mã lỗi)
#   $s2, $s3: Lưu mã ASCII của '(' (40) và ')' (41)
#   $s4, $s5: Lưu mã ASCII của '[' (91) và ']' (93)
#   $s6, $s7: Lưu mã ASCII của '{' (123) và '}' (125)
#   $t0: Đếm vị trí ký tự hiện tại trong chuỗi (bắt đầu từ 1)
#   $t1: Lưu byte ký tự hiện tại đang được đọc từ chuỗi
#   $t2: Lưu mã ASCII của ký tự xuống dòng '\n' (10)
#   $t3: Lưu ký tự ngoặc mở vừa pop ra từ Stack để đối chiếu
#   $t5: Con trỏ duyệt qua từng byte ký tự trong chuỗi
#   $t9: Lưu giá trị con trỏ $sp ban đầu để kiểm tra Stack rỗng và khôi phục $sp khi thoát
check_brackets:
    
    move $t9, $sp 

    li   $s2, 40       
    li   $s3, 41       
    li   $s4, 91      
    li   $s5, 93       
    li   $s6, 123      
    li   $s7, 125      

    move $t5, $a0       
    li   $t0, 0        

loop_check:
    lbu  $t1, 0($t5) 
    beq  $t1, $zero, check_end_string
    li   $t2, 10        
    beq  $t1, $t2, check_end_string

    addi $t0, $t0, 1  

    beq  $t1, $s2, is_open_bracket
    beq  $t1, $s4, is_open_bracket
    beq  $t1, $s6, is_open_bracket
    j    check_close_bracket

is_open_bracket:
    addi $sp, $sp, -4
    sw   $t1, 0($sp)    
    j    next_char

check_close_bracket:
    beq  $t1, $s3, is_close_bracket
    beq  $t1, $s5, is_close_bracket
    beq  $t1, $s7, is_close_bracket
    j    next_char     

is_close_bracket:
    beq  $sp, $t9, err_stack_empty

    lw   $t3, 0($sp)
    addi $sp, $sp, 4

    beq  $t1, $s3, check_paren
    beq  $t1, $s5, check_square
    beq  $t1, $s7, check_curly

check_paren:
    bne  $t3, $s2, err_mismatch
    j    next_char

check_square:
    bne  $t3, $s4, err_mismatch
    j    next_char

check_curly:
    bne  $t3, $s6, err_mismatch
    j    next_char

next_char:
    addi $t5, $t5, 1  
    j    loop_check

check_end_string:
    bne  $sp, $t9, err_leftover_open

    li   $v0, 0
    li   $v1, 0
    j    func_return

err_mismatch:
    move $v0, $t0       
    li   $v1, 1         
    j    func_return

err_stack_empty:
 
    move $v0, $t0       
    li   $v1, 2      
    j    func_return

err_leftover_open:
 
    addi $v0, $t0, 1    
    li   $v1, 3      
    j    func_return

func_return:
    move $sp, $t9       
    jr   $ra