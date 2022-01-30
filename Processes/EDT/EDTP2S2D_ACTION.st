
ACTION P2S2D_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S2_STEP_NUM DO
		IF EDTP2S2D_ST[i] < T#5s THEN
			EDTP2S2D_ST[i] := T#5s;
		END_IF;
		EDTP2S2D_STEP[i].set_time := EDTP2S2D_ST[i];
	END_FOR;

	
	//流程步骤
	ProcessHandleFC(EDTP2S2D,EDTP2S2D_STEP[0],EDTP2S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S2D.status.mode <> 0) AND (NOT EDTP2S2D.auto_mode_edge) THEN
		EDTP2S2D.auto_mode_edge := TRUE;
		EDTP2S2D.manual_mode_edge := FALSE;
		
		EDTXV0601.control.auto_operate := TRUE;
		EDTP06.control.auto_operate := TRUE;
		EDTXV0603.control.auto_operate := TRUE;
		EDTP02.control.auto_operate := TRUE;
		EDTXV0602.control.auto_operate := TRUE;
		EDTP04.control.auto_operate := TRUE;
		EDTXV0637.control.auto_operate := TRUE;
		EDTXV0634.control.auto_operate := TRUE;
		EDTXV0635.control.auto_operate := TRUE;
		EDTXV0639.control.auto_operate := TRUE;
		EDTXV0645.control.auto_operate := TRUE;
		EDTR05D.control.auto_operate := TRUE;
		EDTXV0644.control.auto_operate := TRUE;
		EDTTV0607D.control.auto_operate := TRUE;
		EDTTV0607F.control.auto_operate := TRUE;
		EDTTV0607E.control.auto_operate := TRUE;
		EDTXV0633.control.auto_operate := TRUE;
		EDTXV0638.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S2D.status.mode = 0) AND (NOT EDTP2S2D.manual_mode_edge) THEN
		EDTP2S2D.manual_mode_edge := TRUE;
		EDTP2S2D.auto_mode_edge := FALSE;
		
		EDTXV0601.control.manual_operate := TRUE;
		EDTP06.control.manual_operate := TRUE;
		EDTXV0603.control.manual_operate := TRUE;
		EDTP02.control.manual_operate := TRUE;
		EDTXV0602.control.manual_operate := TRUE;
		EDTP04.control.manual_operate := TRUE;
		EDTXV0637.control.manual_operate := TRUE;
		EDTXV0634.control.manual_operate := TRUE;
		EDTXV0635.control.manual_operate := TRUE;
		EDTXV0639.control.manual_operate := TRUE;
		EDTXV0645.control.manual_operate := TRUE;
		EDTR05D.control.manual_operate := TRUE;
		EDTXV0644.control.manual_operate := TRUE;
		EDTTV0607D.control.manual_operate := TRUE;
		EDTTV0607F.control.manual_operate := TRUE;
		EDTTV0607E.control.manual_operate := TRUE;
		EDTXV0633.control.manual_operate := TRUE;
		EDTXV0638.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S2D.input.error_signal := (EDTXV0601.status.valve_status >= 2) OR (EDTP06.status.motor_status >= 2) OR
	(EDTXV0603.status.valve_status >= 2) OR(EDTP02.status.motor_status >= 2) OR (EDTXV0602.status.valve_status >= 2) OR
	(EDTP04.status.motor_status >= 2) OR (EDTXV0637.status.valve_status >= 2) OR (EDTXV0634.status.valve_status >= 2) OR
	(EDTXV0635.status.valve_status >= 2) OR (EDTXV0639.status.valve_status >= 2) OR (EDTXV0645.status.valve_status >= 2) OR 
	(EDTR05D.status.motor_status >= 2) OR (EDTTV0607D.status.valve_status >= 2) OR (EDTXV0644.status.valve_status >= 2) OR
	(EDTTV0607F.status.valve_status >= 2) OR (EDTTV0607E.status.valve_status >= 2) OR (EDTXV0633.status.valve_status >= 2) OR (EDTXV0638.status.valve_status >= 2);
	
	IF EDTP2S2D.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S2D.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S2D_STEP[0].done THEN
					EDTXV0601.control.auto_operate := TRUE;
					EDTP06.control.auto_operate := TRUE;
					EDTXV0603.control.auto_operate := TRUE;
					EDTP02.control.auto_operate := TRUE;
					EDTXV0602.control.auto_operate := TRUE;
					EDTP04.control.auto_operate := TRUE;
					EDTXV0637.control.auto_operate := TRUE;
					EDTXV0634.control.auto_operate := TRUE;
					EDTXV0635.control.auto_operate := TRUE;
					EDTXV0639.control.auto_operate := TRUE;
					EDTXV0645.control.auto_operate := TRUE;
					EDTR05D.control.auto_operate := TRUE;
					EDTXV0644.control.auto_operate := TRUE;
					EDTTV0607D.control.auto_operate := TRUE;
					EDTTV0607F.control.auto_operate := TRUE;
					EDTTV0607E.control.auto_operate := TRUE;
					EDTXV0633.control.auto_operate := TRUE;
					EDTXV0638.control.auto_operate := TRUE;
					EDTP2S2D_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料edc
			2:
				EDTXV0638.input.auto_open_signal := FALSE;
				IF EDTXV0638.input.close_feedback_state THEN
					EDTXV0637.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0637.input.open_feedback_state THEN
					EDTXV0639.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0639.input.open_feedback_state THEN
					EDTXV0645.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0637.input.open_feedback_state AND EDTXV0639.input.open_feedback_state AND EDTXV0645.input.open_feedback_state THEN
					EDTP2S2D_STEP[2].done := TRUE;
				END_IF;
			3:	
				CASE p2_step2_3d OF
					0:
						IF NOT EDTP2S2D_STEP[3].done THEN
							p2_step2_3d := 1;
						END_IF;
					1:
						EDTXV0634.input.auto_open_signal := TRUE;
						IF EDTXV0634.input.open_feedback_state THEN
							p2_step2_3d := 2;
						END_IF;
					2:
						TON_35.PT := DINT_TO_TIME(EDTP2S2_PARA_T4 * 60 * 1000);
						TON_35.IN := TRUE;
						IF TON_35.Q THEN
							TON_35.IN := FALSE;
							p2_step2_3d := 3;
						END_IF;
					3:
						EDTXV0635.input.auto_open_signal := TRUE;
						IF EDTXV0635.input.open_feedback_state THEN
							p2_step2_3d := 4;
						END_IF;
					4:
						TON_35.PT := DINT_TO_TIME(EDTP2S2_PARA_T5 * 60 * 1000);
						TON_35.IN := TRUE;
						IF TON_35.Q THEN
							TON_35.IN := FALSE;
							p2_step2_3d := 5;
						END_IF;
					5:
						EDTXV0634.input.auto_open_signal := FALSE;
						EDTXV0635.input.auto_open_signal := FALSE;
						IF EDTXV0634.input.close_feedback_state AND EDTXV0635.input.close_feedback_state THEN
							p2_step2_3d := 6;
						END_IF;
					6:
						p2_step2_3d := 7;
					7:
						IF EDTTIT0607.status.value < EDTP2S2_PARA_Temp1 THEN
							p2_step2_3d := 8;
						ELSE
							p2_step2_3d := 9;
						END_IF;
					8:
						//升温
						CASE p2_step2_3d_8 OF
							0:
								EDTTV0607F.input.auto_open_signal := TRUE;
								IF EDTTV0607F.input.open_feedback_state THEN
									EDTXV0644.input.auto_open_signal := TRUE;
									p2_step2_3d_8 := 1;
								END_IF;
							1:
								TON_36.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
								TON_36.IN := TRUE;
								IF TON_36.Q THEN
									TON_36.IN := FALSE;
									p2_step2_3d_8 := 2;
								END_IF;
							2:
								EDTXV0644.input.auto_open_signal := FALSE;
								EDTTV0607F.input.auto_open_signal := FALSE;
								IF EDTTV0607F.input.close_feedback_state THEN
									p2_step2_3d_8 := 3;
								END_IF;
							3:
								EDTTV0607E.input.auto_open_signal := TRUE;
								IF EDTTV0607E.input.open_feedback_state THEN
									EDTTV0607D.input.auto_open_signal := TRUE;
									IF EDTTV0607D.input.open_feedback_state THEN
										p2_step2_3d_8 := 4;
									END_IF;
								END_IF;
							4:
								IF EDTTIT0607.status.value >= EDTP2S2_PARA_Temp1 THEN
									p2_step2_3d_8 := 5;
								END_IF;
							5:
								EDTTV0607D.input.auto_open_signal := FALSE;
								IF EDTTV0607D.input.close_feedback_state THEN
									EDTTV0607E.input.auto_open_signal := FALSE;
									IF EDTTV0607E.input.close_feedback_state THEN
										EDTTV0607F.input.auto_open_signal := TRUE;//21.2.5
										IF EDTTV0607F.input.open_feedback_state THEN
											p2_step2_3d_8 := 0;
											p2_step2_3d := 9;
										END_IF;
									END_IF;
								END_IF;
						END_CASE;
						TON_36();
					9:
						//温度和时间到enable confirm
						EDTR05D.input.auto_run_signal := TRUE;
						TON_35.PT := DINT_TO_TIME(EDTP2S2_PARA_T6 * 60 * 1000);
						TON_35.IN := TRUE;
						p2_step2_3d := 10;
					10:
						IF TON_35.Q THEN
							TON_35.IN := FALSE;
							p2_step2_3d_confirm_enable := TRUE;
						END_IF;
						IF EDTP2S2D_STEP[3].done THEN
							p2_step2_3d := 0;
							p2_step2_3d_confirm_enable := FALSE;
						END_IF;
				END_CASE;
				TON_35();
			4:
				CASE p2_step2_4d OF
					0:
						IF NOT EDTP2S2D_STEP[4].done THEN
							p2_step2_4d := 1;
						END_IF;
					1:
						EDTXV0633.input.auto_open_signal := TRUE;
						p2_step2_4d := 2;
					2:
						TON_37.PT := DINT_TO_TIME(EDTP2S2_PARA_T8 * 60 * 1000);
						TON_37.IN := TRUE;
						IF TON_37.Q THEN
							TON_37.IN := FALSE;
							p2_step2_4d := 3;
						END_IF;
					3:
						EDTXV0633.input.auto_open_signal := FALSE;
						IF EDTXV0633.input.close_feedback_state THEN
							p2_step2_4d := 4;
						END_IF;
					4:
						EDTTV0607F.input.auto_open_signal := TRUE;
						IF EDTTV0607F.input.open_feedback_state THEN
							EDTXV0644.input.auto_open_signal := TRUE;
							p2_step2_4d := 5;
						END_IF;
					5:
						TON_37.PT := DINT_TO_TIME(EDTP2S2_PARA_T7 * 1000);
						TON_37.IN := TRUE;
						IF TON_37.Q THEN
							TON_37.IN := FALSE;
							p2_step2_4d := 6;
						END_IF;
					6:
						EDTXV0644.input.auto_open_signal := FALSE;
						EDTTV0607F.input.auto_open_signal := FALSE;
						IF EDTTV0607F.input.close_feedback_state THEN
							p2_step2_4d := 7;
						END_IF;
					7:
						EDTTV0607E.input.auto_open_signal := TRUE;
						IF EDTTV0607E.input.open_feedback_state THEN
							EDTTV0607D.input.auto_open_signal := TRUE;
							IF EDTTV0607D.input.open_feedback_state THEN
								p2_step2_4d := 8;
							END_IF;
						END_IF;
					8:
						IF EDTTIT0607.status.value >= EDTP2S2_PARA_Temp2 THEN
							p2_step2_4d := 0;
							EDTP2S2D_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
				TON_37();
			5:
				//确认回收结束
			6:
				EDTXV0637.input.auto_open_signal := FALSE;
				EDTXV0638.input.auto_open_signal := TRUE;
				EDTTV0607D.input.auto_open_signal := FALSE;
				IF EDTTV0607D.input.close_feedback_state THEN
					EDTTV0607E.input.auto_open_signal := FALSE;
					IF EDTTV0607E.input.close_feedback_state THEN
						EDTTV0607F.input.auto_open_signal := TRUE;//21.2.5
						IF EDTTV0607F.input.open_feedback_state THEN
							EDTP2S2D_STEP[6].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
		END_CASE;		
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP2S2D.status.run_state) AND (NOT EDTP2S2D_STEP[EDTP2S2D.status.run_step].done AND ((EDTP2S2D.status.run_step = 1) OR (EDTP2S2D.status.run_step = 5) OR (p2_step2_3d_confirm_enable))) THEN
		EDTP2S2D.status.confirm_enable := TRUE;
	ELSE
		EDTP2S2D.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
