
ACTION P5S2_ACT: 
	//设定时间
	FOR i := 0 TO EDTP5S2_STEP_NUM DO
		IF EDTP5S2_ST[i] < T#5s THEN
			EDTP5S2_ST[i] := T#5s;
		END_IF;
		EDTP5S2_STEP[i].set_time := EDTP5S2_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP5S2,EDTP5S2_STEP[0],EDTP5S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP5S2.status.mode <> 0) AND (NOT EDTP5S2.auto_mode_edge) THEN
		EDTP5S2.auto_mode_edge := TRUE;
		EDTP5S2.manual_mode_edge := FALSE;

		EDTFQV1801C.control.auto_operate := TRUE;
		EDTXV1702.control.auto_operate := TRUE;
		EDTFQV1801A.control.auto_operate := TRUE;
		EDTXV1806.control.auto_operate := TRUE;
		EDTXV1807.control.auto_operate := TRUE;
		EDTXV1809.control.auto_operate := TRUE;
		EDTXV1813.control.auto_operate := TRUE;
		EDTFVT1802.control.auto_operate := TRUE;
		EDTR15.control.auto_operate := TRUE;
		EDTTV1801C.control.auto_operate := TRUE;
		EDTTV1801D.control.auto_operate := TRUE;
		EDTTV1801E.control.auto_operate := TRUE;
		EDTTV1801F.control.auto_operate := TRUE;
		EDTXV1812.control.auto_operate := TRUE;
		EDTTV1801A.control.auto_operate := TRUE;
		EDTTV1801B.control.auto_operate := TRUE;
		EDTXV1808.control.auto_operate := TRUE;
		EDTXV1814.control.auto_operate := TRUE;
		EDTTVT1803.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP5S2.status.mode = 0) AND (NOT EDTP5S2.manual_mode_edge) THEN
		EDTP5S2.manual_mode_edge := TRUE;
		EDTP5S2.auto_mode_edge := FALSE;

		EDTFQV1801C.control.manual_operate := TRUE;
		EDTXV1702.control.manual_operate := TRUE;
		EDTFQV1801A.control.manual_operate := TRUE;
		EDTXV1806.control.manual_operate := TRUE;
		EDTXV1807.control.manual_operate := TRUE;
		EDTXV1809.control.manual_operate := TRUE;
		EDTXV1813.control.manual_operate := TRUE;
		EDTFVT1802.control.manual_operate := TRUE;
		EDTR15.control.manual_operate := TRUE;
		EDTTV1801C.control.manual_operate := TRUE;
		EDTTV1801D.control.manual_operate := TRUE;
		EDTTV1801E.control.manual_operate := TRUE;
		EDTTV1801F.control.manual_operate := TRUE;
		EDTXV1812.control.manual_operate := TRUE;
		EDTTV1801A.control.manual_operate := TRUE;
		EDTTV1801B.control.manual_operate := TRUE;
		EDTXV1808.control.manual_operate := TRUE;
		EDTXV1814.control.manual_operate := TRUE;
		EDTTVT1803.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP5S2.input.error_signal := (EDTFQV1801C.status.valve_status >= 2) OR (EDTXV1702.status.valve_status >= 2) OR (EDTFQV1801A.status.valve_status >= 2) OR 
	(EDTXV1806.status.valve_status >= 2) OR (EDTXV1807.status.valve_status >= 2) OR (EDTXV1809.status.valve_status >= 2) OR (EDTXV1813.status.valve_status >= 2) OR
	(EDTR15.status.motor_status >= 2) OR (EDTTV1801C.status.valve_status >= 2) OR (EDTTV1801D.status.valve_status >= 2) OR (EDTTV1801E.status.valve_status >= 2) OR 
	(EDTTV1801F.status.valve_status >= 2) OR (EDTXV1812.status.valve_status >= 2) OR (EDTTV1801A.status.valve_status >= 2) OR (EDTTV1801B.status.valve_status >= 2) OR 
	(EDTXV1808.status.valve_status >= 2) OR (EDTXV1814.status.valve_status >= 2);
	
	IF EDTP5S2.status.run_state = 1 THEN
		CASE EDTP5S2.status.run_step OF 
			0:
				IF NOT EDTP5S2_STEP[0].done THEN
					EDTFQV1801C.control.auto_operate := TRUE;
					EDTXV1702.control.auto_operate := TRUE;
					EDTFQV1801A.control.auto_operate := TRUE;
					EDTXV1806.control.auto_operate := TRUE;
					EDTXV1807.control.auto_operate := TRUE;
					EDTXV1809.control.auto_operate := TRUE;
					EDTXV1813.control.auto_operate := TRUE;
					EDTFVT1802.control.auto_operate := TRUE;
					EDTR15.control.auto_operate := TRUE;
					EDTTV1801C.control.auto_operate := TRUE;
					EDTTV1801D.control.auto_operate := TRUE;
					EDTTV1801E.control.auto_operate := TRUE;
					EDTTV1801F.control.auto_operate := TRUE;
					EDTXV1812.control.auto_operate := TRUE;
					EDTTV1801A.control.auto_operate := TRUE;
					EDTTV1801B.control.auto_operate := TRUE;
					EDTXV1808.control.auto_operate := TRUE;
					EDTXV1814.control.auto_operate := TRUE;
					EDTTVT1803.control.auto_operate := TRUE;
					EDTP5S2_STEP[0].done := TRUE;
				END_IF;
			1:
				//启动真空机组一级泵
			2:
				//启动进料
				EDTFQV1801C.input.auto_open_signal := TRUE;
				EDTFQV1801A.input.auto_open_signal := TRUE;
				IF EDTFQV1801A.input.open_feedback_state AND EDTFQV1801C.input.open_feedback_state THEN
					EDTXV1702.input.auto_open_signal := TRUE;
					EDTP5S2_STEP[2].done := TRUE;
				END_IF;
			3:
				//进料完毕确认
			4:
				//进料结束
				EDTXV1702.input.auto_open_signal := FALSE;
				EDTFQV1801A.input.auto_open_signal := FALSE;
				EDTFQV1801C.input.auto_open_signal := FALSE;
				IF EDTFQV1801A.input.close_feedback_state AND EDTFQV1801C.input.close_feedback_state THEN
					EDTP5S2_STEP[4].done := TRUE;
				END_IF;
			5:
				//准备升温
				EDTXV1806.input.auto_open_signal := TRUE;
				EDTXV1807.input.auto_open_signal := TRUE;
				EDTXV1809.input.auto_open_signal := TRUE;
				EDTXV1813.input.auto_open_signal := TRUE;
				MTBasicsPID_4.Enable := FALSE;
				EDTFVT1802.input.auto_degree_set := EDTP5S2_PARA_O1;
				EDTR15.input.auto_run_signal := TRUE;
				IF EDTXV1806.input.open_feedback_state AND EDTXV1807.input.open_feedback_state AND EDTXV1809.input.open_feedback_state AND EDTXV1813.input.open_feedback_state THEN
					EDTP5S2_STEP[5].done := TRUE;
				END_IF;
			6:
				//启动真空机组P19二三四级
			7:
				//升温
				CASE p5_step2_7 OF
					0:
						IF NOT EDTP5S2_STEP[7].done THEN
							p5_step2_7 := 1;
						END_IF;
					1:	
						HeatPot_9(ST1 := DINT_TO_TIME(EDTP5S2_PARA_T3 * 1000),
						ST2 := DINT_TO_TIME(EDTP5S2_PARA_T4 * 1000),
						V3 := EDTTV1801C,
						V4 := EDTTV1801D,
						V5 := EDTTV1801E,
						V6 := EDTTV1801F,
						done := p5_step2_7_done);
						IF p5_step2_7_done THEN
							p5_step2_7 := 2;
						END_IF;
					2:
						IF EDTTIT1801.status.value >= EDTP5S2_PARA_Temp1 THEN
							EDTTV1801C.input.auto_open_signal := FALSE;
							p5_step2_7 := 3;
						END_IF;
					3:
						IF EDTTV1801C.input.close_feedback_state THEN
							p5_step2_7 := 4;
						END_IF;
					4:
						p5_step2_7_done := FALSE;
						EDTP5S2_STEP[7].done := TRUE;
						p5_step2_7 := 0;
				END_CASE;
			8:
				//全回流
				CASE p5_step2_8 OF
					0:
						IF NOT EDTP5S2_STEP[8].done THEN
							p5_step2_8 := 1;
						END_IF;
					1:
						IF EDTTIT1802.status.value >= EDTP5S2_PARA_Temp2 THEN
							EDTXV1806.input.auto_open_signal := FALSE;
							MTBasicsPID_4.Enable := FALSE;
							EDTFVT1802.input.auto_degree_set := EDTP5S2_PARA_O2;
							p5_step2_8 := 2;
						END_IF;
					2:
						IF EDTXV1806.input.close_feedback_state THEN
							p5_step2_8 := 3;
						END_IF;
					3:
						TON_81.PT := DINT_TO_TIME(EDTP5S2_PARA_T5 * 60 * 1000);
						TON_81.IN := TRUE;
						IF TON_81.Q THEN
							TON_81.IN := FALSE;
							EDTP5S2_STEP[8].done := TRUE;
							p5_step2_8 := 0;
						END_IF;
				END_CASE;
				TON_81();
			9:
				//出前馏
				EDTXV1806.input.auto_open_signal := TRUE;
				MTBasicsPID_4.Enable := TRUE;
