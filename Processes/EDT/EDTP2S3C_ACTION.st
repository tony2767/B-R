
ACTION P2S3C_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S3_STEP_NUM DO
		IF EDTP2S3C_ST[i] < T#5s THEN
			EDTP2S3C_ST[i] := T#5s;
		END_IF;
		EDTP2S3C_STEP[i].set_time := EDTP2S3C_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP2S3C,EDTP2S3C_STEP[0],EDTP2S3_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S3C.status.mode <> 0) AND (NOT EDTP2S3C.auto_mode_edge) THEN
		EDTP2S3C.auto_mode_edge := TRUE;
		EDTP2S3C.manual_mode_edge := FALSE;
		
		EDTTV0605E.control.auto_operate := TRUE;
		EDTTV0605D.control.auto_operate := TRUE;
		EDTTV0605F.control.auto_operate := TRUE;
		EDTXV0643.control.auto_operate := TRUE;
		EDTR05C.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S3C.status.mode = 0) AND (NOT EDTP2S3C.manual_mode_edge) THEN
		EDTP2S3C.manual_mode_edge := TRUE;
		EDTP2S3C.auto_mode_edge := FALSE;

		EDTTV0605E.control.manual_operate := TRUE;
		EDTTV0605D.control.manual_operate := TRUE;
		EDTTV0605F.control.manual_operate := TRUE;
		EDTXV0643.control.manual_operate := TRUE;
		EDTR05C.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S3C.input.error_signal := (EDTTV0605E.status.valve_status >= 2) OR (EDTR05C.status.motor_status >= 2) OR
	(EDTTV0605D.status.valve_status >= 2) OR (EDTTV0605F.status.valve_status >= 2) OR (EDTXV0643.status.valve_status >= 2);

	IF EDTP2S3C.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S3C.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S3C_STEP[0].done THEN
					EDTTV0605E.control.auto_operate := TRUE;
					EDTTV0605D.control.auto_operate := TRUE;
					EDTTV0605F.control.auto_operate := TRUE;
					EDTXV0643.control.auto_operate := TRUE;
					EDTR05C.control.auto_operate := TRUE;
					EDTP2S3C_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料
			2:
				CASE p2_step3_2c OF
					0:
						IF NOT EDTP2S3C_STEP[2].done THEN
							p2_step3_2c := 1;
						END_IF;
					1:
						EDTTV0605F.input.auto_open_signal := TRUE;
						IF EDTTV0605F.input.open_feedback_state THEN
							EDTXV0643.input.auto_open_signal := TRUE;
							p2_step3_2c := 2;
						END_IF;
					2:
						TON_50.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_50.IN := TRUE;
						IF TON_50.Q THEN
							TON_50.IN := FALSE;
							p2_step3_2c := 3;
						END_IF;
					3:
						EDTTV0605F.input.auto_open_signal := FALSE;
						EDTXV0643.input.auto_open_signal := FALSE;
						IF EDTTV0605F.input.close_feedback_state THEN
							p2_step3_2c := 4;
						END_IF;
					4:
						EDTTV0605E.input.auto_open_signal := TRUE;
						IF EDTTV0605E.input.open_feedback_state THEN
							EDTTV0605D.input.auto_open_signal := TRUE;
							IF EDTTV0605D.input.open_feedback_state THEN
								p2_step3_2c := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0605.status.value >= EDTP2S3_PARA_Temp1 THEN
							p2_step3_2c := 0;
							EDTP2S3C_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
				TON_50();
			3:
				//人工确认釜内回收情况
			4:
				EDTTV0605D.input.auto_open_signal := FALSE;
				IF EDTTV0605D.input.close_feedback_state THEN
					EDTTV0605E.input.auto_open_signal := FALSE;
					IF EDTTV0605E.input.close_feedback_state THEN
						EDTTV0605F.input.auto_open_signal := TRUE;
						IF EDTTV0605F.input.open_feedback_state THEN
							EDTP2S3C_STEP[4].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			5:
				//人工加料
			6:
				CASE p2_step3_6c OF
					0:
						IF NOT EDTP2S3C_STEP[6].done THEN
							p2_step3_6c := 1;
						END_IF;
					1:
						EDTTV0605F.input.auto_open_signal := TRUE;
						IF EDTTV0605F.input.open_feedback_state THEN
							EDTXV0643.input.auto_open_signal := TRUE;
							p2_step3_6c := 2;
						END_IF;
					2:
						TON_51.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_51.IN := TRUE;
						IF TON_51.Q THEN
							TON_51.IN := FALSE;
							p2_step3_6c := 3;
						END_IF;
					3:
						EDTTV0605F.input.auto_open_signal := FALSE;
						EDTXV0643.input.auto_open_signal := FALSE;
						IF EDTTV0605F.input.close_feedback_state THEN
							p2_step3_6c := 4;
						END_IF;
					4:
						EDTTV0605E.input.auto_open_signal := TRUE;
						IF EDTTV0605E.input.open_feedback_state THEN
							EDTTV0605D.input.auto_open_signal := TRUE;
							IF EDTTV0605D.input.open_feedback_state THEN
								p2_step3_6c := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0605.status.value >= EDTP2S3_PARA_Temp2 THEN
							p2_step3_6c := 0;
							EDTP2S3C_STEP[6].done := TRUE;
						END_IF;
				END_CASE;
				TON_51();
			7:
				//观察釜内情况
			8:
				EDTTV0605D.input.auto_open_signal := FALSE;
				IF EDTTV0605D.input.close_feedback_state THEN
					EDTTV0605E.input.auto_open_signal := FALSE;
					IF EDTTV0605E.input.close_feedback_state THEN
						EDTTV0605F.input.auto_open_signal := TRUE;
						IF EDTTV0605F.input.open_feedback_state THEN
							EDTP2S3C_STEP[8].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			9:
				//人工进料
			10:
				TON_53.PT := DINT_TO_TIME(EDTP2S3_PARA_T2 * 60 * 1000);
				TON_53.IN := TRUE;
				IF TON_53.Q THEN
					TON_53.IN := FALSE;
					EDTR05C.input.auto_run_signal := FALSE;
					EDTP2S3C_STEP[10].done := TRUE;
				END_IF;
				TON_53();
		END_CASE;		
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP2S3C.status.run_state) AND (NOT EDTP2S3C_STEP[EDTP2S3C.status.run_step].done AND ((EDTP2S3C.status.run_step = 1) OR (EDTP2S3C.status.run_step = 3) OR (EDTP2S3C.status.run_step = 5) OR (EDTP2S3C.status.run_step = 7) OR
		(EDTP2S3C.status.run_step = 9))) THEN
		EDTP2S3C.status.confirm_enable := TRUE;
	ELSE
		EDTP2S3C.status.confirm_enable := FALSE;
	END_IF;
	
END_ACTION
