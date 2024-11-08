; 计算向上计数的动画帧
; a == 当前数字 || Frame_Counter帧计数
L_Frame_TableTrans_Up:
	clc
	rol
	tax
	sta		P_Temp
	lda		Table_Digit_15bit,x
	sta		Table_Digit_LByte
	inx
	lda		Table_Digit_15bit,x
	sta		Table_Digit_HByte

	lda		P_Temp						; 判断是否是从9->0
	cmp		#09
	bne		L_Target_NoOverflow_Up
	lda		#0
	tax
	bra		L_Target_get_Up
L_Target_NoOverflow_Up:
	inx
L_Target_get_Up:
	lda		Table_Digit_15bit,x
	sta		Target_Digit_LByte
	inx
	lda		Table_Digit_15bit,x
	sta		Target_Digit_HByte

	lda		Frame_Counter
	clc
	adc		#1
	jsr		L_Multiple_3				; n == (FC+1)*3
	sta		P_Temp

	sec
	sbc		#1							; m == n-1
	sta		P_Temp+1

	lda		Frame_Counter
	clc
	rol									; q == FC*2
	sta		P_Temp+2
	
L_TableTrans_Loop1_Up:
	clc
	ror		Table_Digit_HByte
	ror		Table_Digit_LByte
	dec		P_Temp
	lda		P_Temp
	bne		L_TableTrans_Loop1_Up

L_TableTrans_Loop2_Up:
	ror		Target_Digit_HByte
	ror		Target_Digit_LByte
	dec		P_Temp+1
	lda		P_Temp+1
	bne		L_TableTrans_Loop2_Up

	lda		P_Temp+2
	tax
	lda		Table_Digit_15bit_Mask_Up,x
	sta		P_Temp+4					; masklow
	inx
	lda		Table_Digit_15bit_Mask_Up,x
	sta		P_Temp+5					; maskhigh

	lda		Target_Digit_LByte
	and		P_Temp+4
	sta		Target_Digit_LByte
	lda		Target_Digit_HByte
	and		P_Temp+5
	sta		Target_Digit_HByte

	lda		P_Temp+4
	eor		#$ff
	sta		P_Temp+4
	lda		P_Temp+5
	eor		#$ff
	sta		P_Temp+5

	lda		Table_Digit_LByte
	and		P_Temp+4
	sta		Table_Digit_LByte
	lda		Table_Digit_HByte
	and		P_Temp+5
	sta		Table_Digit_HByte

	lda		Table_Digit_LByte
	ora		Target_Digit_LByte
	sta		Table_Digit_LByte
	lda		Table_Digit_HByte
	ora		Target_Digit_HByte
	sta		Table_Digit_HByte

	rts