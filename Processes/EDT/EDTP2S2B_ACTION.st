ACTION P2S2B_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S2_STEP_NUM DO
		IF EDTP2S2B_ST[i] < T#5s THEN
			EDTP2S2B_ST[i] := T#5s;
		END_IF;
		EDTP2S2B_STEP[i].set_time := EDTP2S2B_ST[i];
	END_FOR;

	
	//流程步骤
	ProcessHandleFC(EDTP2S2B,EDTP2S2B_STEP[0],EDTP2S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S2B.status.mode <> 0) AND (NOT EDTP2S2B.auto_mode_edge) THEN
		EDTP2S2B.auto_mode_edge := TRUE;
		EDTP2S2B.manual_mode_edge := FALSE;
		
		EDTXV0601.control.auto_operate := TRUE;
		EDTP06.control.auto_operate := TRUE;
		EDTXV0603.control.auto_operate := TRUE;
		EDTP02.control.auto_operate := TRUE;
		EDTXV0602.control.auto_operate := TRUE;
		EDTP04.control.auto_operate := TRUE;
		EDTXV0621.control.auto_operate := TRUE;
		EDTXV0618.control.auto_operate := TRUE;
		EDTXV0619.control.auto_operate := TRUE;
		EDTXV0623.control.auto_operate := TRUE;
		EDTXV0645.control.auto_operate := TRUE;
		EDTR05B.control.auto_operate := TRUE;
		EDTXV0642.control.auto_operate := TRUE;
		EDTTV0603D.control.auto_operate := TRUE;
		EDTTV0603F.control.auto_operate := TRUE;
		EDTTV0603E.control.auto_operate := TRUE;
		EDTXV0617.control.auto_operate := TRUE;
		EDTXV0622.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S2B.status.mode = 0) AND (NOT EDTP2S2B.manual_mode_edge) THEN
		EDTP2S2B.manual_mode_edge := TRUE;
		EDTP2S2B.auto_mode_edge := FALSE;
		
		EDTXV0601.control.manual_operate := TRUE;
		EDTP06.control.manual_operate := TRUE;
		EDTXV0603.control.manual_operate := TRUE;
		EDTP02.control.manual_operate := TRUE;
		EDTXV0602.control.manual_operate := TRUE;
		EDTP04.control.manual_operate := TRUE;
		EDTXV0621.control.manual_operate := TRUE;
		EDTXV0618.control.manual_operate := TRUE;
		EDTXV0619.control.manual_operate := TRUE;
		EDTXV0623.control.manual_operate := TRUE;
		EDTXV0645.control.manual_operate := TRUE;
		EDTR05B.control.manual_operate := TRUE;
		EDTXV0642.control.manual_operate := TRUE;
		EDTTV0603D.control.manual_operate := TRUE;
		EDTTV0603F.control.manual_operate := TRUE;
		EDTTV0603E.control.manual_operate := TRUE;
		EDTXV0617.control.manual_operate := TRUE;
		EDTXV0622.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S2B.input.error_signal := (EDTXV0601.status.valve_status >= 2) OR (EDTP06.status.motor_status >= 2) OR
	(EDTXV0603.status.valve_status >= 2) OR(EDTP02.status.motor_status >= 2) OR (EDTXV0602.status.valve_status >= 2) OR
	(EDTP04.status.motor_status >= 2) OR (EDTXV0621.status.valve_status >= 2) OR (EDTXV0618.status.valve_status >= 2) OR
	(EDTXV0619.status.valve_status >= 2) OR (EDTXV0623.status.valve_status >= 2) OR (EDTXV0645.status.valve_status >= 2) OR 
	(EDTR05B.status.motor_status >= 2) OR (EDTTV0603D.status.valve_status >= 2) OR (EDTXV0642.status.valve_status >= 2) OR
	(EDTTV0603F.status.valve_status >= 2) OR (EDTTV0603E.status.valve_status >= 2) OR (EDTXV0617.status.valve_status >= 2) OR (EDTXV0622.status.valve_status >= 2);
	
	IF EDTP2S2B.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S2B.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S2B_STEP[0].done THEN
					EDTXV0601.control.auto_operate := TRUE;
					EDTP06.control.auto_operate := TRUE;
					EDTXV0603.control.auto_operate := TRUE;
					EDTP02.control.auto_operate := TRUE;
					EDTXV0602.control.auto_operate := TRUE;
					EDTP04.control.auto_operate := TRUE;
					EDTXV0621.control.auto_operate := TRUE;
					EDTXV0618.control.auto_operate := TRUE;
					EDTXV0619.control.auto_operate := TRUE;
					EDTXV0623.control.auto_operate := TRUE;
					EDTXV0645.control.auto_operate := TRUE;
					EDTR05B.control.auto_operate := TRUE;
					EDTXV0642.control.auto_operate := TRUE;
					EDTTV0603D.control.auto_operate := TRUE;
					EDTTV0603F.control.auto_operate := TRUE;
					EDTTV0603E.control.auto_operate := TRUE;
					EDTXV0617.control.auto_operate := TRUE;
					EDTXV0622.control.auto_operate := TRUE;
					EDTP2S2B_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料edc
			2:
				EDTXV0622.input.auto_open_signal := FALSE;
				IF EDTXV0622.input.close_feedback_state THEN
					EDTXV0621.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0621.input.open_feedback_state THEN
					EDTXV0623.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0623.input.open_feedback_state THEN
					EDTXV0645.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0621.input.open_feedback_state AND EDTXV0623.input.open_feedback_state AND EDTXV0645.input.open_feedback_state THEN
					EDTP2S2B_STEP[2].done := TRUE;
				END_IF;
			3:	
				CASE p2_step2_3b OF
					0:
						IF NOT EDTP2S2B_STEP[3].done THEN
							p2_step2_3b := 1;
						END_IF;
					1:
						EDTXV0618.input.auto_open_signal := TRUE;
						IF EDTXV0618.input.open_feedback_state THEN
							p2_step2_3b := 2;
						END_IF;
					2:
						TON_28.PT := DINT_TO_TIME(EDTP2S2_PARA_T4 * 60 * 1000);
						TON_28.IN := TRUE;
						IF TON_28.Q THEN
							TON_28.IN := FALSE;
							p2_step2_3b := 3;
						END_IF;
					3:
						EDTXV0619.input.auto_open_signal := TRUE;
						IF EDTXV0619.input.open_feedback_state THEN
							p2_step2_3b := 4;
						END_IF;
					4:
						TON_28.PT := DINT_TO_TIME(EDTP2S2_PARA_T5 * 60 * 1000);
						TON_28.IN := TRUE;
						IF TON_28.Q THEN
							TON_28.IN := FALSE;
							p2_step2_3b := 5;
						END_IF;
					5:
						EDTXV0618.input.auto_open_signal := FALSE;
						EDTXV0619.input.auto_open_signal := FALSE;
						IF EDTXV0618.input.close_feedback_state AND EDTXV0619.input.close_feedback_state THEN
							p2_step2_3b := 6;
						END_IF;
					6:
						p2_step2_3b := 7;
					7:
						IF EDTTIT0603.status.value < EDTP2S2_PARA_Temp1 THEN
							p2_step2_3b := 8;
						ELSE
							p2_step2_3b := 9;
						END_IF;
					8:
						//升温
						CASE p2_step2_3b_8 OF
							0:
								EDTTV0603F.input.auto_open_signal := TRUE;
								IF EDTTV0603F.input.open_feedback_state THEN
									EDTXV0642.input.auto_open_signal := TRUE;
									p2_step2_3b_8 := 1;
								END_IF;
							1:
								TON_30.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
								TON_30.IN := TRUE;
								IF TON_30.Q THEN
									TON_30.IN := FALSE;
									p2_step2_3b_8 := 2;
								END_IF;
							2:
								EDTXV0642.input.auto_open_signal := FALSE;
								EDTTV0603F.input.auto_open_signal := FALSE;
								IF EDTTV0603F.input.close_feedback_state THEN
									p2_step2_3b_8 := 3;
								END_IF;
							3:
								EDTTV0603E.input.auto_open_signal := TRUE;
								IF EDTTV0603E.input.open_feedback_state THEN
									EDTTV0603D.input.auto_open_signal := TRUE;
									IF EDTTV0603D.input.open_feedback_state THEN
										p2_step2_3b_8 := 4;
									END_IF;
								END_IF;
							4:
								IF EDTTIT0603.status.value >= EDTP2S2_PARA_Temp1 THEN
									p2_step2_3b_8 := 5;
								END_IF;
							5:
								EDTTV0603D.input.auto_open_signal := FALSE;
								IF EDTTV0603D.input.close_feedback_state THEN
									EDTTV0603E.input.auto_open_signal := FALSE;
									IF EDTTV0603E.input.close_feedback_state THEN
										EDTTV0603F.input.auto_open_signal := TRUE;//21.2.5
										IF EDTTV0603F.input.open_feedback_state THEN
											p2_step2_3b_8 := 0;
											p2_step2_3b := 9;
										END_IF;
									END_IF;
								END_IF;
						END_CASE;
						TON_30();
					9:
						//温度和时间到enable confirm
						EDTR05B.input.auto_run_signal := TRUE;
						TON_28.PT := DINT_TO_TIME(EDTP2S2_PARA_T6 * 60 * 1000);
						TON_28.IN := TRUE;
						p2_step2_3b := 10;
					10:
						IF TON_28.Q THEN
							TON_28.IN := FALSE;
							p2_step2_3b_confirm_enable := TRUE;
						END_IF;
						IF EDTP2S2B_STEP[3].done THEN
							p2_step2_3b := 0;
							p2_step2_3b_confirm_enable := FALSE;
						END_IF;
				END_CASE;
				TON_28();
			4:
				CASE p2_step2_4b OF
					0:
						IF NOT EDTP2S2B_STEP[4].done THEN
							p2_step2_4b := 1;
						END_IF;
					1:
						EDTXV0617.input.auto_open_signal := TRUE;
						p2_step2_4b := 2;
					2:
						TON_31.PT := DINT_TO_TIME(EDTP2S2_PARA_T8 * 60 * 1000);
						TON_31.IN := TRUE;
						IF TON_31.Q THEN
							TON_31.IN := FALSE;
							p2_step2_4b := 3;
						END_IF;
					3:
						EDTXV0617.input.auto_open_signal := FALSE;
						IF EDTXV0617.input.close_feedback_state THEN
							p2_step2_4b := 4;
						END_IF;
					4:
						EDTTV0603F.input.auto_open_signal := TRUE;
						IF EDTTV0603F.input.open_feedback_state THEN
							EDTXV0642.input.auto_open_signal := TRUE;
							p2_step2_4b := 5;
						END_IF;
					5:
						TON_31.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
						TON_31.IN := TRUE;
						IF TON_31.Q THEN
							TON_31.IN := FALSE;
							p2_step2_4b := 6;
						END_IF;
					6:
						EDTXV0642.input.auto_open_signal := FALSE;
						EDTTV0603F.input.auto_open_signal := FALSE;
						IF EDTTV0603F.input.close_feedback_state THEN
							p2_step2_4b := 7;
						END_IF;
					7:
						EDTTV0603E.input.auto_open_signal := TRUE;
						IF EDTTV0603E.input.open_feedback_state THEN
							EDTTV0603D.input.auto_open_signal := TRUE;
							IF EDTTV0603D.input.open_feedback_state THEN
								p2_step2_4b := 8;
							END_IF;
						END_IF;
					8:
						IF EDTTIT0603.status.value >= EDTP2S2_PARA_Temp2 THEN
							p2_step2_4b := 0;
							EDTP2S2B_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
				TON_31();
			5:
				//确认回收结束
			6:
				EDTXV0621.input.auto_open_signal := FALSE;
				EDTXV0622.input.auto_open_signal := TRUE;
				EDTTV0603D.input.auto_open_signal := FALSE;
				IF EDTTV0603D.input.close_feedback_state THEN
					EDTTV0603E.input.auto_open_signal := FALSE;
					IF EDTTV0603E.input.close_feedback_state THEN
						EDTTV0603F.input.auto_open_signal := TRUE;//21.2.5
						IF EDTTV0603F.input.open_feedback_state THEN
							EDTP2S2B_STEP[6].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
		END_CASE;		
	END_IF;

	
	//人工确认步骤可用
	IF (EDTP2S2B.status.run_state) AND (NOT EDTP2S2B_STEP[EDTP2S2B.status.run_step].done AND ((EDTP2S2B.status.run_step = 1) OR (EDTP2S2B.status.run_step = 5) OR (p2_step2_3b_confirm_enable))) THEN
		EDTP2S2B.status.confirm_enable := TRUE;
	ELSE
		EDTP2S2B.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
