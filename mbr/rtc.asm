
;;=============================================================================
;; Gauss Calculation
;; 1 + 2 + 3 + ... + 100 = ?
;; We dont use gauss fomula (i.e. paring numbers)
;; Just use computer to calculate the addition which must be faster than Gauss.
;;=============================================================================

org 7c00h

%include "inc/io.inc"

init:
    jmp Start
    DECLARE_IO_API

section .text
Start:
	cls
	
	;; 指定索引 -- 0x04 “时”
	mov al, 0x84
	out 0x70, al
	xor ax, ax
	in al, 0x71
	call Disp2ByteInHex
	mov si, split
	call puts

	;; 指定索引 -- 0x02 “分”
	mov al, 0x82
	out 0x70, al
	xor ax, ax
	in al, 0x71
	call Disp2ByteInHex
	mov si, split
	call puts

	;; 指定索引 -- 0x00 “秒”
	mov al, 0x80
	out 0x70, al
	xor ax, ax
	in al, 0x71
	call Disp2ByteInHex
	mov si, split
	call puts

End:
	hlt
	jmp $
;;=============================================================================

split db ':', 0
;;=============================================================================

times (512-($-$$) - 2)	db 0 
db   0x55, 0xAA          ;2 byte boot signature
;;=============================================================================
