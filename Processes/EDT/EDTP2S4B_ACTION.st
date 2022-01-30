
ACTION P2S4B_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S4_STEP_NUM DO
		IF EDTP2S4B_ST[i] < T#5s THEN
			EDTP2S4B_ST[i] := T#5s;
		END_IF;
		EDTP2S4B_STEP[i].set_time := EDTP2S4B_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP2S4B,EDTP2S4B_STEP[0],EDTP2S4_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP2S4B.status.mode <> 0) AND (NOT EDTP2S4B.auto_mode_edge) THEN
		EDTP2S4B.auto_mode_edge := TRUE;
		EDTP2S4B.manual_mode_edge := FALSE;
		
		EDTXV0724.control.auto_operate := TRUE;
		EDTAV0702B.control.auto_operate := TRUE;
		EDTAV0702A.control.auto_operate := TRUE;
		EDTXV0716.control.auto_operate := TRUE;
		EDTR12B.control.auto_operate := TRUE;
		EDTTV0703C.control.auto_operate := TRUE;
		EDTTV0703D.control.auto_operate := TRUE;
		EDTTV0703E.control.auto_operate := TRUE;
		EDTTV0703F.control.auto_operate := TRUE;
		EDTFVT0703.control.auto_operate := TRUE;
		EDTXV0719.control.auto_operate := TRUE;
		EDTXV0718.control.auto_operate := TRUE;
		EDTTV0703A.control.auto_operate := TRUE;
		EDTTV0703B.control.auto_operate := TRUE;
		EDTXV0722.control.auto_operate := TRUE;
		EDTXV0723.control.auto_operate := TRUE;
		EDTXV0715.control.auto_operate := TRUE;
		
	END_IF;
	
	IF (EDTP2S4B.status.mode = 0) AND (NOT EDTP2S4B.manual_mode_edge) THEN
		EDTP2S4B.manual_mode_edge := TRUE;
		EDTP2S4B.auto_mode_edge := FALSE;

		EDTXV0724.control.manual_operate := TRUE;
		EDTAV0702B.control.manual_operate := TRUE;
		EDTAV0702A.control.manual_operate := TRUE;
		EDTXV0716.control.manual_operate := TRUE;
		EDTR12B.control.manual_operate := TRUE;
		EDTTV0703C.control.manual_operate := TRUE;
		EDTTV0703D.control.manual_operate := TRUE;
		EDTTV0703E.control.manual_operate := TRUE;
		EDTTV0703F.control.manual_operate := TRUE;
		EDTFVT0703.control.manual_operate := TRUE;
		EDTXV0719.control.manual_operate := TRUE;
		EDTXV0718.control.manual_operate := TRUE;
		EDTTV0703A.control.manual_operate := TRUE;
		EDTTV0703B.control.manual_operate := TRUE;
		EDTXV0722.control.manual_operate := TRUE;
		EDTXV0723.control.manual_operate := TRUE;
		EDTXV0715.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S4B.input.error_signal := (EDTXV0724.status.valve_status >= 2) OR (EDTAV0702B.status.valve_status >= 2) OR
	(EDTR12B.status.motor_status >= 2) OR (EDTAV0702A.status.valve_status >= 2) OR (EDTXV0716.status.valve_status >= 2) OR
	(EDTTV0703C.status.valve_status >= 2) OR (EDTTV0703D.status.valve_status >= 2) OR (EDTTV0703E.status.valve_status >= 2) OR 
	(EDTTV0703F.status.valve_status >= 2) OR (EDTXV0719.status.valve_status >= 2) OR (EDTXV0718.status.valve_status >= 2) OR 
	(EDTTV0703A.status.valve_status >= 2) OR (EDTTV0703B.status.valve_status >= 2) OR (EDTXV0722.status.valve_status >= 2) OR
	(EDTXV0723.status.valve_status >= 2);

	IF EDTP2S4B.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP2S4B.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S4B_STEP[0].done THEN
					EDTXV0724.control.auto_operate := TRUE;
					EDTAV0702B.control.auto_operate := TRUE;
					EDTAV0702A.control.auto_operate := TRUE;
					EDTXV0716.control.auto_operate := TRUE;
					EDTR12B.control.auto_operate := TRUE;
					EDTTV0703C.control.auto_operate := TRUE;
					EDTTV0703D.control.auto_operate := TRUE;
					EDTTV0703E.control.auto_operate := TRUE;
					EDTTV0703F.control.auto_operate := TRUE;
					EDTFVT0703.control.auto_operate := TRUE;
					EDTXV0719.control.auto_operate := TRUE;
					EDTXV0718.control.auto_operate := TRUE;
					EDTTV0703A.control.auto_operate := TRUE;
					EDTTV0703B.control.auto_operate := TRUE;
					EDTXV0722.control.auto_operate := TRUE;	
					EDTXV0723.control.auto_operate := TRUE;
					EDTXV0715.control.auto_operate := TRUE;
					EDTP2S4B_STEP[0].done := TRUE;	
				END_IF;
			1:
				//手动分层，完成后点确认
			2:
				//除前馏
				R12B_process1 := TRUE;
				EDTP2S4B_STEP[2].done := TRUE;
			3:
				IF NOT R12B_process1 THEN
					EDTP2S4B_STEP[3].done := TRUE;
				END_IF;
			4:
				//转移确认V19空
			5:
				TON_70.PT := DINT_TO_TIME(EDTP2S4_PARA_T5 * 60 * 1000);
				EDTXV0722.input.auto_open_signal := TRUE;
				IF EDTXV0722.input.open_feedback_state THEN
					TON_70.IN := TRUE;
				END_IF;
				IF TON_70.Q THEN
					TON_70.IN := FALSE;
					EDTP2S4B_STEP[5].done := TRUE;
				END_IF;
				TON_70();
			6:
				//确认R12空
			7:
				TON_71.PT := DINT_TO_TIME(EDTP2S4_PARA_T6 * 60 * 1000);
				EDTXV0722.input.auto_open_signal := FALSE;
				IF EDTXV0722.input.close_feedback_state THEN
					EDTXV0724.input.auto_open_signal := TRUE;
					EDTAV0702A.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0724.input.open_feedback_state AND EDTAV0702A.input.open_feedback_state THEN
					TON_71.IN := TRUE;
				END_IF;
				IF TON_71.Q THEN
					TON_71.IN := FALSE;
					EDTP2S4B_STEP[7].done := TRUE;
				END_IF;
				TON_71();
			8:
				//确认R06空
			9:
				R12B_process := TRUE;
				EDTAV0702A.input.auto_open_signal := FALSE;
				IF EDTAV0702A.input.close_feedback_state THEN
					EDTXV0724.input.auto_open_signal := FALSE;
					IF EDTXV0724.input.close_feedback_state THEN
						EDTXV0723.input.auto_open_signal := TRUE;
						IF EDTXV0723.input.open_feedback_state THEN
							EDTXV0715.input.auto_open_signal := TRUE;
							EDTP2S4B_STEP[9].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			10:
				//确认转移完毕
			11:
				EDTXV0723.input.auto_open_signal := FALSE;
				EDTXV0715.input.auto_open_signal := FALSE;
				EDTAV0702B.input.auto_open_signal := TRUE;
				EDTXV0724.input.auto_open_signal := TRUE;
				IF EDTXV0723.input.close_feedback_state AND EDTXV0724.input.open_feedback_state AND EDTAV0702B.input.open_feedback_state THEN
					EDTP2S4B_STEP[11].done := TRUE;
				END_IF;
			12:
				//V06-->V22确认转移完毕
			13:
				EDTAV0702B.input.auto_open_signal := FALSE;
				EDTXV0724.input.auto_open_signal := FALSE;
				IF EDTXV0724.input.close_feedback_state AND EDTAV0702B.input.close_feedback_state THEN
					EDTP2S4B_STEP[13].done := TRUE;
				END_IF;
			14:
				IF NOT R12B_process THEN
					EDTP2S4B_STEP[14].done := TRUE;
				END_IF;
			15:
			//转移
		END_CASE;		
	END_IF;
	
	//除前馏
	IF R12B_process1 THEN
		CASE R12B_process1_step OF
			0:
				MTBasicsPID_9.Enable := FALSE;
				EDTXV0716.input.auto_open_signal := TRUE;
				EDTR12B.input.auto_run_signal := TRUE;
				EDTXV0719.input.auto_open_signal := FALSE;
				EDTXV0718.input.auto_open_signal := FALSE;
				EDTFVT0703.input.auto_degree_set := 0.0;
				IF EDTXV0716.input.open_feedback_state AND EDTR12B.input.run_feedback AND EDTXV0719.input.close_feedback_state AND EDTXV0718.input.close_feedback_state THEN
					R12B_process1_step := 1;
				END_IF;
			1:
				HeatPot_6(ST1 := DINT_TO_TIME(EDTP2S4_PARA_T2 * 1000),
				ST2 := DINT_TO_TIME(EDTP2S4_PARA_T3 * 1000),
				V3 := EDTTV0703C,
				V4 := EDTTV0703D,
				V5 := EDTTV0703E,
				V6 := EDTTV0703F,
				done := R12B_process1_step_1_done);
				IF R12B_process1_step_1_done THEN
					R12B_process1_step_1_done := FALSE;
					R12B_process1_step := 2;
				END_IF;
			2:
				IF EDTTIT0703.status.value >= EDTP2S4_PARA_Temp1 THEN
					EDTTV0703C.input.auto_open_signal := FALSE;
					IF EDTTV0703C.input.close_feedback_state THEN
						R12B_process1_step := 3;
					END_IF;
				END_IF;
			3:
				TON_72.PT := DINT_TO_TIME(EDTP2S4_PARA_T4 * 60 * 1000);
				IF EDTTIT0704.status.value >= EDTP2S4_PARA_Temp4 THEN
					TON_72.IN := TRUE;
				END_IF;
				IF TON_72.Q THEN
					TON_72.IN := FALSE;
					R12B_process1_step := 4;
				END_IF;	
			4:
				MTBasicsPID_9.Enable := TRUE;
				EDTXV0718.input.auto_open_signal := FALSE;
				IF EDTXV0718.input.close_feedback_state THEN
					EDTXV0719.input.auto_open_signal := TRUE;
					IF EDTXV0719.input.open_feedback_state THEN
						//EDTFVT0703.input.auto_degree_set := EDTP2S4B_PARA_O1;
						R12B_process1_step := 5;
					END_IF;
				END_IF;
			5:
				TON_72.PT := DINT_TO_TIME(EDTP2S4_PARA_T7 * 1000);
				IF EDTTIT0704.status.value >= EDTP2S4_PARA_Temp2 THEN
					EDTTV0703D.input.auto_open_signal := FALSE;
					IF EDTTV0703D.input.close_feedback_state THEN
						EDTTV0703E.input.auto_open_signal := FALSE;
						EDTTV0703F.input.auto_open_signal := TRUE;
						//IF EDTTV0703E.input.close_feedback_state AND EDTTV0703F.input.open_feedback_state THEN
							TON_72.IN := TRUE;
						//END_IF;
					END_IF;
				END_IF;
				IF TON_72.Q THEN
					TON_72.IN := FALSE;
					R12B_process1_step := 6;
				END_IF;
			6:
				EDTTV0703F.input.auto_open_signal := FALSE;
				IF EDTTV0703F.input.close_feedback_state THEN
					EDTTV0703A.input.auto_open_signal := TRUE;
					IF EDTTV0703A.input.open_feedback_state THEN
						EDTTV0703B.input.auto_open_signal := TRUE;
						R12B_process1_step := 7;
					END_IF;
				END_IF;
			7:
				IF EDTTIT0703.status.value <= EDTP2S4_PARA_Temp3 THEN
					MTBasicsPID_9.Enable := FALSE;
					EDTTV0703B.input.auto_open_signal := FALSE;
					EDTTV0703A.input.auto_open_signal := FALSE;
					EDTR12B.input.auto_run_signal := FALSE;
					EDTXV0716.input.auto_open_signal := FALSE;
					EDTFVT0703.input.auto_degree_set := 100.0;
				END_IF;
				IF EDTTV0703A.input.close_feedback_state AND EDTTV0703B.input.close_feedback_state AND (NOT EDTR12B.input.run_feedback) AND EDTXV0716.input.close_feedback_state THEN
					R12B_process1 := FALSE;
					R12B_process1_step := 0;
				END_IF;
		END_CASE;
		TON_72();
	END_IF;
	
	//甲醇水蒸馏
	IF R12B_process THEN
		CASE R12B_process_step OF
			0:
				//甲醇水蒸馏准备
				MTBasicsPID_9.Enable := FALSE;
				EDTXV0719.input.auto_open_signal := FALSE;
				EDTXV0718.input.auto_open_signal := FALSE;
				EDTXV0716.input.auto_open_signal := TRUE;
				EDTR12B.input.auto_run_signal := TRUE;
				EDTFVT0703.input.auto_degree_set := 0.0;
				IF EDTXV0716.input.open_feedback_state AND EDTR12B.input.run_feedback AND EDTXV0719.input.close_feedback_state AND EDTXV0718.input.close_feedback_state THEN
					R12B_process_step := 1;
				END_IF;
			1:
				HeatPot_10(ST1 := DINT_TO_TIME(EDTP2S4_PARA_T2 * 1000),
				ST2 := DINT_TO_TIME(EDTP2S4_PARA_T3 * 1000),
				V3 := EDTTV0703C,
				V4 := EDTTV0703D,
				V5 := EDTTV0703E,
				V6 := EDTTV0703F,
				done := R12B_process_step_1_done);
				IF R12B_process_step_1_done THEN
					R12B_process_step_1_done := FALSE;
					R12B_process_step := 2;
				END_IF;
			2:
				IF EDTTIT0703.status.value >= EDTP2S4_PARA_Temp1 THEN
					EDTTV0703C.input.auto_open_signal := FALSE;
					IF EDTTV0703C.input.close_feedback_state THEN
						R12B_process_step := 3;
					END_IF;
				END_IF;
			3:
				TON_75.PT := DINT_TO_TIME(EDTP2S4_PARA_T4 * 60 * 1000);
				IF EDTTIT0704.status.value >= EDTP2S4_PARA_Temp4 THEN
					TON_75.IN := TRUE;
				END_IF;
				IF TON_75.Q THEN
					TON_75.IN := FALSE;
					R12B_process_step := 4;
				END_IF;
			4:
				MTBasicsPID_9.Enable := TRUE;
				EDTXV0718.input.auto_open_signal := FALSE;
				IF EDTXV0718.input.close_feedback_state THEN
					EDTXV0719.input.auto_open_signal := TRUE;
					IF EDTXV0719.input.open_feedback_state THEN
						//EDTFVT0703.input.auto_degree_set := EDTP2S4B_PARA_O2;
						R12B_process_step := 5;
					END_IF;
				END_IF;
			5:
				IF EDTTIT0704.status.value >= EDTP2S4_PARA_Temp5 THEN
					EDTXV0719.input.auto_open_signal := FALSE;
					IF EDTXV0719.input.close_feedback_state THEN
						EDTXV0718.input.auto_open_signal := TRUE;
						IF EDTXV0718.input.open_feedback_state THEN
							//EDTFVT0703.input.auto_degree_set := EDTP2S4B_PARA_O3;
							R12B_process_step := 6;
						END_IF;
					END_IF;
				END_IF;
			6:	
				TON_75.PT := DINT_TO_TIME(EDTP2S4_PARA_T7 * 1000);
				IF EDTTIT0704.status.value >= EDTP2S4_PARA_Temp6 THEN
					EDTTV0703D.input.auto_open_signal := FALSE;
					IF EDTTV0703D.input.close_feedback_state THEN
						EDTTV0703E.input.auto_open_signal := FALSE;
						EDTTV0703F.input.auto_open_signal := TRUE;
						//IF EDTTV0703E.input.close_feedback_state AND EDTTV0703F.input.open_feedback_state THEN
							TON_75.IN := TRUE;
						//END_IF;
					END_IF;
				END_IF;
				IF TON_75.Q THEN
					TON_75.IN := FALSE;
					R12B_process_step := 7;
				END_IF;
			7:
				EDTTV0703F.input.auto_open_signal := FALSE;
				IF EDTTV0703F.input.close_feedback_state THEN
					EDTTV0703A.input.auto_open_signal := TRUE;
					IF EDTTV0703A.input.open_feedback_state THEN
						EDTTV0703B.input.auto_open_signal := TRUE;
						R12B_process_step := 8;
					END_IF;
				END_IF;
			8:
				IF EDTTIT0703.status.value <= EDTP2S4_PARA_Temp7 THEN
					MTBasicsPID_9.Enable := FALSE;
					EDTTV0703B.input.auto_open_signal := FALSE;
					EDTTV0703A.input.auto_open_signal := FALSE;
					EDTR12B.input.auto_run_signal := FALSE;
					EDTXV0716.input.auto_open_signal := FALSE;
					EDTFVT0703.input.auto_degree_set := 100.0;
				END_IF;
				IF EDTTV0703A.input.close_feedback_state AND EDTTV0703B.input.close_feedback_state AND (NOT EDTR12B.input.run_feedback) AND EDTXV0716.input.close_feedback_state THEN
					R12B_process := FALSE;
					R12B_process_step := 0;
				END_IF;
		END_CASE;
		TON_75();
	END_IF;
		
	

	R_TRIG_1(CLK := EDTFVT0703.status.auto_mode);
	IF R_TRIG_1.Q THEN
		MTBasicsPID_9.Enable := TRUE;
	END_IF;
	F_TRIG_1(CLK := EDTFVT0703.status.auto_mode);
	IF F_TRIG_1.Q THEN
		MTBasicsPID_9.Enable := FALSE;
	END_IF;
	//FVT0703 pid调节
	//	MTBasicsPID_9.Enable := TRUE;
	MTBasicsPID_9.PIDParameters.Gain := EDTPid0703Para.gain;
	MTBasicsPID_9.PIDParameters.IntegrationTime := EDTPid0703Para.integration_time;
	MTBasicsPID_9.PIDParameters.DerivativeTime := EDTPid0703Para.derivative_time;
	MTBasicsPID_9.MinOut := 0.0;
	MTBasicsPID_9.MaxOut := 100.0;
	MTBasicsPID_9.SetValue := EDTPid0703Para.set_value;
	MTBasicsPID_9.ActValue := EDTFIT0703.flowrate;
	MTBasicsPID_9.Update := EDTPid0703.update;
	MTBasicsPID_9();
	EDTPid0703.out := MTBasicsPID_9.Out;
	IF MTBasicsPID_9.Active THEN
		EDTFVT0703.input.auto_degree_set := MTBasicsPID_9.Out + EDTPid0703Para.min_out;
		//	ELSE
		//		EDTFVT0703.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_9.UpdateDone THEN
		EDTPid0703.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP2S4B.status.run_state) AND (NOT EDTP2S4B_STEP[EDTP2S4B.status.run_step].done AND ((EDTP2S4B.status.run_step = 1) OR (EDTP2S4B.status.run_step = 4) 
		OR (EDTP2S4B.status.run_step = 6) OR (EDTP2S4B.status.run_step = 8) OR (EDTP2S4B.status.run_step = 10) OR (EDTP2S4B.status.run_step = 12) OR (EDTP2S4B.status.run_step = 15))) THEN
		EDTP2S4B.status.confirm_enable := TRUE;
	ELSE
		EDTP2S4B.status.confirm_enable := FALSE;
	END_IF;
	
END_ACTION
