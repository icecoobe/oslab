
;;; print_hex.asm
;;; 
;;; 1.以16进制显式数字
;;; 2.包含正向、逆向顺序显式
;;; 3.只能是两个字节以内的数值
;;;
	
%define BOOTLOADER
	
%ifdef BOOTLOADER
org 7c00h
%else
org 100h
%endif
	
op equ 10h
op2 equ 1000h

section .bss
tmp resw 1

section .text
start:
	xor ax, ax

;; DOS环境下，cs ds 等均一致，且非0
%ifdef 	BOOTLOADER
	mov ds, ax 
	mov es, ax
%endif
	
	mov ax, 3335h
	call Disp2ByteInHex

	;; CRLF
	mov al, 0Dh
	call func_putc
	mov al, 0Ah
	call func_putc
	
	mov ax, 3335h
	call Disp2ByteInHex_Reverse

	;; CRLF
	mov al, 0Dh
	call func_putc
	mov al, 0Ah
	call func_putc

%ifdef BOOTLOADER
	;; ffff0h处只有一句跳转语句
	;; dosbox中是jmp f000:12c0
	;; 1.裸机上未实验
	;; 2.dosbox中会导致重启
	;; 3.vbox上也会导致无限重启
	;; jmp 0xffff:0000
%endif

End:
	hlt
	jmp $

;; ----------------------------------------------------------------------
;; al
func_putc:
	mov ah, 0EH     ; 
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
Disp2ByteInHex_Reverse:
	mov cx, 4
loopproc:
	xor dx, dx
	mov [tmp], ax
	;; 16位除法时候会触发#DE Devide Error
	mov bx, op
	div bx
	mov ax, dx
	call Disp4Bit
	mov ax, [tmp]
	mov dx, cx
	mov cl, 4
	shr ax, cl
	mov cx, dx
	;cmp ax, 0
	;je loopend2
	loop loopproc
loopend2:
	ret                                                       

;; ----------------------------------------------------------------------
;;; MBR尾部标志处理
%ifdef BOOTLOADER	
times (512-($-$$) - 2)	db 0 
;;size equ $ - start
;;%if size+2 >512
;;%error "code is too large for boot sector"
;;%endif
db   0x55, 0xAA
%endif
