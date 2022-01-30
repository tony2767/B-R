
ACTION P3S1B_ACT: 
	//设定时间
	FOR i := 0 TO EDTP3S1_STEP_NUM DO
		IF EDTP3S1B_ST[i] < T#5s THEN
			EDTP3S1B_ST[i] := T#5s;
		END_IF;
		EDTP3S1B_STEP[i].set_time := EDTP3S1B_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP3S1B,EDTP3S1B_STEP[0],EDTP3S1_STEP_NUM);

	//object 手自动切换
	IF (EDTP3S1B.status.mode <> 0) AND (NOT EDTP3S1B.auto_mode_edge) THEN
		EDTP3S1B.auto_mode_edge := TRUE;
		EDTP3S1B.manual_mode_edge := FALSE;
		
		EDTR18B.control.auto_operate := TRUE;
		EDTTV0802C.control.auto_operate := TRUE;
		EDTTV0802E.control.auto_operate := TRUE;
		EDTTV0802D.control.auto_operate := TRUE;
		EDTTV0802B.control.auto_operate := TRUE;
		EDTTV0802A.control.auto_operate := TRUE;
		EDTXV0813.control.auto_operate := TRUE;
		EDTTVT0802.control.auto_operate := TRUE;
		EDTXV0818.control.auto_operate := TRUE;
		EDTXV0902.control.auto_operate := TRUE;
		EDTXV0912.control.auto_operate := TRUE;
		EDTTV0902A.control.auto_operate := TRUE;
		EDTTV0904A.control.auto_operate := TRUE;
		EDTXV2128.control.auto_operate := TRUE;
		EDTXV0925.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP3S1B.status.mode = 0) AND (NOT EDTP3S1B.manual_mode_edge) THEN
		EDTP3S1B.manual_mode_edge := TRUE;
		EDTP3S1B.auto_mode_edge := FALSE;

		EDTR18B.control.manual_operate := TRUE;
		EDTTV0802C.control.manual_operate := TRUE;
		EDTTV0802E.control.manual_operate := TRUE;
		EDTTV0802D.control.manual_operate := TRUE;
		EDTTV0802B.control.manual_operate := TRUE;
		EDTTV0802A.control.manual_operate := TRUE;
		EDTXV0813.control.manual_operate := TRUE;
		EDTTVT0802.control.manual_operate := TRUE;
		EDTXV0818.control.manual_operate := TRUE;
		EDTXV0902.control.manual_operate := TRUE;
		EDTXV0912.control.manual_operate := TRUE;
		EDTTV0902A.control.manual_operate := TRUE;
		EDTTV0904A.control.manual_operate := TRUE;
		EDTXV2128.control.manual_operate := TRUE;
		EDTXV0925.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP3S1B.input.error_signal := (EDTR18B.status.motor_status >= 2) OR (EDTTV0802C.status.valve_status >= 2) OR (EDTTV0802E.status.valve_status >= 2) OR 
	(EDTTV0802D.status.valve_status >= 2) OR(EDTTV0802B.status.valve_status >= 2) OR (EDTTV0802A.status.valve_status >= 2) OR (EDTXV0813.status.valve_status >= 2);

	IF EDTP3S1B.status.run_state = 1 THEN
		CASE EDTP3S1B.status.run_step OF 
			0:
				IF NOT EDTP3S1B_STEP[0].done THEN
					EDTR18B.control.auto_operate := TRUE;
					EDTTV0802C.control.auto_operate := TRUE;
					EDTTV0802E.control.auto_operate := TRUE;
					EDTTV0802D.control.auto_operate := TRUE;
					EDTTV0802B.control.auto_operate := TRUE;
					EDTTV0802A.control.auto_operate := TRUE;
					EDTXV0813.control.auto_operate := TRUE;
					EDTTVT0802.control.auto_operate := TRUE;
					EDTXV0818.control.auto_operate := TRUE;
					EDTXV0902.control.auto_operate := TRUE;
					EDTXV0912.control.auto_operate := TRUE;
					EDTTV0902A.control.auto_operate := TRUE;
					EDTTV0904A.control.auto_operate := TRUE;
					EDTXV2128.control.auto_operate := TRUE;
					EDTXV0925.control.auto_operate := TRUE;
					IF EDTXV0807.input.close_feedback_state AND EDTXV0818.input.close_feedback_state AND EDTXV0810.input.close_feedback_state AND EDTFQV0802.input.close_feedback_state 
						AND EDTXV0809.input.close_feedback_state AND EDTXV0815.input.close_feedback_state AND EDTXV0823.input.close_feedback_state THEN
						EDTP3S1B_STEP[0].done := TRUE;
					END_IF;
				END_IF;
			1:
				//醚化
				CASE p3_step1_1b OF
					0:
						IF NOT EDTP3S1B_STEP[1].done THEN
							p3_step1_1b := 1;
						END_IF;
					1:
						TON_52.IN := FALSE;
						TON_58.IN := FALSE;
						temp_decrease_0802 := FALSE;
						FOR i := 0 TO 50 DO
							EDTTIT0802_avg_record[i] := 0;
						END_FOR;	
						EDTTIT0802_avg := 0;
						m := 0;
						temp_offset_b := 0;
						offset_b := 0;
						EDTPIT0804_record[0] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
						EDTPIT0804_record[1] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
						EDTPIT0804_record[2] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
						EDTTIT0802_record[0] := REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100);
						EDTTIT0802_record[1] := REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100);
						EDTTIT0802_record[2] := REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100);
						EDTR18B.input.auto_run_signal := TRUE;
						IF EDTR18B.input.run_feedback THEN
							p3_step1_1b := 2;
						END_IF;
					2:
						TON_52.PT := DINT_TO_TIME(EDTP3S1_PARA_T2 * 1000);
						EDTTV0802E.input.auto_open_signal := TRUE;
						IF EDTTV0802E.input.open_feedback_state THEN
							EDTXV0813.input.auto_open_signal := TRUE;	
							TON_52.IN := TRUE;
						END_IF;
						IF TON_52.Q THEN
							TON_52.IN := FALSE;
							p3_step1_1b := 3;
						END_IF;
					3:
						//每两秒采集一个数据，连续采集3个，连续下降则判定值开始下降
						TON_52.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
						TON_52.IN := TRUE;
						IF TON_52.Q THEN
							TON_52.IN := FALSE;
							EDTPIT0804_record[offset_b] := REAL_TO_INT(EDTPIT0804.status.value * 100);
							offset_b := offset_b + 1;
						END_IF;
						IF offset_b > 2 THEN
							offset_b := 0;
						END_IF;
						IF (EDTPIT0804_record[0] > EDTPIT0804_record[1]) AND (EDTPIT0804_record[1] > EDTPIT0804_record[2]) THEN
							p3_step1_1b := 4;
						END_IF;
					4:
						IF EDTPIT0804.status.value <= EDTP3S1_PARA_P3 THEN
							EDTXV0813.input.auto_open_signal := FALSE;		
						END_IF;
						IF EDTPIT0804.status.value <= EDTP3S1_PARA_P4 THEN
							EDTTV0802E.input.auto_open_signal := FALSE;
							EDTTV0802D.input.auto_open_signal := TRUE;
							IF EDTTV0802D.input.open_feedback_state THEN
								EDTTV0802C.input.auto_open_signal := TRUE;
								EDTPid0802Para.set_value := EDTP3S1_PARA_Temp1;
								MTBasicsPID_7.Enable := TRUE;
								p3_step1_1b := 5;
							END_IF;
						END_IF;	
					5:
						//大于125℃计时5h
						TON_52.PT := DINT_TO_TIME(EDTP3S1_PARA_T3 * 60 * 1000);
						IF EDTTIT0802.status.value >= EDTP3S1_PARA_Temp2 THEN
							TON_52.IN := TRUE;
						END_IF;
						IF EDTTIT0802.status.value >= EDTP3S1_PARA_Temp1 THEN
							EDTTV0802C.input.auto_open_signal := FALSE;
							R18B_start := TRUE;
							p3_step1_1b := 6;
						END_IF;
					6:
						TON_52.PT := DINT_TO_TIME(EDTP3S1_PARA_T3 * 60 * 1000);
						IF TON_52.Q THEN
							TON_52.IN := FALSE;
							p3_step1_1b := 7;
						END_IF;
					7:
						//复位温控
						R18B_start := FALSE;
						temp_h_flag_b := FALSE;
						R18B_step_1 := 0;
						press_h_flag_b := FALSE;
						R18B_step_2 := 0;
						temp_l_flag_b := FALSE;
						R18B_step_3 := 0;
						
						EDTTV0802C.input.auto_open_signal := FALSE;
						EDTTV0802E.input.auto_open_signal := FALSE;
						EDTTV0802D.input.auto_open_signal := FALSE;
						EDTXV0813.input.auto_open_signal := FALSE;
						IF EDTTV0802C.input.close_feedback_state AND EDTTV0802E.input.close_feedback_state AND EDTTV0802D.input.close_feedback_state THEN
							p3_step1_1b := 8;
						END_IF;
					8:
						MTBasicsPID_7.Enable := FALSE;
						EDTTV0802A.input.auto_open_signal := TRUE;
						EDTTV0802B.input.auto_open_signal := TRUE;
						IF EDTTV0802A.input.open_feedback_state AND EDTTV0802B.input.open_feedback_state THEN
							p3_step1_1b := 9;
						END_IF;
					9:	
						IF EDTTIT0802.status.value <= EDTP3S1_PARA_Temp3 THEN
							EDTTV0802B.input.auto_open_signal := FALSE;
							EDTTV0802A.input.auto_open_signal := FALSE;
							EDTP3S1B_STEP[1].done := TRUE;
							p3_step1_1b := 0;
						END_IF;
				END_CASE;
				TON_52();
			2:
				IF (NOT EDTP3S2A.status.run_state) AND (NOT EDTP3S2B.status.run_state) THEN
					EDTXV0925.input.auto_open_signal := FALSE;
					IF EDTXV0925.input.close_feedback_state THEN
						EDTXV0818.input.auto_open_signal := TRUE;
						EDTXV0902.input.auto_open_signal := TRUE;
						EDTXV0912.input.auto_open_signal := TRUE;
						EDTTV0902A.input.auto_open_signal := TRUE;
						EDTTV0904A.input.auto_open_signal := TRUE;
						EDTXV2128.input.auto_open_signal := TRUE;
						IF EDTPIT0802.status.value <= EDTP3S1_PARA_P5 THEN
							EDTP3S1B_STEP[2].done := TRUE;
						END_IF;	
					END_IF;
				END_IF;
			3:
			//人工转移
		END_CASE;			
	END_IF;

	//R18B控温、控压
	//=======================================================================================================
	IF R18B_start THEN
		//每两秒采集一个数据，连续采集3个，连续下降则判定为温度开始下降
		IF EDTP3S1_PARA_T1 >= 4 THEN
			EDTP3S1_PARA_T1 := 4;
		END_IF;
		IF EDTP3S1_PARA_T1 <= 1 THEN
			EDTP3S1_PARA_T1 := 1;
		END_IF;
		TON_58.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
		TON_58.IN := TRUE;
		EDTTIT0802_avg_record[m] := EDTTIT0802.status.value;
		m := m + 1;
		IF TON_58.Q THEN
			TON_58.IN := FALSE;
			FOR i := 0 TO m DO
				EDTTIT0802_avg := EDTTIT0802_avg_record[i] + EDTTIT0802_avg;
			END_FOR;
			EDTTIT0802_record[temp_offset_b] := REAL_TO_INT(EDTTIT0802_avg * 100 / m);
			FOR i := 0 TO 50 DO
				EDTTIT0802_avg_record[i] := 0;
			END_FOR;	
			EDTTIT0802_avg := 0;
			m := 0;
			//	EDTTIT0802_record[temp_offset_b] := REAL_TO_INT(EDTTIT0802.status.value * 100);
			temp_offset_b := temp_offset_b + 1;
		END_IF;
		IF temp_offset_b > 3 THEN
			temp_offset_b := 0;
		END_IF;
		IF (EDTTIT0802_record[0] > EDTTIT0802_record[1]) AND (EDTTIT0802_record[1] > EDTTIT0802_record[2]) AND
			(EDTTIT0802_record[0] <> REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100)) AND
			(EDTTIT0802_record[1] <> REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100)) AND
			(EDTTIT0802_record[2] <> REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100)) THEN
			temp_decrease_0802 := TRUE;
		ELSE
			temp_decrease_0802 := FALSE;
		END_IF;
		TON_58();
		
		IF EDTTIT0802.status.value >= EDTP3S1_PARA_Temp4 AND (NOT temp_h_flag_b) AND (R18B_step_2 = 0) AND (R18B_step_3 = 0) THEN
			R18B_step_1 := 1;
			temp_h_flag_b := TRUE;
		END_IF;
		IF EDTPIT0802.status.value >= EDTP3S1_PARA_P1 AND (NOT press_h_flag_b) AND (R18B_step_1 = 0) AND (R18B_step_3 = 0) THEN
			R18B_step_2 := 1;
			press_h_flag_b := TRUE;
		END_IF;
		IF (EDTTIT0802.status.value <= EDTP3S1_PARA_Temp5) AND (NOT temp_l_flag_b) AND (R18B_step_1 = 0) AND (R18B_step_2 = 0) THEN
			R18B_step_3 := 1;
			temp_l_flag_b := TRUE;
		END_IF;
	END_IF;
	
	//温度上限
	CASE R18B_step_1 OF
		0:
			//idle
		1:
			TON_62.IN := FALSE;
			EDTPIT0804_record[0] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
			EDTPIT0804_record[1] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
			EDTPIT0804_record[2] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
			EDTTIT0802_record[0] := REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100);
			EDTTIT0802_record[1] := REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100);
			EDTTIT0802_record[2] := REAL_TO_INT(EDTTIT0802_PARA.upper_range * 100);
			R18B_step_1 := 2;
		2:
			EDTTV0802E.input.auto_open_signal := TRUE;
			TON_62.PT := DINT_TO_TIME(EDTP3S1_PARA_T4 * 1000);
			TON_62.IN := TRUE;
			IF TON_62.Q THEN
				TON_62.IN := FALSE;
				R18B_step_1 := 3;
			END_IF;
		3:	
			EDTTV0802E.input.auto_open_signal := FALSE;
			EDTTV0802D.input.auto_open_signal := FALSE;
			R18B_step_1 := 4;
		4:
			EDTTV0802A.input.auto_open_signal := TRUE;
			IF EDTTV0802A.input.open_feedback_state THEN
				EDTTV0802B.input.auto_open_signal := TRUE;
			END_IF;
			IF EDTTV0802B.input.open_feedback_state AND EDTTV0802A.input.open_feedback_state THEN
				R18B_step_1 := 5;
			END_IF;
		5:
			//每两秒采集一个数据，连续采集3个，连续下降则判定为温度开始下降
			IF temp_decrease_0802 THEN
				R18B_step_1 := 6;
			END_IF;
		6:
			EDTTV0802B.input.auto_open_signal := FALSE;
			IF EDTTV0802B.input.close_feedback_state THEN
				EDTTV0802A.input.auto_open_signal := FALSE;
			END_IF;
			IF EDTTV0802A.input.close_feedback_state AND EDTTV0802B.input.close_feedback_state THEN
				R18B_step_1 := 7;
			END_IF;
		7:
			EDTTV0802E.input.auto_open_signal := TRUE;
			IF EDTTV0802E.input.open_feedback_state THEN
				EDTXV0813.input.auto_open_signal := TRUE;
				R18B_step_1 := 8;
			END_IF;
		8:
			TON_62.PT := DINT_TO_TIME(EDTP3S1_PARA_T2 * 1000);
			TON_62.IN := TRUE;
			IF TON_62.Q THEN
				TON_62.IN := FALSE;
				R18B_step_1 := 9;
			END_IF;
		9:
			//每两秒采集一个数据，连续采集3个，连续下降则判定值开始下降
			TON_62.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
			TON_62.IN := TRUE;
			IF TON_62.Q THEN
				TON_62.IN := FALSE;
				EDTPIT0804_record[offset_b] := REAL_TO_INT(EDTPIT0804.status.value * 100);
				offset_b := offset_b + 1;
			END_IF;
			IF offset_b > 2 THEN
				offset_b := 0;
			END_IF;
			IF (EDTPIT0804_record[0] > EDTPIT0804_record[1]) AND (EDTPIT0804_record[1] > EDTPIT0804_record[2]) THEN
				R18B_step_1 := 10;
			END_IF;
		10:
			IF EDTPIT0804.status.value <= EDTP3S1_PARA_P3 THEN
				EDTXV0813.input.auto_open_signal := FALSE;
				temp_h_flag_b := FALSE;
				R18B_step_1 := 0;
			END_IF;
	END_CASE;
	TON_62();
	
	//压力上限
	CASE R18B_step_2 OF
		0:
			//idle
		1:
			EDTPIT0804_record[0] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
			EDTPIT0804_record[1] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
			EDTPIT0804_record[2] := REAL_TO_INT(EDTPIT0804_PARA.upper_range * 100);
			TON_65.IN := FALSE;
			EDTTV0802E.input.auto_open_signal := FALSE;
			EDTTV0802D.input.auto_open_signal := FALSE;
			IF EDTTV0802E.input.close_feedback_state AND EDTTV0802D.input.close_feedback_state AND EDTTV0802C.input.close_feedback_state THEN
				R18B_step_2 := 2;
			END_IF;
		2:
			EDTTV0802A.input.auto_open_signal := TRUE;
			IF EDTTV0802A.input.open_feedback_state THEN
				EDTTV0802B.input.auto_open_signal := TRUE;
			END_IF;
			IF EDTTV0802B.input.open_feedback_state AND EDTTV0802A.input.open_feedback_state THEN
				R18B_step_2 := 3;
			END_IF;
		3:
			IF EDTPIT0802.status.value <= EDTP3S1_PARA_P2 THEN
				R18B_step_2 := 4;
			END_IF;
		4:
			EDTTV0802B.input.auto_open_signal := FALSE;
			IF EDTTV0802B.input.close_feedback_state THEN
				EDTTV0802A.input.auto_open_signal := FALSE;
			END_IF;
			IF EDTTV0802A.input.close_feedback_state AND EDTTV0802B.input.close_feedback_state THEN
				R18B_step_2 := 5;
			END_IF;
		5:
			EDTTV0802E.input.auto_open_signal := TRUE;
			IF EDTTV0802E.input.open_feedback_state THEN
				EDTXV0813.input.auto_open_signal := TRUE;
				R18B_step_2 := 6;
			END_IF;
		6:
			TON_65.PT := DINT_TO_TIME(EDTP3S1_PARA_T2 * 1000);
			TON_65.IN := TRUE;
			IF TON_65.Q THEN
				TON_65.IN := FALSE;
				R18B_step_2 := 7;
			END_IF;
		7:
			//每两秒采集一个数据，连续采集3个，连续下降则判定值开始下降
			TON_65.PT := DINT_TO_TIME(EDTP3S1_PARA_T1 * 1000);
			TON_65.IN := TRUE;
			IF TON_65.Q THEN
				TON_65.IN := FALSE;
				EDTPIT0804_record[offset_b] := REAL_TO_INT(EDTPIT0804.status.value * 100);
				offset_b := offset_b + 1;
			END_IF;
			IF offset_b > 2 THEN
				offset_b := 0;
			END_IF;
			IF (EDTPIT0804_record[0] > EDTPIT0804_record[1]) AND (EDTPIT0804_record[1] > EDTPIT0804_record[2]) THEN
				R18B_step_2 := 8;
			END_IF;
		8:
			IF EDTPIT0804.status.value <= EDTP3S1_PARA_P3 THEN
				EDTXV0813.input.auto_open_signal := FALSE;
				press_h_flag_b := FALSE;
				R18B_step_2 := 0;	
			END_IF;
	END_CASE;
	TON_65();

	//温度低限
	CASE R18B_step_3 OF
		0:
			//idle
		1:
			EDTTV0802E.input.auto_open_signal := FALSE;
			EDTXV0813.input.auto_open_signal := FALSE;
			EDTTV0802C.input.auto_open_signal := TRUE;
			EDTTV0802D.input.auto_open_signal := TRUE;
			R18B_step_3 := 2;
		2:
			IF EDTTIT0802.status.value >= EDTP3S1_PARA_Temp1 THEN
				R18B_step_3 := 3;
			END_IF;
		3:
			EDTTV0802C.input.auto_open_signal := FALSE;
			EDTTV0802D.input.auto_open_signal := FALSE;
			EDTTV0802E.input.auto_open_signal := TRUE;
			R18B_step_3 := 4;
		4:
			temp_l_flag_b := FALSE;
			R18B_step_3 := 0;
	END_CASE;
	
	//=======================================================================================================
	//pid 温度调节
	R_TRIG_3(CLK := EDTTVT0802.status.auto_mode);
	IF R_TRIG_3.Q THEN
		MTBasicsPID_7.Enable := TRUE;
	END_IF;
	F_TRIG_3(CLK := EDTTVT0802.status.auto_mode);
	IF F_TRIG_3.Q THEN
		MTBasicsPID_7.Enable := FALSE;
	END_IF;
	
	//MTBasicsPID_7.Enable := TRUE;
	//MTBasicsPID_7.Invert := TRUE;
	MTBasicsPID_7.PIDParameters.Gain := EDTPid0802Para.gain;
	MTBasicsPID_7.PIDParameters.IntegrationTime := EDTPid0802Para.integration_time;
	MTBasicsPID_7.PIDParameters.DerivativeTime := EDTPid0802Para.derivative_time;
	MTBasicsPID_7.MinOut := 0.0;
	MTBasicsPID_7.MaxOut := 100.0;
	MTBasicsPID_7.SetValue := EDTPid0802Para.set_value;
	MTBasicsPID_7.ActValue := EDTTIT0802.status.value;
	MTBasicsPID_7.Update := EDTPid0802.update;
	MTBasicsPID_7();
	EDTPid0802.out := MTBasicsPID_7.Out;
	IF MTBasicsPID_7.Active THEN
		EDTTVT0802.input.auto_degree_set := MTBasicsPID_7.Out;
	ELSE
		EDTTVT0802.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_7.UpdateDone THEN
		EDTPid0802.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP3S1B.status.run_state) AND (NOT EDTP3S1B_STEP[EDTP3S1B.status.run_step].done AND ((EDTP3S1B.status.run_step = 3))) THEN
		EDTP3S1B.status.confirm_enable := TRUE;
	ELSE
		EDTP3S1B.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
