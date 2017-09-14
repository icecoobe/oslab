
;; 汇编环境下, 开发者必须是已知CPU字节序的处理方式
;; so, 本代码无效

org 100h

section .data
	bInfo db 'Big Endian!', 13, 10, '$'
	lInfo db 'Little Endian!', 13, 10, '$'
	crlf db 13,10,'$' ;; 回车换行
	
section .bss
	
section .text
start:
	mov ax, 0x1
	cmp al, 1
	jnz littleendian ;; not qeual
bigendian:
	mov ax, bInfo
	jmp end

littleendian:
	mov ax, lInfo

end:	
	mov dx, ax
	mov ah, 09h
	int 21h
	
	;; RETURN TO DOS
	mov ah, 4Ch
	int 21h