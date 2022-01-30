
ACTION P2S4A_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S4_STEP_NUM DO
		IF EDTP2S4A_ST[i] < T#5s THEN
			EDTP2S4A_ST[i] := T#5s;
		END_IF;
		EDTP2S4A_STEP[i].set_time := EDTP2S4A_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP2S4A,EDTP2S4A_STEP[0],EDTP2S4_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S4A.status.mode <> 0) AND (NOT EDTP2S4A.auto_mode_edge) THEN
		EDTP2S4A.auto_mode_edge := TRUE;
		EDTP2S4A.manual_mode_edge := FALSE;
		
		EDTXV0711.control.auto_operate := TRUE;
		EDTAV0701B.control.auto_operate := TRUE;
		EDTAV0701A.control.auto_operate := TRUE;
		EDTXV0701.control.auto_operate := TRUE;
		EDTR12A.control.auto_operate := TRUE;
		EDTTV0701C.control.auto_operate := TRUE;
		EDTTV0701D.control.auto_operate := TRUE;
		EDTTV0701E.control.auto_operate := TRUE;
		EDTTV0701F.control.auto_operate := TRUE;
		EDTFVT0701.control.auto_operate := TRUE;
		EDTXV0704.control.auto_operate := TRUE;
		EDTXV0705.control.auto_operate := TRUE;
		EDTTV0701A.control.auto_operate := TRUE;
		EDTTV0701B.control.auto_operate := TRUE;
		EDTXV0708.control.auto_operate := TRUE;
		EDTXV0709.control.auto_operate := TRUE;
		EDTXV0715.control.auto_operate := TRUE;
		
	END_IF;
	
	IF (EDTP2S4A.status.mode = 0) AND (NOT EDTP2S4A.manual_mode_edge) THEN
		EDTP2S4A.manual_mode_edge := TRUE;
		EDTP2S4A.auto_mode_edge := FALSE;

		EDTXV0711.control.manual_operate := TRUE;
		EDTAV0701B.control.manual_operate := TRUE;
		EDTAV0701A.control.manual_operate := TRUE;
		EDTXV0701.control.manual_operate := TRUE;
		EDTR12A.control.manual_operate := TRUE;
		EDTTV0701C.control.manual_operate := TRUE;
		EDTTV0701D.control.manual_operate := TRUE;
		EDTTV0701E.control.manual_operate := TRUE;
		EDTTV0701F.control.manual_operate := TRUE;
		EDTFVT0701.control.manual_operate := TRUE;
		EDTXV0704.control.manual_operate := TRUE;
		EDTXV0705.control.manual_operate := TRUE;
		EDTTV0701A.control.manual_operate := TRUE;
		EDTTV0701B.control.manual_operate := TRUE;
		EDTXV0708.control.manual_operate := TRUE;
		EDTXV0709.control.manual_operate := TRUE;
		EDTXV0715.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S4A.input.error_signal := (EDTXV0711.status.valve_status >= 2) OR (EDTAV0701B.status.valve_status >= 2) OR
	(EDTR12A.status.motor_status >= 2) OR (EDTAV0701A.status.valve_status >= 2) OR (EDTXV0701.status.valve_status >= 2) OR
	(EDTTV0701C.status.valve_status >= 2) OR (EDTTV0701D.status.valve_status >= 2) OR (EDTTV0701E.status.valve_status >= 2) OR 
	(EDTTV0701F.status.valve_status >= 2) OR (EDTXV0704.status.valve_status >= 2) OR (EDTXV0705.status.valve_status >= 2) OR 
	(EDTTV0701A.status.valve_status >= 2) OR (EDTTV0701B.status.valve_status >= 2) OR (EDTXV0708.status.valve_status >= 2) OR
	(EDTXV0709.status.valve_status >= 2);

	IF EDTP2S4A.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S4A.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S4A_STEP[0].done THEN
					EDTXV0711.control.auto_operate := TRUE;
					EDTAV0701B.control.auto_operate := TRUE;
					EDTAV0701A.control.auto_operate := TRUE;
					EDTXV0701.control.auto_operate := TRUE;
					EDTR12A.control.auto_operate := TRUE;
					EDTTV0701C.control.auto_operate := TRUE;
					EDTTV0701D.control.auto_operate := TRUE;
					EDTTV0701E.control.auto_operate := TRUE;
					EDTTV0701F.control.auto_operate := TRUE;
					EDTFVT0701.control.auto_operate := TRUE;
					EDTXV0704.control.auto_operate := TRUE;
					EDTXV0705.control.auto_operate := TRUE;
					EDTTV0701A.control.auto_operate := TRUE;
					EDTTV0701B.control.auto_operate := TRUE;
					EDTXV0708.control.auto_operate := TRUE;	
					EDTXV0709.control.auto_operate := TRUE;
					EDTXV0715.control.auto_operate := TRUE;
					EDTP2S4A_STEP[0].done := TRUE;
				END_IF;
			1:
				//手动分层，完成后点确认
			2:
				//除前馏
				R12A_process1 := TRUE;
				EDTP2S4A_STEP[2].done := TRUE;
			3:
				IF NOT R12A_process1 THEN
					EDTP2S4A_STEP[3].done := TRUE;
				END_IF;
			4:
				//转移确认V19空
			5:
				TON_66.PT := DINT_TO_TIME(EDTP2S4_PARA_T5 * 60 * 1000);
				EDTXV0708.input.auto_open_signal := TRUE;
				IF EDTXV0708.input.open_feedback_state THEN
					TON_66.IN := TRUE;
				END_IF;
				IF TON_66.Q THEN
					TON_66.IN := FALSE;
					EDTP2S4A_STEP[5].done := TRUE;
				END_IF;
				TON_66();
			6:
				//确认R12A空
			7:
				TON_67.PT := DINT_TO_TIME(EDTP2S4_PARA_T6 * 60 * 1000);
				EDTXV0708.input.auto_open_signal := FALSE;
				IF EDTXV0708.input.close_feedback_state THEN
					EDTXV0711.input.auto_open_signal := TRUE;
					EDTAV0701A.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0711.input.open_feedback_state AND EDTAV0701A.input.open_feedback_state THEN
					TON_67.IN := TRUE;
				END_IF;
				IF TON_67.Q THEN
					TON_67.IN := FALSE;
					EDTP2S4A_STEP[7].done := TRUE;
				END_IF;
				TON_67();
			8:
				//确认R06A空
			9:
				R12A_process := TRUE;
				EDTAV0701A.input.auto_open_signal := FALSE;
				IF EDTAV0701A.input.close_feedback_state THEN
					EDTXV0711.input.auto_open_signal := FALSE;
					IF EDTXV0711.input.close_feedback_state THEN
						EDTXV0709.input.auto_open_signal := TRUE;
						IF EDTXV0709.input.open_feedback_state THEN
							EDTXV0715.input.auto_open_signal := TRUE;
							EDTP2S4A_STEP[9].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			10:
				//确认转移完毕，AV0701B前手阀开度为三分一
			11:
				EDTXV0709.input.auto_open_signal := FALSE;
				EDTXV0715.input.auto_open_signal := FALSE;
				EDTAV0701B.input.auto_open_signal := TRUE;
				EDTXV0711.input.auto_open_signal := TRUE;
				IF EDTXV0709.input.close_feedback_state AND EDTXV0711.input.open_feedback_state AND EDTAV0701B.input.open_feedback_state THEN
					EDTP2S4A_STEP[11].done := TRUE;
				END_IF;
			12:
				//V06-->V22确认转移完毕
			13:
				EDTAV0701B.input.auto_open_signal := FALSE;
				EDTXV0711.input.auto_open_signal := FALSE;
				IF EDTXV0711.input.close_feedback_state AND EDTAV0701B.input.close_feedback_state THEN
					EDTP2S4A_STEP[13].done := TRUE;
				END_IF;
			14:
				IF NOT R12A_process THEN
					EDTP2S4A_STEP[14].done := TRUE;
				END_IF;
			15:
			//转移
		END_CASE;		
	END_IF;
	
	//除前馏
	IF R12A_process1 THEN
		CASE R12A_process1_step OF
			0:
				MTBasicsPID_8.Enable := FALSE;
				EDTXV0701.input.auto_open_signal := TRUE;
				EDTR12A.input.auto_run_signal := TRUE;
				EDTXV0704.input.auto_open_signal := FALSE;
				EDTXV0705.input.auto_open_signal := FALSE;
				EDTFVT0701.input.auto_degree_set := 0.0;
				IF EDTXV0701.input.open_feedback_state AND EDTR12A.input.run_feedback AND EDTXV0704.input.close_feedback_state AND EDTXV0705.input.close_feedback_state THEN
					R12A_process1_step := 1;
				END_IF;
			1:
				HeatPot_2(ST1 := DINT_TO_TIME(EDTP2S4_PARA_T2 * 1000),
				ST2 := DINT_TO_TIME(EDTP2S4_PARA_T3 * 1000),
				V3 := EDTTV0701C,
				V4 := EDTTV0701D,
				V5 := EDTTV0701E,
				V6 := EDTTV0701F,
				done := R12A_process1_step_1_done);
				IF R12A_process1_step_1_done THEN
					R12A_process1_step_1_done := FALSE;
					R12A_process1_step := 2;
				END_IF;
			2:
				IF EDTTIT0701.status.value >= EDTP2S4_PARA_Temp1 THEN
					EDTTV0701C.input.auto_open_signal := FALSE;
					IF EDTTV0701C.input.close_feedback_state THEN
						R12A_process1_step := 3;
					END_IF;
				END_IF;
			3:
				TON_24.PT := DINT_TO_TIME(EDTP2S4_PARA_T4 * 60 * 1000);
				IF EDTTIT0702.status.value >= EDTP2S4_PARA_Temp4 THEN
					TON_24.IN := TRUE;
				END_IF;
				IF TON_24.Q THEN
					TON_24.IN := FALSE;
					R12A_process1_step := 4;
				END_IF;	
			4:
				MTBasicsPID_8.Enable := TRUE;
				EDTXV0705.input.auto_open_signal := FALSE;
				IF EDTXV0705.input.close_feedback_state THEN
					EDTXV0704.input.auto_open_signal := TRUE;
					IF EDTXV0704.input.open_feedback_state THEN
						//EDTFVT0701.input.auto_degree_set := EDTP2S4A_PARA_O1;
						R12A_process1_step := 5;
					END_IF;
				END_IF;
			5:
				TON_24.PT := DINT_TO_TIME(EDTP2S4_PARA_T7 * 1000);
				IF EDTTIT0702.status.value >= EDTP2S4_PARA_Temp2 THEN
					EDTTV0701D.input.auto_open_signal := FALSE;
					IF EDTTV0701D.input.close_feedback_state THEN
						EDTTV0701E.input.auto_open_signal := FALSE;
						EDTTV0701F.input.auto_open_signal := TRUE;
						//IF EDTTV0701E.input.close_feedback_state AND EDTTV0701F.input.open_feedback_state THEN
							TON_24.IN := TRUE;
						//END_IF;
					END_IF;
				END_IF;
				IF TON_24.Q THEN
					TON_24.IN := FALSE;
					R12A_process1_step := 6;
				END_IF;
			6:
				EDTTV0701F.input.auto_open_signal := FALSE;
				IF EDTTV0701F.input.close_feedback_state THEN
					EDTTV0701A.input.auto_open_signal := TRUE;
					IF EDTTV0701A.input.open_feedback_state THEN
						EDTTV0701B.input.auto_open_signal := TRUE;
						R12A_process1_step := 7;
					END_IF;
				END_IF;
			7:
				IF EDTTIT0701.status.value <= EDTP2S4_PARA_Temp3 THEN
					MTBasicsPID_8.Enable := FALSE;
					EDTTV0701B.input.auto_open_signal := FALSE;
					EDTTV0701A.input.auto_open_signal := FALSE;
					EDTR12A.input.auto_run_signal := FALSE;
					EDTXV0701.input.auto_open_signal := FALSE;
					EDTFVT0701.input.auto_degree_set := 100.0;
				END_IF;
				IF EDTTV0701A.input.close_feedback_state AND EDTTV0701B.input.close_feedback_state AND (NOT EDTR12A.input.run_feedback) THEN// AND EDTXV0701.input.close_feedback_state THEN
					R12A_process1 := FALSE;
					R12A_process1_step := 0;
				END_IF;
		END_CASE;
		TON_24();
	END_IF;
	
	//甲醇水蒸馏
	IF R12A_process THEN
		CASE R12A_process_step OF
			0:
				//甲醇水蒸馏准备
				MTBasicsPID_8.Enable := FALSE;
				EDTXV0704.input.auto_open_signal := FALSE;
				EDTXV0705.input.auto_open_signal := FALSE;
				EDTXV0701.input.auto_open_signal := TRUE;
				EDTR12A.input.auto_run_signal := TRUE;
				EDTFVT0701.input.auto_degree_set := 0.0;
				IF EDTXV0701.input.open_feedback_state AND EDTR12A.input.run_feedback AND EDTXV0704.input.close_feedback_state AND EDTXV0705.input.close_feedback_state THEN
					R12A_process_step := 1;
				END_IF;
			1:
				HeatPot_5(ST1 := DINT_TO_TIME(EDTP2S4_PARA_T2 * 1000),
				ST2 := DINT_TO_TIME(EDTP2S4_PARA_T3 * 1000),
				V3 := EDTTV0701C,
				V4 := EDTTV0701D,
				V5 := EDTTV0701E,
				V6 := EDTTV0701F,
				done := R12A_process_step_1_done);
				IF R12A_process_step_1_done THEN
					R12A_process_step_1_done := FALSE;
					R12A_process_step := 2;
				END_IF;
			2:
				IF EDTTIT0701.status.value >= EDTP2S4_PARA_Temp1 THEN
					EDTTV0701C.input.auto_open_signal := FALSE;
					IF EDTTV0701C.input.close_feedback_state THEN
						R12A_process_step := 3;
					END_IF;
				END_IF;
			3:
				TON_69.PT := DINT_TO_TIME(EDTP2S4_PARA_T4 * 60 * 1000);
				IF EDTTIT0702.status.value >= EDTP2S4_PARA_Temp4 THEN
					TON_69.IN := TRUE;
				END_IF;
				IF TON_69.Q THEN
					TON_69.IN := FALSE;
					R12A_process_step := 4;
				END_IF;
			4:
				MTBasicsPID_8.Enable := TRUE;
				EDTXV0705.input.auto_open_signal := FALSE;
				IF EDTXV0705.input.close_feedback_state THEN
					EDTXV0704.input.auto_open_signal := TRUE;
					IF EDTXV0704.input.open_feedback_state THEN
						//EDTFVT0701.input.auto_degree_set := EDTP2S4A_PARA_O2;
						R12A_process_step := 5;
					END_IF;
				END_IF;	
			5:
				IF EDTTIT0702.status.value >= EDTP2S4_PARA_Temp5 THEN
					EDTXV0704.input.auto_open_signal := FALSE;
					IF EDTXV0704.input.close_feedback_state THEN
						EDTXV0705.input.auto_open_signal := TRUE;
						IF EDTXV0705.input.open_feedback_state THEN
							//EDTFVT0701.input.auto_degree_set := EDTP2S4A_PARA_O3;
							R12A_process_step := 6;
						END_IF;
					END_IF;
				END_IF;
			6:	
				TON_69.PT := DINT_TO_TIME(EDTP2S4_PARA_T7 * 1000);
				IF EDTTIT0702.status.value >= EDTP2S4_PARA_Temp6 THEN
					EDTTV0701D.input.auto_open_signal := FALSE;
					IF EDTTV0701D.input.close_feedback_state THEN
						EDTTV0701E.input.auto_open_signal := FALSE;
						EDTTV0701F.input.auto_open_signal := TRUE;
						//IF EDTTV0701E.input.close_feedback_state AND EDTTV0701F.input.open_feedback_state THEN
							TON_69.IN := TRUE;
						//END_IF;
					END_IF;
				END_IF;
				IF TON_69.Q THEN
					TON_69.IN := FALSE;
					R12A_process_step := 7;
				END_IF;
			7:
				EDTTV0701F.input.auto_open_signal := FALSE;
				IF EDTTV0701F.input.close_feedback_state THEN
					EDTTV0701A.input.auto_open_signal := TRUE;
					IF EDTTV0701A.input.open_feedback_state THEN
						EDTTV0701B.input.auto_open_signal := TRUE;
						R12A_process_step := 8;
					END_IF;
				END_IF;
			8:
				IF EDTTIT0701.status.value <= EDTP2S4_PARA_Temp7 THEN
					MTBasicsPID_8.Enable := FALSE;
					EDTTV0701B.input.auto_open_signal := FALSE;
					EDTTV0701A.input.auto_open_signal := FALSE;
					EDTR12A.input.auto_run_signal := FALSE;
					EDTXV0701.input.auto_open_signal := FALSE;
					EDTFVT0701.input.auto_degree_set := 100.0;
				END_IF;
				IF EDTTV0701A.input.close_feedback_state AND EDTTV0701B.input.close_feedback_state AND (NOT EDTR12A.input.run_feedback) THEN //AND EDTXV0701.input.close_feedback_state THEN note：关反馈有问题 临时去掉
					R12A_process := FALSE;
					R12A_process_step := 0;
				END_IF;
		END_CASE;
		TON_69();
	END_IF;
	
	//分层
	IF r06a_separate THEN
		CASE r06a_separate_step OF
			0:
				r06a_als_data_last := r06a_als_data;
				EDTAV0701B.control.auto_operate := TRUE;
				r06a_separate_step := 1;
			1:
				TON_3.PT := T#2s;
				TON_3.IN := TRUE;
				IF TON_3.Q THEN
					TON_3.IN := FALSE;
					r06a_separate_step := 2;
				END_IF;
			2:
				IF r06a_als_data_last = r06a_als_data THEN
					r06a_separate := FALSE;
					r06a_separate_step := 0;
				ELSE
					r06a_separate_step := 3;
				END_IF;
			3:
				EDTAV0701B.input.auto_open_signal := TRUE;
				TON_3.PT := T#30s;
				TON_3.IN := TRUE;
				IF TON_3.Q THEN
					TON_3.IN := FALSE;
					r06a_separate_step := 4;
					r06a_als_data_last := r06a_als_data;
				END_IF;
			4:
				IF ABS(r06a_als_data_last - r06a_als_data) >= r06a_als_data_threshold THEN
					EDTAV0701B.input.auto_open_signal := FALSE;
					r06a_separate := FALSE;
					r06a_separate_step := 0;
				END_IF;
		END_CASE;
		TON_3();
	END_IF;
	
	
	R_TRIG_0(CLK := EDTFVT0701.status.auto_mode);
	IF R_TRIG_0.Q THEN
		MTBasicsPID_8.Enable := TRUE;
	END_IF;
	F_TRIG_0(CLK := EDTFVT0701.status.auto_mode);
	IF F_TRIG_0.Q THEN
		MTBasicsPID_8.Enable := FALSE;
	END_IF;
	//FVT0701 pid调节
	//	MTBasicsPID_8.Enable := TRUE;
	MTBasicsPID_8.PIDParameters.Gain := EDTPid0701Para.gain;
	MTBasicsPID_8.PIDParameters.IntegrationTime := EDTPid0701Para.integration_time;
	MTBasicsPID_8.PIDParameters.DerivativeTime := EDTPid0701Para.derivative_time;
	MTBasicsPID_8.MinOut := 0.0;
	MTBasicsPID_8.MaxOut := 100.0;
	MTBasicsPID_8.SetValue := EDTPid0701Para.set_value;
	MTBasicsPID_8.ActValue := EDTFIT0701.flowrate;
	MTBasicsPID_8.Update := EDTPid0701.update;
	MTBasicsPID_8();
	EDTPid0701.out := MTBasicsPID_8.Out;
	IF MTBasicsPID_8.Active THEN
		EDTFVT0701.input.auto_degree_set := MTBasicsPID_8.Out + EDTPid0701Para.min_out;
		//	ELSE
		//		EDTFVT0701.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_8.UpdateDone THEN
		EDTPid0701.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP2S4A.status.run_state) AND (NOT EDTP2S4A_STEP[EDTP2S4A.status.run_step].done AND ((EDTP2S4A.status.run_step = 1) OR (EDTP2S4A.status.run_step = 4) 
		OR (EDTP2S4A.status.run_step = 6) OR (EDTP2S4A.status.run_step = 8) OR (EDTP2S4A.status.run_step = 10) OR (EDTP2S4A.status.run_step = 12) OR (EDTP2S4A.status.run_step = 15))) THEN
		EDTP2S4A.status.confirm_enable := TRUE;
	ELSE
		EDTP2S4A.status.confirm_enable := FALSE;
	END_IF;
	
END_ACTION
