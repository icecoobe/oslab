
org 100h;7c00h

section .data
msg db 'Hello here something ...', 0
op equ 10h
op2 equ 1000h

section .bss
tmp resw 1

section .text
start:
	xor ax, ax
;	mov ds, ax
;	mov es, ax
	
	;mov ax, 000Eh
;	int 10h
	
	mov ah, 0FH  
    int 10H  

    mov ah, 0  
    int 10H  

;	mov al, 'A';65
;	mov ah, 0EH     ; 显示字符
;	mov bx, 0007H   
;	int 10h
	;jmp $
	;jmp func_putc 
	;call Disp1ByteInHex

;	mov ax, msg
;	call func_strlen
	mov ax, 3335h
	call Disp2ByteInHex

	mov ax, 35h
	call Disp2ByteInHex_Reverse

	hlt

func_strlen:
	xor di, di
	xor dx, dx
nextchar:
	mov bp, ax
	mov dl, [bp + di]
	
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
	mov ah, 0EH     ; 显示字符
	mov bx, 0007H   
	int 10h
	ret

;; 对于子过程还需要继续实�? 目前的方法可能不是最佳的	
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
	call Disp4Bit
	mov ax, [tmp]
	shl ax, cl
	;cmp ax, 0
	;je loopendD2BIH
	;jmp loopD2BIH
	loop loopD2BIH
loopendD2BIH:
	ret

;; �?6进制显示1字节的数
;;
;; [输入]:
;;  al
;; [输出]:
;;  会改变ax, bx的内�?
Disp2ByteInHex_Reverse:
	mov cx, 4
loopproc:
	mov [tmp], ax ;dx, ax	
	div byte [op]
	mov al, ah
	call Disp4Bit
	mov ax, [tmp] ;ax, dx
	shr ax, cl
	;cmp ax, 0
	;je loopend2
	loop loopproc
loopend2:
	ret                                                       


;msg db 'Hello here something ...', 0

shutdown:
	mov  AX,  5307h  
	mov  BX,  1  
	mov  CX,  3  
	int  15h

times (512-($-$$) - 2)	db 0 
;;size equ $ - start
;;%if size+2 >512
;;%error "code is too large for boot sector"
;;%endif
db   0x55, 0xAA
