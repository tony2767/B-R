
ACTION P3S1A_ACT: 
	//设定时间
	FOR i := 0 TO EDTP3S1_STEP_NUM DO
		IF EDTP3S1A_ST[i] < T#5s THEN
			EDTP3S1A_ST[i] := T#5s;
		END_IF;
		EDTP3S1A_STEP[i].set_time := EDTP3S1A_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP3S1A,EDTP3S1A_STEP[0],EDTP3S1_STEP_NUM);

	//object 手自动切换
	IF (EDTP3S1A.status.mode <> 0) AND (NOT EDTP3S1A.auto_mode_edge) THEN
		EDTP3S1A.auto_mode_edge := TRUE;
		EDTP3S1A.manual_mode_edge := FALSE;
		
		EDTR18A.control.auto_operate := TRUE;
		EDTTV0801C.control.auto_operate := TRUE;
		EDTTV0801E.control.auto_operate := TRUE;
		EDTTV0801D.control.auto_operate := TRUE;
		EDTTV0801B.control.auto_operate := TRUE;
		EDTTV0801A.control.auto_operate := TRUE;
		EDTXV0812.control.auto_operate := TRUE;
		EDTTVT0801.control.auto_operate := TRUE;
		EDTXV0817.control.auto_operate := TRUE;
		EDTXV2107.control.auto_operate := TRUE;
		EDTXV2113.control.auto_operate := TRUE;
		EDTXV2109.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP3S1A.status.mode = 0) AND (NOT EDTP3S1A.manual_mode_edge) THEN
		EDTP3S1A.manual_mode_edge := TRUE;
		EDTP3S1A.auto_mode_edge := FALSE;

		EDTR18A.control.manual_operate := TRUE;
		EDTTV0801C.control.manual_operate := TRUE;
		EDTTV0801E.control.manual_operate := TRUE;
		EDTTV0801D.control.manual_operate := TRUE;
		EDTTV0801B.control.manual_operate := TRUE;
		EDTTV0801A.control.manual_operate := TRUE;
		EDTXV0812.control.manual_operate := TRUE;
		EDTTVT0801.control.manual_operate := TRUE;
		EDTXV0817.control.manual_operate := TRUE;
		EDTXV2107.control.manual_operate := TRUE;
		EDTXV2113.control.manual_operate := TRUE;
		EDTXV2109.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP3S1A.input.error_signal := (EDTR18A.status.motor_status >= 2) OR (EDTTV0801C.status.valve_status >= 2) OR (EDTTV0801E.status.valve_status >= 2) OR 
	(EDTTV0801D.status.valve_status >= 2) OR(EDTTV0801B.status.valve_status >= 2) OR (EDTTV0801A.status.valve_status >= 2) OR (EDTXV0812.status.valve_status >= 2);

	IF EDTP3S1A.status.run_state = 1 THEN
		CASE EDTP3S1A.status.run_step OF 
			0:
				IF NOT EDTP3S1A_STEP[0].done THEN
					EDTR18A.control.auto_operate := TRUE;
					EDTTV0801C.control.auto_operate := TRUE;
					EDTTV0801E.control.auto_operate := TRUE;
					EDTTV0801D.control.auto_operate := TRUE;
					EDTTV0801B.control.auto_operate := TRUE;
					EDTTV0801A.control.auto_operate := TRUE;
					EDTXV0812.control.auto_operate := TRUE;
					EDTTVT0801.control.auto_operate := TRUE;
					EDTXV0817.control.auto_operate := TRUE;
					EDTXV2107.control.auto_operate := TRUE;
					EDTXV2113.control.auto_operate := TRUE;
					EDTXV2109.control.auto_operate := TRUE;
					IF EDTXV0801.input.close_feedback_state AND EDTXV0806.input.close_feedback_state AND EDTXV0804.input.close_feedback_state AND EDTFQV0801.input.close_feedback_state 
						AND EDTXV0814.input.close_feedback_state AND EDTXV0822.input.close_feedback_state AND EDTXV0817.input.close_feedback_state THEN
						EDTP3S1A_STEP[0].done := TRUE;	
					END_IF;
				END_IF;
			1:
				//醚化
				CASE p3_step1_1a OF
					0:
						IF NOT EDTP3S1A_STEP[1].done THEN
							p3_step1_1a := 1;
						END_IF;
					1:
						TON_0.IN := FALSE;
						TON_46.IN := FALSE;
						temp_decrease := FALSE;
						FOR i := 0 TO 50 DO
							EDTTIT0801_avg_record[i] := 0;
						END_FOR;	
						EDTTIT0801_avg := 0;
						n := 0;
						temp_offset := 0;
						offset := 0;
						EDTPIT0803_record[0] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
						EDTPIT0803_record[1] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
						EDTPIT0803_record[2] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
						EDTTIT0801_record[0] := REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100);
						EDTTIT0801_record[1] := REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100);
						EDTTIT0801_record[2] := REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100);
						EDTR18A.input.auto_run_signal := TRUE;
						IF EDTR18A.input.run_feedback THEN
							p3_step1_1a := 2;
						END_IF;
					2:
						TON_0.PT := DINT_TO_TIME(EDTP3S1_PARA_T2 * 1000);
						EDTTV0801E.input.auto_open_signal := TRUE;
						IF EDTTV0801E.input.open_feedback_state THEN
							EDTXV0812.input.auto_open_signal := TRUE;	
							TON_0.IN := TRUE;
						END_IF;
						IF TON_0.Q THEN
							TON_0.IN := FALSE;
							p3_step1_1a := 3;
						END_IF;
					3:
						//每两秒采集一个数据，连续采集3个，连续下降则判定值开始下降
						TON_0.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
						TON_0.IN := TRUE;
						IF TON_0.Q THEN
							TON_0.IN := FALSE;
							EDTPIT0803_record[offset] := REAL_TO_INT(EDTPIT0803.status.value * 100);
							offset := offset + 1;
						END_IF;
						IF offset > 2 THEN
							offset := 0;
						END_IF;
						IF (EDTPIT0803_record[0] > EDTPIT0803_record[1]) AND (EDTPIT0803_record[1] > EDTPIT0803_record[2]) THEN
							p3_step1_1a := 4;
						END_IF;
					4:
						IF EDTPIT0803.status.value <= EDTP3S1_PARA_P3 THEN
							EDTXV0812.input.auto_open_signal := FALSE;		
						END_IF;
						IF EDTPIT0803.status.value <= EDTP3S1_PARA_P4 THEN
							EDTTV0801E.input.auto_open_signal := FALSE;
							EDTTV0801D.input.auto_open_signal := TRUE;
							IF EDTTV0801D.input.open_feedback_state THEN
								EDTTV0801C.input.auto_open_signal := TRUE;
								EDTPid0801Para.set_value := EDTP3S1_PARA_Temp1;
								MTBasicsPID_0.Enable := TRUE;
								p3_step1_1a := 5;
							END_IF;
						END_IF;	
					5:
						//大于125℃计时5h
						TON_0.PT := DINT_TO_TIME(EDTP3S1_PARA_T3 * 60 * 1000);
						IF EDTTIT0801.status.value >= EDTP3S1_PARA_Temp2 THEN
							TON_0.IN := TRUE;
						END_IF;
						IF EDTTIT0801.status.value >= EDTP3S1_PARA_Temp1 THEN
							EDTTV0801C.input.auto_open_signal := FALSE;
							R18A_start := TRUE;
							p3_step1_1a := 6;
						END_IF;
					6:
						TON_0.PT := DINT_TO_TIME(EDTP3S1_PARA_T3 * 60 * 1000);
						IF TON_0.Q THEN
							TON_0.IN := FALSE;
							p3_step1_1a := 7;
						END_IF;
					7:
						//复位温控
						R18A_start := FALSE;
						temp_h_flag := FALSE;
						R18A_step_1 := 0;
						press_h_flag := FALSE;
						R18A_step_2 := 0;
						temp_l_flag := FALSE;
						R18A_step_3 := 0;
						
						EDTTV0801C.input.auto_open_signal := FALSE;
						EDTTV0801E.input.auto_open_signal := FALSE;
						EDTTV0801D.input.auto_open_signal := FALSE;
						EDTXV0812.input.auto_open_signal := FALSE;
						IF EDTTV0801C.input.close_feedback_state AND EDTTV0801E.input.close_feedback_state AND EDTTV0801D.input.close_feedback_state THEN
							p3_step1_1a := 8;
						END_IF;
					8:
						MTBasicsPID_0.Enable := FALSE;
						EDTTV0801A.input.auto_open_signal := TRUE;
						EDTTV0801B.input.auto_open_signal := TRUE;
						IF EDTTV0801A.input.open_feedback_state AND EDTTV0801B.input.open_feedback_state THEN
							p3_step1_1a := 9;
						END_IF;
					9:	
						IF EDTTIT0801.status.value <= EDTP3S1_PARA_Temp3 THEN
							EDTTV0801B.input.auto_open_signal := FALSE;
							EDTTV0801A.input.auto_open_signal := FALSE;
							EDTP3S1A_STEP[1].done := TRUE;
							p3_step1_1a := 0;
						END_IF;
				END_CASE;
				TON_0();
			2:
				IF NOT EDTP3S2C.status.run_state THEN
					EDTXV2109.input.auto_open_signal := FALSE;
					IF EDTXV2109.input.close_feedback_state THEN
						EDTXV0817.input.auto_open_signal := TRUE;
						EDTXV2107.input.auto_open_signal := TRUE;
						EDTXV2113.input.auto_open_signal := TRUE;
						IF EDTPIT0801.status.value <= EDTP3S1_PARA_P5 THEN
							EDTP3S1A_STEP[2].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			3:
				//人工转移
		END_CASE;			
	END_IF;

	//R18A控温、控压
	//=======================================================================================================
	IF R18A_start THEN
		//每两秒采集一个数据，连续采集3个，连续下降则判定为温度开始下降
		IF EDTP3S1_PARA_T1 >= 4 THEN
			EDTP3S1_PARA_T1 := 4;
		END_IF;
		IF EDTP3S1_PARA_T1 <= 1 THEN
			EDTP3S1_PARA_T1 := 1;
		END_IF;
		TON_46.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
		TON_46.IN := TRUE;
		EDTTIT0801_avg_record[n] := EDTTIT0801.status.value;
		n := n + 1;
		IF TON_46.Q THEN
			TON_46.IN := FALSE;
			FOR i := 0 TO n DO
				EDTTIT0801_avg := EDTTIT0801_avg_record[i] + EDTTIT0801_avg;
			END_FOR;
			EDTTIT0801_record[temp_offset] := REAL_TO_INT(EDTTIT0801_avg * 100 / n);
			FOR i := 0 TO 50 DO
				EDTTIT0801_avg_record[i] := 0;
			END_FOR;	
			EDTTIT0801_avg := 0;
			n := 0;
			//	EDTTIT0801_record[temp_offset] := REAL_TO_INT(EDTTIT0801.status.value * 100);
			temp_offset := temp_offset + 1;
		END_IF;
		IF temp_offset > 3 THEN
			temp_offset := 0;
		END_IF;
		IF (EDTTIT0801_record[0] > EDTTIT0801_record[1]) AND (EDTTIT0801_record[1] > EDTTIT0801_record[2]) AND
			(EDTTIT0801_record[0] <> REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100)) AND
			(EDTTIT0801_record[1] <> REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100)) AND
			(EDTTIT0801_record[2] <> REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100)) THEN
			temp_decrease := TRUE;
		ELSE
			temp_decrease := FALSE;
		END_IF;
		TON_46();
		
		IF EDTTIT0801.status.value >= EDTP3S1_PARA_Temp4 AND (NOT temp_h_flag) AND (R18A_step_2 = 0) AND (R18A_step_3 = 0) THEN
			R18A_step_1 := 1;
			temp_h_flag := TRUE;
		END_IF;
		IF EDTPIT0801.status.value >= EDTP3S1_PARA_P1 AND (NOT press_h_flag) AND (R18A_step_1 = 0) AND (R18A_step_3 = 0) THEN
			R18A_step_2 := 1;
			press_h_flag := TRUE;
		END_IF;
		IF (EDTTIT0801.status.value <= EDTP3S1_PARA_Temp5) AND (NOT temp_l_flag) AND (R18A_step_1 = 0) AND (R18A_step_2 = 0) THEN
			R18A_step_3 := 1;
			temp_l_flag := TRUE;
		END_IF;
	END_IF;
	
	
	//温度上限
	CASE R18A_step_1 OF
		0:
			//idle
		1:
			TON_25.IN := FALSE;
			EDTPIT0803_record[0] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
			EDTPIT0803_record[1] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
			EDTPIT0803_record[2] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
			EDTTIT0801_record[0] := REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100);
			EDTTIT0801_record[1] := REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100);
			EDTTIT0801_record[2] := REAL_TO_INT(EDTTIT0801_PARA.upper_range * 100);
			R18A_step_1 := 2;
		2:
			EDTTV0801E.input.auto_open_signal := TRUE;
			TON_25.PT := DINT_TO_TIME(EDTP3S1_PARA_T4 * 1000);
			TON_25.IN := TRUE;
			IF TON_25.Q THEN
				TON_25.IN := FALSE;
				R18A_step_1 := 3;
			END_IF;
		3:	
			EDTTV0801E.input.auto_open_signal := FALSE;
			EDTTV0801D.input.auto_open_signal := FALSE;
			R18A_step_1 := 4;
		4:
			EDTTV0801A.input.auto_open_signal := TRUE;
			IF EDTTV0801A.input.open_feedback_state THEN
				EDTTV0801B.input.auto_open_signal := TRUE;
			END_IF;
			IF EDTTV0801B.input.open_feedback_state AND EDTTV0801A.input.open_feedback_state THEN
				R18A_step_1 := 5;
			END_IF;
		5:
			//每两秒采集一个数据，连续采集3个，连续下降则判定为温度开始下降
			IF temp_decrease THEN
				R18A_step_1 := 6;
			END_IF;
		6:
			EDTTV0801B.input.auto_open_signal := FALSE;
			IF EDTTV0801B.input.close_feedback_state THEN
				EDTTV0801A.input.auto_open_signal := FALSE;
			END_IF;
			IF EDTTV0801A.input.close_feedback_state AND EDTTV0801B.input.close_feedback_state THEN
				R18A_step_1 := 7;
			END_IF;
		7:
			EDTTV0801E.input.auto_open_signal := TRUE;
			IF EDTTV0801E.input.open_feedback_state THEN
				EDTXV0812.input.auto_open_signal := TRUE;
				R18A_step_1 := 8;
			END_IF;
		8:
			TON_25.PT := DINT_TO_TIME(EDTP3S1_PARA_T2 * 1000);
			TON_25.IN := TRUE;
			IF TON_25.Q THEN
				TON_25.IN := FALSE;
				R18A_step_1 := 9;
			END_IF;
		9:
			//每两秒采集一个数据，连续采集3个，连续下降则判定值开始下降
			TON_25.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
			TON_25.IN := TRUE;
			IF TON_25.Q THEN
				TON_25.IN := FALSE;
				EDTPIT0803_record[offset] := REAL_TO_INT(EDTPIT0803.status.value * 100);
				offset := offset + 1;
			END_IF;
			IF offset > 2 THEN
				offset := 0;
			END_IF;
			IF (EDTPIT0803_record[0] > EDTPIT0803_record[1]) AND (EDTPIT0803_record[1] > EDTPIT0803_record[2]) THEN
				R18A_step_1 := 10;
			END_IF;
		10:
			IF EDTPIT0803.status.value <= EDTP3S1_PARA_P3 THEN
				EDTXV0812.input.auto_open_signal := FALSE;
				temp_h_flag := FALSE;
				R18A_step_1 := 0;
			END_IF;
	END_CASE;
	TON_25();
	
	//压力上限
	CASE R18A_step_2 OF
		0:
			//idle
		1:
			EDTPIT0803_record[0] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
			EDTPIT0803_record[1] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
			EDTPIT0803_record[2] := REAL_TO_INT(EDTPIT0803_PARA.upper_range * 100);
			TON_27.IN := FALSE;
			EDTTV0801E.input.auto_open_signal := FALSE;
			EDTTV0801D.input.auto_open_signal := FALSE;
			IF EDTTV0801E.input.close_feedback_state AND EDTTV0801D.input.close_feedback_state AND EDTTV0801C.input.close_feedback_state THEN
				R18A_step_2 := 2;
			END_IF;
		2:
			EDTTV0801A.input.auto_open_signal := TRUE;
			IF EDTTV0801A.input.open_feedback_state THEN
				EDTTV0801B.input.auto_open_signal := TRUE;
			END_IF;
			IF EDTTV0801B.input.open_feedback_state AND EDTTV0801A.input.open_feedback_state THEN
				R18A_step_2 := 3;
			END_IF;
		3:
			IF EDTPIT0801.status.value <= EDTP3S1_PARA_P2 THEN
				R18A_step_2 := 4;
			END_IF;
		4:
			EDTTV0801B.input.auto_open_signal := FALSE;
			IF EDTTV0801B.input.close_feedback_state THEN
				EDTTV0801A.input.auto_open_signal := FALSE;
			END_IF;
			IF EDTTV0801A.input.close_feedback_state AND EDTTV0801B.input.close_feedback_state THEN
				R18A_step_2 := 5;
			END_IF;
		5:
			EDTTV0801E.input.auto_open_signal := TRUE;
			IF EDTTV0801E.input.open_feedback_state THEN
				EDTXV0812.input.auto_open_signal := TRUE;
				R18A_step_2 := 6;
			END_IF;
		6:
			TON_27.PT := DINT_TO_TIME(EDTP3S1_PARA_T2 * 1000);
			TON_27.IN := TRUE;
			IF TON_27.Q THEN
				TON_27.IN := FALSE;
				R18A_step_2 := 7;
			END_IF;
		7:
			//每两秒采集一个数据，连续采集3个，连续下降则判定值开始下降
			TON_27.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
			TON_27.IN := TRUE;
			IF TON_27.Q THEN
				TON_27.IN := FALSE;
				EDTPIT0803_record[offset] := REAL_TO_INT(EDTPIT0803.status.value * 100);
				offset := offset + 1;
			END_IF;
			IF offset > 2 THEN
				offset := 0;
			END_IF;
			IF (EDTPIT0803_record[0] > EDTPIT0803_record[1]) AND (EDTPIT0803_record[1] > EDTPIT0803_record[2]) THEN
				R18A_step_2 := 8;
			END_IF;
		8:
			IF EDTPIT0803.status.value <= EDTP3S1_PARA_P3 THEN
				EDTXV0812.input.auto_open_signal := FALSE;
				press_h_flag := FALSE;
				R18A_step_2 := 0;	
			END_IF;
	END_CASE;
	TON_27();
	
	//温度低限
	CASE R18A_step_3 OF
		0:
			//idle
		1:
			EDTTV0801E.input.auto_open_signal := FALSE;
			EDTXV0812.input.auto_open_signal := FALSE;
			EDTTV0801C.input.auto_open_signal := TRUE;
			EDTTV0801D.input.auto_open_signal := TRUE;
			R18A_step_3 := 2;
		2:
			IF EDTTIT0801.status.value >= EDTP3S1_PARA_Temp1 THEN
				R18A_step_3 := 3;
			END_IF;
		3:
			EDTTV0801C.input.auto_open_signal := FALSE;
			EDTTV0801D.input.auto_open_signal := FALSE;
			EDTTV0801E.input.auto_open_signal := TRUE;
			R18A_step_3 := 4;
		4:
			temp_l_flag := FALSE;
			R18A_step_3 := 0;
	END_CASE;
	
	
	IF r20_transfer THEN
		CASE r20_transfer_step OF
			0:
				EDTXV2109.control.auto_operate := TRUE;
				EDTXV2107.control.auto_operate := TRUE;
				EDTXV2111.control.auto_operate := TRUE;
				r20_transfer_step := 1;
			1:
				EDTXV2109.input.auto_open_signal := TRUE;
				EDTXV2107.input.auto_open_signal := TRUE;
				EDTXV2111.input.auto_open_signal := TRUE;
				r20_transfer_step := 2;
			2:
				r20_transfer_step := 0;
				r20_transfer := FALSE;
		END_CASE;
	END_IF;
	IF r17_transfer THEN
		CASE r17_transfer_step OF
			0:
				EDTXV0925.control.auto_operate := TRUE;
				EDTXV0902.control.auto_operate := TRUE;
				EDTXV0912.control.auto_operate := TRUE;
				EDTTV0902B.control.auto_operate := TRUE;
				EDTTV0904B.control.auto_operate := TRUE;
				r17_transfer_step := 1;
			1:
				EDTXV0925.input.auto_open_signal := TRUE;
				EDTXV0902.input.auto_open_signal := TRUE;
				EDTXV0912.input.auto_open_signal := TRUE;
				EDTTV0902B.input.auto_open_signal := TRUE;
				EDTTV0904B.input.auto_open_signal := TRUE;
				r17_transfer_step := 2;
			2:
				r17_transfer_step := 0;
				r17_transfer := FALSE;
		END_CASE;
	END_IF;
	//=======================================================================================================
	//pid 温度调节
	
	R_TRIG_2(CLK := EDTTVT0801.status.auto_mode);
	IF R_TRIG_2.Q THEN
		MTBasicsPID_0.Enable := TRUE;
	END_IF;
	F_TRIG_2(CLK := EDTTVT0801.status.auto_mode);
	IF F_TRIG_2.Q THEN
		MTBasicsPID_0.Enable := FALSE;
	END_IF;
	
	//MTBasicsPID_0.Enable := TRUE;
	//MTBasicsPID_0.Invert := TRUE;
	MTBasicsPID_0.PIDParameters.Gain := EDTPid0801Para.gain;
	MTBasicsPID_0.PIDParameters.IntegrationTime := EDTPid0801Para.integration_time;
	MTBasicsPID_0.PIDParameters.DerivativeTime := EDTPid0801Para.derivative_time;
	MTBasicsPID_0.MinOut := 0.0;
	MTBasicsPID_0.MaxOut := 100.0;
	MTBasicsPID_0.SetValue := EDTPid0801Para.set_value;
	MTBasicsPID_0.ActValue := EDTTIT0801.status.value;
	MTBasicsPID_0.Update := EDTPid0801.update;
	MTBasicsPID_0();
	EDTPid0801.out := MTBasicsPID_0.Out;
	IF MTBasicsPID_0.Active THEN
		EDTTVT0801.input.auto_degree_set := MTBasicsPID_0.Out;
	ELSE
		EDTTVT0801.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_0.UpdateDone THEN
		EDTPid0801.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP3S1A.status.run_state) AND (NOT EDTP3S1A_STEP[EDTP3S1A.status.run_step].done AND ((EDTP3S1A.status.run_step = 3))) THEN
		EDTP3S1A.status.confirm_enable := TRUE;
	ELSE
		EDTP3S1A.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
