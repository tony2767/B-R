
ACTION P4S1C_ACT: 
	//设定时间
	FOR i := 0 TO EDTP4S1_STEP_NUM DO
		IF EDTP4S1C_ST[i] < T#5s THEN
			EDTP4S1C_ST[i] := T#5s;
		END_IF;
		EDTP4S1C_STEP[i].set_time := EDTP4S1C_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP4S1C,EDTP4S1C_STEP[0],EDTP4S1_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP4S1C.status.mode <> 0) AND (NOT EDTP4S1C.auto_mode_edge) THEN
		EDTP4S1C.auto_mode_edge := TRUE;
		EDTP4S1C.manual_mode_edge := FALSE;
	
		EDTXV1011.control.auto_operate := TRUE;
		EDTXV1022.control.auto_operate := TRUE;
		EDTP16.control.auto_operate := TRUE;
		EDTLV1002.control.auto_operate := TRUE;
		STFP06.control.auto_operate := TRUE;
		STFLV0602.control.auto_operate := TRUE;
		STFLV0601.control.auto_operate := TRUE;
		EDTLV1003.control.auto_operate := TRUE;
		EDTFQV1001C.control.auto_operate := TRUE;
		EDTTV1006B.control.auto_operate := TRUE;
		EDTXV1023.control.auto_operate := TRUE;
		EDTXV1018.control.auto_operate := TRUE;
		EDTTV1005A.control.auto_operate := TRUE;
		EDTTV1005B.control.auto_operate := TRUE;
		EDTTV1006A.control.auto_operate := TRUE;
		EDTXV1020.control.auto_operate := TRUE;
		EDTR04C.control.auto_operate := TRUE;
		EDTLV1004C.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP4S1C.status.mode = 0) AND (NOT EDTP4S1C.manual_mode_edge) THEN
		EDTP4S1C.manual_mode_edge := TRUE;
		EDTP4S1C.auto_mode_edge := FALSE;
		
		EDTXV1011.control.manual_operate := TRUE;
		EDTXV1022.control.manual_operate := TRUE;
		EDTP16.control.manual_operate := TRUE;
		EDTLV1002.control.manual_operate := TRUE;
		STFP06.control.manual_operate := TRUE;
		STFLV0602.control.manual_operate := TRUE;
		STFLV0601.control.manual_operate := TRUE;
		EDTLV1003.control.manual_operate := TRUE;
		EDTFQV1001C.control.manual_operate := TRUE;
		EDTTV1006B.control.manual_operate := TRUE;
		EDTXV1023.control.manual_operate := TRUE;
		EDTXV1018.control.manual_operate := TRUE;
		EDTTV1005A.control.manual_operate := TRUE;
		EDTTV1005B.control.manual_operate := TRUE;
		EDTTV1006A.control.manual_operate := TRUE;
		EDTXV1020.control.manual_operate := TRUE;
		EDTR04C.control.manual_operate := TRUE;
		EDTLV1004C.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP4S1C.input.error_signal := (EDTXV1011.status.valve_status >= 2) OR
	(EDTXV1022.status.valve_status >= 2) OR (EDTP16.status.motor_status >= 2) OR
	(EDTLV1002.status.valve_status >= 2) OR (STFP06.status.motor_status >= 2) OR (STFLV0602.status.valve_status >= 2) OR
	(STFLV0601.status.valve_status >= 2) OR (EDTLV1003.status.valve_status >= 2) OR (EDTFQV1001C.status.valve_status >= 2) OR
	(EDTTV1006B.status.valve_status >= 2) OR (EDTXV1023.status.valve_status >= 2) OR
	(EDTXV1018.status.valve_status >= 2) OR (EDTTV1005A.status.valve_status >= 2) OR (EDTTV1005B.status.valve_status >= 2) OR
	(EDTTV1006A.status.valve_status >= 2) OR (EDTR04C.status.motor_status >= 2) OR (EDTXV1020.status.valve_status >= 2);
	
	//EDTLV1004C自动补水
	//	IF EDTTIT1005.status.value >= EDTP4S1C_PARA_Temp7 THEN
	//		EDTLV1004C.input.auto_open_signal := TRUE;
	//	ELSIF EDTTIT1005.status.value <= (EDTP4S1C_PARA_Temp7 - EDTP4S1C_PARA_Temp8) THEN
	//		EDTLV1004C.input.auto_open_signal := FALSE;
	//	END_IF;
	IF r04c_water THEN
		CASE r04c_water_step OF
			0:
				EDTLV1004C.control.auto_operate := TRUE;
				r04c_water_step := 1;
			1:
				EDTLV1004C.input.auto_open_signal := TRUE;
				r04c_temp := EDTTIT1005.status.value;
				r04c_water_step := 2;
			2:
				IF r04c_temp - EDTTIT1005.status.value >= EDTP4S1C_PARA_Temp8 THEN
					EDTLV1004C.input.auto_open_signal := FALSE;
					r04c_water_step := 0;
					r04c_water := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	IF EDTP4S1C.status.run_state = 1 THEN
		CASE EDTP4S1C.status.run_step OF 
			0:	
				IF NOT EDTP4S1C_STEP[0].done THEN
					EDTXV1011.control.auto_operate := TRUE;
					EDTXV1022.control.auto_operate := TRUE;
					EDTP16.control.auto_operate := TRUE;
					EDTLV1002.control.auto_operate := TRUE;
					STFP06.control.auto_operate := TRUE;
					STFLV0602.control.auto_operate := TRUE;
					STFLV0601.control.auto_operate := TRUE;
					EDTLV1003.control.auto_operate := TRUE;
					EDTFQV1001C.control.auto_operate := TRUE;
					EDTTV1006B.control.auto_operate := TRUE;
					EDTXV1023.control.auto_operate := TRUE;
					EDTXV1018.control.auto_operate := TRUE;
					EDTTV1005A.control.auto_operate := TRUE;
					EDTTV1005B.control.auto_operate := TRUE;
					EDTTV1006A.control.auto_operate := TRUE;
					EDTXV1020.control.auto_operate := TRUE;
					EDTR04C.control.auto_operate := TRUE;
					EDTLV1004C.control.auto_operate := TRUE;
					EDTP4S1C_STEP[0].done := TRUE;
				END_IF;
			1:
				//手动进DMSO和纯水
			2:
				EDTTV1005A.input.auto_open_signal := TRUE;
				EDTTV1005B.input.auto_open_signal := TRUE;
				EDTXV1023.input.auto_open_signal := TRUE;
				EDTXV1018.input.auto_open_signal := TRUE;
				EDTR04C.input.auto_run_signal := TRUE;
				EDTTV1006B.input.auto_open_signal := TRUE;
				EDTXV1020.input.auto_open_signal := TRUE;
				IF EDTXV1023.input.open_feedback_state AND EDTXV1018.input.open_feedback_state AND EDTR04C.input.run_feedback 
					AND EDTTV1006B.input.open_feedback_state AND EDTXV1020.input.open_feedback_state THEN
					EDTP4S1C_STEP[2].done := TRUE;
				END_IF;
			3:
				CASE p4_step1_3c OF
					0:
						IF NOT EDTP4S1C_STEP[3].done THEN
							p4_step1_3c := 1;
						END_IF;
					1:
						R04C_heat := TRUE;
						p4_step1_3c := 2;
					2:
						IF EDTTIT1005.status.value >= EDTP4S1C_PARA_Temp1 THEN
							EDTTV1006B.input.auto_open_signal := FALSE;	
							IF EDTTV1006B.input.close_feedback_state THEN
								EDTTV1006A.input.auto_open_signal := TRUE;
								IF EDTTV1006A.input.open_feedback_state THEN
									p4_step1_3c := 3;
								END_IF;
							END_IF;
						END_IF;
					3:
						TON_77.PT := DINT_TO_TIME(EDTP4S1C_PARA_T4 * 3600 * 1000);
						IF EDTTIT1005.status.value >= EDTP4S1C_PARA_Temp2 THEN
							R04C_heat := FALSE;
							R04C_hold := TRUE;
							TON_77.IN := TRUE;
						END_IF;
						IF TON_77.Q THEN
							TON_77.IN := FALSE;
							p4_step1_3c := 4;
						END_IF;
					4:
						p4_step1_3c := 0;
						EDTP4S1C_STEP[3].done := TRUE;
				END_CASE;
				TON_77();
			4:
				//人工取样,确认反应结束
			5:
				R04C_hold := FALSE;
				EDTTV1005A.input.auto_open_signal := FALSE;
				EDTTV1005B.input.auto_open_signal := FALSE;
				IF EDTTV1005A.input.close_feedback_state AND EDTTV1005B.input.close_feedback_state THEN
					EDTP4S1C_STEP[5].done := TRUE;
				END_IF;
			6:
				IF EDTTIT1005.status.value <= EDTP4S1C_PARA_Temp5 THEN
					//					EDTXV1023.input.auto_open_signal := FALSE;
					//					EDTXV1018.input.auto_open_signal := FALSE;
					EDTTV1006A.input.auto_open_signal := FALSE;
				END_IF;
				IF (*EDTXV1023.input.close_feedback_state AND EDTXV1018.input.close_feedback_state AND *)(NOT EDTR04C.input.run_feedback) 
					AND EDTTV1006A.input.close_feedback_state THEN
					EDTP4S1C_STEP[6].done := TRUE;
				END_IF;
			7:
				//转移
			8:
				EDTR04C.input.auto_run_signal := FALSE;
				IF NOT EDTR04C.input.run_feedback THEN
					EDTP4S1C_STEP[8].done := TRUE;
				END_IF;
		END_CASE;			
	END_IF;
	
	Slope_2(value := EDTTIT1005.status.value, sample_time := EDTP4S1C_PARA_T5);
	
	IF R04C_heat THEN
		IF Slope_2.out <= EDTP4S1C_PARA_Slope1 THEN
			EDTTV1005A.input.auto_open_signal := TRUE;
			EDTTV1005B.input.auto_open_signal := TRUE;
		END_IF;
		IF Slope_2.out > EDTP4S1C_PARA_Slope1 AND Slope_2.out <= EDTP4S1C_PARA_Slope2 THEN
			EDTTV1005A.input.auto_open_signal := TRUE;
			EDTTV1005B.input.auto_open_signal := FALSE;
		END_IF;	
		IF Slope_2.out > EDTP4S1C_PARA_Slope2 AND Slope_2.out <= EDTP4S1C_PARA_Slope3 THEN
			EDTTV1005A.input.auto_open_signal := FALSE;
			EDTTV1005B.input.auto_open_signal := TRUE;
		END_IF;
		IF Slope_2.out > EDTP4S1C_PARA_Slope3 THEN
			EDTTV1005A.input.auto_open_signal := FALSE;
			EDTTV1005B.input.auto_open_signal := FALSE;
		END_IF;
	END_IF;
	
	//155-158 大  158-162小阀 162都关
	IF R04C_hold THEN
		IF EDTTIT1005.status.value < EDTP4S1C_PARA_Temp2 THEN
			EDTTV1005A.input.auto_open_signal := TRUE;
			EDTTV1005B.input.auto_open_signal := TRUE;
		END_IF;
		IF EDTTIT1005.status.value < EDTP4S1C_PARA_Temp3 AND EDTTIT1005.status.value >= (EDTP4S1C_PARA_Temp2 + EDTP4S1C_PARA_Temp6) THEN
			EDTTV1005A.input.auto_open_signal := TRUE;
			EDTTV1005B.input.auto_open_signal := FALSE;
		END_IF;
		IF EDTTIT1005.status.value < EDTP4S1C_PARA_Temp4 AND EDTTIT1005.status.value >= (EDTP4S1C_PARA_Temp3 + EDTP4S1C_PARA_Temp6) THEN
			EDTTV1005A.input.auto_open_signal := FALSE;
			EDTTV1005B.input.auto_open_signal := TRUE;
		END_IF;
		IF EDTTIT1005.status.value >= (EDTP4S1C_PARA_Temp4 + EDTP4S1C_PARA_Temp6) THEN
			EDTTV1005A.input.auto_open_signal := FALSE;
			EDTTV1005B.input.auto_open_signal := FALSE;
		END_IF;
	END_IF;
	
	//======================================================================================================
	//DMSO进料
	//从罐区进料
	IF pot_to_r04_c THEN
		CASE pot_to_r04_c_step OF
			0:
				EDTFQV1001C.input.auto_open_signal := TRUE;
				EDTLV1003.input.auto_open_signal := TRUE;
				STFLV0601.input.auto_open_signal := FALSE;
				STFLV0602.input.auto_open_signal := FALSE;
				IF EDTFQV1001C.input.open_feedback_state AND EDTLV1003.input.open_feedback_state AND
					STFLV0601.input.close_feedback_state AND STFLV0602.input.close_feedback_state THEN
					pot_to_r04_c_step := 1;
				END_IF;
			1:
				LiquidTransfer_30(sp_time := DINT_TO_TIME(EDTP4S1C_PARA_T2 * 1000),
				sp_accumulation := EDTP4S1C_PARA_AC1,
				done := pot_to_r04_c_step_1_done,
				flowmeter := EDTFQIT1001);
				STFP06.input.auto_run_signal := LiquidTransfer_30.run;
				IF pot_to_r04_c_step_1_done AND (NOT STFP06.input.run_feedback) AND (NOT STFP06.input.auto_run_signal) THEN
					pot_to_r04_c_step_1_done := FALSE;
					pot_to_r04_c_step := 2;
				END_IF;
			2:
				IF EDTFQIT1001.flowrate <= flowrate_threshold THEN
					pot_to_r04_c_step := 3;
				END_IF;
			3:
				EDTFQV1001C.input.auto_open_signal := FALSE;
				EDTLV1003.input.auto_open_signal := FALSE;
				IF EDTFQV1001C.input.close_feedback_state AND EDTLV1003.input.close_feedback_state THEN
					pot_to_r04_c_step := 0;
					pot_to_r04_c := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	
	//从V52进料
	IF v52_to_r04_c THEN
		CASE v52_to_r04_c_step OF
			0:
				EDTFQV1001C.input.auto_open_signal := TRUE;
				EDTLV1002.input.auto_open_signal := TRUE;
				IF EDTFQV1001C.input.open_feedback_state AND EDTLV1002.input.open_feedback_state THEN
					v52_to_r04_c_step := 1;
				END_IF;
			1:
				LiquidTransfer_31(sp_time := DINT_TO_TIME(EDTP4S1C_PARA_T3 * 1000),
				sp_accumulation := EDTP4S1C_PARA_AC2,
				done := v52_to_r04_c_step_1_done,
				flowmeter := EDTFQIT1001);
				EDTP16.input.auto_run_signal := LiquidTransfer_31.run;
				IF v52_to_r04_c_step_1_done AND (NOT EDTP16.input.run_feedback) AND (NOT EDTP16.input.auto_run_signal) THEN
					v52_to_r04_c_step_1_done := FALSE;
					v52_to_r04_c_step := 2;
				END_IF;
			2:
				IF EDTFQIT1001.flowrate <= flowrate_threshold THEN
					v52_to_r04_c_step := 3;
				END_IF;
			3:
				EDTFQV1001C.input.auto_open_signal := FALSE;
				EDTLV1002.input.auto_open_signal := FALSE;
				IF EDTFQV1001C.input.close_feedback_state AND EDTLV1002.input.close_feedback_state THEN
					v52_to_r04_c_step := 0;
					v52_to_r04_c := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	

	//=======================================================================================================
	//人工确认步骤可用
	IF (EDTP4S1C.status.run_state) AND (NOT EDTP4S1C_STEP[EDTP4S1C.status.run_step].done AND ((EDTP4S1C.status.run_step = 1) OR (EDTP4S1C.status.run_step = 4) OR (EDTP4S1C.status.run_step = 7))) THEN
		EDTP4S1C.status.confirm_enable := TRUE;
	ELSE
		EDTP4S1C.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
