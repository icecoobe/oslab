
%include "inc/io.inc"

org  0x7c00

Entry:
	jmp Init ;; without this, the functions in below will be excuted!
	DECLARE_IO_API

Init:
;; 0x8000-0x8FFF
.setupstack:
	mov ax, 0x8000
	mov ss, ax
	mov sp, 0xFFFF

start:
	;; mov ax, 0x3412
	;; push ax
	;; mov ax, 0x7856
	;; call Disp2ByteInHex
	;; mov ax, sp
	;; call Disp2ByteInHex

	;; pop ax
	;; call Disp2ByteInHex
	;; mov ax, sp
	;; call Disp2ByteInHex

	mov ax, 0x4142
	;; push ax
	;; pop ax
	;; call Disp2ByteInHex
	push ax
	call func_putch
	pop ax

	push 0x6062
	call func_putch
	pop ax
End:
	jmp $

;; void func_putch(unsigned char c);
func_putch:
	;; pop ax
	push bp
	mov bp, sp
	sub sp, 0x4
	mov al, [bp + 4]
	mov ah, 0EH     
	mov bx, 0007H   
	int 10h
	add sp, 0x4
	pop bp
	ret

crlf db 0x0d, 0x0a
times 510-($-$$) db 0
db 0x55, 0xAA
