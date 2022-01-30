
ACTION P4S1D_ACT: 
	//设定时间
	FOR i := 0 TO EDTP4S1_STEP_NUM DO
		IF EDTP4S1D_ST[i] < T#5s THEN
			EDTP4S1D_ST[i] := T#5s;
		END_IF;
		EDTP4S1D_STEP[i].set_time := EDTP4S1D_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP4S1D,EDTP4S1D_STEP[0],EDTP4S1_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP4S1D.status.mode <> 0) AND (NOT EDTP4S1D.auto_mode_edge) THEN
		EDTP4S1D.auto_mode_edge := TRUE;
		EDTP4S1D.manual_mode_edge := FALSE;
	
		EDTXV1011.control.auto_operate := TRUE;
		EDTXV1022.control.auto_operate := TRUE;
		EDTP16.control.auto_operate := TRUE;
		EDTLV1002.control.auto_operate := TRUE;
		STFP06.control.auto_operate := TRUE;
		STFLV0602.control.auto_operate := TRUE;
		STFLV0601.control.auto_operate := TRUE;
		EDTLV1003.control.auto_operate := TRUE;
		EDTFQV1001D.control.auto_operate := TRUE;
		EDTTV1008B.control.auto_operate := TRUE;
		EDTXV1024.control.auto_operate := TRUE;
		EDTXV1019.control.auto_operate := TRUE;
		EDTTV1007A.control.auto_operate := TRUE;
		EDTTV1007B.control.auto_operate := TRUE;
		EDTTV1008A.control.auto_operate := TRUE;
		EDTXV1021.control.auto_operate := TRUE;
		EDTR04D.control.auto_operate := TRUE;
		EDTLV1004D.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP4S1D.status.mode = 0) AND (NOT EDTP4S1D.manual_mode_edge) THEN
		EDTP4S1D.manual_mode_edge := TRUE;
		EDTP4S1D.auto_mode_edge := FALSE;
		
		EDTXV1011.control.manual_operate := TRUE;
		EDTXV1022.control.manual_operate := TRUE;
		EDTP16.control.manual_operate := TRUE;
		EDTLV1002.control.manual_operate := TRUE;
		STFP06.control.manual_operate := TRUE;
		STFLV0602.control.manual_operate := TRUE;
		STFLV0601.control.manual_operate := TRUE;
		EDTLV1003.control.manual_operate := TRUE;
		EDTFQV1001D.control.manual_operate := TRUE;
		EDTTV1008B.control.manual_operate := TRUE;
		EDTXV1024.control.manual_operate := TRUE;
		EDTXV1019.control.manual_operate := TRUE;
		EDTTV1007A.control.manual_operate := TRUE;
		EDTTV1007B.control.manual_operate := TRUE;
		EDTTV1008A.control.manual_operate := TRUE;
		EDTXV1021.control.manual_operate := TRUE;
		EDTR04D.control.manual_operate := TRUE;
		EDTLV1004D.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP4S1D.input.error_signal := (EDTXV1011.status.valve_status >= 2) OR
	(EDTXV1022.status.valve_status >= 2) OR (EDTP16.status.motor_status >= 2) OR
	(EDTLV1002.status.valve_status >= 2) OR (STFP06.status.motor_status >= 2) OR (STFLV0602.status.valve_status >= 2) OR
	(STFLV0601.status.valve_status >= 2) OR (EDTLV1003.status.valve_status >= 2) OR (EDTFQV1001D.status.valve_status >= 2) OR
	(EDTTV1008B.status.valve_status >= 2) OR (EDTXV1024.status.valve_status >= 2) OR
	(EDTXV1019.status.valve_status >= 2) OR (EDTTV1007A.status.valve_status >= 2) OR (EDTTV1007B.status.valve_status >= 2) OR
	(EDTTV1008A.status.valve_status >= 2) OR (EDTR04D.status.motor_status >= 2) OR (EDTXV1021.status.valve_status >= 2);
	
	//EDTLV1004D自动补水
	//	IF EDTTIT1007.status.value >= EDTP4S1D_PARA_Temp7 THEN
	//		EDTLV1004D.input.auto_open_signal := TRUE;
	//	ELSIF EDTTIT1007.status.value <= (EDTP4S1D_PARA_Temp7 - EDTP4S1D_PARA_Temp8) THEN
	//		EDTLV1004D.input.auto_open_signal := FALSE;
	//	END_IF;
	IF r04d_water THEN
		CASE r04d_water_step OF
			0:
				EDTLV1004D.control.auto_operate := TRUE;
				r04d_water_step := 1;
			1:
				EDTLV1004D.input.auto_open_signal := TRUE;
				r04d_temp := EDTTIT1007.status.value;
				r04d_water_step := 2;
			2:
				IF r04d_temp - EDTTIT1007.status.value >= EDTP4S1D_PARA_Temp8 THEN
					EDTLV1004D.input.auto_open_signal := FALSE;
					r04d_water_step := 0;
					r04d_water := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	IF EDTP4S1D.status.run_state = 1 THEN
		CASE EDTP4S1D.status.run_step OF 
			0:	
				IF NOT EDTP4S1D_STEP[0].done THEN
					EDTXV1011.control.auto_operate := TRUE;
					EDTXV1022.control.auto_operate := TRUE;
					EDTP16.control.auto_operate := TRUE;
					EDTLV1002.control.auto_operate := TRUE;
					STFP06.control.auto_operate := TRUE;
					STFLV0602.control.auto_operate := TRUE;
					STFLV0601.control.auto_operate := TRUE;
					EDTLV1003.control.auto_operate := TRUE;
					EDTFQV1001D.control.auto_operate := TRUE;
					EDTTV1008B.control.auto_operate := TRUE;
					EDTXV1024.control.auto_operate := TRUE;
					EDTXV1019.control.auto_operate := TRUE;
					EDTTV1007A.control.auto_operate := TRUE;
					EDTTV1007B.control.auto_operate := TRUE;
					EDTTV1008A.control.auto_operate := TRUE;
					EDTXV1021.control.auto_operate := TRUE;
					EDTR04D.control.auto_operate := TRUE;
					EDTLV1004D.control.auto_operate := TRUE;
					EDTP4S1D_STEP[0].done := TRUE;
				END_IF;
			1:
				//手动进DMSO和纯水
			2:
				EDTTV1007A.input.auto_open_signal := TRUE;
				EDTTV1007B.input.auto_open_signal := TRUE;
				EDTXV1024.input.auto_open_signal := TRUE;
				EDTXV1019.input.auto_open_signal := TRUE;
				EDTR04D.input.auto_run_signal := TRUE;
				EDTTV1008B.input.auto_open_signal := TRUE;
				EDTXV1021.input.auto_open_signal := TRUE;
				IF EDTXV1024.input.open_feedback_state AND EDTXV1019.input.open_feedback_state AND EDTR04D.input.run_feedback 
					AND EDTTV1008B.input.open_feedback_state AND EDTXV1021.input.open_feedback_state THEN
					EDTP4S1D_STEP[2].done := TRUE;
				END_IF;
			3:
				CASE p4_step1_3d OF
					0:
						IF NOT EDTP4S1D_STEP[3].done THEN
							p4_step1_3d := 1;
						END_IF;
					1:
						R04D_heat := TRUE;
						p4_step1_3d := 2;
					2:
						IF EDTTIT1007.status.value >= EDTP4S1D_PARA_Temp1 THEN
							EDTTV1008B.input.auto_open_signal := FALSE;	
							IF EDTTV1008B.input.close_feedback_state THEN
								EDTTV1008A.input.auto_open_signal := TRUE;
								IF EDTTV1008A.input.open_feedback_state THEN
									p4_step1_3d := 3;
								END_IF;
							END_IF;
						END_IF;
					3:
						TON_79.PT := DINT_TO_TIME(EDTP4S1D_PARA_T4 * 3600 * 1000);
						IF EDTTIT1007.status.value >= EDTP4S1D_PARA_Temp2 THEN
							R04D_heat := FALSE;
							R04D_hold := TRUE;
							TON_79.IN := TRUE;
						END_IF;
						IF TON_79.Q THEN
							TON_79.IN := FALSE;
							p4_step1_3d := 4;
						END_IF;
					4:
						p4_step1_3d := 0;
						EDTP4S1D_STEP[3].done := TRUE;
				END_CASE;
				TON_79();
			4:
				//人工取样,确认反应结束
			5:
				R04D_hold := FALSE;
				EDTTV1007A.input.auto_open_signal := FALSE;
				EDTTV1007B.input.auto_open_signal := FALSE;
				IF EDTTV1007A.input.close_feedback_state AND EDTTV1007B.input.close_feedback_state THEN
					EDTP4S1D_STEP[5].done := TRUE;
				END_IF;
			6:
				IF EDTTIT1007.status.value <= EDTP4S1D_PARA_Temp5 THEN
					//					EDTXV1024.input.auto_open_signal := FALSE;
					//					EDTXV1019.input.auto_open_signal := FALSE;
					EDTTV1008A.input.auto_open_signal := FALSE;
				END_IF;
				IF (*EDTXV1024.input.close_feedback_state AND EDTXV1019.input.close_feedback_state AND *)(NOT EDTR04D.input.run_feedback) 
					AND EDTTV1008A.input.close_feedback_state THEN
					EDTP4S1D_STEP[6].done := TRUE;
				END_IF;
			7:
				//转移
			8:
				EDTR04D.input.auto_run_signal := FALSE;
				IF NOT EDTR04D.input.run_feedback THEN
					EDTP4S1D_STEP[8].done := TRUE;
				END_IF;
		END_CASE;			
	END_IF;
	
	Slope_3(value := EDTTIT1007.status.value, sample_time := EDTP4S1D_PARA_T5);
	
	IF R04D_heat THEN
		IF Slope_3.out <= EDTP4S1D_PARA_Slope1 THEN
			EDTTV1007A.input.auto_open_signal := TRUE;
			EDTTV1007B.input.auto_open_signal := TRUE;
		END_IF;
		IF Slope_3.out > EDTP4S1D_PARA_Slope1 AND Slope_3.out <= EDTP4S1D_PARA_Slope2 THEN
			EDTTV1007A.input.auto_open_signal := TRUE;
			EDTTV1007B.input.auto_open_signal := FALSE;
		END_IF;	
		IF Slope_3.out > EDTP4S1D_PARA_Slope2 AND Slope_3.out <= EDTP4S1D_PARA_Slope3 THEN
			EDTTV1007A.input.auto_open_signal := FALSE;
			EDTTV1007B.input.auto_open_signal := TRUE;
		END_IF;
		IF Slope_3.out > EDTP4S1D_PARA_Slope3 THEN
			EDTTV1007A.input.auto_open_signal := FALSE;
			EDTTV1007B.input.auto_open_signal := FALSE;
		END_IF;
	END_IF;
	
	//155-158 大  158-162小阀 162都关
	IF R04D_hold THEN
		IF EDTTIT1007.status.value < EDTP4S1D_PARA_Temp2 THEN
			EDTTV1007A.input.auto_open_signal := TRUE;
			EDTTV1007B.input.auto_open_signal := TRUE;
		END_IF;
		IF EDTTIT1007.status.value < EDTP4S1D_PARA_Temp3 AND EDTTIT1007.status.value >= (EDTP4S1D_PARA_Temp2 + EDTP4S1D_PARA_Temp6) THEN
			EDTTV1007A.input.auto_open_signal := TRUE;
			EDTTV1007B.input.auto_open_signal := FALSE;
		END_IF;
		IF EDTTIT1007.status.value < EDTP4S1D_PARA_Temp4 AND EDTTIT1007.status.value >= (EDTP4S1D_PARA_Temp3 + EDTP4S1D_PARA_Temp6) THEN
			EDTTV1007A.input.auto_open_signal := FALSE;
			EDTTV1007B.input.auto_open_signal := TRUE;
		END_IF;
		IF EDTTIT1007.status.value >= (EDTP4S1D_PARA_Temp4 + EDTP4S1D_PARA_Temp6) THEN
			EDTTV1007A.input.auto_open_signal := FALSE;
			EDTTV1007B.input.auto_open_signal := FALSE;
		END_IF;
	END_IF;
	
	//======================================================================================================
	//DMSO进料
	//从罐区进料
	IF pot_to_r04_d THEN
		CASE pot_to_r04_d_step OF
			0:
				EDTFQV1001D.input.auto_open_signal := TRUE;
				EDTLV1003.input.auto_open_signal := TRUE;
				STFLV0601.input.auto_open_signal := FALSE;
				STFLV0602.input.auto_open_signal := FALSE;
				IF EDTFQV1001D.input.open_feedback_state AND EDTLV1003.input.open_feedback_state AND
					STFLV0601.input.close_feedback_state AND STFLV0602.input.close_feedback_state THEN
					pot_to_r04_d_step := 1;
				END_IF;
			1:
				LiquidTransfer_32(sp_time := DINT_TO_TIME(EDTP4S1D_PARA_T2 * 1000),
				sp_accumulation := EDTP4S1D_PARA_AC1,
				done := pot_to_r04_d_step_1_done,
				flowmeter := EDTFQIT1001);
				STFP06.input.auto_run_signal := LiquidTransfer_32.run;
				IF pot_to_r04_d_step_1_done AND (NOT STFP06.input.run_feedback) AND (NOT STFP06.input.auto_run_signal) THEN
					pot_to_r04_d_step_1_done := FALSE;
					pot_to_r04_d_step := 2;
				END_IF;
			2:
				IF EDTFQIT1001.flowrate <= flowrate_threshold THEN
					pot_to_r04_d_step := 3;
				END_IF;
			3:
				EDTFQV1001D.input.auto_open_signal := FALSE;
				EDTLV1003.input.auto_open_signal := FALSE;
				IF EDTFQV1001D.input.close_feedback_state AND EDTLV1003.input.close_feedback_state THEN
					pot_to_r04_d_step := 0;
					pot_to_r04_d := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	
	//从V52进料
	IF v52_to_r04_d THEN
		CASE v52_to_r04_d_step OF
			0:
				EDTFQV1001D.input.auto_open_signal := TRUE;
				EDTLV1002.input.auto_open_signal := TRUE;
				IF EDTFQV1001D.input.open_feedback_state AND EDTLV1002.input.open_feedback_state THEN
					v52_to_r04_d_step := 1;
				END_IF;
			1:
				LiquidTransfer_33(sp_time := DINT_TO_TIME(EDTP4S1D_PARA_T3 * 1000),
				sp_accumulation := EDTP4S1D_PARA_AC2,
				done := v52_to_r04_d_step_1_done,
				flowmeter := EDTFQIT1001);
				EDTP16.input.auto_run_signal := LiquidTransfer_33.run;
				IF v52_to_r04_d_step_1_done AND (NOT EDTP16.input.run_feedback) AND (NOT EDTP16.input.auto_run_signal) THEN
					v52_to_r04_d_step_1_done := FALSE;
					v52_to_r04_d_step := 2;
				END_IF;
			2:
				IF EDTFQIT1001.flowrate <= flowrate_threshold THEN
					v52_to_r04_d_step := 3;
				END_IF;
			3:
				EDTFQV1001D.input.auto_open_signal := FALSE;
				EDTLV1002.input.auto_open_signal := FALSE;
				IF EDTFQV1001D.input.close_feedback_state AND EDTLV1002.input.close_feedback_state THEN
					v52_to_r04_d_step := 0;
					v52_to_r04_d := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	

	//=======================================================================================================
	//人工确认步骤可用
	IF (EDTP4S1D.status.run_state) AND (NOT EDTP4S1D_STEP[EDTP4S1D.status.run_step].done AND ((EDTP4S1D.status.run_step = 1) OR (EDTP4S1D.status.run_step = 4) OR (EDTP4S1D.status.run_step = 7))) THEN
		EDTP4S1D.status.confirm_enable := TRUE;
	ELSE
		EDTP4S1D.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
