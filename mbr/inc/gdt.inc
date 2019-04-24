
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

; 宏descriptor有三个参数
; 第一个是段描述符的基地址
; 第二个是界限值
; 第三个是属性
%macro GDT_Descriptor 3
    dw (%2) & 0ffffh                   ;界限值0-15位
    dw (%1) & 0ffffh                   ;基地址0-15位
    db ((%1) >> 16) & 0ffh             ;基地址16-23位
    dw (((%2) >> 8) & 0f00h) | (%3)    ;界限值16-19位，和段属性
    dw ((%1) >> 24) & 0ffh             ;基地址24-31位
%endmacro

;前缀SA_表示Segment Attribute
;; Bit: G
SA_BYTES equ 0 << 15  ;段粒度：字节
SA_PAGES equ 1 << 15  ;段粒度：页 4k

;; Bit: D/B
SA_16BIT equ 0 << 14  ;16位段
SA_32BIT equ 1 << 14  ;32位段

;; Bit: P
SA_ABSENT equ 0 << 7  ;不存在
SA_PRESENT equ 1 << 7  ;存在

;段特权级 0-3
SA_DPL_0 equ 0 << 5
SA_DPL_1 equ 1 << 5
SA_DPL_2 equ 2 << 5
SA_DPL_3 equ 3 << 5

;; L, AVL, S
;; Type