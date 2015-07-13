
;;
;; 简单的高斯计算，累加而已
;;

org 7c00h

%include "inc/io.inc"
	
xor ax, ax
mov ds, ax
mov es, ax
begin:
	;;cls ;; some bios does not clear the PCI devices informations left on the screen.
	mov si, menu
	call puts
	putc 13
putc 10
putc 'I'
init:
	getc
	cmp al, 13
	je .ParseKey ;; equal to init.ParseKey
	putc al
	mov ah, 0
	push ax	
	jmp init
.ParseKey:
	putc 13
	putc 10
	pop ax
	cmp al, 's' ;; Delete Key
	je Start
	cmp al, 'e'
	je .PowerOff
	cmp al, 'r'
	je .Reset
	cmp al, 'v'
	je .Version
	cmp al, 'c'
	je .Clear
	cmp al, 'm'
	je .Menu
	jmp init
.PowerOff:
	shutdown
.Clear:
	cls
	jmp init
.Version:
	call ShowVersion
	jmp init
.Reset:
	jmp 0xFFFF:0000
.Menu:
	mov si, menu
	call puts
	jmp init

DECLARE_IO_API

section .text
Start:
;;	cls
	
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
	
	mov si, crlf
	call puts

End:
	jmp begin
	;jmp $
;; ----------------------------------------------------------------------

msg db '1+2+3+4+...+100='
crlf db 13, 10, 0
hr db '------------------------------------------------------------', 13, 10, 0
version db 'Bootloader 0.1 by icecoobe', 13, 10, 0
menu db `1).m:this menu\r\n2).s:start\r\n3).e:poweroff\r\n4).r:Reset\r\n5).c:clear screen\r\n6).v:version`, 13, 10, 0
;; ----------------------------------------------------------------------

ShowVersion:
	mov si, hr
	call puts
	mov si, version
	call puts
	mov si, hr
	call puts
	ret

func_strlen:
	xor di, di
	xor dx, dx
	;; mov [length], ax
	mov bp, ax
.nextchar:
	;; add ax, bx
	mov dl, [bp+di]
	cmp dl, 0
	mov al, dl
	je .loopend
	inc di
	loop .nextchar
.loopend:
	xor ax, ax
	mov ax, di
	ret 

;times (512-($-$$) - 2)	db 0 
;db   0x55, 0xAA          ;2 byte boot signature
