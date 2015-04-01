
%define BOOTLOADER
	
%ifdef BOOTLOADER
org 7c00h
%else
org 100h
%endif
	
;; section .data
	msg db 'Hello here something ...', 0

section .bss
	length resw 1
	tmp resw 1
	
op equ 10h
op2 equ 1000h

section .text
start:
	xor ax, ax

%ifdef BOOTLOADER	
	;; mov ds, ax 
	;; mov es, ax
%endif

	mov ax, 000Eh
	int 10h
	
	;; CRLF
	mov al, 0Dh
	call func_putc
	mov al, 0Ah
	call func_putc
	
	mov ax, msg
	call func_strlen
	call Disp2ByteInHex	
	

	;; CRLF
	mov al, 0Dh
	call func_putc
	mov al, 0Ah
	call func_putc
	
	hlt
	jmp $
	
func_strlen:
	xor di, di
	xor dx, dx
	;; mov [length], ax
	mov bp, ax
nextchar:
	;; add ax, bx
	mov dl, [bp+di]
	cmp dl, 0
	je loopend
	inc di
	loop nextchar
loopend:
	xor ax, ax
	mov ax, di
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


%ifdef BOOTLOADER	
times (512-($-$$) - 2)	db 0 
;;size equ $ - start
;;%if size+2 >512
;;%error "code is too large for boot sector"
;;%endif
db   0x55, 0xAA
%endif
