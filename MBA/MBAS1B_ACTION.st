
ACTION S1B_ACT: 
	//设定时间
	FOR i := 0 TO MBAS1_STEP_NUM DO
		IF MBAS1B_ST[i] < T#5s THEN
			MBAS1B_ST[i] := T#5s;
		END_IF;
		MBAS1B_STEP[i].set_time := MBAS1B_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(MBAS1B,MBAS1B_STEP[0],MBAS1_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS1B.status.mode <> 0) AND (NOT MBAS1B.auto_mode_edge) THEN
		MBAS1B.auto_mode_edge := TRUE;
		MBAS1B.manual_mode_edge := FALSE;
		
		STFLV0101.control.auto_operate := TRUE;
		STFLV0102.control.auto_operate := TRUE;
		MBALV0104.control.auto_operate := TRUE;
		STFP01.control.auto_operate := TRUE;
		STFLV3601.control.auto_operate := TRUE;
		STFLV3602.control.auto_operate := TRUE;
		MBALV0105.control.auto_operate := TRUE;
		STFP36.control.auto_operate := TRUE;
		MBALV0101.control.auto_operate := TRUE;
		MBAXV0110.control.auto_operate := TRUE;
		MBAXV0108.control.auto_operate := TRUE;
		MBAAV0102A.control.auto_operate := TRUE;
		MBAR01B.control.auto_operate := TRUE;
		MBAXV0107.control.auto_operate := TRUE;
		MBAXV0106.control.auto_operate := TRUE;
		MBAAV0102B.control.auto_operate := TRUE;
		MBAXV0209.control.auto_operate := TRUE;
		MBAXV0212.control.auto_operate := TRUE;
		MBAXV0109.control.auto_operate := TRUE;
		MBAXV0415.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS1B.status.mode = 0) AND (NOT MBAS1B.manual_mode_edge) THEN
		MBAS1B.manual_mode_edge := TRUE;
		MBAS1B.auto_mode_edge := FALSE;

		STFLV0101.control.manual_operate := TRUE;
		STFLV0102.control.manual_operate := TRUE;
		MBALV0104.control.manual_operate := TRUE;
		STFP01.control.manual_operate := TRUE;
		STFLV3601.control.manual_operate := TRUE;
		STFLV3602.control.manual_operate := TRUE;
		MBALV0105.control.manual_operate := TRUE;
		STFP36.control.manual_operate := TRUE;
		MBALV0101.control.manual_operate := TRUE;
		MBAXV0110.control.manual_operate := TRUE;
		MBAXV0108.control.manual_operate := TRUE;
		MBAAV0102A.control.manual_operate := TRUE;
		MBAR01B.control.manual_operate := TRUE;
		MBAXV0107.control.manual_operate := TRUE;
		MBAXV0106.control.manual_operate := TRUE;
		MBAAV0102B.control.manual_operate := TRUE;
		MBAXV0209.control.manual_operate := TRUE;
		MBAXV0212.control.manual_operate := TRUE;
		MBAXV0109.control.manual_operate := TRUE;
		MBAXV0415.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS1B.input.error_signal := (STFLV0101.status.valve_status >= 2) OR (STFLV0102.status.valve_status >= 2) OR
	(MBALV0104.status.valve_status >= 2) OR (STFP01.status.motor_status >= 2) OR (STFLV3601.status.valve_status >= 2) OR
	(STFLV3602.status.valve_status >= 2) OR (MBALV0105.status.valve_status >= 2) OR (STFP36.status.motor_status >= 2) OR
	(MBALV0101.status.valve_status >= 2) OR (MBAXV0110.status.valve_status >= 2) OR (MBAXV0108.status.valve_status >= 2) OR
	(MBAAV0102A.status.valve_status >= 2) OR (MBAR01B.status.motor_status >= 2) OR (MBAXV0107.status.valve_status >= 2) OR
	(MBAXV0106.status.valve_status >= 2) OR (MBAAV0102B.status.valve_status >= 2) OR (MBAXV0209.status.valve_status >= 2) OR
	(MBAXV0212.status.valve_status >= 2) OR (MBAXV0109.status.valve_status >= 2) OR (MBAXV0415.status.valve_status >= 2);
	
	IF MBAS1B.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS1B.status.run_step OF 
			0:
				IF NOT MBAS1B_STEP[0].done THEN
					STFLV0101.control.auto_operate := TRUE;
					STFLV0102.control.auto_operate := TRUE;
					MBALV0104.control.auto_operate := TRUE;
					STFP01.control.auto_operate := TRUE;
					STFLV3601.control.auto_operate := TRUE;
					STFLV3602.control.auto_operate := TRUE;
					MBALV0105.control.auto_operate := TRUE;
					STFP36.control.auto_operate := TRUE;
					MBALV0101.control.auto_operate := TRUE;
					MBAXV0110.control.auto_operate := TRUE;
					MBAXV0108.control.auto_operate := TRUE;
					MBAAV0102A.control.auto_operate := TRUE;
					MBAR01B.control.auto_operate := TRUE;
					MBAXV0107.control.auto_operate := TRUE;
					MBAXV0106.control.auto_operate := TRUE;
					MBAAV0102B.control.auto_operate := TRUE;
					MBAXV0209.control.auto_operate := TRUE;
					MBAXV0212.control.auto_operate := TRUE;
					MBAXV0109.control.auto_operate := TRUE;
					MBAXV0415.control.auto_operate := TRUE;
					MBAS1B_STEP[0].done := TRUE;
				END_IF;
			1:
				//高位槽进料
			2:
				CASE step1_4b OF
					0:
						IF NOT MBAS1B_STEP[2].done THEN
							step1_4b := 1;
						END_IF;
					1:
						MBAXV0110.input.auto_open_signal := TRUE;
						step1_4b := 2;
					2:
						TON_14.PT := DINT_TO_TIME(MBAS1B_PARA_T4 * 1000);
						TON_14.IN := TRUE;			
						IF TON_14.Q THEN
							TON_14.IN := FALSE;
							step1_4b := 3;
						END_IF;
					3:
						MBAXV0110.input.auto_open_signal := FALSE;
						step1_4b := 4;
					4:
						MBAXV0108.input.auto_open_signal := TRUE;
						IF MBAXV0108.input.open_feedback_state THEN
							step1_4b := 5;
						END_IF;
					5:
						IF MBALIT0101.status.value <= MBAS1B_PARA_L4 THEN
							step1_4b := 6;
						END_IF;
					6:
						TON_14.PT := DINT_TO_TIME(MBAS1B_PARA_T5 * 60 * 1000);
						TON_14.IN := TRUE;
						IF TON_14.Q THEN
							TON_14.IN := FALSE;
							step1_4b := 7;
						END_IF;
					7:
						MBAXV0108.input.auto_open_signal := FALSE;
						IF MBAXV0108.input.close_feedback_state THEN
							step1_4b := 0;
							MBAS1B_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
				TON_14();
			3:
				//人工投料,结束后确认
			4:
				CASE step1_6b OF
					0:
						IF NOT MBAS1B_STEP[4].done THEN
							step1_6b := 1;
						END_IF;
					1:
						LiquidRelease_1(sp_time := DINT_TO_TIME(MBAS1B_PARA_T10 * 60 * 1000),
						level_value := MBALIT0104.status.value,
						set_point := MBAS1B_PARA_L5,
						done := step1_6b_1_done);
						MBAAV0102A.input.auto_open_signal := LiquidRelease_1.run;
						IF step1_6b_1_done AND MBAAV0102A.input.close_feedback_state AND (NOT MBAAV0102A.input.auto_open_signal) THEN
							step1_6b := 2;
						END_IF;
					2:
						MBAR01B.input.auto_run_signal := TRUE;
						IF MBAR01B.input.run_feedback THEN
							step1_6b := 0;
							step1_6b_1_done := FALSE;
							MBAS1B_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
			5:
				CASE step1_7b OF
					0:
						IF NOT MBAS1B_STEP[5].done THEN
							step1_7b := 1;
						END_IF;
					1:
						TON_15.PT := DINT_TO_TIME(MBAS1B_PARA_T6 * 60 * 1000);
						TON_15.IN := TRUE;
						IF TON_15.Q THEN
							TON_15.IN := FALSE;
							step1_7b := 2;
						END_IF;
					2:
						MBAXV0106.input.auto_open_signal := TRUE;
						IF MBAXV0106.input.open_feedback_state THEN
							step1_7b := 3;
						END_IF;
					3:
						IF MBATIT0102.status.value >= MBAS1B_PARA_Temp1 THEN
							step1_7b := 4;
						END_IF;
					4:
						MBAXV0107.input.auto_open_signal := TRUE;
						IF MBAXV0107.input.open_feedback_state THEN
							step1_7b := 5;
						END_IF;
					5:
						TON_15.PT := DINT_TO_TIME(MBAS1B_PARA_T7 * 60 * 1000);
						TON_15.IN := TRUE;
						IF TON_15.Q THEN
							TON_15.IN := FALSE;
							step1_7b := 6;
						END_IF;
					6:
						MBAAV0102B.input.auto_open_signal := TRUE;
						IF MBAAV0102B.input.open_feedback_state THEN
							step1_7b := 7;
						END_IF;
					7:
						TON_15.PT := DINT_TO_TIME(MBAS1B_PARA_T8 * 60 * 1000);
						TON_15.IN := TRUE;
						IF TON_15.Q THEN
							TON_15.IN := FALSE;
							step1_7b := 8;
						END_IF;
					8:
						MBAAV0102A.input.auto_open_signal := TRUE;
						IF MBAAV0102A.input.open_feedback_state THEN
							step1_7b := 9;
						END_IF;
					9:
						TON_15.PT := DINT_TO_TIME(MBAS1B_PARA_T9 * 60 * 1000);
						TON_15.IN := TRUE;
						IF TON_15.Q THEN
							TON_15.IN := FALSE;
							step1_7b := 10;
						END_IF;
					10:
						MBAXV0107.input.auto_open_signal := FALSE;
						MBAAV0102A.input.auto_open_signal := FALSE;
						MBAAV0102B.input.auto_open_signal := FALSE;
						IF MBAXV0107.input.close_feedback_state AND MBAAV0102A.input.close_feedback_state AND MBAAV0102B.input.close_feedback_state THEN
							step1_7b := 0;
							MBAS1B_STEP[5].done := TRUE;
						END_IF;
				END_CASE;
				TON_15();
			6:
				//人工确认MBAR13空闲
			7:
				MBAXV0209.input.auto_open_signal := TRUE;
				MBAXV0212.input.auto_open_signal := TRUE;
				MBAXV0415.input.auto_open_signal := TRUE;
				IF MBAXV0209.input.open_feedback_state AND MBAXV0212.input.open_feedback_state AND MBAXV0415.input.open_feedback_state THEN
					MBAXV0109.input.auto_open_signal := TRUE;
					MBAR01B.input.auto_run_signal := FALSE;
				END_IF;
				IF MBAXV0209.input.open_feedback_state AND MBAXV0212.input.open_feedback_state AND MBAXV0415.input.open_feedback_state AND MBAXV0109.input.open_feedback_state AND (NOT MBAR01B.input.run_feedback) THEN
					MBAS1B_STEP[7].done := TRUE;
				END_IF;
			8:
				//人工确认转移完毕
			9:
				MBAXV0109.input.auto_open_signal := FALSE;
				MBAXV0106.input.auto_open_signal := FALSE;
				IF MBAXV0109.input.close_feedback_state AND MBAXV0106.input.close_feedback_state THEN
					MBAS1B_STEP[9].done := TRUE;
				END_IF;
		END_CASE;
	END_IF;
	
	IF mba_v02b_add THEN
		CASE step1_1b OF
			0:
				step1_1b := 1;
			1:
				STFLV0101.input.auto_open_signal := FALSE;
				STFLV0102.input.auto_open_signal := FALSE;
				MBALV0104.input.auto_open_signal := TRUE;
				IF STFLV0102.input.close_feedback_state AND STFLV0101.input.close_feedback_state AND MBALV0104.input.open_feedback_state THEN
					step1_1b := 2;
				END_IF;
			2:
				LiquidAdd_4(level_value := MBALIT0104.status.value,
				sp_value := MBAS1B_PARA_L1,
				sp_accumulation := MBAS1B_PARA_AC1,
				sp_time := DINT_TO_TIME(MBAS1B_PARA_T1 * 1000),
				flowmeter := STFFQIT0102,
				done := step1_1b_2_done);
				STFP01.input.auto_run_signal := LiquidAdd_4.run;
				IF step1_1b_2_done AND (NOT STFP01.input.run_feedback) AND (NOT STFP01.input.auto_run_signal) THEN
					step1_1b := 3;
				END_IF;
			3:
				IF STFFQIT0102.flowrate <= flowrate_threshold THEN
					step1_1b := 4;
				END_IF;
			4:
				MBALV0104.input.auto_open_signal := FALSE;
				IF MBALV0104.input.close_feedback_state THEN
					step1_1b := 0;
					step1_1b_2_done := FALSE;
					mba_v02b_add := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	IF mba_v03b_add THEN
		CASE step1_2b OF
			0:
				step1_2b := 1;
			1:
				STFLV3601.input.auto_open_signal := TRUE;
				STFLV3602.input.auto_open_signal := FALSE;
				MBALV0105.input.auto_open_signal := TRUE;
				IF STFLV3601.input.open_feedback_state AND STFLV3602.input.close_feedback_state AND MBALV0105.input.open_feedback_state THEN
					step1_2b := 2;
				END_IF;
			2:
				LiquidAdd_5(level_value := MBALIT0105.status.value,
				sp_value := MBAS1B_PARA_L2,
				sp_accumulation := MBAS1B_PARA_AC2,
				sp_time := DINT_TO_TIME(MBAS1B_PARA_T2 * 1000),
				flowmeter := STFFQIT3602,
				done := step1_2b_2_done);
				STFP36.input.auto_run_signal := LiquidAdd_5.run;
				IF step1_2b_2_done AND (NOT STFP36.input.run_feedback) AND (NOT STFP36.input.auto_run_signal) THEN
					step1_2b := 3;
				END_IF;
			3:
				IF STFFQIT3602.flowrate <= flowrate_threshold THEN
					step1_2b := 4;
				END_IF;
			4:
				MBALV0105.input.auto_open_signal := FALSE;
				IF MBALV0105.input.close_feedback_state THEN
					step1_2b := 0;
					step1_2b_2_done := FALSE;
					mba_v03b_add := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS1B.status.run_state) AND (NOT MBAS1B_STEP[MBAS1B.status.run_step].done AND ((MBAS1B.status.run_step = 1) OR (MBAS1B.status.run_step = 3) OR (MBAS1B.status.run_step = 6) OR (MBAS1B.status.run_step = 8))) THEN
		MBAS1B.status.confirm_enable := TRUE;
	ELSE
		MBAS1B.status.confirm_enable := FALSE;
	END_IF;	
END_ACTION

