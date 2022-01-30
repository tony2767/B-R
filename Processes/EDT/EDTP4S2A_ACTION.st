
ACTION P4S2A_ACT: 
	//设定时间
	FOR i := 0 TO EDTP4S2_STEP_NUM DO
		IF EDTP4S2A_ST[i] < T#5s THEN
			EDTP4S2A_ST[i] := T#5s;
		END_IF;
		EDTP4S2A_STEP[i].set_time := EDTP4S2A_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP4S2A,EDTP4S2A_STEP[0],EDTP4S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP4S2A.status.mode <> 0) AND (NOT EDTP4S2A.auto_mode_edge) THEN
		EDTP4S2A.auto_mode_edge := TRUE;
		EDTP4S2A.manual_mode_edge := FALSE;
		
		EDTXV1114.control.auto_operate := TRUE;
		EDTR10A.control.auto_operate := TRUE;
		EDTXV1104.control.auto_operate := TRUE;
		EDTXV1109.control.auto_operate := TRUE;
		EDTXV1120.control.auto_operate := TRUE;
		EDTXV1106.control.auto_operate := TRUE;
		EDTFVT1101.control.auto_operate := TRUE;
		EDTTV1101C.control.auto_operate := TRUE;
		EDTTV1101D.control.auto_operate := TRUE;
		EDTTV1101E.control.auto_operate := TRUE;
		EDTTV1101F.control.auto_operate := TRUE;
		EDTXV1107.control.auto_operate := TRUE;
		EDTTV1101A.control.auto_operate := TRUE;
		EDTTV1101B.control.auto_operate := TRUE;
		EDTXV1105.control.auto_operate := TRUE;
		EDTXV1108.control.auto_operate := TRUE;
		EDTTVT1103.control.auto_operate := TRUE;
		EDTFQV1101A.control.auto_operate := TRUE;
		EDTP15.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP4S2A.status.mode = 0) AND (NOT EDTP4S2A.manual_mode_edge) THEN
		EDTP4S2A.manual_mode_edge := TRUE;
		EDTP4S2A.auto_mode_edge := FALSE;
		
		EDTXV1114.control.manual_operate := TRUE;
		EDTR10A.control.manual_operate := TRUE;
		EDTXV1104.control.manual_operate := TRUE;
		EDTXV1109.control.manual_operate := TRUE;
		EDTXV1120.control.manual_operate := TRUE;
		EDTXV1106.control.manual_operate := TRUE;
		EDTFVT1101.control.manual_operate := TRUE;
		EDTTV1101C.control.manual_operate := TRUE;
		EDTTV1101D.control.manual_operate := TRUE;
		EDTTV1101E.control.manual_operate := TRUE;
		EDTTV1101F.control.manual_operate := TRUE;
		EDTXV1107.control.manual_operate := TRUE;
		EDTTV1101A.control.manual_operate := TRUE;
		EDTTV1101B.control.manual_operate := TRUE;
		EDTXV1105.control.manual_operate := TRUE;
		EDTXV1108.control.manual_operate := TRUE;
		EDTTVT1103.control.manual_operate := TRUE;
		EDTFQV1101A.control.manual_operate := TRUE;
		EDTP15.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP4S2A.input.error_signal :=
	(EDTXV1114.status.valve_status >= 2) OR 
	(EDTR10A.status.motor_status >= 2) OR (EDTXV1104.status.valve_status >= 2) OR (EDTXV1109.status.valve_status >= 2) OR
	(EDTXV1120.status.valve_status >= 2) OR (EDTXV1106.status.valve_status >= 2) OR
	(EDTTV1101C.status.valve_status >= 2) OR (EDTTV1101D.status.valve_status >= 2) OR (EDTTV1101E.status.valve_status >= 2) OR
	(EDTTV1101F.status.valve_status >= 2) OR (EDTXV1107.status.valve_status >= 2) OR (EDTTV1101A.status.valve_status >= 2) OR
	(EDTTV1101B.status.valve_status >= 2) OR (EDTXV1105.status.valve_status >= 2) OR (EDTXV1108.status.valve_status >= 2) OR
	(EDTFQV1101A.status.valve_status >= 2) OR (EDTP15.status.motor_status >= 2);
	
	IF EDTP4S2A.status.run_state = 1 THEN
		CASE EDTP4S2A.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP4S2A_STEP[0].done THEN
					EDTXV1114.control.auto_operate := TRUE;
					EDTR10A.control.auto_operate := TRUE;
					EDTXV1104.control.auto_operate := TRUE;
					EDTXV1109.control.auto_operate := TRUE;
					EDTXV1120.control.auto_operate := TRUE;
					EDTXV1106.control.auto_operate := TRUE;
					EDTFVT1101.control.auto_operate := TRUE;
					EDTTV1101C.control.auto_operate := TRUE;
					EDTTV1101D.control.auto_operate := TRUE;
					EDTTV1101E.control.auto_operate := TRUE;
					EDTTV1101F.control.auto_operate := TRUE;
					EDTXV1107.control.auto_operate := TRUE;
					EDTTV1101A.control.auto_operate := TRUE;
					EDTTV1101B.control.auto_operate := TRUE;
					EDTXV1105.control.auto_operate := TRUE;
					EDTXV1108.control.auto_operate := TRUE;
					EDTTVT1103.control.auto_operate := TRUE;
					EDTFQV1101A.control.auto_operate := TRUE;
					EDTP15.control.auto_operate := TRUE;
					EDTP4S2A_STEP[0].done := TRUE;
				END_IF;
			1:
				//准备
				MTBasicsPID_1.Enable := FALSE;
				MTBasicsPID_10.Enable := FALSE;
				EDTXV1114.input.auto_open_signal := FALSE;
				EDTFVT1101.input.auto_degree_set := 100.0;
				EDTTVT1103.input.auto_degree_set := 100.0;
				EDTR10A.input.auto_run_signal := TRUE;
				EDTXV1120.input.auto_open_signal := TRUE;
				IF EDTXV1120.input.open_feedback_state THEN
					EDTXV1104.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1104.input.open_feedback_state THEN
					EDTXV1106.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1106.input.open_feedback_state THEN
					EDTXV1109.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTIT1101.status.value <= EDTP4S2_PARA_Temp4 THEN
					EDTTV1101A.input.auto_open_signal := FALSE;
					EDTTV1101B.input.auto_open_signal := FALSE;
					IF EDTR10A.input.run_feedback AND EDTXV1104.input.open_feedback_state AND EDTXV1109.input.open_feedback_state AND EDTTV1101A.input.close_feedback_state
						AND EDTTV1101B.input.close_feedback_state AND EDTXV1120.input.open_feedback_state AND EDTXV1106.input.open_feedback_state AND EDTXV1114.input.close_feedback_state 
						AND EDTXV1114.input.close_feedback_state THEN
						EDTP4S2A_STEP[1].done := TRUE;
					END_IF;
				ELSIF EDTTIT1101.status.value >= EDTP4S2_PARA_Temp6 THEN
					EDTTV1101A.input.auto_open_signal := TRUE;
					EDTTV1101B.input.auto_open_signal := TRUE;
				END_IF;
			2:
				//启动一级真空泵
			3:
				CASE p4_step2_3a OF
					0:
						IF NOT EDTP4S2A_STEP[3].done THEN
							p4_step2_3a := 1;
						END_IF;
					1:
						HeatPot_3(ST1 := DINT_TO_TIME(EDTP4S2_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP4S2_PARA_T2 * 1000),
						V3 := EDTTV1101C,
						V4 := EDTTV1101D,
						V5 := EDTTV1101E,
						V6 := EDTTV1101F,
						done := p4_step2_3a_1_done);
						IF p4_step2_3a_1_done THEN
							p4_step2_3a_1_done := FALSE;
							p4_step2_3a := 2;
						END_IF;
					2:
						IF EDTTIT1101.status.value >= EDTP4S2_PARA_Temp1 THEN
							EDTTV1101C.input.auto_open_signal := FALSE;
						END_IF;
						IF EDTTV1101C.input.close_feedback_state THEN
							p4_step2_3a := 3;
						END_IF;
					3:
						IF EDTTIT1101.status.value >= EDTP4S2_PARA_Temp2 THEN
							p4_step2_3a := 0;
							EDTP4S2A_STEP[3].done := TRUE;
						END_IF;
				END_CASE;
			4:
				//启动二三四级真空泵
			5:
				CASE p4_step2_5a OF
					0:
						IF NOT EDTP4S2A_STEP[5].done THEN
							p4_step2_5a := 1;
						END_IF;
					1:
						IF EDTTIT1102.status.value >= EDTP4S2_PARA_Temp5 THEN
							MTBasicsPID_1.Enable := TRUE;
							MTBasicsPID_10.Enable := FALSE;
							EDTFVT1101.input.auto_degree_set := 0.0;
							p4_step2_5a := 2;
						END_IF;
					2:
						TON_43.PT := DINT_TO_TIME(EDTP4S2_PARA_T3 * 60 * 1000);
						TON_43.IN := TRUE;
						IF TON_43.Q THEN
							TON_43.IN := FALSE;
							p4_step2_5a := 3;
						END_IF;
					3:
						MTBasicsPID_10.Enable := TRUE;
						p4_step2_5a := 4;
					4:
						TON_43.PT := DINT_TO_TIME(EDTP4S2_PARA_T4 * 3600 * 1000);
						TON_43.IN := TRUE;
						IF TON_43.Q THEN
							TON_43.IN := FALSE;
							p4_step2_5a := 5;
							p4_step2_5a_confirm_enable := TRUE;
						END_IF;
					5:
						IF EDTP4S2A_STEP[5].done THEN
							p4_step2_5a := 0;
							p4_step2_5a_confirm_enable := FALSE;
						END_IF;
				END_CASE;
				TON_43();
			6:
				EDTXV1120.input.auto_open_signal := FALSE;
				TON_7.PT := DINT_TO_TIME(EDTP4S2_PARA_T5 * 3600 * 1000);
				IF EDTXV1120.input.close_feedback_state THEN
					EDTXV1107.input.auto_open_signal := TRUE;
					IF EDTXV1107.input.open_feedback_state THEN
						TON_7.IN := TRUE;
					END_IF;
				END_IF;
				IF TON_7.Q THEN
					TON_7.IN := FALSE;
					EDTP4S2A_STEP[6].done := TRUE;
				END_IF;
				TON_7();
			7:
				//观察
			8:
				CASE p4_step2_7a OF
					0:
						IF NOT EDTP4S2A_STEP[8].done THEN
							p4_step2_7a := 1;
						END_IF;
					1:
						CoolPot_4(
							time := cool_pot_time,
							V1 := EDTTV1101A,
							V2 := EDTTV1101B,
							V3 := EDTTV1101F,
							V4 := EDTTV1101D,
							V5 := EDTTV1101E,
							done := p4_step2_7a_1_done);
						IF p4_step2_7a_1_done THEN
							p4_step2_7a_1_done := FALSE;
							p4_step2_7a := 2;
						END_IF;
					2:
						IF EDTTIT1101.status.value <= EDTP4S2_PARA_Temp3 THEN
							p4_step2_7a := 0;
							EDTP4S2A_STEP[8].done := TRUE;
						END_IF;
				END_CASE;
			9:
				//依次关闭四三二级真空泵
			10:
				MTBasicsPID_10.Enable := FALSE;
				EDTFVT1101.input.auto_degree_set := 100.0;
				EDTXV1105.input.auto_open_signal := TRUE;
				EDTXV1108.input.auto_open_signal := TRUE;
				IF EDTPIT1101.status.value >= EDTP4S2_PARA_P1 THEN
					EDTTV1101A.input.auto_open_signal := FALSE;
					EDTTV1101B.input.auto_open_signal := FALSE;
					IF EDTTV1101A.input.close_feedback_state AND EDTTV1101B.input.close_feedback_state THEN
						EDTP4S2A_STEP[10].done := TRUE;
					END_IF;
				END_IF;
			11:
				//关闭一级泵
			12:
				IF EDTPIT1101.status.value >= EDTP4S2_PARA_P2 THEN
					EDTXV1105.input.auto_open_signal := FALSE;
					EDTXV1108.input.auto_open_signal := FALSE;
					EDTP4S2A_STEP[12].done := TRUE;
				END_IF;
			13:
				MTBasicsPID_1.Enable := FALSE;
				EDTTVT1103.input.auto_degree_set := 100.0;
				EDTXV1107.input.auto_open_signal := FALSE;
				EDTXV1114.input.auto_open_signal := TRUE;
				IF EDTXV1107.input.close_feedback_state THEN
					EDTXV1120.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1107.input.close_feedback_state AND EDTXV1114.input.open_feedback_state AND EDTXV1120.input.open_feedback_state THEN
					EDTP4S2A_STEP[13].done := TRUE;
				END_IF;
		END_CASE;			
	END_IF;
	
	//pid调节
	R_TRIG_4(CLK := EDTTVT1103.status.auto_mode);
	IF R_TRIG_4.Q THEN
		MTBasicsPID_1.Enable := TRUE;
	END_IF;
	F_TRIG_4(CLK := EDTTVT1103.status.auto_mode);
	IF F_TRIG_4.Q THEN
		MTBasicsPID_1.Enable := FALSE;
	END_IF;
	
	//	MTBasicsPID_1.Enable := TRUE;
	MTBasicsPID_1.Invert := TRUE;
	MTBasicsPID_1.PIDParameters.Gain := EDTPid1103Para.gain;
	MTBasicsPID_1.PIDParameters.IntegrationTime := EDTPid1103Para.integration_time;
	MTBasicsPID_1.PIDParameters.DerivativeTime := EDTPid1103Para.derivative_time;
	MTBasicsPID_1.MinOut := 0.0;
	MTBasicsPID_1.MaxOut := 100.0;
	MTBasicsPID_1.ActValue := EDTTIT1103.status.value;
	MTBasicsPID_1.SetValue := EDTPid1103Para.set_value;
	MTBasicsPID_1.Update := EDTPid1103.update;
	MTBasicsPID_1();
	EDTPid1103.out := MTBasicsPID_1.Out;
	IF MTBasicsPID_1.Active THEN
		EDTTVT1103.input.auto_degree_set := MTBasicsPID_1.Out;
		//	ELSE
		//		EDTTVT1103.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_1.UpdateDone THEN
		EDTPid1103.update := FALSE;
	END_IF;
	
	//FVT1101 pid调节
	R_TRIG_5(CLK := EDTFVT1101.status.auto_mode);
	IF R_TRIG_5.Q THEN
		MTBasicsPID_10.Enable := TRUE;
	END_IF;
	F_TRIG_5(CLK := EDTFVT1101.status.auto_mode);
	IF F_TRIG_5.Q THEN
		MTBasicsPID_10.Enable := FALSE;
	END_IF;
	
	//	MTBasicsPID_10.Enable := TRUE;
	MTBasicsPID_10.PIDParameters.Gain := EDTPidFVT1101Para.gain;
	MTBasicsPID_10.PIDParameters.IntegrationTime := EDTPidFVT1101Para.integration_time;
	MTBasicsPID_10.PIDParameters.DerivativeTime := EDTPidFVT1101Para.derivative_time;
	MTBasicsPID_10.MinOut := 0.0;
	MTBasicsPID_10.MaxOut := 100.0;
	MTBasicsPID_10.SetValue := EDTPidFVT1101Para.set_value;
	MTBasicsPID_10.ActValue := EDTFIT1101.flowrate;
	MTBasicsPID_10.Update := EDTPidFVT1101.update;
	MTBasicsPID_10();
	EDTPidFVT1101.out := MTBasicsPID_10.Out;
	IF MTBasicsPID_10.Active THEN
		EDTFVT1101.input.auto_degree_set := MTBasicsPID_10.Out + EDTPidFVT1101Para.min_out;
		//	ELSE
		//		EDTFVT1101.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_10.UpdateDone THEN
		EDTPidFVT1101.update := FALSE;
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP4S2A.status.run_state) AND (NOT EDTP4S2A_STEP[EDTP4S2A.status.run_step].done AND ((EDTP4S2A.status.run_step = 2) OR (EDTP4S2A.status.run_step = 4) OR (EDTP4S2A.status.run_step = 7)
		OR (EDTP4S2A.status.run_step = 9) OR (EDTP4S2A.status.run_step = 11) OR (p4_step2_5a_confirm_enable))) THEN
		EDTP4S2A.status.confirm_enable := TRUE;
	ELSE
		EDTP4S2A.status.confirm_enable := FALSE;
	END_IF;
END_ACTION