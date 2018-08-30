
org 6000h


row resb 1 ;
col resb 1 ;

start:
	;; 将DS ES与CS保持一致, 指向相同的段
	;; 在数据操作时候, 能够正确定位到.
	mov ax, cs
	mov ds, ax
	mov es, ax

	;; 640x200 彩色EGA模式
	;mov ax, 000Eh
	;int 10h
	
	mov al, 32
	call Disp1ByteInHex
	call dispdate
	
	mov byte [row], 10h
	mov byte [col], 10h
	
	mov ch, 0h
	mov cl, 7h
	mov ah, 1
	int 10h
	
	call movecursor
inkey:
	mov ah,0
	int 16H ;调用BIOS中断,获取键盘扫描码

	cmp ah, 48H ;方向键"上"的通码
	jz up ;如果按下"上",跳转到"up"
	
	cmp ah, 50H ;方向键"下"的通码
	jz down
	
	cmp ah, 4Bh
	jz left
	
	cmp ah, 4Dh
	jz right
	
	;; 在光标位置显示字符al
	mov cx, 1
	mov bh, 0
	mov ah, 0ah
	int 10h
	
	;cmp ah, 1CH ;回车的通码
	;;jz enter ;同理
	jmp inkey ;;short inkey
up:
	sub byte [row], 1
	call movecursor
	jmp inkey
down:
	add byte [row], 1
	call movecursor
	jmp inkey
left:
	sub byte [col], 1
	call movecursor
	jmp inkey
right:
	add byte [col], 1
	call movecursor
	jmp inkey
	
;; func_puts
;; ax: 字符串的首地址
;; cx: 长度
func_puts:
	mov bp, ax   		; ES:BP = 串地址
	;;mov cx, 12   		; CX = 串长度
	mov ax, 1301h  		; AH = 13,  AL = 01h
	;;mov bx, 000ch  	; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
	mov bx, 00AFh  		; 页号为0(BH = 0) 绿底白字(BL = AFh,高亮)
	mov dl, 0
	int 10h   			; 10h 号中断
	ret	

;; al
func_putc:
	mov ah, 0EH     ; 显示字符
	mov bx, 0007H   
	int 10h
	ret

;; movecursor
;; dh: row
;; dl: col
movecursor:
	mov dh, [row]
	mov dl, [col]
	mov bh, 0
	mov ah, 02h
	int 10h
	ret

;; 对于子过程还需要继续实验, 目前的方法可能不是最佳的	
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

;; 以16进制显示1字节的数
;;
;; [输入]:
;;  al
;; [输出]:
;;  会改变ax, bx的内容
Disp1ByteInHex:	
	mov bl, al
	xor ax, ax
	mov al, bl
	mov bl, 16
	div bl
	mov bh, ah
	call Disp4Bit
	mov al, bh
	call Disp4Bit
	ret

dispdate:
	mov ah, 04h
	int 1Ah
	mov al, CH
	call Disp1ByteInHex
	mov al, CL
	call Disp1ByteInHex
	mov al, DH
	call Disp1ByteInHex
	mov al, DL
	call Disp1ByteInHex
	ret
	
times (512-($-$$) - 2)	db 0 
;;size   equ $ - start
;;%if size+2 >512
;;%error "code is too large forboot sector"
;;%endif
db   0x55, 0xAA          ;2 byte boot signature	`
	