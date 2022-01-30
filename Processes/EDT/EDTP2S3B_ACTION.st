
ACTION P2S3B_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S3_STEP_NUM DO
		IF EDTP2S3B_ST[i] < T#5s THEN
			EDTP2S3B_ST[i] := T#5s;
		END_IF;
		EDTP2S3B_STEP[i].set_time := EDTP2S3B_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP2S3B,EDTP2S3B_STEP[0],EDTP2S3_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S3B.status.mode <> 0) AND (NOT EDTP2S3B.auto_mode_edge) THEN
		EDTP2S3B.auto_mode_edge := TRUE;
		EDTP2S3B.manual_mode_edge := FALSE;
		
		EDTTV0603E.control.auto_operate := TRUE;
		EDTTV0603D.control.auto_operate := TRUE;
		EDTTV0603F.control.auto_operate := TRUE;
		EDTXV0642.control.auto_operate := TRUE;
		EDTR05B.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S3B.status.mode = 0) AND (NOT EDTP2S3B.manual_mode_edge) THEN
		EDTP2S3B.manual_mode_edge := TRUE;
		EDTP2S3B.auto_mode_edge := FALSE;

		EDTTV0603E.control.manual_operate := TRUE;
		EDTTV0603D.control.manual_operate := TRUE;
		EDTTV0603F.control.manual_operate := TRUE;
		EDTXV0642.control.manual_operate := TRUE;
		EDTR05B.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S3B.input.error_signal := (EDTTV0603E.status.valve_status >= 2) OR (EDTR05B.status.motor_status >= 2) OR 
	(EDTTV0603D.status.valve_status >= 2) OR (EDTTV0603F.status.valve_status >= 2) OR (EDTXV0642.status.valve_status >= 2);

	IF EDTP2S3B.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S3B.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S3B_STEP[0].done THEN
					EDTTV0603E.control.auto_operate := TRUE;
					EDTTV0603D.control.auto_operate := TRUE;
					EDTTV0603F.control.auto_operate := TRUE;
					EDTXV0642.control.auto_operate := TRUE;
					EDTR05B.control.auto_operate := TRUE;
					EDTP2S3B_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料
			2:
				CASE p2_step3_2b OF
					0:
						IF NOT EDTP2S3B_STEP[2].done THEN
							p2_step3_2b := 1;
						END_IF;
					1:
						EDTTV0603F.input.auto_open_signal := TRUE;
						IF EDTTV0603F.input.open_feedback_state THEN
							EDTXV0642.input.auto_open_signal := TRUE;
							p2_step3_2b := 2;
						END_IF;
					2:
						TON_44.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_44.IN := TRUE;
						IF TON_44.Q THEN
							TON_44.IN := FALSE;
							p2_step3_2b := 3;
						END_IF;
					3:
						EDTTV0603F.input.auto_open_signal := FALSE;
						EDTXV0642.input.auto_open_signal := FALSE;
						IF EDTTV0603F.input.close_feedback_state THEN
							p2_step3_2b := 4;
						END_IF;
					4:
						EDTTV0603E.input.auto_open_signal := TRUE;
						IF EDTTV0603E.input.open_feedback_state THEN
							EDTTV0603D.input.auto_open_signal := TRUE;
							IF EDTTV0603D.input.open_feedback_state THEN
								p2_step3_2b := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0603.status.value >= EDTP2S3_PARA_Temp1 THEN
							p2_step3_2b := 0;
							EDTP2S3B_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
				TON_44();
			3:
				//人工确认釜内回收情况
			4:
				EDTTV0603D.input.auto_open_signal := FALSE;
				IF EDTTV0603D.input.close_feedback_state THEN
					EDTTV0603E.input.auto_open_signal := FALSE;
					IF EDTTV0603E.input.close_feedback_state THEN
						EDTTV0603F.input.auto_open_signal := TRUE;
						IF EDTTV0603F.input.open_feedback_state THEN
							EDTP2S3B_STEP[4].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			5:
				//人工加料
			6:
				CASE p2_step3_6b OF
					0:
						IF NOT EDTP2S3B_STEP[6].done THEN
							p2_step3_6b := 1;
						END_IF;
					1:
						EDTTV0603F.input.auto_open_signal := TRUE;
						IF EDTTV0603F.input.open_feedback_state THEN
							EDTXV0642.input.auto_open_signal := TRUE;
							p2_step3_6b := 2;
						END_IF;
					2:
						TON_47.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_47.IN := TRUE;
						IF TON_47.Q THEN
							TON_47.IN := FALSE;
							p2_step3_6b := 3;
						END_IF;
					3:
						EDTTV0603F.input.auto_open_signal := FALSE;
						EDTXV0642.input.auto_open_signal := FALSE;
						IF EDTTV0603F.input.close_feedback_state THEN
							p2_step3_6b := 4;
						END_IF;
					4:
						EDTTV0603E.input.auto_open_signal := TRUE;
						IF EDTTV0603E.input.open_feedback_state THEN
							EDTTV0603D.input.auto_open_signal := TRUE;
							IF EDTTV0603D.input.open_feedback_state THEN
								p2_step3_6b := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0603.status.value >= EDTP2S3_PARA_Temp2 THEN
							p2_step3_6b := 0;
							EDTP2S3B_STEP[6].done := TRUE;
						END_IF;
				END_CASE;
				TON_47();
			7:
				//观察釜内情况
			8:
				EDTTV0603D.input.auto_open_signal := FALSE;
				IF EDTTV0603D.input.close_feedback_state THEN
					EDTTV0603E.input.auto_open_signal := FALSE;
					IF EDTTV0603E.input.close_feedback_state THEN
						EDTTV0603F.input.auto_open_signal := TRUE;
						IF EDTTV0603F.input.open_feedback_state THEN
							EDTP2S3B_STEP[8].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			9:
				//人工进料
			10:
				TON_48.PT := DINT_TO_TIME(EDTP2S3_PARA_T2 * 60 * 1000);
				TON_48.IN := TRUE;
				IF TON_48.Q THEN
					TON_48.IN := FALSE;
					EDTR05B.input.auto_run_signal := FALSE;
					EDTP2S3B_STEP[10].done := TRUE;
				END_IF;
				TON_48();
		END_CASE;		
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP2S3B.status.run_state) AND (NOT EDTP2S3B_STEP[EDTP2S3B.status.run_step].done AND ((EDTP2S3B.status.run_step = 1) OR (EDTP2S3B.status.run_step = 3) OR (EDTP2S3B.status.run_step = 5) OR (EDTP2S3B.status.run_step = 7) OR
		(EDTP2S3B.status.run_step = 9))) THEN
		EDTP2S3B.status.confirm_enable := TRUE;
	ELSE
		EDTP2S3B.status.confirm_enable := FALSE;
	END_IF;
	
END_ACTION
