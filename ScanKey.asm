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
	jmp		L_KeyDTrigger_RunTimeMode			; 4D键触发
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
	smb3	Key_Flag
	smb2	PB
	lda		#0
	sta		Backlight_Counter					; 每次按背光都会重置计时

	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeyDTrigger_RunTimeMode:
	lda		#0010B
	sta		Sys_Status_Flag
	lda		#0
	ldx		#lcd_d0
	jsr		L_Dis_15Bit_DigitDot
	lda		#0
	ldx		#lcd_d1
	jsr		L_Dis_15Bit_DigitDot
	lda		#0
	ldx		#lcd_d2
	jsr		L_Dis_15Bit_DigitDot
	lda		#0
	ldx		#lcd_d3
	jsr		L_Dis_15Bit_DigitDot

	smb4	Key_Flag

	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeyUTrigger_RunTimeMode:
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeySTrigger_RunTimeMode:
	lda		#00000100B
	sta		Sys_Status_Flag						; 12h/24h切换
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts



; 4D模式的按键处理
F_KeyTrigger_4DMode:
	bbs0	Key_Flag,L_KeyTrigger_4DMode
	rts
L_KeyTrigger_4DMode:
	rmb0	Key_Flag
	rmb1	Key_Flag
	rmb1	TMRC								; 没有快加功能不需要开Timer1的8Hz计时
	lda		#$00
	sta		P_Temp
L_DelayTrigger_4DMode:							; 消抖延时循环用标签
	inc		P_Temp
	lda		P_Temp
	bne		L_DelayTrigger_4DMode				; 软件消抖

	smb5	PA									; 判断4D和LED键
	rmb0	PC
	lda		PA
	and		#$84
	cmp		#$80
	bne		No_KeyLTrigger_4DMode				; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyLTrigger_4DMode				; LED键触发
No_KeyLTrigger_4DMode:
	cmp		#$04
	bne		No_KeyDTrigger_4DMode
	jmp		L_KeyDTrigger_4DMode				; 4D键触发
No_KeyDTrigger_4DMode:
	rmb5	PA									; 判断SET键和UP键
	smb0	PC
	lda		PA
	and		#$84
	cmp		#$80
	bne		No_KeyUTrigger_4DMode
	jmp		L_KeyUTrigger_4DMode				; Up键触发
No_KeyUTrigger_4DMode:
	cmp		#$04
	bne		L_KeyExit_4DMode
	jmp		L_KeySTrigger_4DMode				; Set键触发

L_KeyExit_4DMode:
	jsr			F_RandomSeed1_Get
	jsr			F_RandomSeed3_Get
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts


L_KeyLTrigger_4DMode:
	smb3	Key_Flag
	smb2	PB
	lda		#0
	sta		Backlight_Counter					; 每次按背光都会重置计时
	lda		#0
	sta		4DMode_Counter						; 按键会重置4D模式计时

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
	lda		#0
	sta		4DMode_Counter						; 重置4D模式计时

	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	rts

L_KeyUTrigger_4DMode:
	jsr		L_4DMode_Stop						; 4D模式下U键可以回到时间模式
	rts

L_KeySTrigger_4DMode:
	lda		#0
	sta		4DMode_Counter
	rts






F_KeyTrigger_TimeMode_Set:
	bbs0	Key_Flag,L_KeyTrigger_TimeMode_Set
	rts
L_KeyTrigger_TimeMode_Set:
	rmb0	Key_Flag
	rmb1	Key_Flag
	rmb1	TMRC								; 没有快加功能不需要开Timer1的8Hz计时
	lda		#$00
	sta		P_Temp
L_DelayTrigger_TimeMode_Set:					; 消抖延时循环用标签
	inc		P_Temp
	lda		P_Temp
	bne		L_DelayTrigger_TimeMode_Set			; 软件消抖

	smb5	PA									; 判断4D和LED键
	rmb0	PC
	lda		PA									; 正常走时模式下只对2个按键有响应
	and		#$84
	cmp		#$80
	bne		No_KeyLTrigger_TimeMode_Set			; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyLTrigger_TimeMode_Set			; LED键触发
No_KeyLTrigger_TimeMode_Set:
	cmp		#$04
	bne		No_KeyDTrigger_TimeMode_Set
	jmp		L_KeyDTrigger_TimeMode_Set			; 4D键触发
No_KeyDTrigger_TimeMode_Set:
	rmb5	PA									; 判断SET键和UP键
	smb0	PC
	lda		PA
	and		#$84
	cmp		#$80
	bne		No_KeyUTrigger_TimeMode_Set
	jmp		L_KeyUTrigger_TimeMode_Set			; Up键触发
