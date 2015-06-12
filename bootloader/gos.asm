
;;
;; 简单的高斯计算，累加而已
;;

org 7c00h

op equ 10h
op2 equ 1000h

section .bss
tmp resw 1

section .text
Start:
	mov ax, 1 ;; operand
	mov dx, 0 ;; sum
	mov cx, 100

ADD:
	add dx, ax
	inc ax
	loop ADD

PrintResult:
	mov si, msg
	call puts

	mov ax, dx
	call Disp2ByteInHex

End:
	jmp $

;; ----------------------------------------------------------------------
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

puts_2:
	mov dx, ax
	mov ah, 09h
	int 21h
	ret

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

msg db '1+2+3+4+...+100=0x'
crlf db 13, 10, 0	
;; ----------------------------------------------------------------------

times (512-($-$$) - 2)	db 0 
db   0x55, 0xAA          ;2 byte boot signature