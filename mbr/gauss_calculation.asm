
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
;;=============================================================================

msg db '1+2+3+4+...+100=0x', 0
;;=============================================================================

times (512-($-$$) - 2)	db 0 
db   0x55, 0xAA          ;2 byte boot signature
;;=============================================================================
