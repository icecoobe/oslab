
org 07c00h

;; dispcard mem range: b800-bfff(32kb)
;; disp a char, we need 2 bytes
;; first byte: ascii code
;; second byte: KRGB IRGB
;; K: Blink; I: Highlight
mov ax, 0xb800
mov es, ax

mov byte [es:0000], 'H'
mov byte [es:0001], 0xF1 ;; bg: white fg: blue
mov byte [es:0002], 'e'
mov byte [es:0004], 'l'
mov byte [es:0006], 'l'
mov byte [es:0008], 'o'
mov byte [es:000ah], ' '
mov byte [es:000ch], 'W'

	mov ax, num
	mov bx, 10

	;;
	xor dx, dx
	div bx
	mov [num + 0], dl

	xor dx, dx
	div bx
	mov [num + 1], dl

	xor dx, dx
	div bx
	mov [num + 2], dl

	xor dx, dx
	div bx
	mov [num + 3], dl

	xor dx, dx
	div bx
	mov [num + 4], dl

	;;
	mov bx, 000eh
	mov si, 4

	mov al, [num + si]
	add al, '0'
	mov byte [es:bx], al
	add bx, 2
	dec si

	mov al, [num + si]
	add al, '0'
	mov byte [es:bx], al
	add bx, 2
	dec si

	mov al, [num + si]
	add al, '0'
	mov byte [es:bx], al
	add bx, 2
	dec si

	mov al, [num + si]
	add al, '0'
	mov byte [es:bx], al
	add bx, 2
	dec si

	mov al, [num + si]
	add al, '0'
	mov byte [es:bx], al
	add bx, 2
	dec si
	
	
jmp $

num db 0, 0, 0, 0, 0

times (512-($-$$) - 2)	db 0 
db   0x55, 0xAA          ;2 byte boot signature
