
ACTION P2S2C_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S2_STEP_NUM DO
		IF EDTP2S2C_ST[i] < T#5s THEN
			EDTP2S2C_ST[i] := T#5s;
		END_IF;
		EDTP2S2C_STEP[i].set_time := EDTP2S2C_ST[i];
	END_FOR;

	
	//流程步骤
	ProcessHandleFC(EDTP2S2C,EDTP2S2C_STEP[0],EDTP2S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S2C.status.mode <> 0) AND (NOT EDTP2S2C.auto_mode_edge) THEN
		EDTP2S2C.auto_mode_edge := TRUE;
		EDTP2S2C.manual_mode_edge := FALSE;
		
		EDTXV0601.control.auto_operate := TRUE;
		EDTP06.control.auto_operate := TRUE;
		EDTXV0603.control.auto_operate := TRUE;
		EDTP02.control.auto_operate := TRUE;
		EDTXV0602.control.auto_operate := TRUE;
		EDTP04.control.auto_operate := TRUE;
		EDTXV0629.control.auto_operate := TRUE;
		EDTXV0626.control.auto_operate := TRUE;
		EDTXV0627.control.auto_operate := TRUE;
		EDTXV0631.control.auto_operate := TRUE;
		EDTXV0645.control.auto_operate := TRUE;
		EDTR05C.control.auto_operate := TRUE;
		EDTXV0643.control.auto_operate := TRUE;
		EDTTV0605D.control.auto_operate := TRUE;
		EDTTV0605F.control.auto_operate := TRUE;
		EDTTV0605E.control.auto_operate := TRUE;
		EDTXV0625.control.auto_operate := TRUE;
		EDTXV0630.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S2C.status.mode = 0) AND (NOT EDTP2S2C.manual_mode_edge) THEN
		EDTP2S2C.manual_mode_edge := TRUE;
		EDTP2S2C.auto_mode_edge := FALSE;
		
		EDTXV0601.control.manual_operate := TRUE;
		EDTP06.control.manual_operate := TRUE;
		EDTXV0603.control.manual_operate := TRUE;
		EDTP02.control.manual_operate := TRUE;
		EDTXV0602.control.manual_operate := TRUE;
		EDTP04.control.manual_operate := TRUE;
		EDTXV0629.control.manual_operate := TRUE;
		EDTXV0626.control.manual_operate := TRUE;
		EDTXV0627.control.manual_operate := TRUE;
		EDTXV0631.control.manual_operate := TRUE;
		EDTXV0645.control.manual_operate := TRUE;
		EDTR05C.control.manual_operate := TRUE;
		EDTXV0643.control.manual_operate := TRUE;
		EDTTV0605D.control.manual_operate := TRUE;
		EDTTV0605F.control.manual_operate := TRUE;
		EDTTV0605E.control.manual_operate := TRUE;
		EDTXV0625.control.manual_operate := TRUE;
		EDTXV0630.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S2C.input.error_signal := (EDTXV0601.status.valve_status >= 2) OR (EDTP06.status.motor_status >= 2) OR
	(EDTXV0603.status.valve_status >= 2) OR(EDTP02.status.motor_status >= 2) OR (EDTXV0602.status.valve_status >= 2) OR
	(EDTP04.status.motor_status >= 2) OR (EDTXV0629.status.valve_status >= 2) OR (EDTXV0626.status.valve_status >= 2) OR
	(EDTXV0627.status.valve_status >= 2) OR (EDTXV0631.status.valve_status >= 2) OR (EDTXV0645.status.valve_status >= 2) OR 
	(EDTR05C.status.motor_status >= 2) OR (EDTTV0605D.status.valve_status >= 2) OR (EDTXV0643.status.valve_status >= 2) OR
	(EDTTV0605F.status.valve_status >= 2) OR (EDTTV0605E.status.valve_status >= 2) OR (EDTXV0625.status.valve_status >= 2) OR (EDTXV0630.status.valve_status >= 2);
	
	IF EDTP2S2C.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S2C.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S2C_STEP[0].done THEN
					EDTXV0601.control.auto_operate := TRUE;
					EDTP06.control.auto_operate := TRUE;
					EDTXV0603.control.auto_operate := TRUE;
					EDTP02.control.auto_operate := TRUE;
					EDTXV0602.control.auto_operate := TRUE;
					EDTP04.control.auto_operate := TRUE;
					EDTXV0629.control.auto_operate := TRUE;
					EDTXV0626.control.auto_operate := TRUE;
					EDTXV0627.control.auto_operate := TRUE;
					EDTXV0631.control.auto_operate := TRUE;
					EDTXV0645.control.auto_operate := TRUE;
					EDTR05C.control.auto_operate := TRUE;
					EDTXV0643.control.auto_operate := TRUE;
					EDTTV0605D.control.auto_operate := TRUE;
					EDTTV0605F.control.auto_operate := TRUE;
					EDTTV0605E.control.auto_operate := TRUE;
					EDTXV0625.control.auto_operate := TRUE;
					EDTXV0630.control.auto_operate := TRUE;
					EDTP2S2C_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料edc
			2:
				EDTXV0630.input.auto_open_signal := FALSE;
				IF EDTXV0630.input.close_feedback_state THEN
					EDTXV0629.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0629.input.open_feedback_state THEN
					EDTXV0631.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0631.input.open_feedback_state THEN
					EDTXV0645.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0629.input.open_feedback_state AND EDTXV0631.input.open_feedback_state AND EDTXV0645.input.open_feedback_state THEN
					EDTP2S2C_STEP[2].done := TRUE;
				END_IF;
			3:	
				CASE p2_step2_3c OF
					0:
						IF NOT EDTP2S2C_STEP[3].done THEN
							p2_step2_3c := 1;
						END_IF;
					1:
						EDTXV0626.input.auto_open_signal := TRUE;
						IF EDTXV0626.input.open_feedback_state THEN
							p2_step2_3c := 2;
						END_IF;
					2:
						TON_32.PT := DINT_TO_TIME(EDTP2S2_PARA_T4 * 60 * 1000);
						TON_32.IN := TRUE;
						IF TON_32.Q THEN
							TON_32.IN := FALSE;
							p2_step2_3c := 3;
						END_IF;
					3:
						EDTXV0627.input.auto_open_signal := TRUE;
						IF EDTXV0627.input.open_feedback_state THEN
							p2_step2_3c := 4;
						END_IF;
					4:
						TON_32.PT := DINT_TO_TIME(EDTP2S2_PARA_T5 * 60 * 1000);
						TON_32.IN := TRUE;
						IF TON_32.Q THEN
							TON_32.IN := FALSE;
							p2_step2_3c := 5;
						END_IF;
					5:
						EDTXV0626.input.auto_open_signal := FALSE;
						EDTXV0627.input.auto_open_signal := FALSE;
						IF EDTXV0626.input.close_feedback_state AND EDTXV0627.input.close_feedback_state THEN
							p2_step2_3c := 6;
						END_IF;
					6:
						p2_step2_3c := 7;
					7:
						IF EDTTIT0605.status.value < EDTP2S2_PARA_Temp1 THEN
							p2_step2_3c := 8;
						ELSE
							p2_step2_3c := 9;
						END_IF;
					8:
						//升温
						CASE p2_step2_3c_8 OF
							0:
								EDTTV0605F.input.auto_open_signal := TRUE;
								IF EDTTV0605F.input.open_feedback_state THEN
									EDTXV0643.input.auto_open_signal := TRUE;
									p2_step2_3c_8 := 1;
								END_IF;
							1:
								TON_33.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
								TON_33.IN := TRUE;
								IF TON_33.Q THEN
									TON_33.IN := FALSE;
									p2_step2_3c_8 := 2;
								END_IF;
							2:
								EDTXV0643.input.auto_open_signal := FALSE;
								EDTTV0605F.input.auto_open_signal := FALSE;
								IF EDTTV0605F.input.close_feedback_state THEN
									p2_step2_3c_8 := 3;
								END_IF;
							3:
								EDTTV0605E.input.auto_open_signal := TRUE;
								IF EDTTV0605E.input.open_feedback_state THEN
									EDTTV0605D.input.auto_open_signal := TRUE;
									IF EDTTV0605D.input.open_feedback_state THEN
										p2_step2_3c_8 := 4;
									END_IF;
								END_IF;
							4:
								IF EDTTIT0605.status.value >= EDTP2S2_PARA_Temp1 THEN
									p2_step2_3c_8 := 5;
								END_IF;
							5:
								EDTTV0605D.input.auto_open_signal := FALSE;
								IF EDTTV0605D.input.close_feedback_state THEN
									EDTTV0605E.input.auto_open_signal := FALSE;
									IF EDTTV0605E.input.close_feedback_state THEN
										EDTTV0605F.input.auto_open_signal := TRUE;//21.2.5
										IF EDTTV0605F.input.open_feedback_state THEN
											p2_step2_3c_8 := 0;
											p2_step2_3c := 9;
										END_IF;
									END_IF;
								END_IF;
						END_CASE;
						TON_33();
					9:
						//温度和时间到enable confirm
						EDTR05C.input.auto_run_signal := TRUE;
						TON_32.PT := DINT_TO_TIME(EDTP2S2_PARA_T6 * 60 * 1000);
						TON_32.IN := TRUE;
						p2_step2_3c := 10;
					10:
						IF TON_32.Q THEN
							TON_32.IN := FALSE;
							p2_step2_3c_confirm_enable := TRUE;
						END_IF;
						IF EDTP2S2C_STEP[3].done THEN
							p2_step2_3c := 0;
							p2_step2_3c_confirm_enable := FALSE;
						END_IF;
				END_CASE;
				TON_32();
			4:
				CASE p2_step2_4c OF
					0:
						IF NOT EDTP2S2C_STEP[4].done THEN
							p2_step2_4c := 1;
						END_IF;
					1:
						EDTXV0625.input.auto_open_signal := TRUE;
						p2_step2_4c := 2;
					2:
						TON_34.PT := DINT_TO_TIME(EDTP2S2_PARA_T8 * 60 * 1000);
						TON_34.IN := TRUE;
						IF TON_34.Q THEN
							TON_34.IN := FALSE;
							p2_step2_4c := 3;
						END_IF;
					3:
						EDTXV0625.input.auto_open_signal := FALSE;
						IF EDTXV0625.input.close_feedback_state THEN
							p2_step2_4c := 4;
						END_IF;
					4:
						EDTTV0605F.input.auto_open_signal := TRUE;
						IF EDTTV0605F.input.open_feedback_state THEN
							EDTXV0643.input.auto_open_signal := TRUE;
							p2_step2_4c := 5;
						END_IF;
					5:
						TON_34.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
						TON_34.IN := TRUE;
						IF TON_34.Q THEN
							TON_34.IN := FALSE;
							p2_step2_4c := 6;
						END_IF;
					6:
						EDTXV0643.input.auto_open_signal := FALSE;
						EDTTV0605F.input.auto_open_signal := FALSE;
						IF EDTTV0605F.input.close_feedback_state THEN
							p2_step2_4c := 7;
						END_IF;
					7:
						EDTTV0605E.input.auto_open_signal := TRUE;
						IF EDTTV0605E.input.open_feedback_state THEN
							EDTTV0605D.input.auto_open_signal := TRUE;
							IF EDTTV0605D.input.open_feedback_state THEN
								p2_step2_4c := 8;
							END_IF;
						END_IF;
					8:
						IF EDTTIT0605.status.value >= EDTP2S2_PARA_Temp2 THEN
							p2_step2_4c := 0;
							EDTP2S2C_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
				TON_34();
			5:
				//确认回收结束
			6:
				EDTXV0629.input.auto_open_signal := FALSE;
				EDTXV0630.input.auto_open_signal := TRUE;
				EDTTV0605D.input.auto_open_signal := FALSE;
				IF EDTTV0605D.input.close_feedback_state THEN
					EDTTV0605E.input.auto_open_signal := FALSE;
					IF EDTTV0605E.input.close_feedback_state THEN
						EDTTV0605F.input.auto_open_signal := TRUE;//21.2.5
						IF EDTTV0605F.input.open_feedback_state THEN
							EDTP2S2C_STEP[6].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
		END_CASE;		
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP2S2C.status.run_state) AND (NOT EDTP2S2C_STEP[EDTP2S2C.status.run_step].done AND ((EDTP2S2C.status.run_step = 1) OR (EDTP2S2C.status.run_step = 5) OR (p2_step2_3c_confirm_enable))) THEN
		EDTP2S2C.status.confirm_enable := TRUE;
	ELSE
		EDTP2S2C.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
