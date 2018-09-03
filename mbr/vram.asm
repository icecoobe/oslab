;;=============================================================================
;; vram.asm
;;
;; A sample to show how to operate video ram to print text.
;;
;; video mem range: b8000-bffff (32kb)
;; to print a character, we need 2 bytes as following:
;; - 1st byte: ascii code
;; - 2nd byte: KRGB IRGB (K: Blink; I: Highlight)
;;=============================================================================

[bits 16]

;;=============================================================================
;; Constants
;;=============================================================================
%define BASE                0x7C00
%define VRAM_SEGMENT_BASE   0xB800

org BASE

start:
    mov ax, cs
    mov ds, ax

    ;; clear screen
    mov ax, 0x0003
    int 0x10

    mov ax, VRAM_SEGMENT_BASE
    mov es, ax
    mov si, msg
    mov di, 30          ;; print char from 15th column of screen(80*25).
    mov cx, msg_len
    rep movsb

end:
    jmp $

;;=============================================================================
;; Data for output
;;=============================================================================
msg db 'H', 0xA4, 'e', 0x13, 'l', 0x52, 'l', 0xB1, 'o', 0xCC
msg_len equ ($ - msg)

;;=============================================================================
;; Padding & Signature
;;=============================================================================
times (512 - ($-$$) - 2) db 0
signature db 0x55, 0xAA