//				EDTFVT1802.input.auto_degree_set := EDTP5S2_PARA_O3;
				TON_82.PT := DINT_TO_TIME(EDTP5S2_PARA_T6 * 60 * 1000);
				IF EDTXV1806.input.open_feedback_state THEN
					TON_82.IN := TRUE;
				END_IF;
				IF TON_82.Q THEN
					TON_82.IN := FALSE;
					EDTP5S2_STEP[9].done := TRUE;	
				END_IF;
				TON_82();
			10:
				//取样
			11:
				//全回流
				EDTXV1806.input.auto_open_signal := FALSE;
				MTBasicsPID_4.Enable := FALSE;
				EDTFVT1802.input.auto_degree_set := EDTP5S2_PARA_O4;
			12:
				//出成品
				EDTXV1812.input.auto_open_signal := TRUE;
				MTBasicsPID_4.Enable := TRUE;
//				EDTFVT1802.input.auto_degree_set := EDTP5S2_PARA_O5;
				IF EDTXV1812.input.open_feedback_state THEN
					EDTP5S2_STEP[12].done := TRUE;
				END_IF;
			13:
				//观察釜液位
			14:
				//停止加热
				EDTTV1801D.input.auto_open_signal := FALSE;
				EDTTV1801E.input.auto_open_signal := FALSE;
				IF EDTFIT1802.flowrate < EDTP5S2_PARA_F1 AND EDTTV1801D.input.close_feedback_state AND EDTTV1801E.input.close_feedback_state THEN
					EDTP5S2_STEP[14].done := TRUE;
				END_IF;
			15:
				//关闭真空泵
			16:
				//降温
				IF EDTTIT1801.status.value <= EDTP5S2_PARA_Temp3 THEN
					EDTTV1801A.input.auto_open_signal := FALSE;
					EDTTV1801B.input.auto_open_signal := FALSE;
					IF EDTTV1801A.input.close_feedback_state AND EDTTV1801B.input.close_feedback_state THEN
						EDTP5S2_STEP[16].done := TRUE;	
					END_IF;
				ELSIF NOT EDTP5S2_STEP[16].done THEN
					EDTTV1801A.input.auto_open_signal := TRUE;
					EDTTV1801B.input.auto_open_signal := TRUE;
				END_IF;
			17:
				//破真空
				IF EDTPIT1801.status.value >= EDTP5S2_PARA_P1 THEN
					EDTXV1807.input.auto_open_signal := FALSE;
					EDTXV1808.input.auto_open_signal := FALSE;
					EDTXV1809.input.auto_open_signal := FALSE;
					EDTXV1813.input.auto_open_signal := FALSE;
					EDTXV1814.input.auto_open_signal := FALSE;
					EDTXV1812.input.auto_open_signal := FALSE;
					EDTP5S2_STEP[17].done := TRUE;
				ELSIF NOT EDTP5S2_STEP[17].done THEN
					EDTXV1808.input.auto_open_signal := TRUE;
					EDTXV1814.input.auto_open_signal := TRUE;
				END_IF;
			18:
				//复原
				MTBasicsPID_4.Enable := FALSE;
				EDTFVT1802.input.auto_degree_set := 0.0;
				EDTR15.input.auto_run_signal := FALSE;
				EDTP5S2_STEP[18].done := TRUE;
		END_CASE;		
	END_IF;
	
	//TVT1803 pid调节
	R_TRIG_13(CLK := EDTTVT1803.status.auto_mode);
	IF R_TRIG_13.Q THEN
		MTBasicsPID_3.Enable := TRUE;
	END_IF;
	F_TRIG_13(CLK := EDTTVT1803.status.auto_mode);
	IF F_TRIG_13.Q THEN
		MTBasicsPID_3.Enable := FALSE;
	END_IF;
	//MTBasicsPID_3.Enable := TRUE;
	MTBasicsPID_3.Invert := TRUE;
	MTBasicsPID_3.PIDParameters.Gain := EDTPid1803Para.gain;
	MTBasicsPID_3.PIDParameters.IntegrationTime := EDTPid1803Para.integration_time;
	MTBasicsPID_3.PIDParameters.DerivativeTime := EDTPid1803Para.derivative_time;
	MTBasicsPID_3.MinOut := 0.0;
	MTBasicsPID_3.MaxOut := 100.0;
	MTBasicsPID_3.SetValue := EDTPid1803Para.set_value;
	MTBasicsPID_3.ActValue := EDTTIT1803.status.value;
	MTBasicsPID_3.Update := EDTPid1803.update;
	MTBasicsPID_3();
	EDTPid1803.out := MTBasicsPID_3.Out;
	IF MTBasicsPID_3.Active THEN
		EDTTVT1803.input.auto_degree_set := MTBasicsPID_3.Out;
	ELSE
		EDTTVT1803.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_3.UpdateDone THEN
		EDTPid1803.update := FALSE;
	END_IF;
	
	//FVT1802 pid调节
	MTBasicsPID_4.PIDParameters.Gain := EDTPid1802Para.gain;
	MTBasicsPID_4.PIDParameters.IntegrationTime := EDTPid1802Para.integration_time;
	MTBasicsPID_4.PIDParameters.DerivativeTime := EDTPid1802Para.derivative_time;
	MTBasicsPID_4.MinOut := 0.0;
	MTBasicsPID_4.MaxOut := 100.0;
	MTBasicsPID_4.SetValue := EDTPid1802Para.set_value;
	MTBasicsPID_4.ActValue := EDTFQIT1803.flowrate_volume;
	MTBasicsPID_4.Update := EDTPid1802.update;
	MTBasicsPID_4();
	EDTPid1802.out := MTBasicsPID_4.Out;
	IF MTBasicsPID_4.Active THEN
		EDTFVT1802.input.auto_degree_set := MTBasicsPID_4.Out + EDTPid1802Para.min_out;
		//	ELSE
		//		EDTFVT1802.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_4.UpdateDone THEN
		EDTPid1802.update := FALSE;
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP5S2.status.run_state) AND (NOT EDTP5S2_STEP[EDTP5S2.status.run_step].done AND ((EDTP5S2.status.run_step = 1) OR  (EDTP5S2.status.run_step = 3) OR (EDTP5S2.status.run_step = 6) OR (EDTP5S2.status.run_step = 10) OR 
		(EDTP5S2.status.run_step = 11) OR (EDTP5S2.status.run_step = 13) OR (EDTP5S2.status.run_step = 15))) THEN
		EDTP5S2.status.confirm_enable := TRUE;
	ELSE
		EDTP5S2.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
