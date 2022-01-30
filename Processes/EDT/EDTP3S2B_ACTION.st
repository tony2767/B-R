
ACTION P3S2B_ACT: 
	//设定时间
	FOR i := 0 TO EDTP3S2_STEP_NUM DO
		IF EDTP3S2B_ST[i] < T#5s THEN
			EDTP3S2B_ST[i] := T#5s;
		END_IF;
		EDTP3S2B_STEP[i].set_time := EDTP3S2B_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP3S2B,EDTP3S2B_STEP[0],EDTP3S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP3S2B.status.mode <> 0) AND (NOT EDTP3S2B.auto_mode_edge) THEN
		EDTP3S2B.auto_mode_edge := TRUE;
		EDTP3S2B.manual_mode_edge := FALSE;
		
		EDTR17B.control.auto_operate := TRUE;
		EDTXV0912.control.auto_operate := TRUE;
		EDTXV2128.control.auto_operate := TRUE;
		EDTXV2119.control.auto_operate := TRUE;
		EDTXV2121.control.auto_operate := TRUE;
		EDTTV0903C.control.auto_operate := TRUE;
		EDTTV0903D.control.auto_operate := TRUE;
		EDTTV0903E.control.auto_operate := TRUE;
		EDTTV0903F.control.auto_operate := TRUE;
		EDTTV0904B.control.auto_operate := TRUE;
		EDTTV0904A.control.auto_operate := TRUE;
		EDTTV0903A.control.auto_operate := TRUE;
		EDTTV0903B.control.auto_operate := TRUE;
		EDTXV0918.control.auto_operate := TRUE;
		EDTFQV0902.control.auto_operate := TRUE;
		EDTFQV0905.control.auto_operate := TRUE;
		EDTLV1002.control.auto_operate := TRUE;
		EDTP16.control.auto_operate := TRUE;
		EDTXV0925.control.auto_operate := TRUE;
		STFP06.control.auto_operate := TRUE;
		STFLV0601.control.auto_operate := TRUE;
		STFLV0602.control.auto_operate := TRUE;
		EDTLV1003.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP3S2B.status.mode = 0) AND (NOT EDTP3S2B.manual_mode_edge) THEN
		EDTP3S2B.manual_mode_edge := TRUE;
		EDTP3S2B.auto_mode_edge := FALSE;

		EDTR17B.control.manual_operate := TRUE;
		EDTXV0912.control.manual_operate := TRUE;
		EDTXV2128.control.manual_operate := TRUE;
		EDTXV2119.control.manual_operate := TRUE;
		EDTXV2121.control.manual_operate := TRUE;
		EDTTV0903C.control.manual_operate := TRUE;
		EDTTV0903D.control.manual_operate := TRUE;
		EDTTV0903E.control.manual_operate := TRUE;
		EDTTV0903F.control.manual_operate := TRUE;
		EDTTV0904B.control.manual_operate := TRUE;
		EDTTV0904A.control.manual_operate := TRUE;
		EDTTV0903A.control.manual_operate := TRUE;
		EDTTV0903B.control.manual_operate := TRUE;
		EDTXV0918.control.manual_operate := TRUE;
		EDTFQV0902.control.manual_operate := TRUE;
		EDTFQV0905.control.manual_operate := TRUE;
		EDTLV1002.control.manual_operate := TRUE;
		EDTP16.control.manual_operate := TRUE;
		EDTXV0925.control.manual_operate := TRUE;
		STFP06.control.manual_operate := TRUE;
		STFLV0601.control.manual_operate := TRUE;
		STFLV0602.control.manual_operate := TRUE;
		EDTLV1003.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP3S2B.input.error_signal := (EDTR17B.status.motor_status >= 2) OR (EDTXV0912.status.valve_status >= 2) OR
	(EDTXV2128.status.valve_status >= 2) OR (EDTXV2119.status.valve_status >= 2) OR (EDTP16.status.motor_status >= 2) OR
	(EDTTV0903C.status.valve_status >= 2) OR (EDTTV0903D.status.valve_status >= 2) OR (EDTXV0918.status.valve_status >= 2) OR
	(EDTTV0903E.status.valve_status >= 2) OR (EDTTV0903F.status.valve_status >= 2) OR (EDTTV0904B.status.valve_status >= 2) OR
	(EDTTV0904A.status.valve_status >= 2) OR (EDTTV0903A.status.valve_status >= 2) OR (EDTTV0903B.status.valve_status >= 2) OR
	(EDTFQV0902.status.valve_status >= 2) OR (EDTFQV0905.status.valve_status >= 2) OR (EDTLV1002.status.valve_status >= 2) OR 
	(EDTXV2121.status.valve_status >= 2) OR (EDTXV0925.status.valve_status >= 2) OR (STFP06.status.motor_status >= 2) OR
	(EDTLV1003.status.valve_status >= 2) OR (STFLV0601.status.valve_status >= 2 )OR (STFLV0602.status.valve_status >= 2);
	
	IF EDTP3S2B.status.run_state = 1 THEN
		CASE EDTP3S2B.status.run_step OF 
			0:	
				IF NOT EDTP3S2B_STEP[0].done THEN
					EDTR17B.control.auto_operate := TRUE;
					EDTXV0912.control.auto_operate := TRUE;
					EDTXV2128.control.auto_operate := TRUE;
					EDTXV2119.control.auto_operate := TRUE;
					EDTXV2121.control.auto_operate := TRUE;
					EDTTV0903C.control.auto_operate := TRUE;
					EDTTV0903D.control.auto_operate := TRUE;
					EDTTV0903E.control.auto_operate := TRUE;
					EDTTV0903F.control.auto_operate := TRUE;
					EDTTV0904B.control.auto_operate := TRUE;
					EDTTV0904A.control.auto_operate := TRUE;
					EDTTV0903A.control.auto_operate := TRUE;
					EDTTV0903B.control.auto_operate := TRUE;
					EDTXV0918.control.auto_operate := TRUE;
					EDTFQV0902.control.auto_operate := TRUE;
					EDTFQV0905.control.auto_operate := TRUE;
					EDTLV1002.control.auto_operate := TRUE;
					EDTP16.control.auto_operate := TRUE;
					EDTXV0925.control.auto_operate := TRUE;
					STFP06.control.auto_operate := TRUE;
					STFLV0601.control.auto_operate := TRUE;
					STFLV0602.control.auto_operate := TRUE;
					EDTLV1003.control.auto_operate := TRUE;
					EDTP3S2B_STEP[0].done := TRUE;
				END_IF;
			1:
				EDTXV0925.input.auto_open_signal := TRUE;
				IF EDTXV0913.input.close_feedback_state THEN
					EDTR17B.input.auto_run_signal := TRUE;
					EDTXV0912.input.auto_open_signal := TRUE;
					EDTTV0904A.input.auto_open_signal := FALSE;
					EDTXV2128.input.auto_open_signal := FALSE;
					IF EDTTV0904A.input.close_feedback_state AND EDTXV2128.input.close_feedback_state THEN
						EDTTV0904B.input.auto_open_signal := TRUE;
						IF EDTR17B.input.run_feedback AND EDTXV0912.input.open_feedback_state AND EDTTV0904B.input.open_feedback_state THEN
							EDTP3S2B_STEP[1].done := TRUE;
						END_IF;	
					END_IF;
				END_IF;
			2:
				CASE p3_step2_3b OF
					0:
						IF NOT EDTP3S2B_STEP[2].done THEN
							p3_step2_3b := 1;
						END_IF;
					1:
						HeatPot_11(ST1 := DINT_TO_TIME(EDTP3S2B_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP3S2B_PARA_T2 * 1000),
						V3 := EDTTV0903C,
						V4 := EDTTV0903D,
						V5 := EDTTV0903E,
						V6 := EDTTV0903F,
						done := p3_step2_3b_1_done);
						IF p3_step2_3b_1_done THEN
							p3_step2_3b_1_done := FALSE;
							p3_step2_3b := 2;
						END_IF;
					2:
						IF EDTTIT0903.status.value >= EDTP3S2B_PARA_Temp1 THEN
							p3_step2_3b := 3;
						END_IF;
					3:
						EDTTV0903C.input.auto_open_signal := FALSE;
						IF EDTTV0903C.input.close_feedback_state THEN
							p3_step2_3b := 4;
						END_IF;
					4:
						IF EDTLIT0902.status.value >= EDTP3S2B_PARA_L1 THEN
							EDTTV0904B.input.auto_open_signal := FALSE;
							EDTTV0904A.input.auto_open_signal := TRUE;
							IF EDTXV2128.input.close_feedback_state THEN
								EDTXV0918.input.auto_open_signal := TRUE;
							END_IF;
							p3_step2_3b := 5;
						END_IF;
					5:
						IF EDTXV2128.input.open_feedback_state THEN
							EDTXV0918.input.auto_open_signal := FALSE;
						END_IF;
						IF EDTTIT0903.status.value >= EDTP3S2B_PARA_Temp2 THEN
							EDTXV0918.input.auto_open_signal := FALSE;
							EDTXV2128.input.auto_open_signal := TRUE;
							EDTXV2119.input.auto_open_signal := TRUE;
							EDTXV2121.input.auto_open_signal := TRUE;
							p3_step2_3b := 0;
							EDTP3S2B_STEP[2].done := TRUE;
						END_IF;
				END_CASE;
			3:
				LiquidTransfer_17(sp_time := DINT_TO_TIME(EDTP3S2B_PARA_T4 * 1000),
				sp_accumulation := EDTP3S2B_PARA_AC1,
				done := EDTP3S2B_STEP[3].done,
				flowmeter := EDTFQIT1904);
				EDTFQV0902.input.auto_open_signal := LiquidTransfer_17.run;
			4:
				//继续回收
				IF EDTTIT0903.status.value >= EDTP3S2B_PARA_Temp3 THEN
					EDTP3S2B_STEP[4].done := TRUE;
				END_IF;
			5:
				//现场观察V83进料的是否有EDC油珠，无油珠后点击确认
			6:
				EDTTV0903D.input.auto_open_signal := FALSE;
				EDTTV0903E.input.auto_open_signal := FALSE;
				EDTTV0903F.input.auto_open_signal := TRUE;
				LiquidTransfer_18(sp_time := DINT_TO_TIME(EDTP3S2B_PARA_T5 * 1000),
				sp_accumulation := EDTP3S2B_PARA_AC2,
				done := EDTP3S2B_STEP[6].done,
				flowmeter := EDTFQIT1904);
				EDTFQV0902.input.auto_open_signal := LiquidTransfer_18.run;	
			7:
				CASE p3_step2_7b OF
					0:
						IF NOT EDTP3S2B_STEP[7].done THEN
							p3_step2_7b := 1;
						END_IF;
					1:
						IF EDTTIT0903.status.value <= EDTP3S2B_PARA_Temp6 THEN
							EDTTV0903A.input.auto_open_signal := FALSE;
							EDTTV0903B.input.auto_open_signal := FALSE;
							EDTTV0903F.input.auto_open_signal := TRUE;
							p3_step2_7b := 2;
						ELSE
							EDTTV0903F.input.auto_open_signal := FALSE;
							EDTTV0903A.input.auto_open_signal := TRUE;
							EDTTV0903B.input.auto_open_signal := TRUE;
						END_IF;
					2:
						TON_85.PT := DINT_TO_TIME(EDTP3S2B_PARA_T9 * 60 * 1000);
						EDTR17B.input.auto_run_signal := FALSE;
						IF (NOT EDTR17B.input.run_feedback) THEN
							TON_85.IN := TRUE;
						END_IF;
						IF TON_85.Q THEN
							TON_85.IN := FALSE;
							p3_step2_7b := 0;
							EDTP3S2B_STEP[7].done := TRUE;
						END_IF;
				END_CASE;
				TON_85();
			8:
				//人工抽水
			9:
				IF EDTLIT1501.status.value >= EDTP3S2B_PARA_L2 THEN
					EDTFQV0905.input.auto_open_signal := TRUE;
					EDTLV1002.input.auto_open_signal := TRUE;
					IF EDTFQV0905.input.open_feedback_state AND EDTLV1002.input.open_feedback_state THEN
						is_v52_b := TRUE;
						EDTP3S2B_STEP[9].done := TRUE;
					END_IF;
				ELSE
					STFLV0601.input.auto_open_signal := FALSE;
					STFLV0602.input.auto_open_signal := FALSE;
					EDTFQV0905.input.auto_open_signal := TRUE;
					EDTLV1003.input.auto_open_signal := TRUE;
					IF STFLV0601.input.close_feedback_state AND STFLV0602.input.close_feedback_state AND EDTFQV0905.input.open_feedback_state AND EDTLV1003.input.open_feedback_state THEN
						is_v52_b := FALSE;
						EDTP3S2B_STEP[9].done := TRUE;
					END_IF;
				END_IF;
			10:
				IF is_v52_b THEN
					LiquidTransfer_22(sp_time := DINT_TO_TIME(EDTP3S2B_PARA_T6 * 1000),
					sp_accumulation := EDTP3S2B_PARA_AC3,
					done := EDTP3S2B_STEP[10].done,
					flowmeter := EDTFQIT2101);
					EDTP16.input.auto_run_signal := LiquidTransfer_22.run;
				ELSE
					LiquidTransfer_2(sp_time := DINT_TO_TIME(EDTP3S2B_PARA_T6 * 1000),
					sp_accumulation := EDTP3S2B_PARA_AC3,
					done := EDTP3S2B_STEP[10].done,
					flowmeter := STFFQIT0602);
					STFP06.input.auto_run_signal := LiquidTransfer_2.run;
				END_IF;
			11:
				IF is_v52_b THEN
					IF EDTFQIT2101.flowrate <= flowrate_threshold THEN
						EDTFQV0905.input.auto_open_signal := FALSE;
						EDTLV1002.input.auto_open_signal := FALSE;
						EDTR17B.input.auto_run_signal := TRUE;
						IF EDTFQV0905.input.close_feedback_state AND EDTLV1002.input.close_feedback_state AND EDTR17B.input.auto_run_signal THEN
							EDTTV0903D.input.auto_open_signal := TRUE;
							EDTP3S2B_STEP[11].done := TRUE;
						END_IF;
					END_IF;
				ELSE
					IF STFFQIT0602.flowrate <= flowrate_threshold THEN
						EDTFQV0905.input.auto_open_signal := FALSE;
						EDTLV1003.input.auto_open_signal := FALSE;
						EDTR17B.input.auto_run_signal := TRUE;
						IF EDTFQV0905.input.close_feedback_state AND EDTLV1003.input.close_feedback_state AND EDTR17B.input.auto_run_signal THEN
							EDTTV0903D.input.auto_open_signal := TRUE;
							EDTP3S2B_STEP[11].done := TRUE;
						END_IF;
					END_IF;
				END_IF;				
			12:
				TON_29.PT := DINT_TO_TIME(EDTP3S2B_PARA_T7 * 1000);
				IF EDTTV0903D.input.open_feedback_state THEN
					TON_29.IN := TRUE;
				END_IF;
				IF TON_29.Q THEN
					TON_29.IN := FALSE;
					EDTTV0903F.input.auto_open_signal := FALSE;
					EDTTV0903E.input.auto_open_signal := TRUE;
					EDTP3S2B_STEP[12].done := TRUE;
				END_IF;
				TON_29();
			13:
				TON_42.PT := DINT_TO_TIME(EDTP3S2B_PARA_T8 * 60 * 1000);
				IF EDTTIT0903.status.value >= EDTP3S2B_PARA_Temp4 THEN
					EDTTV0903D.input.auto_open_signal := FALSE;
					TON_42.IN := TRUE;
				END_IF;
				IF TON_42.Q THEN
					TON_42.IN := FALSE;
					EDTP3S2B_STEP[13].done := TRUE;
				END_IF;
				TON_42();
			14:
				//人工转移
			15:
				EDTR17B.input.auto_run_signal := FALSE;
				EDTTV0903E.input.auto_open_signal := FALSE;
				EDTP3S2B_STEP[15].done := TRUE;
		END_CASE;
	END_IF;

	
	//人工确认步骤可用
	IF (EDTP3S2B.status.run_state) AND (NOT EDTP3S2B_STEP[EDTP3S2B.status.run_step].done AND ((EDTP3S2B.status.run_step = 5) 
		OR (EDTP3S2B.status.run_step = 8) OR (EDTP3S2B.status.run_step = 14))) THEN
		EDTP3S2B.status.confirm_enable := TRUE;
	ELSE
		EDTP3S2B.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
