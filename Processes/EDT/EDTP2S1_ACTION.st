
ACTION P2S1_ACT: 
	//设定时间
	FOR i := 0 TO EDTP2S1_STEP_NUM DO
		IF EDTP2S1_ST[i] < T#5s THEN
			EDTP2S1_ST[i] := T#5s;
		END_IF;
		EDTP2S1_STEP[i].set_time := EDTP2S1_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP2S1,EDTP2S1_STEP[0],EDTP2S1_STEP_NUM);

	//object 手自动切换
	IF (EDTP2S1.status.mode <> 0) AND (NOT EDTP2S1.auto_mode_edge) THEN
		EDTP2S1.auto_mode_edge := TRUE;
		EDTP2S1.manual_mode_edge := FALSE;
		
		EDTPV0501.control.auto_operate := TRUE;
		EDTXV0508.control.auto_operate := TRUE;
		EDTXV0501.control.auto_operate := TRUE;
		EDTXV0504.control.auto_operate := TRUE;
		EDTR01.control.auto_operate := TRUE;
		EDTFQV0501.control.auto_operate := TRUE;
		EDTP06.control.auto_operate := TRUE;	
		EDTP05.control.auto_operate := TRUE;
		EDTXV0503.control.auto_operate := TRUE;
		EDTXV0507.control.auto_operate := TRUE;
		EDTXV0505.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP2S1.status.mode = 0) AND (NOT EDTP2S1.manual_mode_edge) THEN
		EDTP2S1.manual_mode_edge := TRUE;
		EDTP2S1.auto_mode_edge := FALSE;

		EDTPV0501.control.manual_operate := TRUE;
		EDTXV0508.control.manual_operate := TRUE;
		EDTXV0501.control.manual_operate := TRUE;
		EDTXV0504.control.manual_operate := TRUE;
		EDTR01.control.manual_operate := TRUE;
		EDTFQV0501.control.manual_operate := TRUE;
		EDTP06.control.manual_operate := TRUE;	
		EDTP05.control.manual_operate := TRUE;
		EDTXV0503.control.manual_operate := TRUE;
		EDTXV0507.control.manual_operate := TRUE;
		EDTXV0505.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP2S1.input.error_signal := (EDTPV0501.status.valve_status >= 2) OR (EDTXV0508.status.valve_status >= 2) OR
	(EDTXV0501.status.valve_status >= 2) OR (EDTXV0504.status.valve_status >= 2) OR (EDTR01.status.motor_status >= 2) OR
	(EDTFQV0501.status.valve_status >= 2) OR (EDTP06.status.motor_status >= 2) OR (EDTP05.status.motor_status >= 2) OR
	(EDTXV0503.status.valve_status >= 2) OR (EDTXV0507.status.valve_status >= 2) OR (EDTXV0505.status.valve_status >= 2);	
	
	IF EDTP2S1.status.run_state = 1 THEN
		CASE EDTP2S1.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP2S1_STEP[0].done THEN
					EDTPV0501.control.auto_operate := TRUE;
					EDTXV0508.control.auto_operate := TRUE;
					EDTXV0501.control.auto_operate := TRUE;
					EDTXV0504.control.auto_operate := TRUE;
					EDTR01.control.auto_operate := TRUE;
					EDTFQV0501.control.auto_operate := TRUE;
					EDTP06.control.auto_operate := TRUE;	
					EDTP05.control.auto_operate := TRUE;
					EDTXV0503.control.auto_operate := TRUE;
					EDTXV0507.control.auto_operate := TRUE;
					EDTXV0505.control.auto_operate := TRUE;
					EDTP2S1_STEP[0].done := TRUE;
				END_IF;
			1:
				//确认V17液位
			2:
				CASE p2_step1_2 OF
					0:
						IF NOT EDTP2S1_STEP[2].done THEN
							p2_step1_2 := 1;
						END_IF;
					1:
						EDTXV0508.input.auto_open_signal := TRUE;
						EDTXV0504.input.auto_open_signal := TRUE;
						EDTXV0501.input.auto_open_signal := TRUE;
						IF EDTXV0508.input.open_feedback_state AND EDTXV0504.input.open_feedback_state AND EDTXV0501.input.open_feedback_state THEN
							p2_step1_2 := 2;
						END_IF;
					2:
						EDTFQV0501.input.auto_open_signal := TRUE;
						IF EDTFQV0501.input.open_feedback_state THEN
							p2_step1_2 := 3;
						END_IF;
					3:
						LiquidReleaseAdvanced_0(sp_time := DINT_TO_TIME(EDTP2S1_PARA_T1 * 1000),
						level_value := EDTLIT0604.status.value,
						set_point := EDTP2S1_PARA_L1,
						sp_accumulation := EDTP2S1_PARA_AC1,
						flowmeter := EDTFQIT0501,
						done := p2_step1_2_3_done);
						EDTP06.input.auto_run_signal := LiquidReleaseAdvanced_0.run;
						IF (NOT EDTP06.input.run_feedback) AND p2_step1_2_3_done AND (NOT EDTP06.input.auto_run_signal) THEN
							p2_step1_2_3_done := FALSE;
							p2_step1_2 := 4;
						END_IF;
					4:
						IF EDTFQIT0501.flowrate <= flowrate_threshold THEN
							EDTFQV0501.input.auto_open_signal := FALSE;
						END_IF;
						IF EDTFQV0501.input.close_feedback_state THEN
							p2_step1_2 := 5;
						END_IF;
					5:
						EDTXV0508.input.auto_open_signal := FALSE;
						IF EDTXV0508.input.close_feedback_state THEN
							EDTP2S1_STEP[2].done := TRUE;
							p2_step1_2 := 0;
						END_IF;
				END_CASE;
			3:
				EDTR01.input.auto_run_signal := TRUE;
				IF EDTTIT0501.status.value <= EDTP2S1_PARA_Temp1 THEN
					EDTXV0503.input.auto_open_signal := TRUE;
					IF EDTXV0503.input.open_feedback_state THEN
						EDTP05.input.auto_run_signal := TRUE;
						IF EDTP05.input.run_feedback THEN
							EDTP2S1_STEP[3].done := TRUE;
						END_IF;
					END_IF;
				END_IF;
			4:
				//人工抽入甲醇钠,此时需控制温度
				IF EDTTIT0501.status.value >= EDTP2S1_PARA_Temp2 THEN
					EDTXV0503.input.auto_open_signal := FALSE;
				END_IF;
				IF EDTTIT0501.status.value <= EDTP2S1_PARA_Temp3 THEN
					EDTXV0503.input.auto_open_signal := TRUE;
				END_IF;
			5:
				CASE p2_step1_5 OF
					0:
						IF NOT EDTP2S1_STEP[5].done THEN
							p2_step1_5 := 1;
						END_IF;
					1:
						EDTXV0501.input.auto_open_signal := FALSE;
						EDTXV0503.input.auto_open_signal := FALSE;
						EDTP05.input.auto_run_signal := FALSE;
						EDTPV0501.input.auto_open_signal := TRUE;
						p2_step1_5 := 2;
					2:
						IF EDTPIT0501.status.value >= EDTP2S1_PARA_P1 THEN
							EDTPV0501.input.auto_open_signal := FALSE;
							p2_step1_5 := 3;
						END_IF;
					3:
						TON_11.IN := TRUE;
						TON_11.PT := DINT_TO_TIME(EDTP2S1_PARA_T2 * 60 * 1000);
						IF TON_11.Q THEN
							TON_11.IN := FALSE;
							p2_step1_5 := 4;
						END_IF;
					4:
						EDTR01.input.auto_run_signal := FALSE;
						EDTXV0504.input.auto_open_signal := FALSE;
						p2_step1_5 := 0;
						EDTP2S1_STEP[5].done := TRUE;
				END_CASE;
				TON_11();
			6:
				//确认V13可以进料
			7:
				IF NOT EDTP2S1_STEP[7].done THEN
					EDTXV0507.input.auto_open_signal := TRUE;
					IF EDTPIT0501.status.value <= EDTP2S1_PARA_P2 THEN
						EDTPV0501.input.auto_open_signal := TRUE;
					END_IF;
					IF EDTPIT0501.status.value >= EDTP2S1_PARA_P3 THEN
						EDTPV0501.input.auto_open_signal := FALSE;
					END_IF;
				ELSE
					EDTXV0507.input.auto_open_signal := FALSE;
					EDTPV0501.input.auto_open_signal := FALSE;
				END_IF;
			8:
			//清理
		END_CASE;		
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP2S1.status.run_state) AND (NOT EDTP2S1_STEP[EDTP2S1.status.run_step].done AND ((EDTP2S1.status.run_step = 1) OR (EDTP2S1.status.run_step = 4) OR (EDTP2S1.status.run_step = 6)
		OR (EDTP2S1.status.run_step = 7) OR (EDTP2S1.status.run_step = 8))) THEN
		EDTP2S1.status.confirm_enable := TRUE;
	ELSE
		EDTP2S1.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