No_KeyUTrigger_TimeMode_Set:
	cmp		#$04
	bne		L_KeyExit_TimeMode_Set
	jmp		L_KeySTrigger_TimeMode_Set			; Set键触发

L_KeyExit_TimeMode_Set:
	jsr			F_RandomSeed1_Get
	jsr			F_RandomSeed3_Get
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts



L_KeyLTrigger_TimeMode_Set:
	smb3	Key_Flag
	smb2	PB
	lda		#0
	sta		Backlight_Counter					; 每次按背光都会重置计时
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeyDTrigger_TimeMode_Set:
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeyUTrigger_TimeMode_Set:
	lda		Clock_Flag
	eor		#01									; 翻转12/24h模式的状态
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts

L_KeySTrigger_TimeMode_Set:
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	rts


; HourSet模式的按键处理
F_KeyTrigger_Hour_Set:
	bbs3	Timer_Flag,L_Key8Hz_HourSet			; 有快加则直接判断8Hz标志位
	bbr1	Key_Flag,L_KeyScan_HourSet			; 首次按键触发
	rmb1	Key_Flag
	lda		#$00
	sta		P_Temp
L_DelayTrigger_HourSet:							; 消抖延时循环用标签
	inc		P_Temp
	lda		P_Temp
	bne		L_DelayTrigger_HourSet				; 软件消抖
	lda		PA
	and		#$84
	cmp		#$00
	bne		L_KeyYes_HourSet					; 检测是否有按键触发
	bra		L_KeyExit_HourSet
	rts
L_KeyYes_HourSet:
	sta		PA_IO_Backup
	bra		L_KeyHandle_HourSet					; 首次触发处理结束

L_KeyScan_HourSet:								; 长按处理部分
	bbr0	Key_Flag,L_KeyExit_HourSet			; 没有扫键标志直接退出
L_Key8Hz_HourSet:
	bbr4	Timer_Flag,L_Key8HzExit_HourSet		; 8Hz标志位到来前也不进行按键处理(快加下)
	rmb4	Timer_Flag
	lda		PA
	and		#$84
	cmp		PA_IO_Backup						; 若检测到有按键的状态变化则退出快加判断并结束
	beq		L_8Hz_Count_HourSet
	bra		L_KeyExit_HourSet
	rts
L_8Hz_Count_HourSet:
	inc		QuickAdd_Counter
	lda		QuickAdd_Counter
	cmp		#12
	bcs		L_QuikAdd_HourSet
	rts											; 长按计时，必须满1S才有快加
L_QuikAdd_HourSet:
	smb3	Timer_Flag

L_KeyHandle_HourSet:
	rmb4	IER									; 关闭PA口中断，以免重复进中断服务函数
	smb5	PA
	rmb0	PC
	lda		PA									; 判断4D键和LED键
	and		#$84
	bbr3	Timer_Flag,No_KeyDTrigger_HourSet	; L、D键不需要快加
	cmp		#$80
	bne		No_KeyLTrigger_HourSet				; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyLTrigger_HourSet				; LED键触发
No_KeyLTrigger_HourSet:
	cmp		#$04
	bne		No_KeyDTrigger_HourSet
	jmp		L_KeyDTrigger_HourSet				; 4D键触发
No_KeyDTrigger_HourSet:
	rmb5	PA
	smb0	PC									; 虽然没有中断使能，但是上升沿依旧会置标志位
	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	lda		PA									; 判断SET键和UP键
	and		#$84
	cmp		#$80
	bne		No_KeyUTrigger_HourSet
	jmp		L_KeyUTrigger_HourSet				; UP键触发
No_KeyUTrigger_HourSet:
	bbr3	Timer_Flag,L_KeyExit_HourSet		; S键不需要快加
	cmp		#$04
	bne		L_KeyExit_HourSet
	jmp		L_KeySTrigger_HourSet				; SET键触发

L_KeyExit_HourSet:
	rmb1	TMRC								; 关闭快加8Hz计时的定时器
	rmb0	Key_Flag							; 清相关标志位
	rmb3	Timer_Flag
	lda		#0									; 清理相关变量
	bbs2	Random_Flag,L_Key8HzExit_HourSet		; 在滚动随机数时，停止随机数变更
	sta		QuickAdd_Counter
	jsr		F_RandomSeed1_Get
	jsr		F_RandomSeed3_Get
L_Key8HzExit_HourSet:
	rts


L_KeyLTrigger_HourSet:
	smb3	Key_Flag
	smb2	PB
	lda		#0
	sta		Backlight_Counter					; 每次按背光都会重置计时

	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	rts

L_KeyDTrigger_HourSet:
	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	rts

L_KeyUTrigger_HourSet:
	inc		R_Time_Hour
	lda		#23
	cmp		R_Time_Hour
	bcs		L_HourSet_Juge
	lda		#00
	sta		R_Time_Hour
