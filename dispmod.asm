;; dispmode.asm
;; 设置显示模式兼有清屏功能
;;
;; [NOTE]
;; 1.对于超级VGA显示卡，我们可用AX＝4F02H和下列BX的值来设置其显示模式;
;; 2.本程序不支持液晶显示器.
;;
;; BX  显示模式 				属性
;;100H 640x400x256			色
;;101H 640x480x256			色
;;102H 800x600x16			色
;;103H 800x600x256			色
;;104H 1024x768x16			色
;;105H 1024x768x256			色
;;106H 1280x1024x16			色
;;107H 1280x1024x256		色
;;108H 80x60				文本模式
;;109H 132x25				文本模式
;;10AH 132x43				文本模式
;;10BH 132x50				文本模式
;;10CH 132x60				文本模式


org 100h

section .data
mode dw 100H ; 640×400×256 色
	dw 101H ; 640×480×256 色
	dw 102H ; 800×600×16 色
	dw 103H ; 800×600×256 色
	dw 104H ; 1024×768×16 色
	dw 105H ; 1024×768×256 色
	dw 106H ; 1280×1024×16 色
	dw 107H ; 1280×1024×256 色
	
	dw 108H ; 80x60		文本模式
	dw 109H ; 132x25	文本模式
	dw 10AH ; 132x43	文本模式
	dw 10BH ; 132x50	文本模式
	dw 10CH ; 132x60	文本模式
	
modestr:
	db '640x400x256 color', '$'
	db '640x480x256 color', '$'
	db '800x600x16 color', '$'
	db '800x600x256 color', '$'
	db '1024x768x16 color', '$'
	db '1024x768x256 color', '$'
	db '1280x1024x16 color', '$'
	db '1280x1024x256 color', '$'
	db '80x60 text', '$'
	db '132x25 text', '$'
	db '132x43 text', '$'
	db '132x50 text', '$'
	db '132x60 text', '$'
	
tips db 13,10,09,'Mode: $'

section .text
start:
	push cs
	pop ds
	;lea si,mode
	mov si, mode
again:
	mov bx,[si]
	or bx,bx
	jz quit
	
	mov ax,4f02h
	int 10h  
	
	;lea dx,tips
	mov dx, tips
	mov ah,9
	int 21h
	
	call show ;显示当前模式号
	mov di,30h ;画个矩形
	mov bp,30h  
	mov cx,18h  
	mov dx,18h  
Q1:
	mov ax,0c02h
	int 10h
	
	inc dx  
	dec bp  
	jnz Q1  
@11c:
	mov ah,0ch  
	int 10h  
	inc cx  
	dec di  
	jnz @11c  
@124:
	mov ah,0ch  
	int 10h  
	dec dx  
	cmp dx,18h  
	jnl @124  
@12f:
	mov ah,0ch  
	int 10h  
	dec cx  
	cmp cx,18h  
	jnz @12f  
	mov ah,0  
	int 16h  
	cmp al,1bh
	jz quit
	inc si
	inc si
	jmp again
quit:
	mov ax,0003  
	int 10h  
	mov ah,4ch  
	int 21h

show:
	push ax
	push bx
	push cx
	push bp
	mov ah,0fh
	int 10h
	mov bp,ax
	mov cx,4
next:
	rol bp,1
	rol bp,1
	rol bp,1
	rol bp,1
	mov ax,bp
	and al,0fh
	or al,30h
	cmp al,39h
	jbe Crt
	add al,7
Crt:
	mov ah,0eh
	mov bx,7
	int 10h
	loop next
	pop bp
	pop cx
	pop bx
	pop ax
	ret