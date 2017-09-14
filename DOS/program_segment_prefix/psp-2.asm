
;;----------------------------------------------------------------------
;; psp-2.asm
;;
;; 打印命令行参数个数和参数内容
;; 主要练习: 以16进制显示一个数值
;;----------------------------------------------------------------------

org 100h

%include "printreg.h"
	
section .text
start:
	mov ax, hr
	call func_puts
	
	mov ax, info1
	call func_puts
	
	mov ax, argcInfo
	call func_puts
	xor cx, cx
	mov cl, [80h]
	mov al, cl
	call Disp1ByteInHex;Disp4Bit
	mov ax, crlf
	call func_puts
	
	mov ax, argvInfo
	call func_puts
	
	;; 在执行循环之前, 必须要检测cx是否已经为0
	;; loop循环如下: 参考Intel手册
	;; do
	;; { 
	;;	dosomthing();
	;;	cx--;
	;; } while (cx != 0);
	
	;; 当参数个数是0的时候,ch部分是0d(就是命令行参数的结束部分,回车|换行)
	;; 所以不能以cx与0比较
	;; cx: 0d00
	cmp cl, 0
	je endLoop
	
	mov di, 1		;; 略过80h,从下标1开始
readpsp:
	xor ax, ax
	mov al, [80h+di]
	;; 结束方案-1
	;; 利用PSP部分的特征,读取到'0d'作为结束
	;cmp al, 0D		;; [NOTE-2]
	;je end
	call func_putc
	
	;add di, 2 		;; 上述部分一次读取两个字节，所以不需要这样每次以一个字节为单位来操作
	inc di
	loop readpsp
	
	mov ax, crlf
	call func_puts
	
endLoop:
	mov ax, hr
	call func_puts
	
	xor ax, ax
	mov al, 15
	call Disp4Bit
	
end:
	mov ax, crlf
	call func_puts
	
	mov ax, hr
	call func_puts
	
	MOV AX, info2
	CALL func_puts
	
	;; RETURN TO DOS
	MOV AH, 4CH
	INT 21H
	
	
func_putc:
	MOV DL, AL
	Mov ah, 2	; single char use
	int 21h
	ret

func_puts:
	mov dx, ax
	mov ah, 09h
	int 21h
	ret

;; 对于子过程还需要继续实验, 目前的方法可能不是最佳的	
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
	call putc
	ret
DispAF:
	sub al, 10
	add al, 'A'
	call putc
	ret
DispNG:
	mov al, 'N'
	call putc
	ret

;; 以16进制显示1字节的数
;;
;; [输入]:
;;  al
;; [输出]:
;;  会改变ax, bx的内容
Disp1ByteInHex:	
	mov bl, al
	xor ax, ax
	mov al, bl
	mov bl, 16
	div bl
	mov bh, ah
	call Disp4Bit
	mov al, bh
	call Disp4Bit
	ret
