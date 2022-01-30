
ACTION P3S2A_ACT: 
	//设定时间
	FOR i := 0 TO EDTP3S2_STEP_NUM DO
		IF EDTP3S2A_ST[i] < T#5s THEN
			EDTP3S2A_ST[i] := T#5s;
		END_IF;
		EDTP3S2A_STEP[i].set_time := EDTP3S2A_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP3S2A,EDTP3S2A_STEP[0],EDTP3S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP3S2A.status.mode <> 0) AND (NOT EDTP3S2A.auto_mode_edge) THEN
		EDTP3S2A.auto_mode_edge := TRUE;
		EDTP3S2A.manual_mode_edge := FALSE;
		
		EDTR17A.control.auto_operate := TRUE;
		EDTXV0902.control.auto_operate := TRUE;
		EDTXV2128.control.auto_operate := TRUE;
		EDTXV2119.control.auto_operate := TRUE;
		EDTXV2121.control.auto_operate := TRUE;
		EDTTV0901C.control.auto_operate := TRUE;
		EDTTV0901D.control.auto_operate := TRUE;
		EDTTV0901E.control.auto_operate := TRUE;
		EDTTV0901F.control.auto_operate := TRUE;
		EDTTV0902B.control.auto_operate := TRUE;
		EDTTV0902A.control.auto_operate := TRUE;
		EDTTV0901A.control.auto_operate := TRUE;
		EDTTV0901B.control.auto_operate := TRUE;
		EDTXV0918.control.auto_operate := TRUE;
		EDTFQV0901.control.auto_operate := TRUE;
		EDTFQV0904.control.auto_operate := TRUE;
		EDTLV1002.control.auto_operate := TRUE;
		EDTP16.control.auto_operate := TRUE;
		EDTXV0925.control.auto_operate := TRUE;
		STFP06.control.auto_operate := TRUE;
		STFLV0601.control.auto_operate := TRUE;
		STFLV0602.control.auto_operate := TRUE;
		EDTLV1003.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP3S2A.status.mode = 0) AND (NOT EDTP3S2A.manual_mode_edge) THEN
		EDTP3S2A.manual_mode_edge := TRUE;
		EDTP3S2A.auto_mode_edge := FALSE;

		EDTR17A.control.manual_operate := TRUE;
		EDTXV0902.control.manual_operate := TRUE;
		EDTXV2128.control.manual_operate := TRUE;
		EDTXV2119.control.manual_operate := TRUE;
		EDTXV2121.control.manual_operate := TRUE;
		EDTTV0901C.control.manual_operate := TRUE;
		EDTTV0901D.control.manual_operate := TRUE;
		EDTTV0901E.control.manual_operate := TRUE;
		EDTTV0901F.control.manual_operate := TRUE;
		EDTTV0902B.control.manual_operate := TRUE;
		EDTTV0902A.control.manual_operate := TRUE;
		EDTTV0901A.control.manual_operate := TRUE;
		EDTTV0901B.control.manual_operate := TRUE;
		EDTXV0918.control.manual_operate := TRUE;
		EDTFQV0901.control.manual_operate := TRUE;
		EDTFQV0904.control.manual_operate := TRUE;
		EDTLV1002.control.manual_operate := TRUE;
		EDTP16.control.manual_operate := TRUE;
		EDTXV0925.control.manual_operate := TRUE;
		STFP06.control.manual_operate := TRUE;
		STFLV0601.control.manual_operate := TRUE;
		STFLV0602.control.manual_operate := TRUE;
		EDTLV1003.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP3S2A.input.error_signal := (EDTR17A.status.motor_status >= 2) OR (EDTXV0902.status.valve_status >= 2) OR
	(EDTXV2128.status.valve_status >= 2) OR (EDTXV2119.status.valve_status >= 2) OR (EDTP16.status.motor_status >= 2) OR
	(EDTTV0901C.status.valve_status >= 2) OR (EDTTV0901D.status.valve_status >= 2) OR (EDTXV0918.status.valve_status >= 2) OR
	(EDTTV0901E.status.valve_status >= 2) OR (EDTTV0901F.status.valve_status >= 2) OR (EDTTV0902B.status.valve_status >= 2) OR
	(EDTTV0902A.status.valve_status >= 2) OR (EDTTV0901A.status.valve_status >= 2) OR (EDTTV0901B.status.valve_status >= 2) OR
	(EDTFQV0901.status.valve_status >= 2) OR (EDTFQV0904.status.valve_status >= 2) OR (EDTLV1002.status.valve_status >= 2) OR
	(EDTXV2121.status.valve_status >= 2) OR (EDTXV0925.status.valve_status >= 2) OR (STFP06.status.motor_status >= 2) OR
	(EDTLV1003.status.valve_status >= 2) OR (STFLV0601.status.valve_status >= 2 )OR (STFLV0602.status.valve_status >= 2);

	
	IF EDTP3S2A.status.run_state = 1 THEN
		CASE EDTP3S2A.status.run_step OF 
			0:	
				IF NOT EDTP3S2A_STEP[0].done THEN
					EDTR17A.control.auto_operate := TRUE;
					EDTXV0902.control.auto_operate := TRUE;
					EDTXV2128.control.auto_operate := TRUE;
					EDTXV2119.control.auto_operate := TRUE;
					EDTXV2121.control.auto_operate := TRUE;
					EDTTV0901C.control.auto_operate := TRUE;
					EDTTV0901D.control.auto_operate := TRUE;
					EDTTV0901E.control.auto_operate := TRUE;
					EDTTV0901F.control.auto_operate := TRUE;
					EDTTV0902B.control.auto_operate := TRUE;
					EDTTV0902A.control.auto_operate := TRUE;
					EDTTV0901A.control.auto_operate := TRUE;
					EDTTV0901B.control.auto_operate := TRUE;
					EDTXV0918.control.auto_operate := TRUE;
					EDTFQV0901.control.auto_operate := TRUE;
					EDTFQV0904.control.auto_operate := TRUE;
					EDTLV1002.control.auto_operate := TRUE;
					EDTP16.control.auto_operate := TRUE;
					EDTXV0925.control.auto_operate := TRUE;
					STFP06.control.auto_operate := TRUE;
					STFLV0601.control.auto_operate := TRUE;
					STFLV0602.control.auto_operate := TRUE;
					EDTLV1003.control.auto_operate := TRUE;
					EDTP3S2A_STEP[0].done := TRUE;
				END_IF;
			1:
				EDTXV0925.input.auto_open_signal := TRUE;
				IF EDTXV0905.input.close_feedback_state THEN
					EDTR17A.input.auto_run_signal := TRUE;
					EDTXV0902.input.auto_open_signal := TRUE;
					EDTTV0902A.input.auto_open_signal := FALSE;
					EDTXV2128.input.auto_open_signal := FALSE;
					IF EDTTV0902A.input.close_feedback_state AND EDTXV2128.input.close_feedback_state THEN
						EDTTV0902B.input.auto_open_signal := TRUE;
						IF EDTR17A.input.run_feedback AND EDTXV0902.input.open_feedback_state AND EDTTV0902B.input.open_feedback_state THEN
							EDTP3S2A_STEP[1].done := TRUE;
						END_IF;	
					END_IF;
				END_IF;
			2:
				CASE p3_step2_3a OF
					0:
						IF NOT EDTP3S2A_STEP[2].done THEN
							p3_step2_3a := 1;
						END_IF;
					1:
						HeatPot_1(ST1 := DINT_TO_TIME(EDTP3S2A_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP3S2A_PARA_T2 * 1000),
						V3 := EDTTV0901C,
						V4 := EDTTV0901D,
						V5 := EDTTV0901E,
						V6 := EDTTV0901F,
						done := p3_step2_3a_1_done);
						IF p3_step2_3a_1_done THEN
							p3_step2_3a_1_done := FALSE;
							p3_step2_3a := 2;
						END_IF;
					2:
						IF EDTTIT0901.status.value >= EDTP3S2A_PARA_Temp1 THEN
							p3_step2_3a := 3;
						END_IF;
					3:
						EDTTV0901C.input.auto_open_signal := FALSE;
						IF EDTTV0901C.input.close_feedback_state THEN
							p3_step2_3a := 4;
						END_IF;
					4:
						IF EDTLIT0901.status.value >= EDTP3S2A_PARA_L1 THEN
							EDTTV0902B.input.auto_open_signal := FALSE;
							EDTTV0902A.input.auto_open_signal := TRUE;
							IF EDTXV2128.input.close_feedback_state THEN
								EDTXV0918.input.auto_open_signal := TRUE;
							END_IF;
							p3_step2_3a := 5;
						END_IF;	
					5:
						IF EDTXV2128.input.open_feedback_state THEN
							EDTXV0918.input.auto_open_signal := FALSE;
						END_IF;
						IF EDTTIT0901.status.value >= EDTP3S2A_PARA_Temp2 THEN
							EDTXV0918.input.auto_open_signal := FALSE;
							EDTXV2128.input.auto_open_signal := TRUE;
							EDTXV2119.input.auto_open_signal := TRUE;
							EDTXV2121.input.auto_open_signal := TRUE;
							p3_step2_3a := 0;
							EDTP3S2A_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
			3:
				LiquidTransfer_12(sp_time := DINT_TO_TIME(EDTP3S2A_PARA_T4 * 1000),
				sp_accumulation := EDTP3S2A_PARA_AC1,
				done := EDTP3S2A_STEP[3].done,
				flowmeter := EDTFQIT1904);
				EDTFQV0901.input.auto_open_signal := LiquidTransfer_12.run;
			4:
				//继续回收
				IF EDTTIT0901.status.value >= EDTP3S2A_PARA_Temp3 THEN
					EDTP3S2A_STEP[4].done := TRUE;
				END_IF;
			5:
				//现场观察V83进料的是否有EDC油珠，无油珠后点击确认
			6:
				EDTTV0901D.input.auto_open_signal := FALSE;
				EDTTV0901E.input.auto_open_signal := FALSE;
				EDTTV0901F.input.auto_open_signal := TRUE;
				LiquidTransfer_16(sp_time := DINT_TO_TIME(EDTP3S2A_PARA_T5 * 1000),
				sp_accumulation := EDTP3S2A_PARA_AC2,
				done := EDTP3S2A_STEP[6].done,
				flowmeter := EDTFQIT1904);
				EDTFQV0901.input.auto_open_signal := LiquidTransfer_16.run;	
			7:
				CASE p3_step2_7a OF
					0:
						IF NOT EDTP3S2A_STEP[7].done THEN
							p3_step2_7a := 1;
						END_IF;
					1:
						IF EDTTIT0901.status.value <= EDTP3S2A_PARA_Temp6 THEN
							EDTTV0901A.input.auto_open_signal := FALSE;
							EDTTV0901B.input.auto_open_signal := FALSE;
							EDTTV0901F.input.auto_open_signal := TRUE;
							p3_step2_7a := 2;
						ELSE
							EDTTV0901F.input.auto_open_signal := FALSE;
							EDTTV0901A.input.auto_open_signal := TRUE;
							EDTTV0901B.input.auto_open_signal := TRUE;
						END_IF;
					2:
						TON_60.PT := DINT_TO_TIME(EDTP3S2A_PARA_T9 * 60 * 1000);
						EDTR17A.input.auto_run_signal := FALSE;
						IF (NOT EDTR17A.input.run_feedback) THEN
							TON_60.IN := TRUE;
						END_IF;
						IF TON_60.Q THEN
							TON_60.IN := FALSE;
							p3_step2_7a := 0;
							EDTP3S2A_STEP[7].done := TRUE;
						END_IF;
				END_CASE;
				TON_60();
			8:
				//人工抽水,完毕后点击确认
			9:
				IF EDTLIT1501.status.value >= EDTP3S2A_PARA_L2 THEN
					EDTFQV0904.input.auto_open_signal := TRUE;
					EDTLV1002.input.auto_open_signal := TRUE;
					IF EDTFQV0904.input.open_feedback_state AND EDTLV1002.input.open_feedback_state THEN
						is_v52_a := TRUE;
						EDTP3S2A_STEP[9].done := TRUE;
					END_IF;
				ELSE
					STFLV0601.input.auto_open_signal := FALSE;
					STFLV0602.input.auto_open_signal := FALSE;
					EDTFQV0904.input.auto_open_signal := TRUE;
					EDTLV1003.input.auto_open_signal := TRUE;
					IF STFLV0601.input.close_feedback_state AND STFLV0602.input.close_feedback_state AND EDTFQV0904.input.open_feedback_state AND EDTLV1003.input.open_feedback_state THEN
						is_v52_a := FALSE;
						EDTP3S2A_STEP[9].done := TRUE;
					END_IF;
				END_IF;
			10:
				IF is_v52_a THEN
					LiquidTransfer_21(sp_time := DINT_TO_TIME(EDTP3S2A_PARA_T6 * 1000),
					sp_accumulation := EDTP3S2A_PARA_AC3,
					done := EDTP3S2A_STEP[10].done,
					flowmeter := EDTFQIT2101);
					EDTP16.input.auto_run_signal := LiquidTransfer_21.run;
				ELSE
					LiquidTransfer_1(sp_time := DINT_TO_TIME(EDTP3S2A_PARA_T6 * 1000),
					sp_accumulation := EDTP3S2A_PARA_AC3,
					done := EDTP3S2A_STEP[10].done,
					flowmeter := STFFQIT0602);
					STFP06.input.auto_run_signal := LiquidTransfer_1.run;
				END_IF;
			11:
				IF is_v52_a THEN
					IF EDTFQIT2101.flowrate <= flowrate_threshold THEN
						EDTFQV0904.input.auto_open_signal := FALSE;
						EDTLV1002.input.auto_open_signal := FALSE;
						EDTR17A.input.auto_run_signal := TRUE;
						IF EDTFQV0904.input.close_feedback_state AND EDTLV1002.input.close_feedback_state AND EDTR17A.input.auto_run_signal THEN
							EDTTV0901D.input.auto_open_signal := TRUE;
							EDTP3S2A_STEP[11].done := TRUE;
						END_IF;
					END_IF;
				ELSE
					IF STFFQIT0602.flowrate <= flowrate_threshold THEN
						EDTFQV0904.input.auto_open_signal := FALSE;
						EDTLV1003.input.auto_open_signal := FALSE;
						EDTR17A.input.auto_run_signal := TRUE;
						IF EDTFQV0904.input.close_feedback_state AND EDTLV1003.input.close_feedback_state AND EDTR17A.input.auto_run_signal THEN
							EDTTV0901D.input.auto_open_signal := TRUE;
							EDTP3S2A_STEP[11].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
				
			12:
				TON_21.PT := DINT_TO_TIME(EDTP3S2A_PARA_T7 * 1000);
				IF EDTTV0901D.input.open_feedback_state THEN
					TON_21.IN := TRUE;
				END_IF;
				IF TON_21.Q THEN
					TON_21.IN := FALSE;
					EDTTV0901F.input.auto_open_signal := FALSE;
					EDTTV0901E.input.auto_open_signal := TRUE;
					EDTP3S2A_STEP[12].done := TRUE;
				END_IF;
				TON_21();
			13:
				TON_26.PT := DINT_TO_TIME(EDTP3S2A_PARA_T8 * 60 * 1000);
				IF EDTTIT0901.status.value >= EDTP3S2A_PARA_Temp4 THEN
					EDTTV0901D.input.auto_open_signal := FALSE;
					TON_26.IN := TRUE;
				END_IF;
				IF TON_26.Q THEN
					TON_26.IN := FALSE;
					EDTP3S2A_STEP[13].done := TRUE;
				END_IF;
				TON_26();
			14:
				//人工转移
			15:
				EDTR17A.input.auto_run_signal := FALSE;
				EDTTV0901E.input.auto_open_signal := FALSE;
				EDTP3S2A_STEP[15].done := TRUE;
		END_CASE;		
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP3S2A.status.run_state) AND (NOT EDTP3S2A_STEP[EDTP3S2A.status.run_step].done AND ((EDTP3S2A.status.run_step = 5) 
		OR (EDTP3S2A.status.run_step = 8) OR (EDTP3S2A.status.run_step = 14))) THEN
		EDTP3S2A.status.confirm_enable := TRUE;
	ELSE
		EDTP3S2A.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
