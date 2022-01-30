
ACTION P4S2C_ACT: 
		//设定时间
	FOR i := 0 TO EDTP4S2_STEP_NUM DO
		IF EDTP4S2C_ST[i] < T#5s THEN
			EDTP4S2C_ST[i] := T#5s;
		END_IF;
		EDTP4S2C_STEP[i].set_time := EDTP4S2C_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP4S2C,EDTP4S2C_STEP[0],EDTP4S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP4S2C.status.mode <> 0) AND (NOT EDTP4S2C.auto_mode_edge) THEN
		EDTP4S2C.auto_mode_edge := TRUE;
		EDTP4S2C.manual_mode_edge := FALSE;
		
		EDTXV1148.control.auto_operate := TRUE;
		EDTR10C.control.auto_operate := TRUE;
		EDTXV1140.control.auto_operate := TRUE;
		EDTXV1145.control.auto_operate := TRUE;
		EDTXV1152.control.auto_operate := TRUE;
		EDTXV1142.control.auto_operate := TRUE;
		EDTFVT1105.control.auto_operate := TRUE;
		EDTTV1107C.control.auto_operate := TRUE;
		EDTTV1107D.control.auto_operate := TRUE;
		EDTTV1107E.control.auto_operate := TRUE;
		EDTTV1107F.control.auto_operate := TRUE;
		EDTXV1143.control.auto_operate := TRUE;
		EDTTV1107A.control.auto_operate := TRUE;
		EDTTV1107B.control.auto_operate := TRUE;
		EDTXV1141.control.auto_operate := TRUE;
		EDTXV1144.control.auto_operate := TRUE;
		EDTTVT1109.control.auto_operate := TRUE;
		EDTFQV1101C.control.auto_operate := TRUE;
		EDTP15.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP4S2C.status.mode = 0) AND (NOT EDTP4S2C.manual_mode_edge) THEN
		EDTP4S2C.manual_mode_edge := TRUE;
		EDTP4S2C.auto_mode_edge := FALSE;
		
		EDTXV1148.control.manual_operate := TRUE;
		EDTR10C.control.manual_operate := TRUE;
		EDTXV1140.control.manual_operate := TRUE;
		EDTXV1145.control.manual_operate := TRUE;
		EDTXV1152.control.manual_operate := TRUE;
		EDTXV1142.control.manual_operate := TRUE;
		EDTFVT1105.control.manual_operate := TRUE;
		EDTTV1107C.control.manual_operate := TRUE;
		EDTTV1107D.control.manual_operate := TRUE;
		EDTTV1107E.control.manual_operate := TRUE;
		EDTTV1107F.control.manual_operate := TRUE;
		EDTXV1143.control.manual_operate := TRUE;
		EDTTV1107A.control.manual_operate := TRUE;
		EDTTV1107B.control.manual_operate := TRUE;
		EDTXV1141.control.manual_operate := TRUE;
		EDTXV1144.control.manual_operate := TRUE;
		EDTTVT1109.control.manual_operate := TRUE;
		EDTFQV1101C.control.manual_operate := TRUE;
		EDTP15.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP4S2C.input.error_signal :=
	(EDTXV1148.status.valve_status >= 2) OR
	(EDTR10C.status.motor_status >= 2) OR (EDTXV1140.status.valve_status >= 2) OR (EDTXV1145.status.valve_status >= 2) OR
	(EDTXV1152.status.valve_status >= 2) OR (EDTXV1142.status.valve_status >= 2) OR
	(EDTTV1107C.status.valve_status >= 2) OR (EDTTV1107D.status.valve_status >= 2) OR (EDTTV1107E.status.valve_status >= 2) OR
	(EDTTV1107F.status.valve_status >= 2) OR (EDTXV1143.status.valve_status >= 2) OR (EDTTV1107A.status.valve_status >= 2) OR
	(EDTTV1107B.status.valve_status >= 2) OR (EDTXV1141.status.valve_status >= 2) OR (EDTXV1144.status.valve_status >= 2) OR
	(EDTFQV1101C.status.valve_status >= 2) OR (EDTP15.status.motor_status >= 2);
	
	IF EDTP4S2C.status.run_state = 1 THEN
		CASE EDTP4S2C.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP4S2C_STEP[0].done THEN
					EDTXV1148.control.auto_operate := TRUE;
					EDTR10C.control.auto_operate := TRUE;
					EDTXV1140.control.auto_operate := TRUE;
					EDTXV1145.control.auto_operate := TRUE;
					EDTXV1152.control.auto_operate := TRUE;
					EDTXV1142.control.auto_operate := TRUE;
					EDTFVT1105.control.auto_operate := TRUE;
					EDTTV1107C.control.auto_operate := TRUE;
					EDTTV1107D.control.auto_operate := TRUE;
					EDTTV1107E.control.auto_operate := TRUE;
					EDTTV1107F.control.auto_operate := TRUE;
					EDTXV1143.control.auto_operate := TRUE;
					EDTTV1107A.control.auto_operate := TRUE;
					EDTTV1107B.control.auto_operate := TRUE;
					EDTXV1141.control.auto_operate := TRUE;
					EDTXV1144.control.auto_operate := TRUE;
					EDTTVT1109.control.auto_operate := TRUE;
					EDTFQV1101C.control.auto_operate := TRUE;
					EDTP15.control.auto_operate := TRUE;
					EDTP4S2C_STEP[0].done := TRUE;
				END_IF;
			1:
				//准备
				MTBasicsPID_6.Enable := FALSE;
				MTBasicsPID_12.Enable := FALSE;
				EDTXV1148.input.auto_open_signal := FALSE;
				EDTFVT1105.input.auto_degree_set := 100.0;
				EDTTVT1109.input.auto_degree_set := 100.0;
				EDTR10C.input.auto_run_signal := TRUE;
				EDTXV1152.input.auto_open_signal := TRUE;
				IF EDTXV1152.input.open_feedback_state THEN
					EDTXV1140.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1140.input.open_feedback_state THEN
					EDTXV1142.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1142.input.open_feedback_state THEN
					EDTXV1145.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTIT1107.status.value <= EDTP4S2_PARA_Temp4 THEN
					EDTTV1107A.input.auto_open_signal := FALSE;
					EDTTV1107B.input.auto_open_signal := FALSE;
					IF EDTR10C.input.run_feedback AND EDTXV1140.input.open_feedback_state AND EDTXV1145.input.open_feedback_state AND EDTTV1107A.input.close_feedback_state
						AND EDTTV1107B.input.close_feedback_state AND EDTXV1152.input.open_feedback_state AND EDTXV1142.input.open_feedback_state AND EDTXV1148.input.close_feedback_state 
						AND EDTXV1148.input.close_feedback_state THEN
						EDTP4S2C_STEP[1].done := TRUE;
					END_IF;
				ELSIF EDTTIT1107.status.value >=  (EDTP4S2_PARA_Temp4 + 1) THEN
					EDTTV1107A.input.auto_open_signal := TRUE;
					EDTTV1107B.input.auto_open_signal := TRUE;
				END_IF;
			2:
				//启动一级真空泵
			3:
				CASE p4_step2_3c OF
					0:
						IF NOT EDTP4S2C_STEP[3].done THEN
							p4_step2_3c := 1;
						END_IF;
					1:
						HeatPot_14(ST1 := DINT_TO_TIME(EDTP4S2_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP4S2_PARA_T2 * 1000),
						V3 := EDTTV1107C,
						V4 := EDTTV1107D,
						V5 := EDTTV1107E,
						V6 := EDTTV1107F,
						done := p4_step2_3c_1_done);
						IF p4_step2_3c_1_done THEN
							p4_step2_3c_1_done := FALSE;
							p4_step2_3c := 2;
						END_IF;
					2:
						IF EDTTIT1107.status.value >= EDTP4S2_PARA_Temp1 THEN
							EDTTV1107C.input.auto_open_signal := FALSE;
						END_IF;
						IF EDTTV1107C.input.close_feedback_state THEN
							p4_step2_3c := 3;
						END_IF;
					3:
						IF EDTTIT1107.status.value >= EDTP4S2_PARA_Temp2 THEN
							p4_step2_3c := 0;
							EDTP4S2C_STEP[3].done := TRUE;
						END_IF;
				END_CASE;
			4:
				//启动二三四级真空泵
			5:
				CASE p4_step2_5c OF
					0:
						IF NOT EDTP4S2C_STEP[5].done THEN
							p4_step2_5c := 1;
						END_IF;
					1:
						IF EDTTIT1108.status.value >= EDTP4S2_PARA_Temp5 THEN
							MTBasicsPID_6.Enable := TRUE;
							MTBasicsPID_12.Enable := FALSE;
							EDTFVT1105.input.auto_degree_set := 0.0;
							p4_step2_5c := 2;
						END_IF;
					2:
						TON_68.PT := DINT_TO_TIME(EDTP4S2_PARA_T3 * 60 * 1000);
						TON_68.IN := TRUE;
						IF TON_68.Q THEN
							TON_68.IN := FALSE;
							p4_step2_5c := 3;
						END_IF;
					3:
						MTBasicsPID_12.Enable := TRUE;
						p4_step2_5c := 4;
					4:
						TON_68.PT := DINT_TO_TIME(EDTP4S2_PARA_T4 * 3600 * 1000);
						TON_68.IN := TRUE;
						IF TON_68.Q THEN
							TON_68.IN := FALSE;
							p4_step2_5c_confirm_enable := TRUE;
							p4_step2_5c := 5;
						END_IF;
					5:
						IF EDTP4S2C_STEP[5].done THEN
							p4_step2_5c_confirm_enable := FALSE;
							p4_step2_5c := 0;
						END_IF;
				END_CASE;
				TON_68();
			6:
				EDTXV1152.input.auto_open_signal := FALSE;
				TON_16.PT := DINT_TO_TIME(EDTP4S2_PARA_T5 * 3600 * 1000);
				IF EDTXV1152.input.close_feedback_state THEN
					EDTXV1143.input.auto_open_signal := TRUE;
					IF EDTXV1143.input.open_feedback_state THEN
						TON_16.IN := TRUE;
					END_IF;
				END_IF;
				IF TON_16.Q THEN
					TON_16.IN := FALSE;
					EDTP4S2C_STEP[6].done := TRUE;
				END_IF;
				TON_16();
			7:
				//观察
			8:
				CASE p4_step2_7c OF
					0:
						IF NOT EDTP4S2C_STEP[8].done THEN
							p4_step2_7c := 1;
						END_IF;
					1:
						CoolPot_2(
							time := cool_pot_time,
							V1 := EDTTV1107A,
							V2 := EDTTV1107B,
							V3 := EDTTV1107F,
							V4 := EDTTV1107D,
							V5 := EDTTV1107E,
							done := p4_step2_7c_1_done);
						IF p4_step2_7c_1_done THEN
							p4_step2_7c_1_done := FALSE;
							p4_step2_7c := 2;
						END_IF;
					2:
						IF EDTTIT1107.status.value <= EDTP4S2_PARA_Temp3 THEN
							p4_step2_7c := 0;
							EDTP4S2C_STEP[8].done := TRUE;
						END_IF;
				END_CASE;
			9:
				//依次关闭四三二级真空泵
			10:
				MTBasicsPID_12.Enable := FALSE;
				EDTFVT1105.input.auto_degree_set := 100.0;
				EDTXV1141.input.auto_open_signal := TRUE;
				EDTXV1144.input.auto_open_signal := TRUE;
				IF EDTPIT1103.status.value >= EDTP4S2_PARA_P1 THEN
					EDTTV1107A.input.auto_open_signal := FALSE;
					EDTTV1107B.input.auto_open_signal := FALSE;
					IF EDTTV1107A.input.close_feedback_state AND EDTTV1107B.input.close_feedback_state THEN
						EDTP4S2C_STEP[10].done := TRUE;
					END_IF;
				END_IF;
			11:
				//关闭一级泵
			12:
				IF EDTPIT1103.status.value >= EDTP4S2_PARA_P2 THEN
					EDTXV1141.input.auto_open_signal := FALSE;
					EDTXV1144.input.auto_open_signal := FALSE;
					EDTP4S2C_STEP[12].done := TRUE;
				END_IF;
			13:
				MTBasicsPID_6.Enable := FALSE;
				EDTTVT1109.input.auto_degree_set := 100.0;
				EDTXV1143.input.auto_open_signal := FALSE;
				EDTXV1148.input.auto_open_signal := TRUE;
				IF EDTXV1143.input.close_feedback_state THEN
					EDTXV1152.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1143.input.close_feedback_state AND EDTXV1148.input.open_feedback_state AND EDTXV1152.input.open_feedback_state THEN
					EDTP4S2C_STEP[13].done := TRUE;
				END_IF;
		END_CASE;			
	END_IF;
	
	//pid调节
	R_TRIG_8(CLK := EDTTVT1109.status.auto_mode);
	IF R_TRIG_8.Q THEN
		MTBasicsPID_6.Enable := TRUE;
	END_IF;
	F_TRIG_8(CLK := EDTTVT1109.status.auto_mode);
	IF F_TRIG_8.Q THEN
		MTBasicsPID_6.Enable := FALSE;
	END_IF;
	//	MTBasicsPID_6.Enable := TRUE;
	MTBasicsPID_6.Invert := TRUE;
	MTBasicsPID_6.PIDParameters.Gain := EDTPid1109Para.gain;
	MTBasicsPID_6.PIDParameters.IntegrationTime := EDTPid1109Para.integration_time;
	MTBasicsPID_6.PIDParameters.DerivativeTime := EDTPid1109Para.derivative_time;
	MTBasicsPID_6.MinOut := 0.0;
	MTBasicsPID_6.MaxOut := 100.0;
	MTBasicsPID_6.ActValue := EDTTIT1109.status.value;
	MTBasicsPID_6.SetValue := EDTPid1109Para.set_value;
	MTBasicsPID_6.Update := EDTPid1109.update;
	MTBasicsPID_6();
	EDTPid1109.out := MTBasicsPID_6.Out;
	IF MTBasicsPID_6.Active THEN
		EDTTVT1109.input.auto_degree_set := MTBasicsPID_6.Out;
		//	ELSE
		//		EDTTVT1109.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_6.UpdateDone THEN
		EDTPid1109.update := FALSE;
	END_IF;
	
	//FVT1105 pid调节
	R_TRIG_9(CLK := EDTFVT1105.status.auto_mode);
	IF R_TRIG_9.Q THEN
		MTBasicsPID_12.Enable := TRUE;
	END_IF;
	F_TRIG_9(CLK := EDTFVT1105.status.auto_mode);
	IF F_TRIG_9.Q THEN
		MTBasicsPID_12.Enable := FALSE;
	END_IF;
	//	MTBasicsPID_12.Enable := TRUE;
	MTBasicsPID_12.PIDParameters.Gain := EDTPidFVT1105Para.gain;
	MTBasicsPID_12.PIDParameters.IntegrationTime := EDTPidFVT1105Para.integration_time;
	MTBasicsPID_12.PIDParameters.DerivativeTime := EDTPidFVT1105Para.derivative_time;
	MTBasicsPID_12.MinOut := 0.0;
	MTBasicsPID_12.MaxOut := 100.0;
	MTBasicsPID_12.SetValue := EDTPidFVT1105Para.set_value;
	MTBasicsPID_12.ActValue := EDTFIT1105.flowrate;
	MTBasicsPID_12.Update := EDTPidFVT1105.update;
	MTBasicsPID_12();
	EDTPidFVT1105.out := MTBasicsPID_12.Out;
	IF MTBasicsPID_12.Active THEN
		EDTFVT1105.input.auto_degree_set := MTBasicsPID_12.Out + EDTPidFVT1105Para.min_out;
		//	ELSE
		//		EDTFVT1105.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_12.UpdateDone THEN
		EDTPidFVT1105.update := FALSE;
	END_IF;
	

	//人工确认步骤可用
	IF (EDTP4S2C.status.run_state) AND (NOT EDTP4S2C_STEP[EDTP4S2C.status.run_step].done AND ((EDTP4S2C.status.run_step = 2) OR (EDTP4S2C.status.run_step = 4) OR (EDTP4S2C.status.run_step = 7)
		OR (EDTP4S2C.status.run_step = 9) OR (EDTP4S2C.status.run_step = 11) OR (p4_step2_5c_confirm_enable))) THEN
		EDTP4S2C.status.confirm_enable := TRUE;
	ELSE
		EDTP4S2C.status.confirm_enable := FALSE;
	END_IF;

END_ACTION
