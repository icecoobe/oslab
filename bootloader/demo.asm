
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

end:
	jmp $

;; data section
;; NOTE: for bootloader, binary format object
;; donot use section .data, this will make wrong object size
;; refer to $ and $$
msg db 'Hello World!', 13, 10, 0
crlf db 13, 10

;; Footer of bootloader
FitBootloaderto512WithZero
ADDBOOTFLAG
;;-----------------------------------------------------------------------------
;; end of file
