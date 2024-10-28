;===========================================================
; LCD_RamAddr		.equ	0200H
;===========================================================
F_FillScreen:
	lda		#$ff
	bne		L_FillLcd
F_ClearScreen:
	lda		#0
L_FillLcd:
	sta		$1800
	sta		$1801
	sta		$1804
	sta		$1805
	sta		$1806
	sta		$1807
	sta		$180A
	sta		$180B
	sta		$180C
	sta		$180D
	sta		$1810
	sta		$1811
	sta		$1812
	sta		$1813
	sta		$1816
	sta		$1817
	sta		$1818
	sta		$1819
	sta		$181C
	sta		$181D
	sta		$181E
	sta		$181F
	sta		$1822
	sta		$1823

	rts


;===========================================================
;@brief		显示完整的一个数字
;@para:		A = 0~9
;			X = offset	
;@impact:	P_Temp，P_Temp+1，P_Temp+2，P_Temp+3, X，A
;===========================================================
L_Dis_15Bit_DigitDot_Prog:
	stx		P_Temp+2					; 偏移量暂存进P_Temp+2, 腾出X来做变址寻址

	clc
	rol									; 乘以2得到正确的偏移量
	tax
	lda		Table_Digit_15bit,x			; 将显示的数字通过查表找到对应的段码存进A
	sta		P_Temp+1					; 暂存段码值到P_Temp+1、P_Temp
	inx
	lda		Table_Digit_15bit,x
	sta		P_Temp

	lda		#15
	sta		P_Temp+3					; 设置显示段数为15
L_Judge_Dis_15Bit_DigitDot:				; 显示循环的开始
	ldx		P_Temp+2					; 表头偏移量->X
	lda		Lcd_bit,x					; 查表定位目标段的bit位
	sta		P_Temp+4					; bit位->P_Temp+4
	lda		Lcd_byte,x					; 查表定位目标段的显存地址
	tax									; 显存地址偏移->X
	ror		P_Temp						; 循环右移取得目标段是亮或者灭
	ror		P_Temp+1
	bcc		L_CLR_15bit					; 当前段的值若是0则进清点子程序
	lda		LCD_RamAddr,x				; 将目标段的显存的特定bit位置1来打亮
	ora		P_Temp+4
	sta		LCD_RamAddr,x
	bra		L_Inc_Dis_Index_Prog_15bit	; 跳转到显示索引增加的子程序。
L_CLR_15bit:	
	lda		LCD_RamAddr,x				; 加载LCD RAM的地址
	ora		P_Temp+4					; 将COM和SEG信息与LCD RAM地址进行逻辑或操作
	eor		P_Temp+4					; 进行异或操作，用于清除对应的段。
	sta		LCD_RamAddr,x				; 将结果写回LCD RAM，清除对应位置。
L_Inc_Dis_Index_Prog_15bit:
	inc		P_Temp+2					; 递增偏移量，处理下一个段
	dec		P_Temp+3					; 递减剩余要显示的段数
	bne		L_Judge_Dis_15Bit_DigitDot	; 剩余段数为0则返回
	rts


;-----------------------------------------
;@brief:	单独的画点、清点函数,一般用于MS显示
;@para:		X = offset
;@impact:	A, X, P_Temp+2
;-----------------------------------------
F_DispSymbol:
	jsr		F_DispSymbol_Com
	sta		LCD_RamAddr,x				; 画点
	rts

F_ClrpSymbol:
	jsr		F_DispSymbol_Com			; 清点
	eor		P_Temp+2
	sta		LCD_RamAddr,x
	rts

F_DispSymbol_Com:
	lda		Lcd_bit,x					; 查表得知目标段的bit位
	sta		P_Temp+2
	lda		Lcd_byte,x					; 查表得知目标段的地址
	tax
	lda		LCD_RamAddr,x				; 将目标段的显存的特定bit位置1来打亮
	ora		P_Temp+2
	rts


;============================================================

Table_Digit_15bit:
	.word	$7b6f	; 0
	.word	$4924	; 1
	.word	$73e7	; 2
	.word	$79e7	; 3
	.word	$49ed	; 4
	.word	$79cf	; 5
	.word	$7bcf	; 6
	.word	$4927	; 7
	.word	$7bef	; 8
	.word	$79ef	; 9
	.word	$0000	; undisplay
