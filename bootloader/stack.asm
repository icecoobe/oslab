;; About func calling and so-called stack frame.
;;
;; <High address>
;;  ____________
;; |			|
;; |____________|
;; |            | <--- sp after return
;; |____________|___________________________________
;; |	p1		|									|
;; |____________|									|
;; |	p2		|									|
;; |____________|									O
;; |	p3		|									n
;; |____________|									e
;; |	...		|									|
;; |____________|									f
;; |	pn		|									r
;; |____________|									a
;; |	(CS)	|									m
;; |____________|									e
;; |	IP		| <--- sp before return				|
;; |____________|									|
;; |	org-bp	| <--- current bp points to here	|
;; |____________|									|
;; |	loc-1	|									|
;; |____________|									|
;; |	loc-2	|									|
;; |____________|									|
;; |    ...     |									|
;; |____________|									|
;; |    loc-n   | <--- current sp points to here	|
;; |____________|___________________________________|
;; |            |
;; |____________|
;;
;; 1) the one "sp before return" is return instruction pointer.
;; 2) executing a far call, cs will be pushed onto stack, too.

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
	mov ax, 0x4142
	push ax
	call func_putch
	;;pop ax

	push 0x6062
	call func_putch

End:
	jmp $

;; void __stdcall func_putch(unsigned char c);
func_putch:
	push bp
	mov bp, sp
	sub sp, 0x4
	mov al, [bp + 4] ;; param-1. During far call, use [bp + 6]
	mov ah, 0EH     
	mov bx, 0007H   
	int 10h
	add sp, 0x4
	pop bp
	ret 2	;; if ret n is used, we dont need fix stack after call.
			;; the params pushed before will be cleaned.

crlf db 0x0d, 0x0a
times 510-($-$$) db 0
db 0x55, 0xAA
