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
	bcs		L_No_Phase1
	jmp		L_Phase1
L_No_Phase1:
	cmp		#17
	bcs		L_No_Phase2
	jmp		L_Phase2
L_No_Phase2:
	cmp		#41
	bcs		L_No_Phase3
	jmp		L_Phase3
L_No_Phase3:
	cmp		#65
	bcs		L_No_Phase4
	jmp		L_Phase4
L_No_Phase4:
	cmp		#89
	bcs		L_No_Phase5
	jmp		L_Phase5
L_No_Phase5:
	cmp		#113
	bcs		L_No_Phase6
	jmp		L_Phase6
L_No_Phase6:
	lda		#0
	sta		Frame_Counter
	sta		Frame_Serial
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		L_Dis_15Bit_DigitDot_Prog

L_No_Rolling:
	rts


L_Phase1:
	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed0
	ldx		#lcd_d0
	jsr		F_Dis_Animation_Frame
	lda		R_Seed1
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame
	lda		R_Seed2
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
	lda		Frame_Serial
	cmp		#0
	bne		L_Phase1_NoCarry
	inc		R_Seed0
	lda		R_Seed0
L_Phase1_NoCarry:
	rts
L_Phase2:
	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed0
	ldx		#lcd_d0
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed1
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame
	lda		R_Seed2
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
	rts
L_Phase3:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed0
	ldx		#lcd_d0
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed1
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed2
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
	rts
L_Phase4:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed1
	ldx		#lcd_d1
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed2
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
L_Phase5:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed2
	ldx		#lcd_d2
	jsr		F_Dis_Animation_Frame

	lda		Frame_Serial
	jsr		L_Div_2
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial
L_Phase6:
	lda		Frame_Serial
	jsr		L_Div_4
	jsr		L_Mod_6
	sta		Frame_Counter
	lda		R_Seed3
	ldx		#lcd_d3
	jsr		F_Dis_Animation_Frame
	inc		Frame_Serial


L_Display_D0_InPhase:
	lda		Anim_Phase							; 根据动画阶段不同，处理frame serial
	cmp		#0
	beq		L_D0_Phase1
	cmp		#1
	beq		L_D0_Phase2
	cmp		#2
	beq		L_D0_Phase3
	cmp		#3
	beq		L_D0_Phase4
	cmp		#4
	bcs		L_Display_D0_InPhase_Exit

L_D0_Phase1:
	lda		Frame_Serial
	jsr		L_Mod_A_6
	sta		Frame_Counter
	bra		Is_Seed0_CarryOn
L_D0_Phase2:
	lda		Frame_Serial
	jsr		L_Div_A_2
	jsr		L_Mod_A_6
	sta		Frame_Counter
	bra		Is_Seed0_CarryOn
L_D0_Phase3:
	lda		Frame_Serial
	jsr		L_Div_A_4
	jsr		L_Mod_A_6
	sta		Frame_Counter
	bra		Is_Seed0_CarryOn

Is_Seed0_CarryOn:								; seed0是否进位
	lda		Frame_Counter
	cmp		#00
	bne		L_Seed0_NoCarryOn
	inc		R_Seed0
	lda		R_Seed0
	cmp		#10
	bcc		L_Seed0_NoCarryOn					; seed0是否溢出
	lda		#00
	sta		R_Seed0
L_Seed0_NoCarryOn:

L_Dis_Start_D0:
	ldx		#lcd_d0
	lda		R_Seed0
	jsr		F_Dis_Animation_Frame

	inc		Frame_Serial
	rts

	


L_Div_A_2:
	ldx		#0
L_Div_A_2_Start:
	cmp		#2
	bcc		L_Div_A_2_Over
	sec
	sbc		#2
	inx
	bra		L_Div_A_2_Start
L_Div_A_2_Over:
	txa
	rts

L_Div_A_4:
	ldx		#0
L_Div_A_4_Start:
	cmp		#4
	bcc		L_Div_A_4_Over
	sec
	sbc		#4
	inx
	bra		L_Div_A_4_Start
L_Div_A_4_Over:
	txa
	rts


L_Mod_A_6:
	cmp		#6
	bcc		L_Mod_A_6_Over
	sec
	sbc		#6
	bra		L_Mod_A_6
L_Mod_A_6_Over:
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
