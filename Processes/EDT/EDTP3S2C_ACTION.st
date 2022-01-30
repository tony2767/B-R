
ACTION P3S2C_ACT: 
	//设定时间
	FOR i := 0 TO EDTP3S2_STEP_NUM DO
		IF EDTP3S2C_ST[i] < T#5s THEN
			EDTP3S2C_ST[i] := T#5s;
		END_IF;
		EDTP3S2C_STEP[i].set_time := EDTP3S2C_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP3S2C,EDTP3S2C_STEP[0],EDTP3S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP3S2C.status.mode <> 0) AND (NOT EDTP3S2C.auto_mode_edge) THEN
		EDTP3S2C.auto_mode_edge := TRUE;
		EDTP3S2C.manual_mode_edge := FALSE;
		
		EDTR20.control.auto_operate := TRUE;
		EDTXV2107.control.auto_operate := TRUE;
		EDTXV2119.control.auto_operate := TRUE;
		EDTXV2110.control.auto_operate := TRUE;
		EDTTV2101C.control.auto_operate := TRUE;
		EDTTV2101D.control.auto_operate := TRUE;
		EDTTV2101E.control.auto_operate := TRUE;
		EDTTV2101F.control.auto_operate := TRUE;
		EDTXV2111.control.auto_operate := TRUE;
		EDTXV2113.control.auto_operate := TRUE;
		EDTTV2101B.control.auto_operate := TRUE;
		EDTTV2101A.control.auto_operate := TRUE;
		EDTXV2112.control.auto_operate := TRUE;
		EDTFQV2102.control.auto_operate := TRUE;
		EDTFQV2101.control.auto_operate := TRUE;
		EDTLV1002.control.auto_operate := TRUE;
		EDTP16.control.auto_operate := TRUE;
		EDTXV2109.control.auto_operate := TRUE;
		STFP06.control.auto_operate := TRUE;
		STFLV0601.control.auto_operate := TRUE;
		STFLV0602.control.auto_operate := TRUE;
		EDTLV1003.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP3S2C.status.mode = 0) AND (NOT EDTP3S2C.manual_mode_edge) THEN
		EDTP3S2C.manual_mode_edge := TRUE;
		EDTP3S2C.auto_mode_edge := FALSE;

		EDTR20.control.manual_operate := TRUE;
		EDTXV2107.control.manual_operate := TRUE;
		EDTXV2119.control.manual_operate := TRUE;
		EDTXV2110.control.manual_operate := TRUE;
		EDTTV2101C.control.manual_operate := TRUE;
		EDTTV2101D.control.manual_operate := TRUE;
		EDTTV2101E.control.manual_operate := TRUE;
		EDTTV2101F.control.manual_operate := TRUE;
		EDTXV2111.control.manual_operate := TRUE;
		EDTXV2113.control.manual_operate := TRUE;
		EDTTV2101B.control.manual_operate := TRUE;
		EDTTV2101A.control.manual_operate := TRUE;
		EDTXV2112.control.manual_operate := TRUE;
		EDTFQV2102.control.manual_operate := TRUE;
		EDTFQV2101.control.manual_operate := TRUE;
		EDTLV1002.control.manual_operate := TRUE;
		EDTXV2109.control.manual_operate := TRUE;
		EDTP16.control.manual_operate := TRUE;
		STFP06.control.manual_operate := TRUE;
		STFLV0601.control.manual_operate := TRUE;
		STFLV0602.control.manual_operate := TRUE;
		EDTLV1003.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP3S2C.input.error_signal := (EDTR20.status.motor_status >= 2) OR (EDTXV2107.status.valve_status >= 2) OR
	(EDTXV2119.status.valve_status >= 2) OR (EDTXV2110.status.valve_status >= 2) OR (EDTP16.status.motor_status >= 2) OR
	(EDTTV2101C.status.valve_status >= 2) OR (EDTTV2101D.status.valve_status >= 2) OR (EDTXV2113.status.valve_status >= 2) OR
	(EDTTV2101E.status.valve_status >= 2) OR (EDTTV2101F.status.valve_status >= 2) OR (EDTXV2111.status.valve_status >= 2) OR
	(EDTTV2101B.status.valve_status >= 2) OR (EDTTV2101A.status.valve_status >= 2) OR (STFP06.status.motor_status >= 2) OR
	(EDTFQV2102.status.valve_status >= 2) OR (EDTFQV2101.status.valve_status >= 2) OR (EDTLV1002.status.valve_status >= 2) OR
	(EDTXV2112.status.valve_status >= 2) OR (EDTXV2109.status.valve_status >= 2 )OR (EDTLV1003.status.valve_status >= 2) OR
	(STFLV0601.status.valve_status >= 2 )OR (STFLV0602.status.valve_status >= 2);

	
	TON_19.PT := DINT_TO_TIME(EDTP3S2C_PARA_T3 * 60 * 1000);
	IF EDTP3S2C.status.run_state = 1 THEN
		IF EDTTIT2102.status.value >= EDTP3S2C_PARA_Temp5 THEN
			TON_19.IN := TRUE;
		END_IF;
		CASE EDTP3S2C.status.run_step OF 
			0:	
				IF NOT EDTP3S2C_STEP[0].done THEN
					EDTR20.control.auto_operate := TRUE;
					EDTXV2107.control.auto_operate := TRUE;
					EDTXV2119.control.auto_operate := TRUE;
					EDTXV2110.control.auto_operate := TRUE;
					EDTTV2101C.control.auto_operate := TRUE;
					EDTTV2101D.control.auto_operate := TRUE;
					EDTTV2101E.control.auto_operate := TRUE;
					EDTTV2101F.control.auto_operate := TRUE;
					EDTXV2111.control.auto_operate := TRUE;
					EDTXV2113.control.auto_operate := TRUE;
					EDTTV2101B.control.auto_operate := TRUE;
					EDTTV2101A.control.auto_operate := TRUE;
					EDTXV2112.control.auto_operate := TRUE;
					EDTFQV2102.control.auto_operate := TRUE;
					EDTFQV2101.control.auto_operate := TRUE;
					EDTLV1002.control.auto_operate := TRUE;
					EDTP16.control.auto_operate := TRUE;
					EDTXV2109.control.auto_operate := TRUE;
					STFP06.control.auto_operate := TRUE;
					STFLV0601.control.auto_operate := TRUE;
					STFLV0602.control.auto_operate := TRUE;
					EDTLV1003.control.auto_operate := TRUE;
					EDTP3S2C_STEP[0].done := TRUE;
				END_IF;
			1:
				EDTXV2109.input.auto_open_signal := TRUE;
				IF EDTXV2114.input.close_feedback_state THEN
					EDTR20.input.auto_run_signal := TRUE;
					EDTXV2107.input.auto_open_signal := TRUE;
					EDTXV2113.input.auto_open_signal := FALSE;
					IF EDTXV2113.input.close_feedback_state THEN
						EDTXV2111.input.auto_open_signal := TRUE;
						IF EDTR20.input.run_feedback AND EDTXV2107.input.open_feedback_state AND EDTXV2111.input.open_feedback_state THEN
							EDTP3S2C_STEP[1].done := TRUE;
						END_IF;	
					END_IF;
				END_IF;				
			2:
				CASE p3_step2_3c OF
					0:
						IF NOT EDTP3S2C_STEP[2].done THEN
							p3_step2_3c := 1;
						END_IF;
					1:
						HeatPot_15(ST1 := DINT_TO_TIME(EDTP3S2C_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP3S2C_PARA_T2 * 1000),
						V3 := EDTTV2101C,
						V4 := EDTTV2101D,
						V5 := EDTTV2101E,
						V6 := EDTTV2101F,
						done := p3_step2_3c_1_done);
						IF p3_step2_3c_1_done THEN
							p3_step2_3c_1_done := FALSE;
							p3_step2_3c := 2;
						END_IF;
					2:
						IF EDTTIT2101.status.value >= EDTP3S2C_PARA_Temp1 THEN
							p3_step2_3c := 3;
						END_IF;
					3:
						EDTTV2101C.input.auto_open_signal := FALSE;
						IF EDTTV2101C.input.close_feedback_state THEN
							p3_step2_3c := 4;
						END_IF;
					4:
						IF TON_19.Q OR EDTLSS2101.low THEN
							TON_19.IN := FALSE;
							EDTXV2111.input.auto_open_signal := FALSE;
							EDTXV2112.input.auto_open_signal := TRUE;
							p3_step2_3c := 5;
						END_IF
					5:
						IF EDTTIT2101.status.value >= EDTP3S2C_PARA_Temp2 THEN
							EDTXV2112.input.auto_open_signal := FALSE;
							EDTXV2113.input.auto_open_signal := TRUE;
							EDTXV2119.input.auto_open_signal := TRUE;
							EDTXV2110.input.auto_open_signal := TRUE;
							p3_step2_3c := 0;
							EDTP3S2C_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
			3:
				LiquidTransfer_19(sp_time := DINT_TO_TIME(EDTP3S2C_PARA_T4 * 1000),
				sp_accumulation := EDTP3S2C_PARA_AC1,
				done := EDTP3S2C_STEP[3].done,
				flowmeter := EDTFQIT1904);
				EDTFQV2102.input.auto_open_signal := LiquidTransfer_19.run;
			4:
				//继续回收
				IF EDTTIT2101.status.value >= EDTP3S2C_PARA_Temp3 THEN
					EDTP3S2C_STEP[4].done := TRUE;
				END_IF;
			5:
				//现场观察V83进料的是否有EDC油珠，无油珠后点击确认
			6:
				EDTTV2101D.input.auto_open_signal := FALSE;
				EDTTV2101E.input.auto_open_signal := FALSE;
				EDTTV2101F.input.auto_open_signal := TRUE;
				LiquidTransfer_20(sp_time := DINT_TO_TIME(EDTP3S2C_PARA_T5 * 1000),
				sp_accumulation := EDTP3S2C_PARA_AC2,
				done := EDTP3S2C_STEP[6].done,
				flowmeter := EDTFQIT1904);
				EDTFQV2102.input.auto_open_signal := LiquidTransfer_20.run;
			7:	
				CASE p3_step2_7c OF
					0:
						IF NOT EDTP3S2C_STEP[7].done THEN
							p3_step2_7c := 1;
						END_IF;
					1:
						IF EDTTIT2101.status.value <= EDTP3S2C_PARA_Temp6 THEN
							EDTTV2101A.input.auto_open_signal := FALSE;
							EDTTV2101B.input.auto_open_signal := FALSE;
							EDTTV2101F.input.auto_open_signal := TRUE;
							p3_step2_7c := 2;
						ELSE
							EDTTV2101F.input.auto_open_signal := FALSE;
							EDTTV2101A.input.auto_open_signal := TRUE;
							EDTTV2101B.input.auto_open_signal := TRUE;
						END_IF;
					2:
						TON_86.PT := DINT_TO_TIME(EDTP3S2C_PARA_T9 * 60 * 1000);
						EDTR20.input.auto_run_signal := FALSE;
						IF (NOT EDTR20.input.run_feedback) THEN
							TON_86.IN := TRUE;
						END_IF;
						IF TON_86.Q THEN
							TON_86.IN := FALSE;
							p3_step2_7c := 0;
							EDTP3S2C_STEP[7].done := TRUE;
						END_IF;
				END_CASE;
				TON_86();
			8:
			//人工抽水
			9:
				IF EDTLIT1501.status.value >= EDTP3S2C_PARA_L2 THEN
					EDTFQV2101.input.auto_open_signal := TRUE;
					EDTLV1002.input.auto_open_signal := TRUE;
					IF EDTFQV2101.input.open_feedback_state AND EDTLV1002.input.open_feedback_state THEN
						is_v52_c := TRUE;
						EDTP3S2C_STEP[9].done := TRUE;
					END_IF;
				ELSE
					STFLV0601.input.auto_open_signal := FALSE;
					STFLV0602.input.auto_open_signal := FALSE;
					EDTFQV2101.input.auto_open_signal := TRUE;
					EDTLV1003.input.auto_open_signal := TRUE;
					IF STFLV0601.input.close_feedback_state AND STFLV0602.input.close_feedback_state AND EDTFQV2101.input.open_feedback_state AND EDTLV1003.input.open_feedback_state THEN
						is_v52_c := FALSE;
						EDTP3S2C_STEP[9].done := TRUE;
					END_IF;
				END_IF;
			10:
				IF is_v52_c THEN
					LiquidTransfer_23(sp_time := DINT_TO_TIME(EDTP3S2C_PARA_T6 * 1000),
					sp_accumulation := EDTP3S2C_PARA_AC3,
					done := EDTP3S2C_STEP[10].done,
					flowmeter := EDTFQIT2101);
					EDTP16.input.auto_run_signal := LiquidTransfer_23.run;
				ELSE
					LiquidTransfer_7(sp_time := DINT_TO_TIME(EDTP3S2C_PARA_T6 * 1000),
					sp_accumulation := EDTP3S2C_PARA_AC3,
					done := EDTP3S2C_STEP[10].done,
					flowmeter := STFFQIT0602);
					STFP06.input.auto_run_signal := LiquidTransfer_7.run;
				END_IF;
			11:
				IF is_v52_c THEN
					IF EDTFQIT2101.flowrate <= flowrate_threshold THEN
						EDTFQV2101.input.auto_open_signal := FALSE;
						EDTLV1002.input.auto_open_signal := FALSE;
						EDTR20.input.auto_run_signal := TRUE;
						IF EDTFQV2101.input.close_feedback_state AND EDTLV1002.input.close_feedback_state AND EDTR20.input.auto_run_signal THEN
							EDTTV2101D.input.auto_open_signal := TRUE;
							EDTP3S2C_STEP[11].done := TRUE;
						END_IF;
					END_IF;	
				ELSE
					IF STFFQIT0602.flowrate <= flowrate_threshold THEN
						EDTFQV2101.input.auto_open_signal := FALSE;
						EDTLV1003.input.auto_open_signal := FALSE;
						EDTR20.input.auto_run_signal := TRUE;
						IF EDTFQV2101.input.close_feedback_state AND EDTLV1003.input.close_feedback_state AND EDTR20.input.auto_run_signal THEN
							EDTTV2101D.input.auto_open_signal := TRUE;
							EDTP3S2C_STEP[11].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			12:
				TON_61.PT := DINT_TO_TIME(EDTP3S2C_PARA_T7 * 1000);
				IF EDTTV2101D.input.open_feedback_state THEN
					TON_61.IN := TRUE;
				END_IF;
				IF TON_61.Q THEN
					EDTTV2101F.input.auto_open_signal := FALSE;
					EDTTV2101E.input.auto_open_signal := TRUE;
					TON_61.IN := FALSE;
					EDTP3S2C_STEP[12].done := TRUE;
				END_IF;
				TON_61();
			13:
				TON_73.PT := DINT_TO_TIME(EDTP3S2C_PARA_T8 * 60 * 1000);
				IF EDTTIT2101.status.value >= EDTP3S2C_PARA_Temp4 THEN
					EDTTV2101D.input.auto_open_signal := FALSE;
					TON_73.IN := TRUE;
				END_IF;
				IF TON_73.Q THEN
					TON_73.IN := FALSE;
					EDTP3S2C_STEP[13].done := TRUE;
				END_IF;
				TON_73();
			14:
				//人工转移
			15:
				EDTR20.input.auto_run_signal := FALSE;
				EDTTV2101E.input.auto_open_signal := FALSE;
				EDTP3S2C_STEP[15].done := TRUE;
		END_CASE;		
	END_IF;
	TON_19();
	
	
	//人工确认步骤可用
	IF (EDTP3S2C.status.run_state) AND (NOT EDTP3S2C_STEP[EDTP3S2C.status.run_step].done AND ((EDTP3S2C.status.run_step = 5) 
		OR (EDTP3S2C.status.run_step = 8) OR (EDTP3S2C.status.run_step = 14))) THEN
		EDTP3S2C.status.confirm_enable := TRUE;
	ELSE
		EDTP3S2C.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
