
ACTION P3S3C_ACT: 
	//设定时间
	FOR i := 0 TO EDTP3S3_STEP_NUM DO
		IF EDTP3S3C_ST[i] < T#5s THEN
			EDTP3S3C_ST[i] := T#5s;
		END_IF;
		EDTP3S3C_STEP[i].set_time := EDTP3S3C_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP3S3C,EDTP3S3C_STEP[0],EDTP3S3_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP3S3C.status.mode <> 0) AND (NOT EDTP3S3C.auto_mode_edge) THEN
		EDTP3S3C.auto_mode_edge := TRUE;
		EDTP3S3C.manual_mode_edge := FALSE;
		
		EDTXV2109.control.auto_operate := TRUE;
		EDTXV2110.control.auto_operate := TRUE;
		EDTXV2119.control.auto_operate := TRUE;
		EDTXV2126.control.auto_operate := TRUE;
		EDTP34.control.auto_operate := TRUE;
		EDTTV2101C.control.auto_operate := TRUE;
		EDTTV2101D.control.auto_operate := TRUE;
		EDTTV2101E.control.auto_operate := TRUE;
		EDTTV2101F.control.auto_operate := TRUE;
		EDTTV2101B.control.auto_operate := TRUE;
		EDTTV2101A.control.auto_operate := TRUE;
		EDTXV2106.control.auto_operate := TRUE;
		EDTXV2118.control.auto_operate := TRUE;	
		EDTXV2113.control.auto_operate := TRUE;
		EDTXV2107.control.auto_operate := TRUE;
		EDTR20.control.auto_operate := TRUE;
		EDTXV2127.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP3S3C.status.mode = 0) AND (NOT EDTP3S3C.manual_mode_edge) THEN
		EDTP3S3C.manual_mode_edge := TRUE;
		EDTP3S3C.auto_mode_edge := FALSE;

		EDTXV2109.control.manual_operate := TRUE;
		EDTXV2110.control.manual_operate := TRUE;
		EDTXV2119.control.manual_operate := TRUE;
		EDTXV2126.control.manual_operate := TRUE;
		EDTP34.control.manual_operate := TRUE;
		EDTTV2101C.control.manual_operate := TRUE;
		EDTTV2101D.control.manual_operate := TRUE;
		EDTTV2101E.control.manual_operate := TRUE;
		EDTTV2101F.control.manual_operate := TRUE;
		EDTTV2101B.control.manual_operate := TRUE;
		EDTTV2101A.control.manual_operate := TRUE;
		EDTXV2106.control.manual_operate := TRUE;
		EDTXV2118.control.manual_operate := TRUE;
		EDTXV2113.control.manual_operate := TRUE;
		EDTXV2107.control.manual_operate := TRUE;
		EDTR20.control.manual_operate := TRUE;
		EDTXV2127.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP3S3C.input.error_signal := (EDTP34.status.motor_status >= 2) OR (EDTXV2109.status.valve_status >= 2) OR
	(EDTXV2110.status.valve_status >= 2) OR (EDTXV2119.status.valve_status >= 2) OR (EDTXV2126.status.valve_status >= 2) OR
	(EDTTV2101C.status.valve_status >= 2) OR (EDTTV2101D.status.valve_status >= 2) OR (EDTXV2113.status.valve_status >= 2) OR
	(EDTTV2101E.status.valve_status >= 2) OR (EDTTV2101F.status.valve_status >= 2) OR (EDTTV2101B.status.valve_status >= 2) OR (EDTXV2127.status.valve_status >= 2) OR
	(EDTTV2101A.status.valve_status >= 2) OR (EDTXV2106.status.valve_status >= 2) OR (EDTXV2118.status.valve_status >= 2) OR (EDTXV2107.status.valve_status >= 2) OR
	(EDTR20.status.motor_status >= 2);

	
	IF EDTP3S3C.status.run_state = 1 THEN
		CASE EDTP3S3C.status.run_step OF 
			0:	
				IF NOT EDTP3S3C_STEP[0].done THEN
					EDTXV2109.control.auto_operate := TRUE;
					EDTXV2110.control.auto_operate := TRUE;
					EDTXV2119.control.auto_operate := TRUE;
					EDTXV2126.control.auto_operate := TRUE;
					EDTP34.control.auto_operate := TRUE;
					EDTTV2101C.control.auto_operate := TRUE;
					EDTTV2101D.control.auto_operate := TRUE;
					EDTTV2101E.control.auto_operate := TRUE;
					EDTTV2101F.control.auto_operate := TRUE;
					EDTTV2101B.control.auto_operate := TRUE;
					EDTTV2101A.control.auto_operate := TRUE;
					EDTXV2106.control.auto_operate := TRUE;
					EDTXV2118.control.auto_operate := TRUE;	
					EDTXV2113.control.auto_operate := TRUE;
					EDTXV2107.control.auto_operate := TRUE;
					EDTR20.control.auto_operate := TRUE;
					EDTXV2127.control.auto_operate := TRUE;
					EDTP3S3C_STEP[0].done := TRUE;
				END_IF;
			1:
				EDTXV2109.input.auto_open_signal := FALSE;
				EDTXV2110.input.auto_open_signal := TRUE;
				EDTXV2119.input.auto_open_signal := TRUE;
				EDTXV2126.input.auto_open_signal := TRUE;
				EDTR20.input.auto_run_signal := TRUE;
				IF EDTR20.input.run_feedback AND EDTXV2109.input.close_feedback_state AND EDTXV2110.input.open_feedback_state AND EDTXV2119.input.open_feedback_state AND EDTXV2126.input.open_feedback_state THEN
					EDTP3S3C_STEP[1].done := TRUE;
				END_IF;
			2:
				//现场确认P34循环水手阀开启
				EDTXV2127.input.auto_open_signal := TRUE;
			3:
				EDTP34.input.auto_run_signal := TRUE;
				IF EDTP34.input.run_feedback THEN
					EDTP3S3C_STEP[3].done := TRUE;
				END_IF;
			4:
				CASE p3_step3_4c OF
					0:
						IF NOT EDTP3S3C_STEP[4].done THEN
							p3_step3_4c := 1;
						END_IF;
					1:
						IF EDTPIT2101.status.value <= EDTP3S3_PARA_P2 THEN
							p3_step3_4c := 2;
						END_IF;
					2:
						HeatPot_18(ST1 := DINT_TO_TIME(EDTP3S3_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP3S3_PARA_T2 * 1000),
						V3 := EDTTV2101C,
						V4 := EDTTV2101D,
						V5 := EDTTV2101E,
						V6 := EDTTV2101F,
						done := p3_step3_4c_1_done);
						IF p3_step3_4c_1_done THEN
							p3_step3_4c_1_done := FALSE;
							p3_step3_4c := 3;
						END_IF;
					3:
						IF EDTTIT2101.status.value >= EDTP3S3_PARA_Temp1 THEN
							p3_step3_4c := 4;
						END_IF;
					4:
						EDTTV2101C.input.auto_open_signal := FALSE;
						IF EDTTV2101C.input.close_feedback_state THEN
							p3_step3_4c := 5;
						END_IF;
					5:
						TON_23.PT := DINT_TO_TIME(EDTP3S3_PARA_T3 * 60 * 1000);
						TON_23.IN := TRUE;
						IF TON_23.Q THEN
							TON_23.IN := FALSE;
							p3_step3_4c := 6;
						END_IF;
					6:
						IF (NOT EDTP3S3A.status.run_state) AND (NOT EDTP3S3B.status.run_state) THEN
							p3_step3_4c := 7;
						ELSIF EDTP3S3A.status.run_state AND (NOT EDTP3S3B.status.run_state) THEN
							IF p3_step3_4a >= 6 THEN
								p3_step3_4c := 7;
							END_IF;
						ELSIF (NOT EDTP3S3A.status.run_state) AND  EDTP3S3B.status.run_state THEN
							IF p3_step3_4b >= 6 THEN
								p3_step3_4c := 7;
							END_IF;
						ELSIF EDTP3S3A.status.run_state AND EDTP3S3B.status.run_state THEN
							IF (p3_step3_4a >= 6) AND (p3_step3_4b >= 6) THEN
								p3_step3_4c := 7;
							END_IF;
						END_IF;
					7:
						CoolPot_11(
							time := cool_pot_time,
							V1 := EDTTV2101B,
							V2 := EDTTV2101A,
							V3 := EDTTV2101F,
							V4 := EDTTV2101D,
							V5 := EDTTV2101E,
							done := p3_step3_4c_5_done);
						IF p3_step3_4c_5_done THEN
							p3_step3_4c_5_done := FALSE;
							p3_step3_4c := 8;
						END_IF;
					8:
						IF EDTTIT2101.status.value <= EDTP3S3_PARA_Temp2 THEN
							EDTXV2110.input.auto_open_signal := FALSE;
							IF EDTXV2110.input.close_feedback_state THEN
								EDTXV2106.input.auto_open_signal := TRUE;
								EDTXV2118.input.auto_open_signal := TRUE;
								IF EDTXV2106.input.open_feedback_state AND EDTXV2118.input.open_feedback_state THEN
									p3_step3_4c := 9;
								END_IF;
							END_IF;
						END_IF;
					9:
						IF EDTPIT2101.status.value >= EDTP3S3_PARA_P1 THEN
							p3_step3_4c := 10;
						END_IF;
					10:
						EDTXV2106.input.auto_open_signal := FALSE;
						EDTXV2118.input.auto_open_signal := FALSE;
						EDTXV2109.input.auto_open_signal := TRUE;
						EDTTV2101B.input.auto_open_signal := FALSE;
						EDTTV2101A.input.auto_open_signal := FALSE;
						IF EDTXV2118.input.close_feedback_state AND EDTXV2106.input.close_feedback_state AND EDTXV2109.input.open_feedback_state AND EDTTV2101B.input.close_feedback_state AND EDTTV2101A.input.close_feedback_state THEN
							p3_step3_4c := 11;
						END_IF;
					11:
						EDTP34.input.auto_run_signal := FALSE;
						EDTXV2119.input.auto_open_signal := FALSE;
						EDTXV2126.input.auto_open_signal := FALSE;
						EDTXV2113.input.auto_open_signal := FALSE;
						EDTXV2107.input.auto_open_signal := FALSE;
						EDTR20.input.auto_run_signal := FALSE;
						IF EDTXV2107.input.close_feedback_state AND EDTXV2113.input.close_feedback_state AND EDTXV2119.input.close_feedback_state AND
							EDTXV2126.input.close_feedback_state AND (NOT EDTP34.input.run_feedback) AND (NOT EDTR20.input.run_feedback)THEN
							EDTP3S3C_STEP[4].done := TRUE;
							p3_step3_4c := 0;
						END_IF;
				END_CASE;
				TON_23();
			5:
			//现场关闭P34循环水手阀
			EDTXV2127.input.auto_open_signal := FALSE;
		END_CASE;		
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP3S3C.status.run_state) AND (NOT EDTP3S3C_STEP[EDTP3S3C.status.run_step].done AND ((EDTP3S3C.status.run_step = 2) OR (EDTP3S3C.status.run_step = 5))) THEN
		EDTP3S3C.status.confirm_enable := TRUE;
	ELSE
		EDTP3S3C.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
