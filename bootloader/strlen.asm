
%define BOOTLOADER
	
%ifdef BOOTLOADER
org 7c00h
%else
org 100h
%endif
	
section .data
msg db 'Hello here something ...', 0	
op equ 10h
op2 equ 1000h

section .bss
tmp resw 1

section .text
start:
	xor ax, ax
	;; mov ds, ax 
;	mov es, ax
	
	;mov ax, 000Eh
;	int 10h
	
	mov ah, 0FH  
   	int 10H  

    	mov ah, 0  
	int 10H  

	;; CRLF
	mov al, 0Dh
	call func_putc
	mov al, 0Ah
	call func_putc
	
	;; mov ax, msg
	;; call func_strlen

	
	mov ax, 3335h
	call Disp2ByteInHex
	
	mov ax, 3335h
	call Disp2ByteInHex_Reverse

	;; ;; CRLF
	;; mov al, 0Dh
	;; call func_putc
	;; mov al, 0Ah
	;; call func_putc

%ifdef BOOTLOADER
	;; ffff0h处只有一句跳转语句
	;; dosbox中是jmp f000:12c0
	;; 1.裸机上未实验
	;; 2.dosbox中会导致重启
	;; 3.vbox上也会导致无限重启
	;; jmp 0xffff:0000
%endif
	
	hlt
	jmp $
	
func_strlen:
	xor di, di
	xor dx, dx
	mov bp, ax
nextchar:
	mov dl, [bp + di]
	mov al, dl
	call func_putc
	cmp dl, 0
	je loopend
	inc di
	inc dh
	loop nextchar
loopend:
	xor ax, ax
	mov al, dh
	ret 

;; al
func_putc:
	mov ah, 0EH     ; 
	mov bx, 0007H   
	int 10h
	ret

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

Disp2ByteInHex:
	mov cx, 4
loopD2BIH:
	xor dx, dx
	mov [tmp], ax
	mov bx, op2
	div bx; [op2]
	;; div word  [op2] ;; 这样写始终由问题，奇怪，会导致除数为0还是。。。查看lst文件，应该是将常量直接当宏来文本替换了
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


shutdown:
	mov  AX,  5307h  
	mov  BX,  1  
	mov  CX,  3  
	int  15h

%ifdef BOOTLOADER	
times (512-($-$$) - 2)	db 0 
;;size equ $ - start
;;%if size+2 >512
;;%error "code is too large for boot sector"
;;%endif
db   0x55, 0xAA
%endif
