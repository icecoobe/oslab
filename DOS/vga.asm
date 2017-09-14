;;----------------------------------------------------------------------
;; vga.asm
;;
;; 简易地设置显示模式为: 1280×1024×256 彩色

org 100h

section .data
	modeinfo db 'Set the disp mode to: 1280×1024×256 color$'
	crlf db 13,10,'$'
	
section .text
start:
	mov bx, 107H
	mov ax, 4f02h
	int 10h 
	
	mov ax, modeinfo
	call func_puts

end:
	;; return to DOS
	mov ah, 4ch
	int 21h
	
func_puts:
	mov dx, ax
	mov ah, 09h
	int 21h
	ret