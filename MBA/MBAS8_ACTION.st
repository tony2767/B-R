
ACTION S8_ACT: 
	//设定时间
	FOR i := 0 TO MBAS8_STEP_NUM DO
		IF MBAS8_ST[i] < T#5s THEN
			MBAS8_ST[i] := T#5s;
		END_IF;
		MBAS8_STEP[i].set_time := MBAS8_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(MBAS8,MBAS8_STEP[0],MBAS8_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS8.status.mode <> 0) AND (NOT MBAS8.auto_mode_edge) THEN
		MBAS8.auto_mode_edge := TRUE;
		MBAS8.manual_mode_edge := FALSE;
		
		MBAXV0516.control.auto_operate := TRUE;
		MBAXV0524.control.auto_operate := TRUE;
		MBAXV0520.control.auto_operate := TRUE;
		MBAXV0611.control.auto_operate := TRUE;
		MBAXV0603.control.auto_operate := TRUE;
		MBAXV0628.control.auto_operate := TRUE;
		MBAXV0613.control.auto_operate := TRUE;
		MBAPV0601.control.auto_operate := TRUE;
		MBAP06.control.auto_operate := TRUE;
		MBATV0601A.control.auto_operate := TRUE;
		MBATV0601B.control.auto_operate := TRUE;
		MBATV0601C.control.auto_operate := TRUE;
		MBATV0601D.control.auto_operate := TRUE;
		MBATV0601E.control.auto_operate := TRUE;
		MBATV0601F.control.auto_operate := TRUE;
		MBAXV0631.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS8.status.mode = 0) AND (NOT MBAS8.manual_mode_edge) THEN
		MBAS8.manual_mode_edge := TRUE;
		MBAS8.auto_mode_edge := FALSE;
		
		MBAXV0516.control.manual_operate := TRUE;
		MBAXV0524.control.manual_operate := TRUE;
		MBAXV0520.control.manual_operate := TRUE;
		MBAXV0611.control.manual_operate := TRUE;
		MBAXV0603.control.manual_operate := TRUE;
		MBAXV0628.control.manual_operate := TRUE;
		MBAXV0613.control.manual_operate := TRUE;
		MBAPV0601.control.manual_operate := TRUE;
		MBAP06.control.manual_operate := TRUE;
		MBATV0601A.control.manual_operate := TRUE;
		MBATV0601B.control.manual_operate := TRUE;
		MBATV0601C.control.manual_operate := TRUE;
		MBATV0601D.control.manual_operate := TRUE;
		MBATV0601E.control.manual_operate := TRUE;
		MBATV0601F.control.manual_operate := TRUE;
		MBAXV0631.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS8.input.error_signal := (MBAP06.status.motor_status >= 2) OR (MBAXV0516.status.valve_status >= 2) OR
	(MBAXV0524.status.valve_status >= 2) OR (MBAXV0520.status.valve_status >= 2) OR (MBAXV0611.status.valve_status >= 2) OR
	(MBAXV0603.status.valve_status >= 2) OR (MBAXV0628.status.valve_status >= 2) OR (MBAXV0613.status.valve_status >= 2) OR
	(MBAPV0601.status.valve_status >= 2) OR (MBATV0601A.status.valve_status >= 2) OR (MBATV0601B.status.valve_status >= 2) OR
	(MBATV0601C.status.valve_status >= 2) OR (MBATV0601D.status.valve_status >= 2) OR (MBATV0601E.status.valve_status >= 2) OR
	(MBATV0601F.status.valve_status >= 2) OR (MBAXV0631.status.valve_status >= 2);

	IF MBAS8.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS8.status.run_step OF 
			0:
				IF NOT MBAS8_STEP[0].done THEN
					MBAXV0516.control.auto_operate := TRUE;
					MBAXV0524.control.auto_operate := TRUE;
					MBAXV0520.control.auto_operate := TRUE;
					MBAXV0611.control.auto_operate := TRUE;
					MBAXV0603.control.auto_operate := TRUE;
					MBAXV0628.control.auto_operate := TRUE;
					MBAXV0613.control.auto_operate := TRUE;
					MBAPV0601.control.auto_operate := TRUE;
					MBAP06.control.auto_operate := TRUE;
					MBATV0601A.control.auto_operate := TRUE;
					MBATV0601B.control.auto_operate := TRUE;
					MBATV0601C.control.auto_operate := TRUE;
					MBATV0601D.control.auto_operate := TRUE;
					MBATV0601E.control.auto_operate := TRUE;
					MBATV0601F.control.auto_operate := TRUE;
					MBAXV0631.control.auto_operate := TRUE;
					is_press_ok_R09 := FALSE;
					MBAS8_STEP[0].done := TRUE;
				END_IF;
			1:
				//试漏
			2:
				//R09进料,人工观察R08转移完毕反馈
				CASE step8_2 OF
					0:
						IF NOT MBAS8_STEP[2].done THEN
							step8_2 := 1;
						END_IF;
					1:
						MBAXV0516.input.auto_open_signal := TRUE;
						IF MBAXV0516.input.open_feedback_state THEN
							step8_2 := 2;
						END_IF;
					2:
						IF MBAPIT0601.status.value <= MBAS8_PARA_P3 THEN
							MBAXV0524.input.auto_open_signal := FALSE;
							step8_2 := 3;
						END_IF;
					3:
						IF MBAXV0524.input.close_feedback_state THEN
							step8_2 := 4;
						END_IF;
					4:
						MBAXV0520.input.auto_open_signal := TRUE;
						MBAXV0611.input.auto_open_signal := TRUE;
						IF MBAXV0611.input.open_feedback_state THEN
							step8_2 := 5;
						END_IF;
					5:
						IF NOT MBAS8_STEP[2].done THEN
							IF MBAPIT0502.status.value <= MBAS8_PARA_P4 THEN
								MBAXV0520.input.auto_open_signal := TRUE;
							ELSIF MBAPIT0502.status.value >= MBAS8_PARA_P5 THEN
								MBAXV0520.input.auto_open_signal := FALSE;
							END_IF;
						ELSE
							step8_2 := 0;
						END_IF;
				END_CASE;
			3:
				MBAXV0520.input.auto_open_signal := FALSE;
				IF MBAPIT0502.status.value <= MBAS8_PARA_P6 THEN
					MBAXV0516.input.auto_open_signal := FALSE;
					MBAXV0524.input.auto_open_signal := TRUE;
					IF MBAXV0516.input.close_feedback_state AND MBAXV0524.input.open_feedback_state THEN
						MBAS8_STEP[3].done := TRUE;
					END_IF;
				END_IF;
			4:
				//吹扫 需人工观察
				IF NOT MBAS8_STEP[4].done THEN
					MBAXV0603.input.auto_open_signal := TRUE;
					IF MBAPIT0601.status.value >= MBAS8_PARA_P7 THEN
						MBAXV0611.input.auto_open_signal := TRUE;
					ELSIF MBAPIT0601.status.value <= MBAS8_PARA_P8 THEN
						MBAXV0611.input.auto_open_signal := FALSE;
					END_IF;
				ELSE
					MBAXV0603.input.auto_open_signal := FALSE;
					MBAXV0611.input.auto_open_signal := FALSE;
				END_IF;
			5:
				MBAXV0628.input.auto_open_signal := FALSE;
				MBAXV0613.input.auto_open_signal := TRUE;
				MBAPV0601.input.auto_open_signal := TRUE;
				//手动启动R09搅拌
			6:
				MBAP06.input.auto_run_signal := TRUE;
				IF MBAP06.input.run_feedback THEN
					MBAS8_STEP[6].done := TRUE;
				END_IF;
			7:
				HeatPot_4(ST1 := DINT_TO_TIME(MBAS8_PARA_T2 * 1000),
				ST2 := DINT_TO_TIME(MBAS8_PARA_T3 * 1000),
				V3 := MBATV0601E,
				V4 := MBATV0601F,
				V5 := MBATV0601C,
				V6 := MBATV0601D,
				done := MBAS8_STEP[7].done);
			8:
				IF MBATIT0601.status.value >= MBAS8_PARA_Temp1 THEN
					MBATV0601E.input.auto_open_signal := FALSE;
				END_IF;
			9:
				//降温
				MBATV0601E.input.auto_open_signal := FALSE;
				MBAXV0631.input.auto_open_signal := TRUE;
				CoolPot_2(
					time := cool_pot_time,
					V1 := MBATV0601A,
					V2 := MBATV0601B,
					V3 := MBATV0601D,
					V4 := MBATV0601F,
					V5 := MBATV0601C,
				done := MBAS8_STEP[9].done);
			10:
				CASE step8_10 OF
					0:
						IF NOT MBAS8_STEP[10].done THEN
							step8_10 := 1;
						END_IF;
					1:
						IF MBATIT0601.status.value <= MBAS8_PARA_Temp2 THEN
							MBAXV0631.input.auto_open_signal := FALSE;
							MBAXV0603.input.auto_open_signal := TRUE;
							step8_10 := 2;
						END_IF;
					2:
						IF MBAPIT0601.status.value >= MBAS8_PARA_P9 THEN
							MBAP06.input.auto_run_signal := FALSE;
							IF MBAP06.input.run_feedback = FALSE THEN
								step8_10 := 3;
							END_IF;
						END_IF;
					3:
						IF MBAPIT0601.status.value >= MBAS8_PARA_P10 THEN
							MBAXV0603.input.auto_open_signal := FALSE;
							step8_10 := 4;
						END_IF;
					4:
						MBAS8_STEP[10].done := TRUE;
						step8_10 := 0;
				END_CASE;
			11:
				MBAXV0628.input.auto_open_signal := TRUE;
				//				IF MBAXV0628.input.open_feedback_state THEN
				//					MBAS8_STEP[11].done := TRUE;
				//				END_IF;
			12:
				MBAXV0613.input.auto_open_signal := FALSE;
				MBATV0601A.input.auto_open_signal := FALSE;
				MBATV0601B.input.auto_open_signal := FALSE;
				IF MBAXV0613.input.close_feedback_state AND MBATV0601A.input.close_feedback_state AND MBATV0601B.input.close_feedback_state THEN
					MBAS8_STEP[12].done := TRUE;
				END_IF;
		END_CASE;		
	END_IF;
	
	IF press_test_R09 THEN
		CASE step8_1 OF
			0:
				is_press_ok_R09 := FALSE;
				step8_1 := 1;
			1:
				MBAPV0601.input.auto_open_signal := FALSE;
				IF MBAPV0601.input.close_feedback_state THEN
					MBAXV0603.input.auto_open_signal := TRUE;
					step8_1 := 2;
				END_IF;
			2:
				IF MBAPIT0601.status.value >= MBAS8_PARA_P1 THEN
					MBAXV0603.input.auto_open_signal := FALSE;
					step8_1 := 3;
				END_IF;
			3:
				TON_12.PT := DINT_TO_TIME(MBAS8_PARA_T1 * 60 * 1000);
				TON_12.IN := TRUE;
				IF TON_12.Q THEN
					TON_12.IN := FALSE;
					step8_1 := 4;
				END_IF;
			4:
				IF MBAS8_PARA_P1 - MBAPIT0601.status.value <= MBAS8_PARA_P2 THEN
					is_press_ok_R09 := TRUE;
				ELSE
					is_press_ok_R09 := FALSE;
				END_IF;
				step8_1 := 5;
			5:
				press_test_R09 := FALSE;
				step8_1 := 0;	
		END_CASE;
		TON_12();
	END_IF;
	
	
	//MBAR05酒精回收 
	//常压回收
	IF r05_recover THEN
		CASE r05_recover_step OF
			0:	
				MBAXV0616.control.auto_operate := TRUE;
				MBAFVT0601.control.auto_operate := TRUE;
				MBAR05.control.auto_operate := TRUE;
				MBATV0602E.control.auto_operate := TRUE;
				MBATV0602F.control.auto_operate := TRUE;
				MBATV0602C.control.auto_operate := TRUE;
				MBATV0602D.control.auto_operate := TRUE;
				MBATV0602A.control.auto_operate := TRUE;
				MBATV0602B.control.auto_operate := TRUE;
				r05_recover_step := 1;
			1:
				MBAXV0616.input.auto_open_signal := TRUE;
				MTBasicsPID_2.Enable := FALSE;
				MBAFVT0601.input.auto_degree_set := 0.0;
				MBAR05.input.auto_run_signal := TRUE;
				IF MBAXV0616.input.open_feedback_state AND MBAR05.input.auto_run_signal THEN
					r05_recover_step := 2;
				END_IF;
			2:
				HeatPot_1(ST1 := DINT_TO_TIME(MBAR05_PARA_T1 * 1000),
				ST2 := DINT_TO_TIME(MBAR05_PARA_T2 * 1000),
				V3 := MBATV0602E,
				V4 := MBATV0602F,
				V5 := MBATV0602C,
				V6 := MBATV0602D,
				done := HeatPot_1_done);
				IF HeatPot_1_done THEN
					HeatPot_1_done := FALSE;
					r05_recover_step := 3;
				END_IF;
			3:
				IF MBATIT0602.status.value >=  MBAR05_PARA_Temp1 THEN
					MBATV0602E.input.auto_open_signal := FALSE;
					r05_recover_step := 4;
				END_IF;
			4:
				TON_6.PT := DINT_TO_TIME(MBAR05_PARA_T3 * 60 * 1000);
				TON_6.IN := TRUE;
				IF TON_6.Q THEN
					TON_6.IN := FALSE;
					MTBasicsPID_2.Enable := TRUE;
					r05_recover_step := 5;
				END_IF;
			5:
				IF MBATIT0602.status.value >= MBAR05_PARA_Temp2 THEN
					MBATV0602F.input.auto_open_signal := FALSE;
					MBATV0602C.input.auto_open_signal := FALSE;
					MBATV0602D.input.auto_open_signal := TRUE;
					IF MBATV0602F.input.close_feedback_state AND MBATV0602C.input.close_feedback_state AND MBATV0602D.input.open_feedback_state THEN
						r05_recover_step := 6;
					END_IF;
				END_IF;
			6:
				TON_6.PT := DINT_TO_TIME(MBAR05_PARA_T4 * 1000);
				TON_6.IN := TRUE;
				IF TON_6.Q THEN
					TON_6.IN := FALSE;
					r05_recover_step := 7;
				END_IF;
			7:
				MBATV0602D.input.auto_open_signal := FALSE;
				IF MBATV0602D.input.close_feedback_state THEN
					MBATV0602A.input.auto_open_signal := TRUE;
				END_IF;
				IF MBATV0602A.input.open_feedback_state THEN
					MBATV0602B.input.auto_open_signal := TRUE;
				END_IF;
				IF MBATV0602A.input.open_feedback_state AND MBATV0602B.input.open_feedback_state AND MBATV0602D.input.close_feedback_state THEN
					r05_recover_step := 8;
				END_IF;
			8:
				IF MBATIT0602.status.value <= MBAR05_PARA_Temp3 THEN
					MTBasicsPID_2.Enable := FALSE;
					MBAFVT0601.input.auto_degree_set := 0.0;
					MBATV0602B.input.auto_open_signal := FALSE;
					IF MBATV0602B.input.close_feedback_state THEN
						MBATV0602A.input.auto_open_signal := FALSE;
						IF MBATV0602A.input.close_feedback_state THEN
							r05_recover_step := 9;
						END_IF;
					END_IF;
				END_IF;
			9:
				MBAR05.input.auto_run_signal := FALSE;
				MBAXV0616.input.auto_open_signal := FALSE;
				IF (NOT MBAR05.input.run_feedback) AND MBAXV0616.input.close_feedback_state THEN
					r05_recover_step := 0;
					r05_recover := FALSE;
				END_IF;	
		END_CASE;
		TON_6();
	END_IF;

	
	
	//FVT0601 pid调节
	R_TRIG_2(CLK := MBAFVT0601.status.auto_mode);
	IF R_TRIG_2.Q THEN
		MTBasicsPID_2.Enable := TRUE;
	END_IF;
	F_TRIG_2(CLK := MBAFVT0601.status.auto_mode);
	IF F_TRIG_2.Q THEN
		MTBasicsPID_2.Enable := FALSE;
	END_IF;
	//MTBasicsPID_2.Enable := TRUE;
	MTBasicsPID_2.PIDParameters.Gain := MBAPidFVT0601Para.gain;
	MTBasicsPID_2.PIDParameters.IntegrationTime := MBAPidFVT0601Para.integration_time;
	MTBasicsPID_2.PIDParameters.DerivativeTime := MBAPidFVT0601Para.derivative_time;
	MTBasicsPID_2.MinOut := 0.0;
	MTBasicsPID_2.MaxOut := 100.0;
	MTBasicsPID_2.SetValue := MBAPidFVT0601Para.set_value;
	MTBasicsPID_2.ActValue := MBAFIT0601.flowrate;
	MTBasicsPID_2.Update := MBAPidFVT0601.update;
	MTBasicsPID_2();
	MBAPidFVT0601.out := MTBasicsPID_2.Out;
	IF MTBasicsPID_2.Active THEN
		MBAFVT0601.input.auto_degree_set := MTBasicsPID_2.Out + MBAPidFVT0601Para.min_out;
		//	ELSE
		//		MBAFVT0601.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_2.UpdateDone THEN
		MBAPidFVT0601.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS8.status.run_state) AND (NOT MBAS8_STEP[MBAS8.status.run_step].done AND ((MBAS8.status.run_step = 1) OR (MBAS8.status.run_step = 2) OR (MBAS8.status.run_step = 4) OR (MBAS8.status.run_step = 5) OR (MBAS8.status.run_step = 8) OR (MBAS8.status.run_step = 11))) THEN
		MBAS8.status.confirm_enable := TRUE;
	ELSE
		MBAS8.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
