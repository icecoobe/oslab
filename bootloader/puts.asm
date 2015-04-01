
	org 07c00h
;; section .data
 	
section .text
start:
	xor ax, ax
	mov ds, ax
	mov es, ax

	;; mov ah, 0FH  
	;; int 10H  
	;; mov ah, 0  
	;; int 10H
	
	mov si, msg
	call puts
	jmp $
	
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


msg db 'kjhsdk', 13, 10, 0
 	crlf db 13, 10, 0	
	
times (512-($-$$) - 2)	db 0 
;;size equ $ - start
;;%if size+2 >512
;;%error "code is too large for boot sector"
;;%endif
db   0x55, 0xAA