L_HourSet_Juge:
	jsr		F_Display_Time
	rts

L_KeySTrigger_HourSet:
	lda		#00010000B
	sta		Sys_Status_Flag
	rts




; MinSet模式的按键处理
F_KeyTrigger_Min_Set:
	bbs3	Timer_Flag,L_Key8Hz_MinSet			; 有快加则直接判断8Hz标志位
	bbr1	Key_Flag,L_KeyScan_MinSet			; 首次按键触发
	rmb1	Key_Flag
	lda		#$00
	sta		P_Temp
L_DelayTrigger_MinSet:							; 消抖延时循环用标签
	inc		P_Temp
	lda		P_Temp
	bne		L_DelayTrigger_MinSet				; 软件消抖
	lda		PA
	and		#$84
	cmp		#$00
	bne		L_KeyYes_MinSet					; 检测是否有按键触发
	bra		L_KeyExit_MinSet
	rts
L_KeyYes_MinSet:
	sta		PA_IO_Backup
	bra		L_KeyHandle_MinSet					; 首次触发处理结束

L_KeyScan_MinSet:								; 长按处理部分
	bbr0	Key_Flag,L_KeyExit_MinSet			; 没有扫键标志直接退出
L_Key8Hz_MinSet:
	bbr4	Timer_Flag,L_Key8HzExit_MinSet		; 8Hz标志位到来前也不进行按键处理(快加下)
	rmb4	Timer_Flag
	lda		PA
	and		#$84
	cmp		PA_IO_Backup						; 若检测到有按键的状态变化则退出快加判断并结束
	beq		L_8Hz_Count_MinSet
	bra		L_KeyExit_MinSet
	rts
L_8Hz_Count_MinSet:
	inc		QuickAdd_Counter
	lda		QuickAdd_Counter
	cmp		#12
	bcs		L_QuikAdd_MinSet
	rts											; 长按计时，必须满1S才有快加
L_QuikAdd_MinSet:
	smb3	Timer_Flag

L_KeyHandle_MinSet:
	rmb4	IER									; 关闭PA口中断，以免重复进中断服务函数
	smb5	PA
	rmb0	PC
	lda		PA									; 判断4D键和LED键
	and		#$84
	bbr3	Timer_Flag,No_KeyDTrigger_MinSet	; L、D键不需要快加
	cmp		#$80
	bne		No_KeyLTrigger_MinSet				; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyLTrigger_MinSet				; LED键触发
No_KeyLTrigger_MinSet:
	cmp		#$04
	bne		No_KeyDTrigger_MinSet
	jmp		L_KeyDTrigger_MinSet				; 4D键触发
No_KeyDTrigger_MinSet:
	rmb5	PA
	smb0	PC									; 虽然没有中断使能，但是上升沿依旧会置标志位
	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	lda		PA									; 判断SET键和UP键
	and		#$84
	cmp		#$80
	bne		No_KeyUTrigger_MinSet
	jmp		L_KeyUTrigger_MinSet				; UP键触发
No_KeyUTrigger_MinSet:
	bbr3	Timer_Flag,L_KeyExit_MinSet		; S键不需要快加
	cmp		#$04
	bne		L_KeyExit_MinSet
	jmp		L_KeySTrigger_MinSet				; SET键触发

L_KeyExit_MinSet:
	rmb1	TMRC								; 关闭快加8Hz计时的定时器
	rmb0	Key_Flag							; 清相关标志位
	rmb3	Timer_Flag
	lda		#0									; 清理相关变量
	bbs2	Random_Flag,L_Key8HzExit_MinSet		; 在滚动随机数时，停止随机数变更
	sta		QuickAdd_Counter
	jsr		F_RandomSeed1_Get
	jsr		F_RandomSeed3_Get
L_Key8HzExit_MinSet:
	rts


L_KeyLTrigger_MinSet:
	smb3	Key_Flag
	smb2	PB
	lda		#0
	sta		Backlight_Counter					; 每次按背光都会重置计时

	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	rts

L_KeyDTrigger_MinSet:
	rmb4	IFR									; 开启中断前需要重新复位标志位
	smb5	PA									; 恢复高电平以方便下一次按键
	smb0	PC
	smb4	IER									; 恢复PA口中断
	rts

L_KeyUTrigger_MinSet:
	inc		R_Time_Min
	lda		#23
	cmp		R_Time_Min
	bcs		L_MinSet_Juge
	lda		#00
	sta		R_Time_Hour
L_MinSet_Juge:
	jsr		F_Display_Time
	rts

L_KeySTrigger_MinSet:
	lda		#00100000B
	sta		Sys_Status_Flag
	rts