
;; 开启 A20 地址线
;; 入口参数: 无
;; 返回: 无
;; 备注：
;; 这是利用 ICH 端口快速开启 A20 的方式；
;; 旧版采用键盘控制器中一个端口
%macro Enable_A20   0
    in al, 0x92         ;; ICH I/O port 
    or al, 0000_0010B
    out 0x92, al        ;; 打开A20
%endmacro

;; 开启保护模式 cr0.PE=1
;; 入口参数: 无
;; 返回: 无
%macro Enable_ProtectMode    0
    mov eax, cr0
    or eax, 1
    mov cr0, eax
%endmacro