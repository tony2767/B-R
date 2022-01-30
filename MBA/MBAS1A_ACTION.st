
ACTION S1A_ACT: 
	//设定时间
	FOR i := 0 TO MBAS1_STEP_NUM DO
		IF MBAS1A_ST[i] < T#5s THEN
			MBAS1A_ST[i] := T#5s;
		END_IF;
		MBAS1A_STEP[i].set_time := MBAS1A_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(MBAS1A,MBAS1A_STEP[0],MBAS1_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS1A.status.mode <> 0) AND (NOT MBAS1A.auto_mode_edge) THEN
		MBAS1A.auto_mode_edge := TRUE;
		MBAS1A.manual_mode_edge := FALSE;
		
		STFLV0101.control.auto_operate := TRUE;
		STFLV0102.control.auto_operate := TRUE;
		MBALV0102.control.auto_operate := TRUE;
		STFP01.control.auto_operate := TRUE;
		STFLV3601.control.auto_operate := TRUE;
		STFLV3602.control.auto_operate := TRUE;
		MBALV0103.control.auto_operate := TRUE;
		STFP36.control.auto_operate := TRUE;
		MBALV0101.control.auto_operate := TRUE;
		MBAXV0105.control.auto_operate := TRUE;
		MBAXV0103.control.auto_operate := TRUE;
		MBAAV0101A.control.auto_operate := TRUE;
		MBAR01A.control.auto_operate := TRUE;
		MBAXV0102.control.auto_operate := TRUE;
		MBAXV0101.control.auto_operate := TRUE;
		MBAAV0101B.control.auto_operate := TRUE;
		MBAXV0209.control.auto_operate := TRUE;
		MBAXV0212.control.auto_operate := TRUE;
		MBAXV0104.control.auto_operate := TRUE;
		MBAXV0415.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS1A.status.mode = 0) AND (NOT MBAS1A.manual_mode_edge) THEN
		MBAS1A.manual_mode_edge := TRUE;
		MBAS1A.auto_mode_edge := FALSE;

		STFLV0101.control.manual_operate := TRUE;
		STFLV0102.control.manual_operate := TRUE;
		MBALV0102.control.manual_operate := TRUE;
		STFP01.control.manual_operate := TRUE;
		STFLV3601.control.manual_operate := TRUE;
		STFLV3602.control.manual_operate := TRUE;
		MBALV0103.control.manual_operate := TRUE;
		STFP36.control.manual_operate := TRUE;
		MBALV0101.control.manual_operate := TRUE;
		MBAXV0105.control.manual_operate := TRUE;
		MBAXV0103.control.manual_operate := TRUE;
		MBAAV0101A.control.manual_operate := TRUE;
		MBAR01A.control.manual_operate := TRUE;
		MBAXV0102.control.manual_operate := TRUE;
		MBAXV0101.control.manual_operate := TRUE;
		MBAAV0101B.control.manual_operate := TRUE;
		MBAXV0209.control.manual_operate := TRUE;
		MBAXV0212.control.manual_operate := TRUE;
		MBAXV0104.control.manual_operate := TRUE;
		MBAXV0415.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS1A.input.error_signal := (STFLV0101.status.valve_status >= 2) OR (STFLV0102.status.valve_status >= 2) OR
	(MBALV0102.status.valve_status >= 2) OR (STFP01.status.motor_status >= 2) OR (STFLV3601.status.valve_status >= 2) OR
	(STFLV3602.status.valve_status >= 2) OR (MBALV0103.status.valve_status >= 2) OR (STFP36.status.motor_status >= 2) OR
	(MBALV0101.status.valve_status >= 2) OR (MBAXV0105.status.valve_status >= 2) OR (MBAXV0103.status.valve_status >= 2) OR
	(MBAAV0101A.status.valve_status >= 2) OR (MBAR01A.status.motor_status >= 2) OR (MBAXV0102.status.valve_status >= 2) OR
	(MBAXV0101.status.valve_status >= 2) OR (MBAAV0101B.status.valve_status >= 2) OR (MBAXV0209.status.valve_status >= 2) OR
	(MBAXV0212.status.valve_status >= 2) OR (MBAXV0104.status.valve_status >= 2) OR (MBAXV0415.status.valve_status >= 2);
	
	IF MBAS1A.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS1A.status.run_step OF 
			0:
				IF NOT MBAS1A_STEP[0].done  THEN
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
					MBAS1A_STEP[0].done := TRUE;
				END_IF;
			1:
				//高位槽进料
			2:
				CASE step1_4a OF
					0:
						IF NOT MBAS1A_STEP[2].done THEN
							step1_4a := 1;
						END_IF;
					1:
						MBAXV0105.input.auto_open_signal := TRUE;
						step1_4a := 2;
					2:
						TON_8.PT := DINT_TO_TIME(MBAS1A_PARA_T4 * 1000);
						TON_8.IN := TRUE;			
						IF TON_8.Q THEN
							TON_8.IN := FALSE;
							step1_4a := 3;
						END_IF;
					3:
						MBAXV0105.input.auto_open_signal := FALSE;
						step1_4a := 4;
					4:
						MBAXV0103.input.auto_open_signal := TRUE;
						IF MBAXV0103.input.open_feedback_state THEN
							step1_4a := 5;
						END_IF;
					5:
						IF MBALIT0101.status.value <= MBAS1A_PARA_L4 THEN
							step1_4a := 6;
						END_IF;
					6:
						TON_8.PT := DINT_TO_TIME(MBAS1A_PARA_T5 * 60 * 1000);
						TON_8.IN := TRUE;
						IF TON_8.Q THEN
							TON_8.IN := FALSE;
							step1_4a := 7;
						END_IF;
					7:
						MBAXV0103.input.auto_open_signal := FALSE;
						IF MBAXV0103.input.close_feedback_state THEN
							step1_4a := 0;
							MBAS1A_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
				TON_8();
			3:
				//人工投料,结束后确认
			4:
				CASE step1_6a OF
					0:
						IF NOT MBAS1A_STEP[4].done THEN
							step1_6a := 1;
						END_IF;
					1:
						LiquidRelease_3(sp_time := DINT_TO_TIME(MBAS1A_PARA_T10 * 60 * 1000),
						level_value := MBALIT0102.status.value,
						set_point := MBAS1A_PARA_L5,
						done := step1_6a_1_done);
						MBAAV0101A.input.auto_open_signal := LiquidRelease_3.run;
						IF step1_6a_1_done AND MBAAV0101A.input.close_feedback_state AND (NOT MBAAV0101A.input.auto_open_signal) THEN
							step1_6a := 2;
						END_IF;
					2:
						MBAR01A.input.auto_run_signal := TRUE;
						IF MBAR01A.input.run_feedback THEN
							step1_6a := 0;
							step1_6a_1_done := FALSE;
							MBAS1A_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
			5:
				CASE step1_7a OF
					0:
						IF NOT MBAS1A_STEP[5].done THEN
							step1_7a := 1;
						END_IF;
					1:
						TON_13.PT := DINT_TO_TIME(MBAS1A_PARA_T6 * 60 * 1000);
						TON_13.IN := TRUE;
						IF TON_13.Q THEN
							TON_13.IN := FALSE;
							step1_7a := 2;
						END_IF;
					2:
						MBAXV0101.input.auto_open_signal := TRUE;
						IF MBAXV0101.input.open_feedback_state THEN
							step1_7a := 3;
						END_IF;
					3:
						IF MBATIT0101.status.value >= MBAS1A_PARA_Temp1 THEN
							step1_7a := 4;
						END_IF;
					4:
						MBAXV0102.input.auto_open_signal := TRUE;
						IF MBAXV0102.input.open_feedback_state THEN
							step1_7a := 5;
						END_IF;
					5:
						TON_13.PT := DINT_TO_TIME(MBAS1A_PARA_T7 * 60 * 1000);
						TON_13.IN := TRUE;
						IF TON_13.Q THEN
							TON_13.IN := FALSE;
							step1_7a := 6;
						END_IF;
					6:
						MBAAV0101B.input.auto_open_signal := TRUE;
						IF MBAAV0101B.input.open_feedback_state THEN
							step1_7a := 7;
						END_IF;
					7:
						TON_13.PT := DINT_TO_TIME(MBAS1A_PARA_T8 * 60 * 1000);
						TON_13.IN := TRUE;
						IF TON_13.Q THEN
							TON_13.IN := FALSE;
							step1_7a := 8;
						END_IF;
					8:
						MBAAV0101A.input.auto_open_signal := TRUE;
						IF MBAAV0101A.input.open_feedback_state THEN
							step1_7a := 9;
						END_IF;
					9:
						TON_13.PT := DINT_TO_TIME(MBAS1A_PARA_T9 * 60 * 1000);
						TON_13.IN := TRUE;
						IF TON_13.Q THEN
							TON_13.IN := FALSE;
							step1_7a := 10;
						END_IF;
					10:
						MBAXV0102.input.auto_open_signal := FALSE;
						MBAAV0101A.input.auto_open_signal := FALSE;
						MBAAV0101B.input.auto_open_signal := FALSE;
						IF MBAXV0102.input.close_feedback_state AND MBAAV0101A.input.close_feedback_state AND MBAAV0101B.input.close_feedback_state THEN
							step1_7a := 0;
							MBAS1A_STEP[5].done := TRUE;
						END_IF;
				END_CASE;
				TON_13();
			6:
				//人工确认MBAR13空闲
			7:	
				MBAXV0209.input.auto_open_signal := TRUE;
				MBAXV0212.input.auto_open_signal := TRUE;
				MBAXV0415.input.auto_open_signal := TRUE;
				IF MBAXV0209.input.open_feedback_state AND MBAXV0212.input.open_feedback_state AND MBAXV0415.input.open_feedback_state THEN
					MBAXV0104.input.auto_open_signal := TRUE;
					MBAR01A.input.auto_run_signal := FALSE;
				END_IF;
				IF MBAXV0209.input.open_feedback_state AND MBAXV0212.input.open_feedback_state AND MBAXV0415.input.open_feedback_state AND MBAXV0104.input.open_feedback_state AND (NOT MBAR01A.input.run_feedback) THEN
					MBAS1A_STEP[7].done := TRUE;
				END_IF;
			8:
				//人工确认转移完毕
			9:
				MBAXV0104.input.auto_open_signal := FALSE;
				MBAXV0101.input.auto_open_signal := FALSE;
				IF MBAXV0104.input.close_feedback_state AND MBAXV0101.input.close_feedback_state THEN
					MBAS1A_STEP[9].done := TRUE;
				END_IF;
		END_CASE;
	END_IF;
	
	IF mba_v02a_add THEN
		CASE step1_1a OF
			0:
				step1_1a := 1;
			1:
				STFLV0101.input.auto_open_signal := FALSE;
				STFLV0102.input.auto_open_signal := FALSE;
				MBALV0102.input.auto_open_signal := TRUE;
				IF STFLV0102.input.close_feedback_state AND STFLV0101.input.close_feedback_state AND MBALV0102.input.open_feedback_state THEN
					step1_1a := 2;
				END_IF;
			2:
				LiquidAdd_0(level_value := MBALIT0102.status.value,
				sp_value := MBAS1A_PARA_L1,
				sp_accumulation := MBAS1A_PARA_AC1,
				sp_time := DINT_TO_TIME(MBAS1A_PARA_T1 * 1000),
				flowmeter := STFFQIT0102,
				done := step1_1a_2_done);
				STFP01.input.auto_run_signal := LiquidAdd_0.run;
				IF step1_1a_2_done AND (NOT STFP01.input.run_feedback) AND (NOT STFP01.input.auto_run_signal) THEN
					step1_1a := 3;
				END_IF;
			3:
				IF STFFQIT0102.flowrate <= flowrate_threshold THEN
					step1_1a := 4;
				END_IF;
			4:
				MBALV0102.input.auto_open_signal := FALSE;
				IF MBALV0102.input.close_feedback_state THEN
					step1_1a_2_done := FALSE;
					step1_1a := 0;
					mba_v02a_add := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	IF mba_v03a_add THEN
		CASE step1_2a OF
			0:
				step1_2a := 1;
			1:
				STFLV3601.input.auto_open_signal := TRUE;
				STFLV3602.input.auto_open_signal := FALSE;
				MBALV0103.input.auto_open_signal := TRUE;
				IF STFLV3601.input.open_feedback_state AND STFLV3602.input.close_feedback_state AND MBALV0103.input.open_feedback_state THEN
					step1_2a := 2;
				END_IF;
			2:
				LiquidAdd_1(level_value := MBALIT0103.status.value,
				sp_value := MBAS1A_PARA_L2,
				sp_accumulation := MBAS1A_PARA_AC2,
				sp_time := DINT_TO_TIME(MBAS1A_PARA_T2 * 1000),
				flowmeter := STFFQIT3602,
				done := step1_2a_2_done);
				STFP36.input.auto_run_signal := LiquidAdd_1.run;
				IF step1_2a_2_done AND (NOT STFP36.input.run_feedback) AND (NOT STFP36.input.auto_run_signal) THEN
					step1_2a := 3;
				END_IF;
			3:
				IF STFFQIT3602.flowrate <= flowrate_threshold THEN
					step1_2a := 4;
				END_IF;
			4:
				MBALV0103.input.auto_open_signal := FALSE;
				IF MBALV0103.input.close_feedback_state THEN
					step1_2a := 0;
					step1_2a_2_done := FALSE;
					mba_v03a_add := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS1A.status.run_state) AND (NOT MBAS1A_STEP[MBAS1A.status.run_step].done AND ((MBAS1A.status.run_step = 1) OR (MBAS1A.status.run_step = 3) OR (MBAS1A.status.run_step = 6) OR (MBAS1A.status.run_step = 8))) THEN
		MBAS1A.status.confirm_enable := TRUE;
	ELSE
		MBAS1A.status.confirm_enable := FALSE;
	END_IF;	
END_ACTION

