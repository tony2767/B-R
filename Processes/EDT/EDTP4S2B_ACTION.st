
ACTION P4S2B_ACT: 
		//设定时间
	FOR i := 0 TO EDTP4S2_STEP_NUM DO
		IF EDTP4S2B_ST[i] < T#5s THEN
			EDTP4S2B_ST[i] := T#5s;
		END_IF;
		EDTP4S2B_STEP[i].set_time := EDTP4S2B_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP4S2B,EDTP4S2B_STEP[0],EDTP4S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP4S2B.status.mode <> 0) AND (NOT EDTP4S2B.auto_mode_edge) THEN
		EDTP4S2B.auto_mode_edge := TRUE;
		EDTP4S2B.manual_mode_edge := FALSE;
		
		EDTXV1132.control.auto_operate := TRUE;
		EDTR10B.control.auto_operate := TRUE;
		EDTXV1124.control.auto_operate := TRUE;
		EDTXV1129.control.auto_operate := TRUE;
		EDTXV1136.control.auto_operate := TRUE;
		EDTXV1126.control.auto_operate := TRUE;
		EDTFVT1103.control.auto_operate := TRUE;
		EDTTV1104C.control.auto_operate := TRUE;
		EDTTV1104D.control.auto_operate := TRUE;
		EDTTV1104E.control.auto_operate := TRUE;
		EDTTV1104F.control.auto_operate := TRUE;
		EDTXV1127.control.auto_operate := TRUE;
		EDTTV1104A.control.auto_operate := TRUE;
		EDTTV1104B.control.auto_operate := TRUE;
		EDTXV1125.control.auto_operate := TRUE;
		EDTXV1128.control.auto_operate := TRUE;
		EDTTVT1106.control.auto_operate := TRUE;
		EDTFQV1101B.control.auto_operate := TRUE;
		EDTP15.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP4S2B.status.mode = 0) AND (NOT EDTP4S2B.manual_mode_edge) THEN
		EDTP4S2B.manual_mode_edge := TRUE;
		EDTP4S2B.auto_mode_edge := FALSE;
		
		EDTXV1132.control.manual_operate := TRUE;
		EDTR10B.control.manual_operate := TRUE;
		EDTXV1124.control.manual_operate := TRUE;
		EDTXV1129.control.manual_operate := TRUE;
		EDTXV1136.control.manual_operate := TRUE;
		EDTXV1126.control.manual_operate := TRUE;
		EDTFVT1103.control.manual_operate := TRUE;
		EDTTV1104C.control.manual_operate := TRUE;
		EDTTV1104D.control.manual_operate := TRUE;
		EDTTV1104E.control.manual_operate := TRUE;
		EDTTV1104F.control.manual_operate := TRUE;
		EDTXV1127.control.manual_operate := TRUE;
		EDTTV1104A.control.manual_operate := TRUE;
		EDTTV1104B.control.manual_operate := TRUE;
		EDTXV1125.control.manual_operate := TRUE;
		EDTXV1128.control.manual_operate := TRUE;
		EDTTVT1106.control.manual_operate := TRUE;
		EDTFQV1101B.control.manual_operate := TRUE;
		EDTP15.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP4S2B.input.error_signal :=
	(EDTXV1132.status.valve_status >= 2) OR
	(EDTR10B.status.motor_status >= 2) OR (EDTXV1124.status.valve_status >= 2) OR (EDTXV1129.status.valve_status >= 2) OR
	(EDTXV1136.status.valve_status >= 2) OR (EDTXV1126.status.valve_status >= 2) OR
	(EDTTV1104C.status.valve_status >= 2) OR (EDTTV1104D.status.valve_status >= 2) OR (EDTTV1104E.status.valve_status >= 2) OR
	(EDTTV1104F.status.valve_status >= 2) OR (EDTXV1127.status.valve_status >= 2) OR (EDTTV1104A.status.valve_status >= 2) OR
	(EDTTV1104B.status.valve_status >= 2) OR (EDTXV1125.status.valve_status >= 2) OR (EDTXV1128.status.valve_status >= 2) OR
	(EDTFQV1101B.status.valve_status >= 2) OR (EDTP15.status.motor_status >= 2);
	
	IF EDTP4S2B.status.run_state = 1 THEN
		CASE EDTP4S2B.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP4S2B_STEP[0].done THEN
					EDTXV1132.control.auto_operate := TRUE;
					EDTR10B.control.auto_operate := TRUE;
					EDTXV1124.control.auto_operate := TRUE;
					EDTXV1129.control.auto_operate := TRUE;
					EDTXV1136.control.auto_operate := TRUE;
					EDTXV1126.control.auto_operate := TRUE;
					EDTFVT1103.control.auto_operate := TRUE;
					EDTTV1104C.control.auto_operate := TRUE;
					EDTTV1104D.control.auto_operate := TRUE;
					EDTTV1104E.control.auto_operate := TRUE;
					EDTTV1104F.control.auto_operate := TRUE;
					EDTXV1127.control.auto_operate := TRUE;
					EDTTV1104A.control.auto_operate := TRUE;
					EDTTV1104B.control.auto_operate := TRUE;
					EDTXV1125.control.auto_operate := TRUE;
					EDTXV1128.control.auto_operate := TRUE;
					EDTTVT1106.control.auto_operate := TRUE;
					EDTFQV1101B.control.auto_operate := TRUE;
					EDTP15.control.auto_operate := TRUE;
					EDTP4S2B_STEP[0].done := TRUE;
				END_IF;
			1:
				//准备
				MTBasicsPID_5.Enable := FALSE;
				MTBasicsPID_11.Enable := FALSE;
				EDTXV1132.input.auto_open_signal := FALSE;
				EDTFVT1103.input.auto_degree_set := 100.0;
				EDTTVT1106.input.auto_degree_set := 100.0;
				EDTR10B.input.auto_run_signal := TRUE;
				EDTXV1136.input.auto_open_signal := TRUE;
				IF EDTXV1136.input.open_feedback_state THEN
					EDTXV1124.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1124.input.open_feedback_state THEN
					EDTXV1126.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1126.input.open_feedback_state THEN
					EDTXV1129.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTIT1104.status.value <= EDTP4S2_PARA_Temp4 THEN
					EDTTV1104A.input.auto_open_signal := FALSE;
					EDTTV1104B.input.auto_open_signal := FALSE;
					IF EDTR10B.input.run_feedback AND EDTXV1124.input.open_feedback_state AND EDTXV1129.input.open_feedback_state AND EDTTV1104A.input.close_feedback_state
						AND EDTTV1104B.input.close_feedback_state AND EDTXV1136.input.open_feedback_state AND EDTXV1126.input.open_feedback_state AND EDTXV1132.input.close_feedback_state 
						AND EDTXV1132.input.close_feedback_state THEN
						EDTP4S2B_STEP[1].done := TRUE;
					END_IF;
				ELSIF EDTTIT1104.status.value >=  (EDTP4S2_PARA_Temp4 + 1) THEN
					EDTTV1104A.input.auto_open_signal := TRUE;
					EDTTV1104B.input.auto_open_signal := TRUE;
				END_IF;
			2:
				//启动一级真空泵
			3:
				CASE p4_step2_3b OF
					0:
						IF NOT EDTP4S2B_STEP[3].done THEN
							p4_step2_3b := 1;
						END_IF;
					1:
						HeatPot_12(ST1 := DINT_TO_TIME(EDTP4S2_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP4S2_PARA_T2 * 1000),
						V3 := EDTTV1104C,
						V4 := EDTTV1104D,
						V5 := EDTTV1104E,
						V6 := EDTTV1104F,
						done := p4_step2_3b_1_done);
						IF p4_step2_3b_1_done THEN
							p4_step2_3b_1_done := FALSE;
							p4_step2_3b := 2;
						END_IF;
					2:
						IF EDTTIT1104.status.value >= EDTP4S2_PARA_Temp1 THEN
							EDTTV1104C.input.auto_open_signal := FALSE;
						END_IF;
						IF EDTTV1104C.input.close_feedback_state THEN
							p4_step2_3b := 3;
						END_IF;
					3:
						IF EDTTIT1104.status.value >= EDTP4S2_PARA_Temp2 THEN
							p4_step2_3b := 0;
							EDTP4S2B_STEP[3].done := TRUE;
						END_IF;
				END_CASE;
			4:
				//启动二三四级真空泵
			5:
				CASE p4_step2_5b OF
					0:
						IF NOT EDTP4S2B_STEP[5].done THEN
							p4_step2_5b := 1;
						END_IF;
					1:
						IF EDTTIT1105.status.value >= EDTP4S2_PARA_Temp5 THEN
							MTBasicsPID_5.Enable := TRUE;
							MTBasicsPID_11.Enable := FALSE;
							EDTFVT1103.input.auto_degree_set := 0.0;
							p4_step2_5b := 2;
						END_IF;
					2:
						TON_64.PT := DINT_TO_TIME(EDTP4S2_PARA_T3 * 60 * 1000);
						TON_64.IN := TRUE;
						IF TON_64.Q THEN
							TON_64.IN := FALSE;
							p4_step2_5b := 3;
						END_IF;
					3:
						MTBasicsPID_11.Enable := TRUE;
						p4_step2_5b := 4;
					4:
						TON_64.PT := DINT_TO_TIME(EDTP4S2_PARA_T4 * 3600 * 1000);
						TON_64.IN := TRUE;
						IF TON_64.Q THEN
							TON_64.IN := FALSE;
							p4_step2_5b_confirm_enable := TRUE;
							p4_step2_5b := 5;
						END_IF;
					5:
						IF EDTP4S2B_STEP[5].done THEN
							p4_step2_5b := 0;
							p4_step2_5b_confirm_enable := FALSE;
						END_IF;
				END_CASE;
				TON_64();
			6:
				EDTXV1136.input.auto_open_signal := FALSE;
				TON_13.PT := DINT_TO_TIME(EDTP4S2_PARA_T5 * 3600 * 1000);
				IF EDTXV1136.input.close_feedback_state THEN
					EDTXV1127.input.auto_open_signal := TRUE;
					IF EDTXV1127.input.open_feedback_state THEN
						TON_13.IN := TRUE;
					END_IF;
				END_IF;
				IF TON_13.Q THEN
					TON_13.IN := FALSE;
					EDTP4S2B_STEP[6].done := TRUE;
				END_IF;
				TON_13();
			7:
				//观察
			8:
				CASE p4_step2_7b OF
					0:
						IF NOT EDTP4S2B_STEP[8].done THEN
							p4_step2_7b := 1;
						END_IF;
					1:
						CoolPot_1(
							time := cool_pot_time,
							V1 := EDTTV1104A,
							V2 := EDTTV1104B,
							V3 := EDTTV1104F,
							V4 := EDTTV1104D,
							V5 := EDTTV1104E,
							done := p4_step2_7b_1_done);
						IF p4_step2_7b_1_done THEN
							p4_step2_7b_1_done := FALSE;
							p4_step2_7b := 2;
						END_IF;
					2:
						IF EDTTIT1104.status.value <= EDTP4S2_PARA_Temp3 THEN
							p4_step2_7b := 0;
							EDTP4S2B_STEP[8].done := TRUE;
						END_IF;
				END_CASE;
			9:
				//依次关闭四三二级真空泵
			10:
				MTBasicsPID_11.Enable := FALSE;
				EDTFVT1103.input.auto_degree_set := 100.0;
				EDTXV1125.input.auto_open_signal := TRUE;
				EDTXV1128.input.auto_open_signal := TRUE;
				IF EDTPIT1102.status.value >= EDTP4S2_PARA_P1 THEN
					EDTTV1104A.input.auto_open_signal := FALSE;
					EDTTV1104B.input.auto_open_signal := FALSE;
					IF EDTTV1104A.input.close_feedback_state AND EDTTV1104B.input.close_feedback_state THEN
						EDTP4S2B_STEP[10].done := TRUE;
					END_IF;
				END_IF;
			11:
				//关闭一级泵
			12:
				IF EDTPIT1102.status.value >= EDTP4S2_PARA_P2 THEN
					EDTXV1125.input.auto_open_signal := FALSE;
					EDTXV1128.input.auto_open_signal := FALSE;
					EDTP4S2B_STEP[12].done := TRUE;
				END_IF;
			13:
				MTBasicsPID_5.Enable := FALSE;
				EDTTVT1106.input.auto_degree_set := 100.0;
				EDTXV1127.input.auto_open_signal := FALSE;
				EDTXV1132.input.auto_open_signal := TRUE;
				IF EDTXV1127.input.close_feedback_state THEN
					EDTXV1136.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV1127.input.close_feedback_state AND EDTXV1132.input.open_feedback_state AND EDTXV1136.input.open_feedback_state THEN
					EDTP4S2B_STEP[13].done := TRUE;
				END_IF;
		END_CASE;			
	END_IF;
	
	//pid调节
	R_TRIG_6(CLK := EDTTVT1106.status.auto_mode);
	IF R_TRIG_6.Q THEN
		MTBasicsPID_5.Enable := TRUE;
	END_IF;
	F_TRIG_6(CLK := EDTTVT1106.status.auto_mode);
	IF F_TRIG_6.Q THEN
		MTBasicsPID_5.Enable := FALSE;
	END_IF;
	//	MTBasicsPID_5.Enable := TRUE;
	MTBasicsPID_5.Invert := TRUE;
	MTBasicsPID_5.PIDParameters.Gain := EDTPid1106Para.gain;
	MTBasicsPID_5.PIDParameters.IntegrationTime := EDTPid1106Para.integration_time;
	MTBasicsPID_5.PIDParameters.DerivativeTime := EDTPid1106Para.derivative_time;
	MTBasicsPID_5.MinOut := 0.0;
	MTBasicsPID_5.MaxOut := 100.0;
	MTBasicsPID_5.ActValue := EDTTIT1106.status.value;
	MTBasicsPID_5.SetValue := EDTPid1106Para.set_value;
	MTBasicsPID_5.Update := EDTPid1106.update;
	MTBasicsPID_5();
	EDTPid1106.out := MTBasicsPID_5.Out;
	IF MTBasicsPID_5.Active THEN
		EDTTVT1106.input.auto_degree_set := MTBasicsPID_5.Out;
		//	ELSE
		//		EDTTVT1106.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_5.UpdateDone THEN
		EDTPid1106.update := FALSE;
	END_IF;
	
	//FVT1103 pid调节
	R_TRIG_7(CLK := EDTFVT1103.status.auto_mode);
	IF R_TRIG_7.Q THEN
		MTBasicsPID_11.Enable := TRUE;
	END_IF;
	F_TRIG_7(CLK := EDTFVT1103.status.auto_mode);
	IF F_TRIG_7.Q THEN
		MTBasicsPID_11.Enable := FALSE;
	END_IF;
	//	MTBasicsPID_11.Enable := TRUE;
	MTBasicsPID_11.PIDParameters.Gain := EDTPidFVT1103Para.gain;
	MTBasicsPID_11.PIDParameters.IntegrationTime := EDTPidFVT1103Para.integration_time;
	MTBasicsPID_11.PIDParameters.DerivativeTime := EDTPidFVT1103Para.derivative_time;
	MTBasicsPID_11.MinOut := 0.0;
	MTBasicsPID_11.MaxOut := 100.0;
	MTBasicsPID_11.SetValue := EDTPidFVT1103Para.set_value;
	MTBasicsPID_11.ActValue := EDTFIT1103.flowrate;
	MTBasicsPID_11.Update := EDTPidFVT1103.update;
	MTBasicsPID_11();
	EDTPidFVT1103.out := MTBasicsPID_11.Out;
	IF MTBasicsPID_11.Active THEN
		EDTFVT1103.input.auto_degree_set := MTBasicsPID_11.Out + EDTPidFVT1103Para.min_out;
		//	ELSE
		//		EDTFVT1103.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_11.UpdateDone THEN
		EDTPidFVT1103.update := FALSE;
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP4S2B.status.run_state) AND (NOT EDTP4S2B_STEP[EDTP4S2B.status.run_step].done AND ((EDTP4S2B.status.run_step = 2) OR (EDTP4S2B.status.run_step = 4) OR (EDTP4S2B.status.run_step = 7)
		OR (EDTP4S2B.status.run_step = 9) OR (EDTP4S2B.status.run_step = 11) OR (p4_step2_5b_confirm_enable))) THEN
		EDTP4S2B.status.confirm_enable := TRUE;
	ELSE
		EDTP4S2B.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
