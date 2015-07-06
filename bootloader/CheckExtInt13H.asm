
;; We are bootloader
%define BOOTLOADER


%include "inc/env.inc"
%include "inc/io.inc"
%include "inc/vga.inc"

org ORG_ADDRESS

entry:
	jmp start ;; without this, the functions in below will be excuted!
	DECLARE_IO_API

;; main proc
start:
	set_vga_mode VGA_MODE_80x25_2color_text
	mov si, msg
	call puts
	call CheckExtInt13H
end:
	mov si, msgProgramEnd
	call puts
	jmp $

CheckExtInt13H:
	mov ah, 0x41		;           功能号是 41H
	mov bx, 0x55aa;         入口参数之一
	mov dl, 0x80	;             第二个参数表示要测试的 驱动器， 80H 是第一块硬盘，则81H是第二块……
	int 13h
	cmp bx, 0xaa55;        如果存在扩展 13H 功能，则bx==AA55H
	jz Surpportted
NotSurpportted:
	mov si, msgNoturpportExtInt13H
	call puts
	ret
Surpportted:
	mov si, msgSurpportExtInt13H
	call puts
	ret

;; data section
;; NOTE: for bootloader, binary format object
;; donot use section .data, this will make wrong object size
;; refer to $ and $$
msg db 'Hello World!', 13, 10, 0
msgSurpportExtInt13H db 'Surpport extended int 13h!', 13, 10, 0
msgNoturpportExtInt13H db 'Not Surpport extended int 13h!', 13, 10, 0
msgProgramEnd db 'Program terminated.', 13, 10, 0
crlf db 13, 10

;; Footer of bootloader
FitBootloaderto512WithZero
ADDBOOTFLAG
;;-----------------------------------------------------------------------------
;; end of file
