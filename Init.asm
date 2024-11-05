F_Init_SystemRam:							; 系统初始化
	lda		#0
	sta		Frame_Counter
	sta		Frame_Serial
	sta		Frame_Counter_D0
	sta		Frame_Counter_D1
	sta		Frame_Counter_D2
	sta		Frame_Counter_D3
	sta		Anim_Phase
	sta		Counter_1Hz
	sta		Counter_16Hz
	sta		Counter_Lcd
	sta		Key_Flag
	sta		Timer_Flag
	sta		Clock_Flag
	sta		Calendar_Flag
	sta		AlarmLoud_Counter					; 阶段响闹计数
	sta		QuickAdd_Counter					; 快加标志的计数
	sta		Backlight_Counter

	lda		#01
	sta		Sys_Status_Flag

	lda		#00
	sta		R_Time_Hour
	lda		#00
	sta		R_Time_Min
	lda		#00
	sta		R_Time_Sec

	lda		#06
	sta		R_Alarm_Hour
	lda		#00
	sta		R_Alarm_Min

	lda		#05
	sta		R_Date_Day
	lda		#11
	sta		R_Date_Month
	lda		#24
	sta		R_Date_Year
	lda		#00
	sta		R_Date_Week

	rts


F_LCD_Init:
	; 设置为强模式，1/3Bias 3.0V
	lda		#C_BIS_C_1_3_V45+C_HIS_Strong
	sta		LCD_CTRL

	; 设置为4COM 28SEG模式，打开Charge Pump， LCD中断频率为1/2FrameRate
	lda		#C_COM_4_28+C_ENCH_Enable+C_LCDIS_Rate_2
	sta		LCD_COM

	; 设置Seg线 除了S0、S1做IO口，其他全作Seg线
	lda		#C_PC2S+C_PC3S+C_PC54S+C_PC76S+C_PD30S+C_PD74S
	sta		PC_SEG
	lda		#$ff
	sta		PD_SEG

	lda		TMRC
	ora		#C_LCDON
	sta		TMRC

	jsr		F_ClearScreen						; 清屏

	rts


F_Port_Init:
	lda		#$ac
	sta		PA_WAKE
	lda		#$8c
	sta		PA_DIR
	lda		#$ac
	sta		PA
	
	smb4	IER									; 打开PA口外部中断

	lda		PC_DIR								; PC0、1配置为输出，初始值为高
	and		#$fc
	sta		PC_DIR
	lda		PC
	and		#$fd
	sta		PC

	lda		PB
	and		#$fb
	sta		PB

	lda		#04
	sta		PB_TYPE

	; PB2口作背光输出,PB3作PN声音输出
	lda		#C_PB3S
	sta		PADF0

	rts


F_Timer_Init:
	TMR0_CLK_FSUB								; TIM0时钟源Fsub(32768Hz)
	TMR1_CLK_512Hz								; TIM1时钟源Fsub/64(512Hz)
	; TIM2时钟源DIV,Fsub 64分频512Hz，关闭定时器同步
	lda		DIVC
	ora		#C_DIVC_Fsub_64+C_Asynchronous
	sta		DIVC

	lda		#$0									; 重装载计数设置为0
	sta		TMR0
	lda		#$0
	sta		TMR2

	lda		#$bf								; 8Hz一次中断
	sta		TMR1

	lda		IER									; 开定时器中断
	ora		#C_TMR0I+C_TMR1I+C_TMR2I+C_LCDI
	sta		IER

	smb0	TMRC								; 初始化只开TIM2用于走时
	rmb1	TMRC
	smb2	TMRC

	rts


F_Beep_Init:
	; 配置蜂鸣器的PWM输出口为PB3 PN输出
	lda		#C_PB3S
	sta		PADF0

	; 配置PWM频率为Fsub的16分频 1/2占空比
	lda		DIVC
	ora		#C_TONE_Fsub_16_1_2
	sta		DIVC

	rmb1	AUDCR								; 配置BP位，选择AUD开启时的模式，这里选择TONE模式				
	lda		#$ff
	sta		AUD0								; TONE模式下其实AUD0没用
