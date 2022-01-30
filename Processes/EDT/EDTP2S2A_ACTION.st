
ACTION P2S2A_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S2_STEP_NUM DO
		IF EDTP2S2A_ST[i] < T#5s THEN
			EDTP2S2A_ST[i] := T#5s;
		END_IF;
		EDTP2S2A_STEP[i].set_time := EDTP2S2A_ST[i];
	END_FOR;

	
	//流程步骤
	ProcessHandleFC(EDTP2S2A,EDTP2S2A_STEP[0],EDTP2S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S2A.status.mode <> 0) AND (NOT EDTP2S2A.auto_mode_edge) THEN
		EDTP2S2A.auto_mode_edge := TRUE;
		EDTP2S2A.manual_mode_edge := FALSE;
		
		EDTXV0601.control.auto_operate := TRUE;
		EDTP06.control.auto_operate := TRUE;
		EDTXV0603.control.auto_operate := TRUE;
		EDTP02.control.auto_operate := TRUE;
		EDTXV0602.control.auto_operate := TRUE;
		EDTP04.control.auto_operate := TRUE;
		EDTXV0609.control.auto_operate := TRUE;
		EDTXV0605.control.auto_operate := TRUE;
		EDTXV0606.control.auto_operate := TRUE;
		EDTXV0611.control.auto_operate := TRUE;
		EDTXV0645.control.auto_operate := TRUE;
		EDTR05A.control.auto_operate := TRUE;
		EDTXV0641.control.auto_operate := TRUE;
		EDTTV0601D.control.auto_operate := TRUE;
		EDTTV0601F.control.auto_operate := TRUE;
		EDTTV0601E.control.auto_operate := TRUE;
		EDTXV0604.control.auto_operate := TRUE;
		EDTXV0610.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S2A.status.mode = 0) AND (NOT EDTP2S2A.manual_mode_edge) THEN
		EDTP2S2A.manual_mode_edge := TRUE;
		EDTP2S2A.auto_mode_edge := FALSE;
		
		EDTXV0601.control.manual_operate := TRUE;
		EDTP06.control.manual_operate := TRUE;
		EDTXV0603.control.manual_operate := TRUE;
		EDTP02.control.manual_operate := TRUE;
		EDTXV0602.control.manual_operate := TRUE;
		EDTP04.control.manual_operate := TRUE;
		EDTXV0609.control.manual_operate := TRUE;
		EDTXV0605.control.manual_operate := TRUE;
		EDTXV0606.control.manual_operate := TRUE;
		EDTXV0611.control.manual_operate := TRUE;
		EDTXV0645.control.manual_operate := TRUE;
		EDTR05A.control.manual_operate := TRUE;
		EDTXV0641.control.manual_operate := TRUE;
		EDTTV0601D.control.manual_operate := TRUE;
		EDTTV0601F.control.manual_operate := TRUE;
		EDTTV0601E.control.manual_operate := TRUE;
		EDTXV0604.control.manual_operate := TRUE;
		EDTXV0610.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S2A.input.error_signal := (EDTXV0601.status.valve_status >= 2) OR (EDTP06.status.motor_status >= 2) OR
	(EDTXV0603.status.valve_status >= 2) OR(EDTP02.status.motor_status >= 2) OR (EDTXV0602.status.valve_status >= 2) OR
	(EDTP04.status.motor_status >= 2) OR (EDTXV0609.status.valve_status >= 2) OR (EDTXV0605.status.valve_status >= 2) OR
	(EDTXV0606.status.valve_status >= 2) OR (EDTXV0611.status.valve_status >= 2) OR (EDTXV0645.status.valve_status >= 2) OR 
	(EDTR05A.status.motor_status >= 2) OR (EDTTV0601D.status.valve_status >= 2) OR (EDTXV0641.status.valve_status >= 2) OR
	(EDTTV0601F.status.valve_status >= 2) OR (EDTTV0601E.status.valve_status >= 2) OR (EDTXV0604.status.valve_status >= 2) OR (EDTXV0610.status.valve_status >= 2);
	
	IF EDTP2S2A.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S2A.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S2A_STEP[0].done THEN
					EDTXV0601.control.auto_operate := TRUE;
					EDTP06.control.auto_operate := TRUE;
					EDTXV0603.control.auto_operate := TRUE;
					EDTP02.control.auto_operate := TRUE;
					EDTXV0602.control.auto_operate := TRUE;
					EDTP04.control.auto_operate := TRUE;
					EDTXV0609.control.auto_operate := TRUE;
					EDTXV0605.control.auto_operate := TRUE;
					EDTXV0606.control.auto_operate := TRUE;
					EDTXV0611.control.auto_operate := TRUE;
					EDTXV0645.control.auto_operate := TRUE;
					EDTR05A.control.auto_operate := TRUE;
					EDTXV0641.control.auto_operate := TRUE;
					EDTTV0601D.control.auto_operate := TRUE;
					EDTTV0601F.control.auto_operate := TRUE;
					EDTTV0601E.control.auto_operate := TRUE;
					EDTXV0604.control.auto_operate := TRUE;
					EDTXV0610.control.auto_operate := TRUE;
					EDTP2S2A_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料edc
			2:
				EDTXV0610.input.auto_open_signal := FALSE;
				IF EDTXV0610.input.close_feedback_state THEN
					EDTXV0609.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0609.input.open_feedback_state THEN
					EDTXV0611.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0611.input.open_feedback_state THEN
					EDTXV0645.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0609.input.open_feedback_state AND EDTXV0611.input.open_feedback_state AND EDTXV0645.input.open_feedback_state THEN
					EDTP2S2A_STEP[2].done := TRUE;
				END_IF;
			3:	
				CASE p2_step2_3a OF
					0:
						IF NOT EDTP2S2A_STEP[3].done THEN
							p2_step2_3a := 1;
						END_IF;
					1:
						EDTXV0605.input.auto_open_signal := TRUE;
						IF EDTXV0605.input.open_feedback_state THEN
							p2_step2_3a := 2;
						END_IF;
					2:
						TON_17.PT := DINT_TO_TIME(EDTP2S2_PARA_T4 * 60 * 1000);
						TON_17.IN := TRUE;
						IF TON_17.Q THEN
							TON_17.IN := FALSE;
							p2_step2_3a := 3;
						END_IF;
					3:
						EDTXV0606.input.auto_open_signal := TRUE;
						IF EDTXV0606.input.open_feedback_state THEN
							p2_step2_3a := 4;
						END_IF;
					4:
						TON_17.PT := DINT_TO_TIME(EDTP2S2_PARA_T5 * 60 * 1000);
						TON_17.IN := TRUE;
						IF TON_17.Q THEN
							TON_17.IN := FALSE;
							p2_step2_3a := 5;
						END_IF;
					5:
						EDTXV0605.input.auto_open_signal := FALSE;
						EDTXV0606.input.auto_open_signal := FALSE;
						IF EDTXV0605.input.close_feedback_state AND EDTXV0606.input.close_feedback_state THEN
							p2_step2_3a := 6;
						END_IF;
					6:
						p2_step2_3a := 7;
					7:
						IF EDTTIT0601.status.value < EDTP2S2_PARA_Temp1 THEN
							p2_step2_3a := 8;
						ELSE
							p2_step2_3a := 9;
						END_IF;
					8:
						//升温
						CASE p2_step2_3a_8 OF
							0:
								EDTTV0601F.input.auto_open_signal := TRUE;
								IF EDTTV0601F.input.open_feedback_state THEN
									EDTXV0641.input.auto_open_signal := TRUE;
									p2_step2_3a_8 := 1;
								END_IF;
							1:
								TON_8.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
								TON_8.IN := TRUE;
								IF TON_8.Q THEN
									TON_8.IN := FALSE;
									p2_step2_3a_8 := 2;
								END_IF;
							2:
								EDTXV0641.input.auto_open_signal := FALSE;
								EDTTV0601F.input.auto_open_signal := FALSE;
								IF EDTTV0601F.input.close_feedback_state THEN
									p2_step2_3a_8 := 3;
								END_IF;
							3:
								EDTTV0601E.input.auto_open_signal := TRUE;
								IF EDTTV0601E.input.open_feedback_state THEN
									EDTTV0601D.input.auto_open_signal := TRUE;
									IF EDTTV0601D.input.open_feedback_state THEN
										p2_step2_3a_8 := 4;
									END_IF;
								END_IF;
							4:
								IF EDTTIT0601.status.value >= EDTP2S2_PARA_Temp1 THEN
									p2_step2_3a_8 := 5;
								END_IF;
							5:
								EDTTV0601D.input.auto_open_signal := FALSE;
								IF EDTTV0601D.input.close_feedback_state THEN
									EDTTV0601E.input.auto_open_signal := FALSE;
									IF EDTTV0601E.input.close_feedback_state THEN
										EDTTV0601F.input.auto_open_signal := TRUE;//21.2.5
										IF EDTTV0601F.input.open_feedback_state THEN
											p2_step2_3a_8 := 0;
											p2_step2_3a := 9;
										END_IF;
									END_IF;
								END_IF;
						END_CASE;
						TON_8();
					9:
						//温度和时间到enable confirm
						EDTR05A.input.auto_run_signal := TRUE;
						TON_17.PT := DINT_TO_TIME(EDTP2S2_PARA_T6 * 60 * 1000);
						TON_17.IN := TRUE;
						p2_step2_3a := 10;
					10:
						IF TON_17.Q THEN
							TON_17.IN := FALSE;
							p2_step2_3a_confirm_enable := TRUE;
						END_IF;
						IF EDTP2S2A_STEP[3].done THEN
							p2_step2_3a := 0;
							p2_step2_3a_confirm_enable := FALSE;
						END_IF;
				END_CASE;
				TON_17();
			4:
				CASE p2_step2_4a OF
					0:
						IF NOT EDTP2S2A_STEP[4].done THEN
							p2_step2_4a := 1;
						END_IF;
					1:
						EDTXV0604.input.auto_open_signal := TRUE;
						p2_step2_4a := 2;
					2:
						TON_15.PT := DINT_TO_TIME(EDTP2S2_PARA_T8 * 60 * 1000);
						TON_15.IN := TRUE;
						IF TON_15.Q THEN
							TON_15.IN := FALSE;
							p2_step2_4a := 3;
						END_IF;
					3:
						EDTXV0604.input.auto_open_signal := FALSE;
						IF EDTXV0604.input.close_feedback_state THEN
							p2_step2_4a := 4;
						END_IF;
					4:
						EDTTV0601F.input.auto_open_signal := TRUE;
						IF EDTTV0601F.input.open_feedback_state THEN
							EDTXV0641.input.auto_open_signal := TRUE;
							p2_step2_4a := 5;
						END_IF;
					5:
						TON_15.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
						TON_15.IN := TRUE;
						IF TON_15.Q THEN
							TON_15.IN := FALSE;
							p2_step2_4a := 6;
						END_IF;
					6:
						EDTXV0641.input.auto_open_signal := FALSE;
						EDTTV0601F.input.auto_open_signal := FALSE;
						IF EDTTV0601F.input.close_feedback_state THEN
							p2_step2_4a := 7;
						END_IF;
					7:
						EDTTV0601E.input.auto_open_signal := TRUE;
						IF EDTTV0601E.input.open_feedback_state THEN
							EDTTV0601D.input.auto_open_signal := TRUE;
							IF EDTTV0601D.input.open_feedback_state THEN
								p2_step2_4a := 8;
							END_IF;
						END_IF;
					8:
						IF EDTTIT0601.status.value >= EDTP2S2_PARA_Temp2 THEN
							p2_step2_4a := 0;
							EDTP2S2A_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
				TON_15();
			5:
				//确认回收结束
			6:
				EDTXV0609.input.auto_open_signal := FALSE;
				EDTXV0610.input.auto_open_signal := TRUE;
				EDTTV0601D.input.auto_open_signal := FALSE;
				IF EDTTV0601D.input.close_feedback_state THEN
					EDTTV0601E.input.auto_open_signal := FALSE;
					IF EDTTV0601E.input.close_feedback_state THEN
						EDTTV0601F.input.auto_open_signal := TRUE;//21.2.5
						IF EDTTV0601F.input.open_feedback_state THEN
							EDTP2S2A_STEP[6].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
		END_CASE;		
	END_IF;
	
	//V14进料
	IF v14_add THEN
		CASE v14_add_step OF
			0:
				EDTXV0601.input.auto_open_signal := TRUE;
				IF EDTXV0601.input.open_feedback_state THEN
					v14_add_step := 1;
				END_IF;
			1:
				LiquidTransfer_6(sp_time := DINT_TO_TIME(EDTP2S2_PARA_T1 * 1000),
				sp_accumulation := EDTP2S2_PARA_AC1,
				done := v14_add_step1_done,
				flowmeter := EDTFQIT0501);
				EDTP06.input.auto_run_signal := LiquidTransfer_6.run;
				IF v14_add_step1_done AND (NOT EDTP06.input.run_feedback) AND (NOT EDTP06.input.auto_run_signal)THEN
					v14_add_step := 2;
					v14_add_step1_done := FALSE;
				END_IF;
			2:
				IF EDTFQIT0501.flowrate <= flowrate_threshold THEN
					EDTXV0601.input.auto_open_signal := FALSE;
					v14_add_step := 0;
					v14_add := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	//V15进料
	IF v15_add THEN
		CASE v15_add_step OF
			0:
				EDTXV0602.input.auto_open_signal := TRUE;
				IF EDTXV0602.input.open_feedback_state THEN
					v15_add_step := 1;
				END_IF;
			1:
				LiquidAddSimple_2(level_value := EDTLIT0602.status.value,
				sp_value := EDTP2S2_PARA_L1,
				sp_time := DINT_TO_TIME(EDTP2S2_PARA_T2 * 60 * 1000),
				done := v15_add_1_done);
				EDTP04.input.auto_run_signal := LiquidAddSimple_2.run;
				IF v15_add_1_done AND (NOT EDTP04.input.run_feedback) AND (NOT EDTP04.input.auto_run_signal) THEN
					v15_add_step := 2;
					v15_add_1_done := FALSE;
				END_IF;
			2:
				TON_12.PT := T#10s;
				TON_12.IN := TRUE;
				IF TON_12.Q THEN
					TON_12.IN := FALSE;
					v15_add_step := 3;
				END_IF;
			3:
				EDTXV0602.input.auto_open_signal := FALSE;
				v15_add_step := 0;
				v15_add := FALSE;
		END_CASE;
		TON_12();
	END_IF;
	//V16进料
	IF v16_add THEN
		CASE v16_add_step OF
			0:
				EDTXV0603.input.auto_open_signal := TRUE;
				IF EDTXV0603.input.open_feedback_state THEN
					v16_add_step := 1;
				END_IF;
			1:
				LiquidAddSimple_3(level_value := EDTLIT0603.status.value,
				sp_value := EDTP2S2_PARA_L2,
				sp_time := DINT_TO_TIME(EDTP2S2_PARA_T3 * 60 * 1000),
				done := v16_add_1_done);
				EDTP02.input.auto_run_signal := LiquidAddSimple_3.run;
				IF v16_add_1_done AND (NOT EDTP02.input.run_feedback) AND (NOT EDTP02.input.auto_run_signal) THEN
					v16_add_step := 2;
					v16_add_1_done := FALSE;
				END_IF;
			2:
				TON_14.PT := T#10s;
				TON_14.IN := TRUE;
				IF TON_14.Q THEN
					TON_14.IN := FALSE;
					v16_add_step := 3;
				END_IF;
			3:
				EDTXV0603.input.auto_open_signal := FALSE;
				v16_add_step := 0;
				v16_add := FALSE;
		END_CASE;
		TON_14();
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP2S2A.status.run_state) AND (NOT EDTP2S2A_STEP[EDTP2S2A.status.run_step].done AND ((EDTP2S2A.status.run_step = 1) OR (EDTP2S2A.status.run_step = 5) OR (p2_step2_3a_confirm_enable))) THEN
		EDTP2S2A.status.confirm_enable := TRUE;
	ELSE
		EDTP2S2A.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
