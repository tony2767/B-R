
ACTION S3_ACT: 
	//设定时间
	FOR i := 0 TO MBAS3_STEP_NUM DO
		IF MBAS3_ST[i] < T#5s THEN
			MBAS3_ST[i] := T#5s;
		END_IF;
		MBAS3_STEP[i].set_time := MBAS3_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(MBAS3,MBAS3_STEP[0],MBAS3_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS3.status.mode <> 0) AND (NOT MBAS3.auto_mode_edge) THEN
		MBAS3.auto_mode_edge := TRUE;
		MBAS3.manual_mode_edge := FALSE;

		MBAR04.control.auto_operate := TRUE;
		MBAXV0408.control.auto_operate := TRUE;
		MBAXV0409.control.auto_operate := TRUE;
		MBAFVT0401.control.auto_operate := TRUE;
		MBATV0401A.control.auto_operate := TRUE;
		MBATV0401B.control.auto_operate := TRUE;
		MBATV0401E.control.auto_operate := TRUE;
		MBATV0401F.control.auto_operate := TRUE;
		MBATV0401C.control.auto_operate := TRUE;
		MBATV0401D.control.auto_operate := TRUE;
		MBAXV0411.control.auto_operate := TRUE;
		MBAXV0415.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS3.status.mode = 0) AND (NOT MBAS3.manual_mode_edge) THEN
		MBAS3.manual_mode_edge := TRUE;
		MBAS3.auto_mode_edge := FALSE;
		
		MBAR04.control.manual_operate := TRUE;
		MBAXV0408.control.manual_operate := TRUE;
		MBAXV0409.control.manual_operate := TRUE;
		MBAFVT0401.control.manual_operate := TRUE;
		MBATV0401A.control.manual_operate := TRUE;
		MBATV0401B.control.manual_operate := TRUE;
		MBATV0401E.control.manual_operate := TRUE;
		MBATV0401F.control.manual_operate := TRUE;
		MBATV0401C.control.manual_operate := TRUE;
		MBATV0401D.control.manual_operate := TRUE;
		MBAXV0411.control.manual_operate := TRUE;
		MBAXV0415.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS3.input.error_signal := (MBAR04.status.motor_status >= 2) OR
	(MBAXV0408.status.valve_status >= 2) OR (MBAXV0409.status.valve_status >= 2) OR
	(MBATV0401A.status.valve_status >= 2) OR (MBATV0401B.status.valve_status >= 2) OR (MBAXV0415.status.valve_status >= 2) OR
	(MBATV0401E.status.valve_status >= 2) OR (MBATV0401F.status.valve_status >= 2) OR (MBATV0401C.status.valve_status >= 2) OR
	(MBATV0401D.status.valve_status >= 2) OR (MBAXV0411.status.valve_status >= 2);
	
	IF MBAS3.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS3.status.run_step OF 
			0:
				IF NOT MBAS3_STEP[0].done THEN
					MBAR04.control.auto_operate := TRUE;
					MBAXV0408.control.auto_operate := TRUE;
					MBAXV0409.control.auto_operate := TRUE;
					MBAFVT0401.control.auto_operate := TRUE;
					MBATV0401A.control.auto_operate := TRUE;
					MBATV0401B.control.auto_operate := TRUE;
					MBATV0401E.control.auto_operate := TRUE;
					MBATV0401F.control.auto_operate := TRUE;
					MBATV0401C.control.auto_operate := TRUE;
					MBATV0401D.control.auto_operate := TRUE;
					MBAXV0411.control.auto_operate := TRUE;
					MBAXV0415.control.auto_operate := TRUE;
					MBAS3_STEP[0].done := TRUE;
				END_IF;
			1:
				//确认皂化釜反应5批
			2:
				MBAR04.input.auto_run_signal := TRUE;
				MBAXV0409.input.auto_open_signal := TRUE;
				MBAXV0415.input.auto_open_signal := TRUE;
				MTBasicsPID_4.Enable := FALSE;
				MBAFVT0401.input.auto_degree_set := 0.0;
				IF MBAR04.input.run_feedback AND MBAXV0409.input.open_feedback_state AND MBAXV0415.input.open_feedback_state THEN
					MBAS3_STEP[2].done := TRUE;
				END_IF;
			3:
				CASE step3_3 OF
					0:
						IF NOT MBAS3_STEP[3].done THEN
							step3_3 := 1;
						END_IF;
					1:
						HeatPot_7(ST1 := DINT_TO_TIME(MBAS3_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(MBAS3_PARA_T2 * 1000),
						V3 := MBATV0401A,
						V4 := MBATV0401B,
						V5 := MBATV0401E,
						V6 := MBATV0401F,
						done := step3_3_1_done);
						IF step3_3_1_done THEN
							step3_3 := 2;
						END_IF;
					2:
						IF MBATIT0401.status.value >= MBAS3_PARA_Temp1 THEN
							step3_3 := 3;
						END_IF;
					3:
						MBATV0401A.input.auto_open_signal := FALSE;
						IF MBATV0401A.input.close_feedback_state THEN
							step3_3 := 0;
							step3_3_1_done := FALSE;
							MBAS3_STEP[3].done := TRUE;
						END_IF;
				END_CASE;	
			4:
				CASE step3_4 OF
					0:
						last_value_MBATIT0402 := 0.0;
						IF NOT MBAS3_STEP[4].done THEN
							step3_4 := 1;
						END_IF;
//					1:
//						TON_2.PT := DINT_TO_TIME(MBAS3_PARA_T3 * 60 * 1000);
//						TON_2.IN := TRUE;
//						IF TON_2.Q THEN
//							TON_2.IN := FALSE;
//							IF ABS(MBATIT0402.status.value - last_value_MBATIT0402) <= MBAS3_PARA_Temp2 THEN	
//								MTBasicsPID_4.Enable := TRUE;
////								MBAFVT0401.input.auto_degree_set := MBAS3_PARA_O2;
//								step3_4 := 2;
//							END_IF;
//							last_value_MBATIT0402 := MBATIT0402.status.value;	
						//						END_IF;
					1:
						TON_2.PT := DINT_TO_TIME(MBAS3_PARA_T3 * 60 * 1000);
						IF MBATIT0402.status.value >= MBAS3_PARA_Temp2 THEN
							TON_2.IN := TRUE;
						END_IF;
						IF TON_2.Q THEN
							TON_2.IN := FALSE;
							MTBasicsPID_4.Enable := TRUE;
							step3_4 := 2;
						END_IF;
					2:
						IF MBATIT0401.status.value >= MBAS3_PARA_Temp3 THEN
							step3_4 := 3;
						END_IF;
					3:
						MBATV0401F.input.auto_open_signal := TRUE;
						IF MBATV0401F.input.open_feedback_state THEN
							step3_4 := 4;
						END_IF;
					4:
						MBATV0401B.input.auto_open_signal := FALSE;
						IF MBATV0401B.input.close_feedback_state THEN
							step3_4 := 5;
						END_IF;
					5:
						TON_2.PT := DINT_TO_TIME(MBAS3_PARA_T4 * 1000);
						TON_2.IN := TRUE;
						IF TON_2.Q THEN
							TON_2.IN := FALSE;
							step3_4 := 6;
						END_IF;
					6:
						MBATV0401E.input.auto_open_signal := FALSE;
						MBATV0401F.input.auto_open_signal := FALSE;
						IF MBATV0401E.input.close_feedback_state AND MBATV0401F.input.close_feedback_state THEN
							step3_4 := 0;
							MBAS3_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
				TON_2();
				//手动控制出料阀
			5:
				CASE step3_5 OF
					0:
						IF NOT MBAS3_STEP[5].done THEN
							step3_5 := 1;
						END_IF;
					1:
						MBATV0401C.input.auto_open_signal := TRUE;
						IF MBATV0401C.input.open_feedback_state THEN
							step3_5 := 2;
						END_IF;
					2:
						MBATV0401D.input.auto_open_signal := TRUE;
						IF MBATV0401D.input.open_feedback_state THEN
							step3_5 := 3;
						END_IF;
					3:
						IF MBATIT0401.status.value <= MBAS3_PARA_Temp4 THEN
							step3_5 := 4;
						END_IF;
					4:
						MBATV0401D.input.auto_open_signal := FALSE;
						IF MBATV0401D.input.close_feedback_state THEN
							step3_5 := 5;
						END_IF;
					5:
						MBATV0401C.input.auto_open_signal := FALSE;
						IF MBATV0401C.input.close_feedback_state THEN
							step3_5 := 6;
						END_IF;
					6:
						MBAR04.input.auto_run_signal := FALSE;
						IF NOT MBAR04.input.run_feedback THEN
							step3_5 := 7;
						END_IF;
					7:
						MTBasicsPID_4.Enable := FALSE;
						MBAFVT0401.input.auto_degree_set := 0.0;
						MBAXV0409.input.auto_open_signal := FALSE;
						IF MBAXV0409.input.close_feedback_state THEN
							step3_5 := 0;
							MBAS3_STEP[5].done := TRUE;
						END_IF;
				END_CASE;
			6:
				CASE step3_9 OF
					0:
						IF NOT MBAS3_STEP[6].done THEN
							step3_9 := 1;
						END_IF;
					1:
						MBAXV0411.input.auto_open_signal := TRUE;
						step3_9 := 2;
					2:
						IF MBALIT0401.status.value <= 0.0 THEN
							step3_9 := 3;
						END_IF;
					3:
						TON_4.PT := DINT_TO_TIME(MBAS3_PARA_T5 * 60 * 1000);
						TON_4.IN := TRUE;
						IF TON_4.Q THEN
							TON_4.IN := FALSE;
							step3_9 := 4;
						END_IF;
					4:
						MBAXV0411.input.auto_open_signal := FALSE;
						IF MBAXV0411.input.close_feedback_state THEN
							step3_9 := 0;
							MBAS3_STEP[6].done := TRUE;
						END_IF;
				END_CASE;
				TON_4();
		END_CASE;		
	END_IF;
	
	//FVT0401 pid调节
	R_TRIG_4(CLK := MBAFVT0401.status.auto_mode);
	IF R_TRIG_4.Q THEN
		MTBasicsPID_4.Enable := TRUE;
	END_IF;
	F_TRIG_4(CLK := MBAFVT0401.status.auto_mode);
	IF F_TRIG_4.Q THEN
		MTBasicsPID_4.Enable := FALSE;
	END_IF;
	//MTBasicsPID_4.Enable := TRUE;
	MTBasicsPID_4.PIDParameters.Gain := MBAPidFVT0401Para.gain;
	MTBasicsPID_4.PIDParameters.IntegrationTime := MBAPidFVT0401Para.integration_time;
	MTBasicsPID_4.PIDParameters.DerivativeTime := MBAPidFVT0401Para.derivative_time;
	MTBasicsPID_4.MinOut := 0.0;
	MTBasicsPID_4.MaxOut := 100.0;
	MTBasicsPID_4.SetValue := MBAPidFVT0401Para.set_value;
	MTBasicsPID_4.ActValue := MBAFIT0401.flowrate;
	MTBasicsPID_4.Update := MBAPidFVT0401.update;
	MTBasicsPID_4();
	MBAPidFVT0401.out := MTBasicsPID_4.Out;
	IF MTBasicsPID_4.Active THEN
		MBAFVT0401.input.auto_degree_set := MTBasicsPID_4.Out + MBAPidFVT0401Para.min_out;
		//	ELSE
		//		MBAFVT0401.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_4.UpdateDone THEN
		MBAPidFVT0401.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS3.status.run_state) AND (NOT MBAS3_STEP[MBAS3.status.run_step].done AND ((MBAS3.status.run_step = 1))) THEN
		MBAS3.status.confirm_enable := TRUE;
	ELSE
		MBAS3.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
