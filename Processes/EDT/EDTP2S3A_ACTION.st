
ACTION P2S3A_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S3_STEP_NUM DO
		IF EDTP2S3A_ST[i] < T#5s THEN
			EDTP2S3A_ST[i] := T#5s;
		END_IF;
		EDTP2S3A_STEP[i].set_time := EDTP2S3A_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP2S3A,EDTP2S3A_STEP[0],EDTP2S3_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S3A.status.mode <> 0) AND (NOT EDTP2S3A.auto_mode_edge) THEN
		EDTP2S3A.auto_mode_edge := TRUE;
		EDTP2S3A.manual_mode_edge := FALSE;
		
		EDTTV0601E.control.auto_operate := TRUE;
		EDTTV0601D.control.auto_operate := TRUE;
		EDTTV0601F.control.auto_operate := TRUE;
		EDTXV0641.control.auto_operate := TRUE;
		EDTR05A.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S3A.status.mode = 0) AND (NOT EDTP2S3A.manual_mode_edge) THEN
		EDTP2S3A.manual_mode_edge := TRUE;
		EDTP2S3A.auto_mode_edge := FALSE;

		EDTTV0601E.control.manual_operate := TRUE;
		EDTTV0601D.control.manual_operate := TRUE;
		EDTTV0601F.control.manual_operate := TRUE;
		EDTXV0641.control.manual_operate := TRUE;
		EDTR05A.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S3A.input.error_signal := (EDTTV0601E.status.valve_status >= 2) OR (EDTR05A.status.motor_status >= 2) OR
	(EDTTV0601D.status.valve_status >= 2) OR (EDTTV0601F.status.valve_status >= 2) OR (EDTXV0641.status.valve_status >= 2);

	IF EDTP2S3A.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S3A.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S3A_STEP[0].done THEN
					EDTTV0601E.control.auto_operate := TRUE;
					EDTTV0601D.control.auto_operate := TRUE;
					EDTTV0601F.control.auto_operate := TRUE;
					EDTXV0641.control.auto_operate := TRUE;
					EDTR05A.control.auto_operate := TRUE;
					EDTP2S3A_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料
			2:
				CASE p2_step3_2a OF
					0:
						IF NOT EDTP2S3A_STEP[2].done THEN
							p2_step3_2a := 1;
						END_IF;
					1:
						EDTTV0601F.input.auto_open_signal := TRUE;
						IF EDTTV0601F.input.open_feedback_state THEN
							EDTXV0641.input.auto_open_signal := TRUE;
							p2_step3_2a := 2;
						END_IF;
					2:
						TON_38.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_38.IN := TRUE;
						IF TON_38.Q THEN
							TON_38.IN := FALSE;
							p2_step3_2a := 3;
						END_IF;
					3:
						EDTTV0601F.input.auto_open_signal := FALSE;
						EDTXV0641.input.auto_open_signal := FALSE;
						IF EDTTV0601F.input.close_feedback_state THEN
							p2_step3_2a := 4;
						END_IF;
					4:
						EDTTV0601E.input.auto_open_signal := TRUE;
						IF EDTTV0601E.input.open_feedback_state THEN
							EDTTV0601D.input.auto_open_signal := TRUE;
							IF EDTTV0601D.input.open_feedback_state THEN
								p2_step3_2a := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0601.status.value >= EDTP2S3_PARA_Temp1 THEN
							p2_step3_2a := 0;
							EDTP2S3A_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
				TON_38();
			3:
				//人工确认釜内回收情况
			4:
				EDTTV0601D.input.auto_open_signal := FALSE;
				IF EDTTV0601D.input.close_feedback_state THEN
					EDTTV0601E.input.auto_open_signal := FALSE;
					IF EDTTV0601E.input.close_feedback_state THEN
						EDTTV0601F.input.auto_open_signal := TRUE;
						IF EDTTV0601F.input.open_feedback_state THEN
							EDTP2S3A_STEP[4].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			5:
				//人工加料
			6:
				CASE p2_step3_6a OF
					0:
						IF NOT EDTP2S3A_STEP[6].done THEN
							p2_step3_6a := 1;
						END_IF;
					1:
						EDTTV0601F.input.auto_open_signal := TRUE;
						IF EDTTV0601F.input.open_feedback_state THEN
							EDTXV0641.input.auto_open_signal := TRUE;
							p2_step3_6a := 2;
						END_IF;
					2:
						TON_39.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_39.IN := TRUE;
						IF TON_39.Q THEN
							TON_39.IN := FALSE;
							p2_step3_6a := 3;
						END_IF;
					3:
						EDTTV0601F.input.auto_open_signal := FALSE;
						EDTXV0641.input.auto_open_signal := FALSE;
						IF EDTTV0601F.input.close_feedback_state THEN
							p2_step3_6a := 4;
						END_IF;
					4:
						EDTTV0601E.input.auto_open_signal := TRUE;
						IF EDTTV0601E.input.open_feedback_state THEN
							EDTTV0601D.input.auto_open_signal := TRUE;
							IF EDTTV0601D.input.open_feedback_state THEN
								p2_step3_6a := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0601.status.value >= EDTP2S3_PARA_Temp2 THEN
							p2_step3_6a := 0;
							EDTP2S3A_STEP[6].done := TRUE;
						END_IF;
				END_CASE;
				TON_39();
			7:
				//观察釜内情况
			8:
				EDTTV0601D.input.auto_open_signal := FALSE;
				IF EDTTV0601D.input.close_feedback_state THEN
					EDTTV0601E.input.auto_open_signal := FALSE;
					IF EDTTV0601E.input.close_feedback_state THEN
						EDTTV0601F.input.auto_open_signal := TRUE;
						IF EDTTV0601F.input.open_feedback_state THEN
							EDTP2S3A_STEP[8].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			9:
				//人工进料
			10:
				TON_10.PT := DINT_TO_TIME(EDTP2S3_PARA_T2 * 60 * 1000);
				TON_10.IN := TRUE;
				IF TON_10.Q THEN
					TON_10.IN := FALSE;
					EDTR05A.input.auto_run_signal := FALSE;
					EDTP2S3A_STEP[10].done := TRUE;
				END_IF;
				TON_10();
		END_CASE;		
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP2S3A.status.run_state) AND (NOT EDTP2S3A_STEP[EDTP2S3A.status.run_step].done AND ((EDTP2S3A.status.run_step = 1) OR (EDTP2S3A.status.run_step = 3) OR (EDTP2S3A.status.run_step = 5) OR (EDTP2S3A.status.run_step = 7) OR
		(EDTP2S3A.status.run_step = 9))) THEN
		EDTP2S3A.status.confirm_enable := TRUE;
	ELSE
		EDTP2S3A.status.confirm_enable := FALSE;
	END_IF;
	
END_ACTION
