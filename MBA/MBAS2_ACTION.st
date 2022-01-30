
ACTION S2_ACT: 
	//设定时间
	FOR i := 0 TO MBAS2_STEP_NUM DO
		IF MBAS2_ST[i] < T#5s THEN
			MBAS2_ST[i] := T#5s;
		END_IF;
		MBAS2_STEP[i].set_time := MBAS2_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(MBAS2,MBAS2_STEP[0],MBAS2_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS2.status.mode <> 0) AND (NOT MBAS2.auto_mode_edge) THEN
		MBAS2.auto_mode_edge := TRUE;
		MBAS2.manual_mode_edge := FALSE;
		
		MBALV0201.control.auto_operate := TRUE;
		STFLV0101.control.auto_operate := TRUE;
		STFLV0102.control.auto_operate := TRUE;
		STFP01.control.auto_operate := TRUE;
		MBAR03.control.auto_operate := TRUE;
		MBAXV0208.control.auto_operate := TRUE;
		MBATV0201B.control.auto_operate := TRUE;
		MBATV0201C.control.auto_operate := TRUE;
		MBATV0201F.control.auto_operate := TRUE;
		MBATV0201E.control.auto_operate := TRUE;
		MBAFQV0201.control.auto_operate := TRUE;
		MBAXV0207.control.auto_operate := TRUE;
		MBAXV1102.control.auto_operate := TRUE;
		MBAXV0209.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS2.status.mode = 0) AND (NOT MBAS2.manual_mode_edge) THEN
		MBAS2.manual_mode_edge := TRUE;
		MBAS2.auto_mode_edge := FALSE;

		MBALV0201.control.manual_operate := TRUE;
		STFLV0101.control.manual_operate := TRUE;
		STFLV0102.control.manual_operate := TRUE;
		STFP01.control.manual_operate := TRUE;
		MBAR03.control.manual_operate := TRUE;
		MBAXV0208.control.manual_operate := TRUE;
		MBATV0201B.control.manual_operate := TRUE;
		MBATV0201C.control.manual_operate := TRUE;
		MBATV0201F.control.manual_operate := TRUE;
		MBATV0201E.control.manual_operate := TRUE;
		MBAFQV0201.control.manual_operate := TRUE;
		MBAXV0207.control.manual_operate := TRUE;
		MBAXV1102.control.manual_operate := TRUE;
		MBAXV0209.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS2.input.error_signal := (MBALV0201.status.valve_status >= 2) OR (STFLV0101.status.valve_status >= 2) OR
	(STFLV0102.status.valve_status >= 2) OR (STFP01.status.motor_status >= 2) OR (MBAR03.status.motor_status >= 2) OR
	(MBAXV0208.status.valve_status >= 2) OR (MBATV0201B.status.valve_status >= 2) OR (MBATV0201C.status.valve_status >= 2) OR
	(MBATV0201F.status.valve_status >= 2) OR (MBATV0201E.status.valve_status >= 2) OR (MBAFQV0201.status.valve_status >= 2) OR
	(MBAXV0207.status.valve_status >= 2) OR (MBAXV1102.status.valve_status >= 2) OR (MBAXV0209.status.valve_status >= 2);
	
	IF MBAS2.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS2.status.run_step OF 
			0:
				IF NOT MBAS2_STEP[0].done THEN
					MBALV0201.control.auto_operate := TRUE;
					STFLV0101.control.auto_operate := TRUE;
					STFLV0102.control.auto_operate := TRUE;
					STFP01.control.auto_operate := TRUE;
					MBAR03.control.auto_operate := TRUE;
					MBAXV0208.control.auto_operate := TRUE;
					MBATV0201B.control.auto_operate := TRUE;
					MBATV0201C.control.auto_operate := TRUE;
					MBATV0201F.control.auto_operate := TRUE;
					MBATV0201E.control.auto_operate := TRUE;
					MBAFQV0201.control.auto_operate := TRUE;
					MBAXV0207.control.auto_operate := TRUE;
					MBAXV1102.control.auto_operate := TRUE;
					MBAXV0209.control.auto_operate := TRUE;
					MBAS2_STEP[0].done := TRUE;
				END_IF;
			1:
				CASE step2_1 OF
					0:
						IF NOT MBAS2_STEP[1].done THEN
							step2_1 := 1;
						END_IF;
					1:
						IF MBALIT0201.status.value <= MBAS2_PARA_L2 THEN
							step2_1 := 2;
						ELSE
							step2_1 := 6;
						END_IF;
					2:
						MBALV0201.input.auto_open_signal := TRUE;
						STFLV0101.input.auto_open_signal := FALSE;
						STFLV0102.input.auto_open_signal := FALSE;
						IF STFLV0101.input.close_feedback_state AND STFLV0102.input.close_feedback_state AND MBALV0201.input.open_feedback_state THEN
							step2_1 := 3;
						END_IF;
					3:
						LiquidAdd_3(level_value := MBALIT0201.status.value,
						sp_value := MBAS2_PARA_L1, 
						sp_accumulation := MBAS2_PARA_AC1,
						sp_time := DINT_TO_TIME(MBAS2_PARA_T1 * 1000),
						flowmeter := STFFQIT0102,
						done := step2_1_3_done);
						STFP01.input.auto_run_signal := LiquidAdd_3.run;
						IF step2_1_3_done AND (NOT STFP01.input.run_feedback) AND (NOT STFP01.input.auto_run_signal) THEN
							step2_1 := 4;
						END_IF;
					4:
						IF STFFQIT0102.flowrate <= flowrate_threshold THEN
							step2_1 := 5;
						END_IF;
					5:
						MBALV0201.input.auto_open_signal := FALSE;
						IF MBALV0201.input.close_feedback_state THEN
							step2_1 := 6;
						END_IF;
					6:
						step2_1_3_done := FALSE;
						step2_1 := 0;
						MBAS2_STEP[1].done := TRUE;
				END_CASE;
			2:
				MBAR03.input.auto_run_signal := TRUE;
				IF MBAR03.input.run_feedback THEN
					MBAS2_STEP[2].done := TRUE;
				END_IF;
			3:
				LiquidRelease_4(sp_time := DINT_TO_TIME(MBAS2_PARA_T2 * 60 * 1000),
				level_value := MBALIT0201.status.value,
				set_point := MBAS2_PARA_L2,
				done := MBAS2_STEP[3].done);
				MBAXV0208.input.auto_open_signal := LiquidRelease_4.run;	
			4:
				CASE step2_4 OF
					0:
						IF NOT MBAS2_STEP[4].done THEN
							step2_4 := 1;
						END_IF;
					1:
						HeatPot_0(ST1 := DINT_TO_TIME(MBAS2_PARA_T3 * 1000),
						ST2 := DINT_TO_TIME(MBAS2_PARA_T4 * 1000),
						V3 := MBATV0201B,
						V4 := MBATV0201C,
						V5 := MBATV0201F,
						V6 := MBATV0201E,
						done := step2_4_1_done);
						IF step2_4_1_done THEN
							step2_4 := 2;
						END_IF;
					2:
						IF MBATIT0201.status.value >= MBAS2_PARA_Temp1 THEN
							MBATV0201B.input.auto_open_signal := FALSE;
							step2_4 := 3;
						END_IF;
					3:
						IF MBATIT0201.status.value >= MBAS2_PARA_Temp2 THEN
							step2_4 := 4;
						END_IF;
					4:
						TON_1.PT := DINT_TO_TIME(MBAS2_PARA_T5 * 60 * 1000);
						TON_1.IN := TRUE;
						IF TON_1.Q THEN
							TON_1.IN := FALSE;
							step2_4 := 5;
						END_IF;
					5:
						MBATV0201C.input.auto_open_signal := FALSE;
						IF MBATV0201C.input.close_feedback_state THEN
							step2_4 := 0;
							step2_4_1_done := FALSE;
							MBAS2_STEP[4].done := TRUE;
						END_IF;
				END_CASE;
				TON_1();
			5:
				LiquidTransfer_1(sp_time := DINT_TO_TIME(MBAS2_PARA_T6 * 1000),
				sp_accumulation := MBAS2_PARA_AC2,
				done := MBAS2_STEP[5].done,
				flowmeter := MBAFQIT0503);
				MBAFQV0201.input.auto_open_signal := LiquidTransfer_1.run;
			6:	
				//确认R13空闲
			7:
				MBAR03.input.auto_run_signal := FALSE;
				MBAXV1102.input.auto_open_signal := TRUE;
				IF (NOT MBAR03.input.run_feedback) AND MBAXV1102.input.open_feedback_state THEN
					MBAXV0207.input.auto_open_signal := TRUE;
					MBAS2_STEP[7].done := TRUE;
				END_IF;
			8:
				//确认转移完毕
			9:
				CASE step2_9 OF
					0:
						IF NOT MBAS2_STEP[9].done THEN
							step2_9 := 1;
						END_IF;
					1:
						LiquidTransfer_0(sp_time := DINT_TO_TIME(MBAS2_PARA_T7 * 1000),
						sp_accumulation := MBAS2_PARA_AC3,
						done := step2_9_1_done,
						flowmeter := MBAFQIT0503);
						MBAFQV0201.input.auto_open_signal := LiquidTransfer_0.run;
						IF step2_9_1_done AND MBAFQV0201.input.close_feedback_state AND (NOT MBAFQV0201.input.auto_open_signal) THEN
							step2_9 := 2;
						END_IF;
					2:
						TON_0.PT := DINT_TO_TIME(MBAS2_PARA_T8 * 1000);
						TON_0.IN := TRUE;
						IF TON_0.Q THEN
							TON_0.IN := FALSE;
							step2_9 := 3;
						END_IF;
					3:
						MBAXV0207.input.auto_open_signal := FALSE;
						MBAXV0209.input.auto_open_signal := FALSE;
						MBATV0201F.input.auto_open_signal := FALSE;
						IF MBAXV0207.input.close_feedback_state AND MBAXV0209.input.close_feedback_state AND MBATV0201F.input.close_feedback_state THEN
							step2_9 := 0;
							step2_9_1_done := FALSE;
							MBAS2_STEP[9].done := TRUE;
						END_IF;
				END_CASE;
				TON_0();
			10:
			//清理过滤器
		END_CASE;			
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS2.status.run_state) AND (NOT MBAS2_STEP[MBAS2.status.run_step].done AND ((MBAS2.status.run_step = 6) OR (MBAS2.status.run_step = 8) OR (MBAS2.status.run_step = 10))) THEN
		MBAS2.status.confirm_enable := TRUE;
	ELSE
		MBAS2.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
