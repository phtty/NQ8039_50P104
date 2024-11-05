; 正常走时模式的按键处理
F_KeyTrigger_RunTimeMode:
	bbs0	Key_Flag,L_KeyTrigger_RunTimeMode
	rts
L_KeyTrigger_RunTimeMode:
	rmb0	Key_Flag
	rmb1	Key_Flag
	rmb1	TMRC								; 没有快加功能不需要开Timer1的8Hz计时
	lda		#$00
	sta		P_Temp
L_DelayTrigger_RunTimeMode:						; 消抖延时循环用标签
	inc		P_Temp
	lda		P_Temp
	bne		L_DelayTrigger_RunTimeMode			; 软件消抖

	smb5	PA									; 判断4D和LED键
	rmb0	PC
	lda		PA									; 正常走时模式下只对2个按键有响应
	and		#$84
	cmp		#$80
	bne		No_KeyLTrigger_RunTimeMode			; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyLTrigger_RunTimeMode			; LED键触发
No_KeyLTrigger_RunTimeMode:
	cmp		#$04
	bne		No_KeyDTrigger_RunTimeMode
	jmp		L_KeyDTrigger_RunTimeMode			;4D键触发
No_KeyDTrigger_RunTimeMode:
	rmb5	PA									; 判断SET键和UP键
	smb0	PC
	lda		PA
	and		#$84
	cmp		#$80
	bne		No_KeyUTrigger_RunTimeMode
	jmp		L_KeyUTrigger_RunTimeMode			; Up键触发
No_KeyUTrigger_RunTimeMode:
	cmp		#$04
	bne		L_KeyExit_RunTimeMode
	jmp		L_KeySTrigger_RunTimeMode			; Set键触发

L_KeyExit_RunTimeMode:
	jsr			F_RandomSeed1_Get
	jsr			F_RandomSeed3_Get
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeyLTrigger_RunTimeMode:
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeyDTrigger_RunTimeMode:
	lda		#0010B
	sta		Sys_Status_Flag
	lda		#0
	ldx		#lcd_d0
	jsr		L_Dis_15Bit_DigitDot_Prog
	lda		#0
	ldx		#lcd_d1
	jsr		L_Dis_15Bit_DigitDot_Prog
	lda		#0
	ldx		#lcd_d2
	jsr		L_Dis_15Bit_DigitDot_Prog
	lda		#0
	ldx		#lcd_d3
	jsr		L_Dis_15Bit_DigitDot_Prog
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeyUTrigger_RunTimeMode:
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeySTrigger_RunTimeMode:
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts



; 4D模式的按键处理
F_KeyTrigger_4DMode:
	bbs3	Timer_Flag,L_Key8Hz_4DMode			; 有快加则直接判断8Hz标志位
	bbr1	Key_Flag,L_KeyScan_4DMode			; 首次按键触发
	rmb1	Key_Flag
	lda		#$00
	sta		P_Temp
L_DelayTrigger_4DMode:							; 消抖延时循环用标签
	inc		P_Temp
	lda		P_Temp
	bne		L_DelayTrigger_4DMode				; 软件消抖
	lda		PA
	and		#$84
	cmp		#$00
	bne		L_KeyYes_4DMode						; 检测是否有按键触发
	bra		L_KeyExit_4DMode
	rts
L_KeyYes_4DMode:
	sta		PA_IO_Backup
	bra		L_KeyHandle_4DMode					; 首次触发处理结束

L_KeyScan_4DMode:								; 长按处理部分
	bbr0	Key_Flag,L_KeyExit_4DMode			; 没有扫键标志直接退出
L_Key8Hz_4DMode:
	bbr4	Timer_Flag,L_Key8HzExit_4DMode		; 8Hz标志位到来前也不进行按键处理(快加下)
	rmb4	Timer_Flag
	lda		PA
	and		#$84
	cmp		PA_IO_Backup						; 若检测到有按键的状态变化则退出快加判断并结束
	beq		L_8Hz_Count_4DMode
	bra		L_KeyExit_4DMode
	rts
L_8Hz_Count_4DMode:
	inc		QuickAdd_Counter
	lda		QuickAdd_Counter
	cmp		#12
	bcs		L_QuikAdd_4DMode
	rts											; 长按计时，必须满1S才有快加
L_QuikAdd_4DMode:
	smb3	Timer_Flag

L_KeyHandle_4DMode:
	rmb4	IER									; 关闭PA口中断，以免重复进中断服务函数
	smb5	PA
	rmb0	PC
	lda		PA									; 判断4D键和LED键
	and		#$84
	cmp		#$80
	bne		No_KeyLTrigger_4DMode				; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyLTrigger_4DMode				; LED键触发
No_KeyLTrigger_4DMode:
	cmp		#$04
	bne		No_KeyDTrigger_4DMode
	jmp		L_KeyDTrigger_4DMode				; 4D键触发
No_KeyDTrigger_4DMode:
	rmb5	PA
	smb0	PC									; 虽然没有中断使能，但是上升沿依旧会置标志位
	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	lda		PA									; 判断SET键和UP键
	and		#$84
	cmp		#$80
	bne		No_KeyUTrigger_4DMode
	jmp		L_KeyUTrigger_4DMode				; UP键触发
No_KeyUTrigger_4DMode:
	cmp		#$04
	bne		L_KeyExit_4DMode
	jmp		L_KeySTrigger_4DMode				; SET键触发

L_KeyExit_4DMode:
	rmb1	TMRC								; 关闭快加8Hz计时的定时器
	rmb0	Key_Flag							; 清相关标志位
	rmb3	Timer_Flag
	lda		#0									; 清理相关变量
	bbs2	Random_Flag,L_Key8HzExit_4DMode		; 在滚动随机数时，停止随机数变更
	sta		QuickAdd_Counter
	jsr		F_RandomSeed1_Get
	jsr		F_RandomSeed3_Get
L_Key8HzExit_4DMode:
	rts


L_KeyLTrigger_4DMode:

	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	rts

L_KeyDTrigger_4DMode:
	smb0	Random_Flag							; 开始滚动动画
	smb2	Random_Flag							; 停止采样随机数
	jsr		F_RandomSeed0_Get
	jsr		F_RandomSeed2_Get

	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	rts

L_KeyUTrigger_4DMode:
	rts

L_KeySTrigger_4DMode:
	rts
