
ACTION P2S3D_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S3_STEP_NUM DO
		IF EDTP2S3D_ST[i] < T#5s THEN
			EDTP2S3D_ST[i] := T#5s;
		END_IF;
		EDTP2S3D_STEP[i].set_time := EDTP2S3D_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP2S3D,EDTP2S3D_STEP[0],EDTP2S3_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S3D.status.mode <> 0) AND (NOT EDTP2S3D.auto_mode_edge) THEN
		EDTP2S3D.auto_mode_edge := TRUE;
		EDTP2S3D.manual_mode_edge := FALSE;
		
		EDTTV0607E.control.auto_operate := TRUE;
		EDTTV0607D.control.auto_operate := TRUE;
		EDTTV0607F.control.auto_operate := TRUE;
		EDTXV0644.control.auto_operate := TRUE;
		EDTR05D.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S3D.status.mode = 0) AND (NOT EDTP2S3D.manual_mode_edge) THEN
		EDTP2S3D.manual_mode_edge := TRUE;
		EDTP2S3D.auto_mode_edge := FALSE;

		EDTTV0607E.control.manual_operate := TRUE;
		EDTTV0607D.control.manual_operate := TRUE;
		EDTTV0607F.control.manual_operate := TRUE;
		EDTXV0644.control.manual_operate := TRUE;
		EDTR05D.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S3D.input.error_signal := (EDTTV0607E.status.valve_status >= 2) OR (EDTR05D.status.motor_status >= 2) OR
	(EDTTV0607D.status.valve_status >= 2) OR (EDTTV0607F.status.valve_status >= 2) OR (EDTXV0644.status.valve_status >= 2);

	IF EDTP2S3D.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S3D.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S3D_STEP[0].done THEN
					EDTTV0607E.control.auto_operate := TRUE;
					EDTTV0607D.control.auto_operate := TRUE;
					EDTTV0607F.control.auto_operate := TRUE;
					EDTXV0644.control.auto_operate := TRUE;
					EDTR05D.control.auto_operate := TRUE;
					EDTP2S3D_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工投料
			2:
				CASE p2_step3_2d OF
					0:
						IF NOT EDTP2S3D_STEP[2].done THEN
							p2_step3_2d := 1;
						END_IF;
					1:
						EDTTV0607F.input.auto_open_signal := TRUE;
						IF EDTTV0607F.input.open_feedback_state THEN
							EDTXV0644.input.auto_open_signal := TRUE;
							p2_step3_2d := 2;
						END_IF;
					2:
						TON_56.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_56.IN := TRUE;
						IF TON_56.Q THEN
							TON_56.IN := FALSE;
							p2_step3_2d := 3;
						END_IF;
					3:
						EDTTV0607F.input.auto_open_signal := FALSE;
						EDTXV0644.input.auto_open_signal := FALSE;
						IF EDTTV0607F.input.close_feedback_state THEN
							p2_step3_2d := 4;
						END_IF;
					4:
						EDTTV0607E.input.auto_open_signal := TRUE;
						IF EDTTV0607E.input.open_feedback_state THEN
							EDTTV0607D.input.auto_open_signal := TRUE;
							IF EDTTV0607D.input.open_feedback_state THEN
								p2_step3_2d := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0607.status.value >= EDTP2S3_PARA_Temp1 THEN
							p2_step3_2d := 0;
							EDTP2S3D_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
				TON_56();
			3:
				//人工确认釜内回收情况
			4:
				EDTTV0607D.input.auto_open_signal := FALSE;
				IF EDTTV0607D.input.close_feedback_state THEN
					EDTTV0607E.input.auto_open_signal := FALSE;
					IF EDTTV0607E.input.close_feedback_state THEN
						EDTTV0607F.input.auto_open_signal := TRUE;
						IF EDTTV0607F.input.open_feedback_state THEN
							EDTP2S3D_STEP[4].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			5:
				//人工加料
			6:
				CASE p2_step3_6d OF
					0:
						IF NOT EDTP2S3D_STEP[6].done THEN
							p2_step3_6d := 1;
						END_IF;
					1:
						EDTTV0607F.input.auto_open_signal := TRUE;
						IF EDTTV0607F.input.open_feedback_state THEN
							EDTXV0644.input.auto_open_signal := TRUE;
							p2_step3_6d := 2;
						END_IF;
					2:
						TON_57.PT := DINT_TO_TIME(EDTP2S3_PARA_T1 * 1000);
						TON_57.IN := TRUE;
						IF TON_57.Q THEN
							TON_57.IN := FALSE;
							p2_step3_6d := 3;
						END_IF;
					3:
						EDTTV0607F.input.auto_open_signal := FALSE;
						EDTXV0644.input.auto_open_signal := FALSE;
						IF EDTTV0607F.input.close_feedback_state THEN
							p2_step3_6d := 4;
						END_IF;
					4:
						EDTTV0607E.input.auto_open_signal := TRUE;
						IF EDTTV0607E.input.open_feedback_state THEN
							EDTTV0607D.input.auto_open_signal := TRUE;
							IF EDTTV0607D.input.open_feedback_state THEN
								p2_step3_6d := 5;
							END_IF;
						END_IF;
					5:
						IF EDTTIT0607.status.value >= EDTP2S3_PARA_Temp2 THEN
							p2_step3_6d := 0;
							EDTP2S3D_STEP[6].done := TRUE;
						END_IF;
				END_CASE;
				TON_57();
			7:
				//观察釜内情况
			8:
				EDTTV0607D.input.auto_open_signal := FALSE;
				IF EDTTV0607D.input.close_feedback_state THEN
					EDTTV0607E.input.auto_open_signal := FALSE;
					IF EDTTV0607E.input.close_feedback_state THEN
						EDTTV0607F.input.auto_open_signal := TRUE;
						IF EDTTV0607F.input.open_feedback_state THEN
							EDTP2S3D_STEP[8].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			9:
				//人工进料
			10:
				TON_59.PT := DINT_TO_TIME(EDTP2S3_PARA_T2 * 60 * 1000);
				TON_59.IN := TRUE;
				IF TON_59.Q THEN
					TON_59.IN := FALSE;
					EDTR05D.input.auto_run_signal := FALSE;
					EDTP2S3D_STEP[10].done := TRUE;
				END_IF;
				TON_59();
		END_CASE;		
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP2S3D.status.run_state) AND (NOT EDTP2S3D_STEP[EDTP2S3D.status.run_step].done AND ((EDTP2S3D.status.run_step = 1) OR (EDTP2S3D.status.run_step = 3) OR (EDTP2S3D.status.run_step = 5) OR (EDTP2S3D.status.run_step = 7) OR
		(EDTP2S3D.status.run_step = 9))) THEN
		EDTP2S3D.status.confirm_enable := TRUE;
	ELSE
		EDTP2S3D.status.confirm_enable := FALSE;
	END_IF;
	
END_ACTION
