
ACTION S5_ACT: 
	//设定时间
	FOR i := 0 TO MBAS5_STEP_NUM DO
		IF MBAS5_ST[i] < T#5s THEN
			MBAS5_ST[i] := T#5s;
		END_IF;
		MBAS5_STEP[i].set_time := MBAS5_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(MBAS5,MBAS5_STEP[0],MBAS5_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS5.status.mode <> 0) AND (NOT MBAS5.auto_mode_edge) THEN
		MBAS5.auto_mode_edge := TRUE;
		MBAS5.manual_mode_edge := FALSE;
		
		MBAXV0308.control.auto_operate := TRUE;
		MBAXV0301.control.auto_operate := TRUE;
		MBAR13.control.auto_operate := TRUE;
		MBAPHV1101.control.auto_operate := TRUE;
		MBATV1101.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS5.status.mode = 0) AND (NOT MBAS5.manual_mode_edge) THEN
		MBAS5.manual_mode_edge := TRUE;
		MBAS5.auto_mode_edge := FALSE;

		MBAXV0308.control.manual_operate := TRUE;
		MBAXV0301.control.manual_operate := TRUE;
		MBAR13.control.manual_operate := TRUE;
		MBAPHV1101.control.manual_operate := TRUE;
		MBATV1101.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	MBAS5.input.error_signal := (MBAXV0308.status.valve_status >= 2) OR (MBAXV0301.status.valve_status >= 2) OR
	(MBAR13.status.motor_status >= 2) OR (MBAPHV1101.status.valve_status >= 2) OR (MBATV1101.status.valve_status >= 2);

	
	IF MBAS5.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS5.status.run_step OF 
			0:
				IF NOT MBAS5_STEP[0].done THEN
					MBAXV0308.control.auto_operate := TRUE;
					MBAXV0301.control.auto_operate := TRUE;
					MBAR13.control.auto_operate := TRUE;
					MBAPHV1101.control.auto_operate := TRUE;
					MBATV1101.control.auto_operate := TRUE;
					MBAS5_STEP[0].done := TRUE;
				END_IF;
			1:
				//V30进料
				IF MBALIT1101.status.value >= MBAS5_PARA_L1 THEN
					MBAXV0308.input.auto_open_signal := FALSE;
					MBAXV0301.input.auto_open_signal := FALSE;
					MBAS5_STEP[1].done := TRUE;
				ELSE
					MBAXV0308.input.auto_open_signal := TRUE;
					MBAXV0301.input.auto_open_signal := TRUE;
				END_IF;
			2:
				//酸化
				CASE step5_2 OF
					0:
						IF NOT MBAS5_STEP[2].done THEN
							step5_2 := 1;
						END_IF;
					1:
						MBAR13.input.auto_run_signal := TRUE;
						IF MBAR13.input.run_feedback THEN
							step5_2 := 2;
						END_IF;
					2:
						TON_17.PT := DINT_TO_TIME(MBAS5_PARA_T3 * 1000);
						TON_17.IN := TRUE;
						IF TON_17.Q THEN
							TON_17.IN := FALSE;
							step5_2 := 3;
						END_IF;
					3:
						MBAPHV1101.input.auto_open_signal := TRUE;
						IF MBAPHV1101.input.open_feedback_state THEN
							temp_monitor_0302 := TRUE;
							step5_2 := 4;
						END_IF;
					4:
						TON_17.PT := DINT_TO_TIME(MBAS5_PARA_T4 * 60 * 1000);
						TON_17.IN := TRUE;
						IF TON_17.Q THEN
							TON_17.IN := FALSE;
							step5_2 := 5;
						END_IF;
					5:
						MBAPHV1101.input.auto_open_signal := FALSE;
						temp_monitor_0302 := FALSE;
						IF MBAPHV1101.input.close_feedback_state THEN
							MBATV1101.input.auto_open_signal := FALSE;
							IF MBATV1101.input.close_feedback_state THEN
								step5_2 := 6;
							END_IF;
						END_IF;
					6:
						TON_17.PT := DINT_TO_TIME(MBAS5_PARA_T5 * 60 * 1000);
						TON_17.IN := TRUE;
						IF TON_17.Q THEN
							TON_17.IN := FALSE;
							step5_2 := 0;
							MBAS5_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
				TON_17();
			3:
				//离心
		END_CASE;		
	END_IF;
	
	//V06滴加温控
	IF temp_monitor_0302 THEN
		IF MBATIT1101.status.value >= MBAS5_PARA_Temp1 THEN
			MBATV1101.input.auto_open_signal := TRUE;
		END_IF;
		IF MBATIT1101.status.value <= MBAS5_PARA_Temp2 THEN
			MBATV1101.input.auto_open_signal := FALSE;
		END_IF;
	END_IF;
	

	
	//人工确认步骤可用
	IF (MBAS5.status.run_state) AND (NOT MBAS5_STEP[MBAS5.status.run_step].done AND ((MBAS5.status.run_step = 3))) THEN
		MBAS5.status.confirm_enable := TRUE;
	ELSE
		MBAS5.status.confirm_enable := FALSE;
	END_IF;
	
END_ACTION
