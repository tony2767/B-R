
ACTION P3S3B_ACT: 
	//设定时间
	FOR i := 0 TO EDTP3S3_STEP_NUM DO
		IF EDTP3S3B_ST[i] < T#5s THEN
			EDTP3S3B_ST[i] := T#5s;
		END_IF;
		EDTP3S3B_STEP[i].set_time := EDTP3S3B_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP3S3B,EDTP3S3B_STEP[0],EDTP3S3_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP3S3B.status.mode <> 0) AND (NOT EDTP3S3B.auto_mode_edge) THEN
		EDTP3S3B.auto_mode_edge := TRUE;
		EDTP3S3B.manual_mode_edge := FALSE;
		
		EDTXV0925.control.auto_operate := TRUE;
		EDTXV2121.control.auto_operate := TRUE;
		EDTXV2119.control.auto_operate := TRUE;
		EDTXV2126.control.auto_operate := TRUE;
		EDTP34.control.auto_operate := TRUE;
		EDTTV0903C.control.auto_operate := TRUE;
		EDTTV0903D.control.auto_operate := TRUE;
		EDTTV0903E.control.auto_operate := TRUE;
		EDTTV0903F.control.auto_operate := TRUE;
		EDTTV0903A.control.auto_operate := TRUE;
		EDTTV0903B.control.auto_operate := TRUE;
		EDTXV0924.control.auto_operate := TRUE;
		EDTXV2118.control.auto_operate := TRUE;	
		EDTXV2128.control.auto_operate := TRUE;
		EDTTV0904A.control.auto_operate := TRUE;
		EDTXV0912.control.auto_operate := TRUE;
		EDTR17B.control.auto_operate := TRUE;
		EDTXV2127.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP3S3B.status.mode = 0) AND (NOT EDTP3S3B.manual_mode_edge) THEN
		EDTP3S3B.manual_mode_edge := TRUE;
		EDTP3S3B.auto_mode_edge := FALSE;

		EDTXV0925.control.manual_operate := TRUE;
		EDTXV2121.control.manual_operate := TRUE;
		EDTXV2119.control.manual_operate := TRUE;
		EDTXV2126.control.manual_operate := TRUE;
		EDTP34.control.manual_operate := TRUE;
		EDTTV0903C.control.manual_operate := TRUE;
		EDTTV0903D.control.manual_operate := TRUE;
		EDTTV0903E.control.manual_operate := TRUE;
		EDTTV0903F.control.manual_operate := TRUE;
		EDTTV0903A.control.manual_operate := TRUE;
		EDTTV0903B.control.manual_operate := TRUE;
		EDTXV0924.control.manual_operate := TRUE;
		EDTXV2118.control.manual_operate := TRUE;	
		EDTXV2128.control.manual_operate := TRUE;
		EDTTV0904A.control.manual_operate := TRUE;
		EDTXV0912.control.manual_operate := TRUE;
		EDTR17B.control.manual_operate := TRUE;
		EDTXV2127.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP3S3B.input.error_signal := (EDTP34.status.motor_status >= 2) OR (EDTXV0925.status.valve_status >= 2) OR
	(EDTXV2121.status.valve_status >= 2) OR (EDTXV2119.status.valve_status >= 2) OR (EDTXV2126.status.valve_status >= 2) OR
	(EDTTV0903C.status.valve_status >= 2) OR (EDTTV0903D.status.valve_status >= 2) OR (EDTXV2128.status.valve_status >= 2) OR (EDTTV0904A.status.valve_status >= 2) OR
	(EDTTV0903E.status.valve_status >= 2) OR (EDTTV0903F.status.valve_status >= 2) OR (EDTTV0903A.status.valve_status >= 2) OR (EDTXV2127.status.valve_status >= 2) OR
	(EDTTV0903B.status.valve_status >= 2) OR (EDTXV0924.status.valve_status >= 2) OR (EDTXV2118.status.valve_status >= 2) OR (EDTXV0912.status.valve_status >= 2) OR
	(EDTR17B.status.motor_status >= 2);

	
	IF EDTP3S3B.status.run_state = 1 THEN
		CASE EDTP3S3B.status.run_step OF 
			0:	
				IF NOT EDTP3S3B_STEP[0].done THEN
					EDTXV0925.control.auto_operate := TRUE;
					EDTXV2121.control.auto_operate := TRUE;
					EDTXV2119.control.auto_operate := TRUE;
					EDTXV2126.control.auto_operate := TRUE;
					EDTP34.control.auto_operate := TRUE;
					EDTTV0903C.control.auto_operate := TRUE;
					EDTTV0903D.control.auto_operate := TRUE;
					EDTTV0903E.control.auto_operate := TRUE;
					EDTTV0903F.control.auto_operate := TRUE;
					EDTTV0903A.control.auto_operate := TRUE;
					EDTTV0903B.control.auto_operate := TRUE;
					EDTXV0924.control.auto_operate := TRUE;
					EDTXV2118.control.auto_operate := TRUE;	
					EDTXV2128.control.auto_operate := TRUE;
					EDTTV0904A.control.auto_operate := TRUE;
					EDTXV0912.control.auto_operate := TRUE;
					EDTR17B.control.auto_operate := TRUE;
					EDTXV2127.control.auto_operate := TRUE;
					EDTP3S3B_STEP[0].done := TRUE;
				END_IF;
			1:
				EDTR17B.input.auto_run_signal := TRUE;
				EDTXV0925.input.auto_open_signal := FALSE;
				EDTXV2121.input.auto_open_signal := TRUE;
				EDTXV2119.input.auto_open_signal := TRUE;
				EDTXV2126.input.auto_open_signal := TRUE;
				IF EDTR17B.input.run_feedback AND EDTXV0925.input.close_feedback_state AND EDTXV2121.input.open_feedback_state AND EDTXV2119.input.open_feedback_state AND EDTXV2126.input.open_feedback_state THEN
					EDTP3S3B_STEP[1].done := TRUE;
				END_IF;
			2:
				//现场确认P34循环水手阀开启
				EDTXV2127.input.auto_open_signal := TRUE;
			3:
				EDTP34.input.auto_run_signal := TRUE;
				IF EDTP34.input.run_feedback THEN
					EDTP3S3B_STEP[3].done := TRUE;
				END_IF;
			4:
				CASE p3_step3_4b OF
					0:
						IF NOT EDTP3S3B_STEP[4].done THEN
							p3_step3_4b := 1;
						END_IF;
					1:
						IF EDTPIT0904.status.value <= EDTP3S3_PARA_P2 THEN
							p3_step3_4b := 2;
						END_IF;
					2:
						HeatPot_17(ST1 := DINT_TO_TIME(EDTP3S3_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP3S3_PARA_T2 * 1000),
						V3 := EDTTV0903C,
						V4 := EDTTV0903D,
						V5 := EDTTV0903E,
						V6 := EDTTV0903F,
						done := p3_step3_4b_1_done);
						IF p3_step3_4b_1_done THEN
							p3_step3_4b_1_done := FALSE;
							p3_step3_4b := 3;
						END_IF;
					3:
						IF EDTTIT0903.status.value >= EDTP3S3_PARA_Temp1 THEN
							p3_step3_4b := 4;
						END_IF;
					4:
						EDTTV0903C.input.auto_open_signal := FALSE;
						IF EDTTV0903C.input.close_feedback_state THEN
							p3_step3_4b := 5;
						END_IF;
					5:
						TON_22.PT := DINT_TO_TIME(EDTP3S3_PARA_T3 * 60 * 1000);
						TON_22.IN := TRUE;
						IF TON_22.Q THEN
							TON_22.IN := FALSE;
							p3_step3_4b := 6;
						END_IF;
					6:
						IF (NOT EDTP3S3A.status.run_state) AND (NOT EDTP3S3C.status.run_state) THEN
							p3_step3_4b := 7;
						ELSIF EDTP3S3A.status.run_state AND (NOT EDTP3S3C.status.run_state) THEN
							IF p3_step3_4a >= 6 THEN
								p3_step3_4b := 7;
							END_IF;
						ELSIF (NOT EDTP3S3A.status.run_state) AND  EDTP3S3C.status.run_state THEN
							IF p3_step3_4c >= 6 THEN
								p3_step3_4b := 7;
							END_IF;
						ELSIF EDTP3S3A.status.run_state AND EDTP3S3C.status.run_state THEN
							IF (p3_step3_4a >= 6) AND (p3_step3_4c >= 6) THEN
								p3_step3_4b := 7;
							END_IF;
						END_IF;
					7:
						CoolPot_10(
							time := cool_pot_time,
							V1 := EDTTV0903A,
							V2 := EDTTV0903B,
							V3 := EDTTV0903F,
							V4 := EDTTV0903D,
							V5 := EDTTV0903E,
							done := p3_step3_4b_5_done);
						IF p3_step3_4b_5_done THEN
							p3_step3_4b_5_done := FALSE;
							p3_step3_4b := 8;
						END_IF;
					8:
						IF EDTTIT0903.status.value <= EDTP3S3_PARA_Temp2 THEN
							EDTXV2121.input.auto_open_signal := FALSE;
							IF EDTXV2121.input.close_feedback_state THEN
								EDTXV0924.input.auto_open_signal := TRUE;
								EDTXV2118.input.auto_open_signal := TRUE;
								IF EDTXV0924.input.open_feedback_state AND EDTXV2118.input.open_feedback_state THEN
									p3_step3_4b := 9;
								END_IF;
							END_IF;
						END_IF;
					9:
						IF EDTPIT0904.status.value >= EDTP3S3_PARA_P1 THEN
							p3_step3_4b := 10;
						END_IF;
					10:
						EDTXV2118.input.auto_open_signal := FALSE;
						EDTXV0924.input.auto_open_signal := FALSE;
						EDTXV0925.input.auto_open_signal := TRUE;
						EDTTV0903A.input.auto_open_signal := FALSE;
						EDTTV0903B.input.auto_open_signal := FALSE;
						IF EDTXV2118.input.close_feedback_state AND EDTXV0924.input.close_feedback_state AND EDTXV0925.input.open_feedback_state AND EDTTV0903A.input.close_feedback_state AND EDTTV0903B.input.close_feedback_state THEN
							p3_step3_4b := 11;
						END_IF;
					11:
						EDTP34.input.auto_run_signal := FALSE;
						EDTXV2119.input.auto_open_signal := FALSE;
						EDTXV2126.input.auto_open_signal := FALSE;
						EDTXV2128.input.auto_open_signal := FALSE;
						EDTTV0904A.input.auto_open_signal := FALSE;
						EDTXV0912.input.auto_open_signal := FALSE;
						EDTR17B.input.auto_run_signal := FALSE;
						IF EDTXV0912.input.close_feedback_state AND EDTXV2128.input.close_feedback_state AND EDTTV0904A.input.close_feedback_state 
							AND EDTXV2119.input.close_feedback_state AND EDTXV2126.input.close_feedback_state AND (NOT EDTP34.input.run_feedback) AND (NOT EDTR17B.input.run_feedback) THEN
							EDTP3S3B_STEP[4].done := TRUE;
							p3_step3_4b := 0;
						END_IF;
				END_CASE;
				TON_22();
			5:
			//现场关闭P34循环水手阀
			EDTXV2127.input.auto_open_signal := FALSE;
		END_CASE;		
	END_IF;
	
	
	//人工确认步骤可用
	IF (EDTP3S3B.status.run_state) AND (NOT EDTP3S3B_STEP[EDTP3S3B.status.run_step].done AND ((EDTP3S3B.status.run_step = 2) OR (EDTP3S3B.status.run_step = 5))) THEN
		EDTP3S3B.status.confirm_enable := TRUE;
	ELSE
		EDTP3S3B.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
