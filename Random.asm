F_RandomSeed0_Get:
	lda		R_Seed0
	adc		TMR0
	tax
	lda		Table_RandomNum,x
	sta		R_Seed0
	rts

F_RandomSeed1_Get:
	lda		R_Seed1
	sbc		TMR0
	tax
	lda		Table_RandomNum,x
	sta		R_Seed1
	rts

F_RandomSeed2_Get:
	lda		R_Seed2
	adc		CC0
	tax
	lda		Table_RandomNum,x
	sta		R_Seed2
	rts

F_RandomSeed3_Get:
	lda		R_Seed3
	sbc		CC0
	tax
	lda		Table_RandomNum,x
	sta		R_Seed3
	rts

F_Display_Random_Rolling:
	bbr0	Random_Flag,L_No_Rolling
	bbr1	Random_Flag,L_No_Rolling

	rmb1	Random_Flag

	lda		Frame_Serial
	cmp		#5
	bcc		L_Phase1
	cmp		#17
	bcc		L_Phase2
	cmp		#41
	bcc		L_Phase3
	cmp		#65
	bcc		L_Phase4
	cmp		#89
	bcc		L_Phase5
	cmp		#113
	bcc		L_Phase6

	lda		#0
	sta		Frame_Counter
	sta		Frame_Serial
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		L_Dis_15Bit_DigitDot_Prog

L_No_Rolling:
	rts

	; 尚未将当前数字更新给a，需要试验
L_Phase1:
	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d0
	jsr		F_Dis_Animation_Frame
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
L_Phase2:
	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d0
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
L_Phase3:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d0
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
L_Phase4:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
L_Phase5:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
L_Phase6:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial


L_Div_2:
	ldx		#0
L_Div_2_Start:
	cmp		#2
	bcc		L_Div_2Over
	sec
	sbc		#2
	inx
	bra		L_Div_2_Start
L_Div_2Over:
	txa
	rts

L_Div_4:
	ldx		#0
L_Div_4_Start:
	cmp		#4
	bcc		L_Div_4Over
	sec
	sbc		#4
	inx
	bra		L_Div_4_Start
L_Div_4Over:
	txa
	rts


L_Mod_6:
	cmp		#6
	bcc		L_Mod_6Over
	sec
	sbc		#6
	bra		L_Mod_6
L_Mod_6Over:
	rts



Table_RandomNum:
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
	.byte	$7
	.byte	$8
	.byte	$9
	.byte	$0
	.byte	$1
	.byte	$2
	.byte	$3
	.byte	$4
	.byte	$5
	.byte	$6
