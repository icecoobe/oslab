
;; vga.inc
;; vga settings

%define VGA_MODE_40x25_16color_text		00h
%define VGA_MODE_80x25_2color_text		07h
%define VGA_MODE_640x200_16color		0eh
%define VGA_MODE_640x480_256color		13h
;; (continue ...)

%macro set_vga_mode 1
	mov ah, 0h
	mov al, %1	;; 显示器模式
	int 10h
 %endmacro
