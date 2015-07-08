
%macro DECLARE_IO_API 0

op equ 10h
op2 equ 1000h

section .bss
tmp resw 1

section .text
;; 以0作为字符串结束标志
puts:
	lodsb
	or al, al
	jz putsd

	mov ah, 0eh
	mov bx, 0007h
	int 10h

	jmp puts
putsd:
	retn
;; ----------------------------------------------------------------------

;; DOS 
;; puts_2
;; 串地址通过ax传递
puts_2:
	mov dx, ax
	mov ah, 09h
	int 21h
	ret
;; ----------------------------------------------------------------------

;; 输出al中保存的ascii码字符
;; al
func_putc:
	mov ah, 0EH     
	mov bx, 0007H   
	int 10h
	ret
;; ----------------------------------------------------------------------

;; 
Disp4Bit:
	cmp al, 0
	jae CMP_9
CMP_9:
	cmp al, 9
	jbe Disp09
	cmp al, 15
	jbe	DispAF
	ja	DispNG
Disp09:
	add al, '0'
	call func_putc
	ret
DispAF:
	sub al, 10
	add al, 'A'
	call func_putc
	ret
DispNG:
	mov al, 'N'
	call func_putc
	ret
;; ----------------------------------------------------------------------

Disp2ByteInHex:
	mov cx, 4
loopD2BIH:
	xor dx, dx
	mov [tmp], ax
	mov bx, op2
	div bx
	call Disp4Bit
	mov ax, [tmp]
	;; 保存循环执行次数cx的值
	mov dx, cx
	;; 置移位数值4
	mov cl, 4
	shl ax, cl
	mov cx, dx
	;cmp ax, 0
	;je loopendD2BIH
	;jmp loopD2BIH
	loop loopD2BIH
loopendD2BIH:
	ret
;; ----------------------------------------------------------------------

%endmacro

;; 清屏操作
;; 入口参数: 无
;; 返回值: 无
%macro cls 0
	mov ax, 0003H
	int 10H	
%endmacro

;; 关闭计算机
;; 入口参数: 无
;; 返回值: 无
%macro shutdown 0
	mov  ax,  5307h  
	mov  bx,  1  
	mov  cx,  3  
	int  15h
%endmacro

;; 显示一个字符
;; 入口参数: 要显示的字符
;; 返回值: 无
;; Example:
;; putc 'a'
;; putc `\'`
%macro putc 1
	mov al, %1
	mov ah, 0EH     
	mov bx, 0007H   
	int 10h
%endmacro

;; 输入一个字符
;; 入口参数: 无 
;; 返回值: al, 输入的字符 
%macro getc 0
	mov ah, 0h    
	int 16h
%endmacro

%macro puts 2
	mov ax, %1		;; pointer to string
	mov bp, ax		;; ES:BP = 串地址
	mov cx, %2		;; CX = 串长度
	mov ax, 01301h  ;; AH = 13,  AL = 01h
	mov bx, 000ch	;; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
	mov dh, 5	;; start row
	mov dl, 0	;; start col
	int 10h
%endmacro

;; End of file
