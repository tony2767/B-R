
ACTION P1S1_1_ACT: 
	//步与步之间切换的设定时间,至少设置为5s(可更改，调整阀门到位、液位延时后),用于检查步骤错误信号
	FOR i := 0 TO EDTP1S1_1_STEP_NUM DO
		IF EDTP1S1_1_ST[i] < T#5s THEN
			EDTP1S1_1_ST[i] := T#5s;
		END_IF;
		EDTP1S1_1_STEP[i].set_time := EDTP1S1_1_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP1S1_1,EDTP1S1_1_STEP[0],EDTP1S1_1_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP1S1_1.status.mode <> 0) AND (NOT EDTP1S1_1.auto_mode_edge) THEN
		EDTP1S1_1.auto_mode_edge := TRUE;
		EDTP1S1_1.manual_mode_edge := FALSE;
		EDTR01.control.auto_operate := TRUE;
		EDTFQV0502.control.auto_operate := TRUE;
		EDTXV0505.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP1S1_1.status.mode = 0) AND (NOT EDTP1S1_1.manual_mode_edge) THEN
		EDTP1S1_1.manual_mode_edge := TRUE;
		EDTP1S1_1.auto_mode_edge := FALSE;
		EDTR01.control.manual_operate := TRUE;
		EDTFQV0502.control.manual_operate := TRUE;
		EDTXV0505.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP1S1_1.input.error_signal := (EDTR01.status.motor_status >= 2) OR (EDTFQV0502.status.valve_status >= 2) OR 
	(EDTXV0505.status.valve_status >= 2);
	
	//步骤执行动作
	IF EDTP1S1_1.status.run_state = 1 THEN
		CASE EDTP1S1_1.status.run_step OF 
			0:
				//初始化检查
				IF NOT EDTP1S1_1_STEP[0].done THEN
					EDTR01.control.auto_operate := TRUE;
					EDTFQV0502.control.auto_operate := TRUE;
					EDTXV0505.control.auto_operate := TRUE;
					EDTP1S1_1_STEP[0].done := TRUE;
				END_IF;
			1:
				//关闭底阀
				EDTXV0505.input.auto_open_signal := FALSE;
				IF EDTXV0505.input.close_feedback_state THEN
					EDTP1S1_1_STEP[1].done := TRUE;
				END_IF;
			2:
				//加定量纯水
				LiquidTransfer_3(sp_time := DINT_TO_TIME(EDTP1S1_1_PARA_T1 * 1000),
				sp_accumulation := EDTP1S1_1_PARA_AC1,
				done := EDTP1S1_1_STEP[2].done,
				flowmeter := EDTFQIT1904);
				EDTFQV0502.input.auto_open_signal := LiquidTransfer_3.run;
			3:
				//开启搅拌
				EDTR01.input.auto_run_signal := TRUE;
				IF EDTR01.input.run_feedback THEN
					EDTP1S1_1_STEP[3].done := TRUE;
				END_IF;
			4:
				//人工投料，完成后点击确认
			5:
				//溶解计时
				TON_41.PT := DINT_TO_TIME(EDTP1S1_1_PARA_T2 * 60 * 1000);
				TON_41.IN := TRUE;
				IF TON_41.Q THEN
					TON_41.IN := FALSE;
					EDTP1S1_1_STEP[5].done := TRUE;
				END_IF;
				TON_41();
			6:
				//观察溶解结束后点击确认
		END_CASE;
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP1S1_1.status.run_state) AND (NOT EDTP1S1_1_STEP[EDTP1S1_1.status.run_step].done AND ((EDTP1S1_1.status.run_step = 4) OR (EDTP1S1_1.status.run_step = 6))) THEN
		EDTP1S1_1.status.confirm_enable := TRUE;
	ELSE
		EDTP1S1_1.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
