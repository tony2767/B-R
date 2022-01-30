
ACTION P1S3_ACT: 
	//设定时间
	FOR i := 0 TO EDTP1S3_STEP_NUM DO
		IF EDTP1S3_ST[i] < T#5s THEN
			EDTP1S3_ST[i] := T#5s;
		END_IF;
		EDTP1S3_STEP[i].set_time := EDTP1S3_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP1S3,EDTP1S3_STEP[0],EDTP1S3_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP1S3.status.mode <> 0) AND (NOT EDTP1S3.auto_mode_edge) THEN
		EDTP1S3.auto_mode_edge := TRUE;
		EDTP1S3.manual_mode_edge := FALSE;
		
		EDTXV0304.control.auto_operate := TRUE;
		EDTXV0410.control.auto_operate := TRUE;
		EDTXV0302.control.auto_operate := TRUE;
		EDTTV0301G.control.auto_operate := TRUE;
		EDTR13.control.auto_operate := TRUE;
		EDTP03.control.auto_operate := TRUE;
		EDTTV0301C.control.auto_operate := TRUE;
		EDTTV0301D.control.auto_operate := TRUE;
		EDTTV0301E.control.auto_operate := TRUE;
		EDTTV0301F.control.auto_operate := TRUE;
		EDTTV0301A.control.auto_operate := TRUE;
		EDTTV0301B.control.auto_operate := TRUE;
		EDTPV0301.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP1S3.status.mode = 0) AND (NOT EDTP1S3.manual_mode_edge) THEN
		EDTP1S3.manual_mode_edge := TRUE;
		EDTP1S3.auto_mode_edge := FALSE;
		
		EDTXV0304.control.manual_operate := TRUE;
		EDTXV0410.control.manual_operate := TRUE;
		EDTXV0302.control.manual_operate := TRUE;
		EDTTV0301G.control.manual_operate := TRUE;
		EDTR13.control.manual_operate := TRUE;
		EDTP03.control.manual_operate := TRUE;
		EDTTV0301C.control.manual_operate := TRUE;
		EDTTV0301D.control.manual_operate := TRUE;
		EDTTV0301E.control.manual_operate := TRUE;
		EDTTV0301F.control.manual_operate := TRUE;
		EDTTV0301A.control.manual_operate := TRUE;
		EDTTV0301B.control.manual_operate := TRUE;
		EDTPV0301.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP1S3.input.error_signal := 
	(EDTXV0304.status.valve_status >= 2) OR (EDTXV0410.status.valve_status >= 2) OR (EDTXV0302.status.valve_status >= 2) OR
	(EDTTV0301G.status.valve_status >= 2) OR (EDTR13.status.motor_status >= 2) OR
	(EDTP03.status.motor_status >= 2) OR (EDTTV0301C.status.valve_status >= 2) OR
	(EDTTV0301D.status.valve_status >= 2) OR (EDTTV0301E.status.valve_status >= 2) OR
	(EDTTV0301F.status.valve_status >= 2) OR (EDTTV0301A.status.valve_status >= 2) OR
	(EDTTV0301B.status.valve_status >= 2) OR (EDTPV0301.status.valve_status >= 2);

	
	IF EDTP1S3.status.run_state = 1 THEN
		CASE EDTP1S3.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP1S3_STEP[0].done THEN
					EDTXV0302.control.auto_operate := TRUE;
					EDTXV0304.control.auto_operate := TRUE;
					EDTXV0410.control.auto_operate := TRUE;
					EDTTV0301G.control.auto_operate := TRUE;
					EDTR13.control.auto_operate := TRUE;
					EDTP03.control.auto_operate := TRUE;
					EDTTV0301C.control.auto_operate := TRUE;
					EDTTV0301D.control.auto_operate := TRUE;
					EDTTV0301E.control.auto_operate := TRUE;
					EDTTV0301F.control.auto_operate := TRUE;
					EDTTV0301A.control.auto_operate := TRUE;
					EDTTV0301B.control.auto_operate := TRUE;
					EDTPV0301.control.auto_operate := TRUE;
					EDTP1S3_STEP[0].done := TRUE;
				END_IF;
			1:	
				//确认R13釜空闲,手动开阀进料
			2:
				EDTXV0302.input.auto_open_signal := TRUE;
				IF EDTXV0302.input.open_feedback_state THEN
					EDTXV0304.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0304.input.open_feedback_state THEN
					EDTTV0301G.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV0301G.input.open_feedback_state THEN
					EDTXV0410.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0302.input.open_feedback_state AND EDTXV0304.input.open_feedback_state AND EDTTV0301G.input.open_feedback_state
					AND EDTXV0410.input.open_feedback_state THEN
					EDTR13.input.auto_run_signal := TRUE;
					EDTP03.input.auto_run_signal := TRUE;
					IF EDTR13.input.run_feedback AND EDTP03.input.run_feedback THEN
						EDTP1S3_STEP[2].done := TRUE;
					END_IF;
				END_IF;
			3:
				CASE p1_step3_3 OF
					0:
						IF NOT EDTP1S3_STEP[3].done THEN
							p1_step3_3 := 1;
						END_IF;
					1:
						HeatPot_0(ST1 := DINT_TO_TIME(EDTP1S3_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP1S3_PARA_T2 * 1000),
						V3 := EDTTV0301C, 
						V4 := EDTTV0301D,
						V5 := EDTTV0301E, 
						V6 := EDTTV0301F, 
						done := p1_step3_3_1_done);
						IF p1_step3_3_1_done THEN
							p1_step3_3 := 2;
						END_IF;
					2:
						IF EDTTIT0301.status.value >= EDTP1S3_PARA_Temp1 THEN
							EDTTV0301C.input.auto_open_signal := FALSE;
							IF EDTTIT0301.status.value >= EDTP1S3_PARA_Temp2 THEN
								p1_step3_3 := 3;
							END_IF;
						END_IF;	
					3:
						TON_40.PT := DINT_TO_TIME(EDTP1S3_PARA_T3 * 60 * 1000);
						TON_40.IN := TRUE;
						IF TON_40.Q THEN
							TON_40.IN := FALSE;
							EDTTV0301D.input.auto_open_signal := FALSE;
							EDTTV0301E.input.auto_open_signal := FALSE;
							p1_step3_3 := 4;
						END_IF;
					4:
						TON_40.PT := DINT_TO_TIME(EDTP1S3_PARA_T4 * 60 * 1000);
						TON_40.IN := TRUE;
						IF TON_40.Q THEN
							TON_40.IN := FALSE;
							EDTTV0301F.input.auto_open_signal := TRUE;
							p1_step3_3 := 5;
						END_IF;
					5:
						TON_40.PT := DINT_TO_TIME(EDTP1S3_PARA_T5 * 1000);
						TON_40.IN := TRUE;
						IF TON_40.Q THEN
							TON_40.IN := FALSE;
							EDTTV0301F.input.auto_open_signal := FALSE;
							p1_step3_3 := 6;
						END_IF;
					6:
						IF EDTTV0301C.input.close_feedback_state AND EDTTV0301D.input.close_feedback_state AND EDTTV0301E.input.close_feedback_state AND EDTTV0301F.input.close_feedback_state THEN
							p1_step3_3 := 0;
							p1_step3_3_1_done := FALSE;
							EDTP1S3_STEP[3].done := TRUE;
						END_IF;
				END_CASE;
				TON_40();
			4:
				CASE p1_step3_4 OF
					0:
						IF NOT EDTP1S3_STEP[4].done THEN
							p1_step3_4 := 1;
						END_IF;
					1:
						EDTTV0301A.input.auto_open_signal := TRUE;
						IF EDTTV0301A.input.open_feedback_state THEN
							EDTTV0301B.input.auto_open_signal := TRUE;
							IF EDTTV0301B.input.open_feedback_state THEN
								p1_step3_4 := 2;
							END_IF;
						END_IF;
					2:
						IF EDTTIT0301.status.value <= EDTP1S3_PARA_Temp4 THEN
							EDTPV0301.input.auto_open_signal := TRUE;
							p1_step3_4 := 3;
						END_IF;
					3:
						IF EDTPIT0301.status.value >= EDTP1S3_PARA_P1 THEN
							EDTTV0301G.input.auto_open_signal := FALSE;
							IF EDTTV0301G.input.close_feedback_state THEN
								EDTP03.input.auto_run_signal := FALSE;
								p1_step3_4 := 4;
							END_IF;
						END_IF;
					4:
						IF NOT EDTP03.input.run_feedback THEN
							EDTXV0410.input.auto_open_signal := FALSE;
							EDTXV0304.input.auto_open_signal := FALSE;
							EDTTV0301A.input.auto_open_signal := FALSE;
							EDTTV0301B.input.auto_open_signal := FALSE;
							p1_step3_4 := 5;
						END_IF;
					5:
						IF EDTPIT0301.status.value >= EDTP1S3_PARA_P2 THEN
							EDTXV0302.input.auto_open_signal := FALSE;
							EDTPV0301.input.auto_open_signal := FALSE;
							EDTR13.input.auto_run_signal := FALSE;
							EDTP1S3_STEP[4].done := TRUE;
							p1_step3_4 := 0;
						END_IF;
				END_CASE;			
		END_CASE;		
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP1S3.status.run_state) AND (NOT EDTP1S3_STEP[EDTP1S3.status.run_step].done AND ((EDTP1S3.status.run_step = 1))) THEN
		EDTP1S3.status.confirm_enable := TRUE;
	ELSE
		EDTP1S3.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
