
ACTION S4_ACT: 
	//设定时间
	FOR i := 0 TO MBAS4_STEP_NUM DO
		IF MBAS4_ST[i] < T#5s THEN
			MBAS4_ST[i] := T#5s;
		END_IF;
		MBAS4_STEP[i].set_time := MBAS4_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(MBAS4,MBAS4_STEP[0],MBAS4_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS4.status.mode <> 0) AND (NOT MBAS4.auto_mode_edge) THEN
		MBAS4.auto_mode_edge := TRUE;
		MBAS4.manual_mode_edge := FALSE;
		//		
		STFLV0301.control.auto_operate := TRUE;
		STFLV0302.control.auto_operate := TRUE;
		MBALV0301.control.auto_operate := TRUE;
		STFP03.control.auto_operate := TRUE;
		MBAFQV0301.control.auto_operate := TRUE;
		MBAXV0306.control.auto_operate := TRUE;
		MBAR07.control.auto_operate := TRUE;
		MBATV0301.control.auto_operate := TRUE;
		MBAAV0301.control.auto_operate := TRUE;
		MBAXV0627.control.auto_operate := TRUE;
		MBAXV0629.control.auto_operate := TRUE;
		MBAXV0630.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS4.status.mode = 0) AND (NOT MBAS4.manual_mode_edge) THEN
		MBAS4.manual_mode_edge := TRUE;
		MBAS4.auto_mode_edge := FALSE;
		
		STFLV0301.control.manual_operate := TRUE;
		STFLV0302.control.manual_operate := TRUE;
		MBALV0301.control.manual_operate := TRUE;
		STFP03.control.manual_operate := TRUE;
		MBAFQV0301.control.manual_operate := TRUE;
		MBAXV0306.control.manual_operate := TRUE;
		MBAR07.control.manual_operate := TRUE;
		MBATV0301.control.manual_operate := TRUE;
		MBAAV0301.control.manual_operate := TRUE;
		MBAXV0627.control.manual_operate := TRUE;
		MBAXV0629.control.manual_operate := TRUE;
		MBAXV0630.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS4.input.error_signal := (STFLV0301.status.valve_status >= 2) OR (STFLV0302.status.valve_status >= 2) OR 
	(MBALV0301.status.valve_status >= 2) OR (STFP03.status.motor_status >= 2) OR (MBAFQV0301.status.valve_status >= 2) OR
	(MBAXV0306.status.valve_status >= 2) OR (MBAR07.status.motor_status >= 2) OR (MBATV0301.status.valve_status >= 2) OR	
	(MBAAV0301.status.valve_status >= 2) OR (MBAXV0627.status.valve_status >= 2) OR
	(MBAXV0629.status.valve_status >= 2) OR (MBAXV0630.status.valve_status >= 2);
	
	IF MBAS4.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS4.status.run_step OF 
			0:
				IF NOT MBAS4_STEP[0].done THEN
					STFLV0301.control.auto_operate := TRUE;
					STFLV0302.control.auto_operate := TRUE;
					MBALV0301.control.auto_operate := TRUE;
					STFP03.control.auto_operate := TRUE;
					MBAFQV0301.control.auto_operate := TRUE;
					MBAXV0306.control.auto_operate := TRUE;
					MBAR07.control.auto_operate := TRUE;
					MBATV0301.control.auto_operate := TRUE;
					MBAAV0301.control.auto_operate := TRUE;
					MBAXV0627.control.auto_operate := TRUE;
					MBAXV0629.control.auto_operate := TRUE;
					MBAXV0630.control.auto_operate := TRUE;
					MBAS4_STEP[0].done := TRUE;
				END_IF;
			1:
				CASE step4_1 OF
					0:
						IF NOT MBAS4_STEP[1].done THEN
							step4_1 := 1;
						END_IF;
					1:
						STFLV0301.input.auto_open_signal := TRUE;
						STFLV0302.input.auto_open_signal := FALSE;
						MBALV0301.input.auto_open_signal := TRUE;
						IF MBALV0301.input.open_feedback_state AND STFLV0301.input.open_feedback_state AND STFLV0302.input.close_feedback_state THEN
							step4_1 := 2;
						END_IF;
					2:
						LiquidAdd_7(level_value := MBALIT0301.status.value,
						sp_value := MBAS4_PARA_L4,
						sp_accumulation := MBAS4_PARA_AC1,
						sp_time := DINT_TO_TIME(MBAS4_PARA_T1 * 1000),
						flowmeter := STFFQIT0302,
						done := step4_1_2_done);
						STFP03.input.auto_run_signal := LiquidAdd_7.run;
						IF step4_1_2_done AND (NOT STFP03.input.run_feedback) AND (NOT STFP03.input.auto_run_signal) THEN
							step4_1 := 3;
						END_IF;
					3:
						IF STFFQIT0302.flowrate <= flowrate_threshold THEN
							step4_1 := 4;
						END_IF;
					4:
						MBALV0301.input.auto_open_signal := FALSE;
						IF MBALV0301.input.close_feedback_state THEN
							step4_1 := 0;
							step4_1_2_done := FALSE;
							MBAS4_STEP[1].done := TRUE;
						END_IF;
				END_CASE;
			2:
				//加水
				LiquidTransfer_2(sp_time := DINT_TO_TIME(MBAS4_PARA_T5 * 1000),
				sp_accumulation := MBAS4_PARA_AC2,
				done := MBAS4_STEP[2].done,
				flowmeter := MBAFQIT0503);
				MBAFQV0301.input.auto_open_signal := LiquidTransfer_2.run;
			3:
				//滴加
				CASE step4_3 OF
					0:
						IF NOT MBAS4_STEP[3].done THEN
							step4_3 := 1;
						END_IF;
					1:
						MBAXV0306.input.auto_open_signal := TRUE;
						MBAR07.input.auto_run_signal := TRUE;
						IF MBAXV0306.input.open_feedback_state AND MBAR07.input.run_feedback THEN
							step4_3 := 2;
						END_IF;
					2:
						IF MBALIT0301.status.value > 0.0 THEN
							IF MBATIT0301.status.value <= MBAS4_PARA_Temp1 THEN
								MBATV0301.input.auto_open_signal := TRUE;
							END_IF;
							IF MBATIT0301.status.value >= MBAS4_PARA_Temp2 THEN
								MBATV0301.input.auto_open_signal := FALSE;
							END_IF;
						ELSE
							step4_3 := 3;
						END_IF;
					3:
						TON_16.PT := DINT_TO_TIME(MBAS4_PARA_T6 * 1000);
						TON_16.IN := TRUE;
						IF TON_16.Q THEN
							TON_16.IN := FALSE;
							step4_3 := 4;
						END_IF;
					4:
						MBATV0301.input.auto_open_signal := FALSE;
						MBAXV0306.input.auto_open_signal := FALSE;
						MBAR07.input.auto_run_signal := FALSE;
						IF MBATV0301.input.close_feedback_state AND MBAXV0306.input.close_feedback_state AND (NOT MBAR07.input.run_feedback) THEN
							step4_3 := 0;
							MBAS4_STEP[3].done := TRUE;
						END_IF;
				END_CASE;
				TON_16();
		END_CASE;
	END_IF;
	
	//人工确认步骤可用
	//	IF (MBAS4.status.run_state) AND (NOT MBAS4_STEP[MBAS4.status.run_step].done AND ((MBAS4.status.run_step = 1) OR (MBAS4.status.run_step = 2) OR (MBAS4.status.run_step = 4))) THEN
	//		MBAS4.status.confirm_enable := TRUE;
	//	ELSE
	//		MBAS4.status.confirm_enable := FALSE;
	//	END_IF;
END_ACTION
