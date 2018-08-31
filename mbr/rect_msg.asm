;; rect_msg.asm
;;
;; draw a rectangle and print message inside it
;; tool: nasm, bochs | virtualbox
;; https://github.com/icecoobe
;;=============================================================================

bits 16

;;----- constant definitions -----
%define BASE 0x7c00

%define VGA_MODE_40x25_16color_text		00h
%define VGA_MODE_80x25_2color_text		07h
%define VGA_MODE_640x200_16color		0eh
%define VGA_MODE_640x480_256color		13h
;;=============================================================================

;;----- rectangle settings -----
%define rect_color  0x1C

%define rect_width  80h
%define rect_height 20h

%define p1.x        20h
%define p1.y        20h

%define p2.x        (p1.x + rect_width)
%define p2.y        p1.y

%define p3.x        (p1.x + rect_width)
%define p3.y        (p1.y + rect_height)

%define p4.x        p1.x
%define p4.y        (p1.y + rect_height)
;;=============================================================================

;;----- code snippets -----
;; set_vga_mode(VGA_MODE_XXXX_XXX)
%macro set_vga_mode 1
	mov ah, 0h
	mov al, %1	;; 显示器模式
	int 10h
%endmacro

;; set_pixel(byte color, byte pageNo, short x, short y)
%macro set_pixel 4
    mov al, %1
    mov bh, %2
    mov cx, %3
    mov dx, %4
    mov ah, 0Ch
    int 10h
%endmacro

;; puts(string, len)
%macro puts 2
	mov ax, %1		;; pointer to string
	mov bp, ax		;; ES:BP = address of string
	mov cx, %2		;; CX = length of string
	
    ;; Page NO.=0(BH = 0) 
    ;; bg:black, fg:red;
    ;; BL = 0Ch, highlight
	mov bx, 000ch

	mov dh, 5	;; start row
	mov dl, 6	;; start col

    mov ax, 01301h  ;; AH = 13,  AL = 01h
	int 10h
%endmacro
;;=============================================================================

org BASE

start:
	mov ax, cs
	mov ds, ax
	mov es, ax

    set_vga_mode VGA_MODE_640x200_16color


    mov bx, p1.x
.draw_p1p2:
    set_pixel rect_color, 0, bx, p1.y
    inc bx
    cmp bx, p2.x
    jne .draw_p1p2

    mov bx, p2.y
.draw_p2p3:
    set_pixel rect_color, 0, p2.x, bx
    inc bx
    cmp bx, p3.y
    jne .draw_p2p3

    mov bx, p3.x
.draw_p3p4:
    set_pixel rect_color, 0, bx, p3.y
    dec bx
    cmp bx, p4.x
    jne .draw_p3p4

    mov bx, p4.y
.draw_p4p1:
    set_pixel rect_color, 0, p4.x, bx
    dec bx
    cmp bx, p1.y
    jne .draw_p4p1

print:
    puts msg, msg_len

end:
    hlt
    jmp $
;;=============================================================================

msg db 'Hello World!'
msg_len equ ($-msg)
;;=============================================================================

times (512 - ($-$$) - 2) db 0
sign db 0x55, 0xAA
;;=============================================================================