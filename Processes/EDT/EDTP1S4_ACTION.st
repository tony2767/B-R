
ACTION P1S4_ACT: 
	//设定时间
	FOR i := 0 TO EDTP1S4_STEP_NUM DO
		IF EDTP1S4_ST[i] < T#5s THEN
			EDTP1S4_ST[i] := T#5s;
		END_IF;
		EDTP1S4_STEP[i].set_time := EDTP1S4_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP1S4,EDTP1S4_STEP[0],EDTP1S4_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP1S4.status.mode <> 0) AND (NOT EDTP1S4.auto_mode_edge) THEN
		EDTP1S4.auto_mode_edge := TRUE;
		EDTP1S4.manual_mode_edge := FALSE;

		EDTLV0401.control.auto_operate := TRUE;
		STFP14.control.auto_operate := TRUE;
		STFLV1401.control.auto_operate := TRUE;
		STFLV1402.control.auto_operate := TRUE;
		EDTXV0404.control.auto_operate := TRUE;
		EDTXV0405.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP1S4.status.mode = 0) AND (NOT EDTP1S4.manual_mode_edge) THEN
		EDTP1S4.manual_mode_edge := TRUE;
		EDTP1S4.auto_mode_edge := FALSE;
		
		EDTLV0401.control.manual_operate := TRUE;
		STFP14.control.manual_operate := TRUE;
		STFLV1401.control.manual_operate := TRUE;
		STFLV1402.control.manual_operate := TRUE;
		EDTXV0404.control.manual_operate := TRUE;
		EDTXV0405.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP1S4.input.error_signal := (EDTXV0405.status.valve_status >= 2) OR (EDTXV0404.status.valve_status >= 2) OR (EDTLV0401.status.valve_status >= 2) OR
	(STFLV1401.status.valve_status >= 2) OR (STFLV1402.status.valve_status >= 2) OR (STFP14.status.motor_status >= 2);
	
	IF EDTP1S4.status.run_state = 1 THEN
		CASE EDTP1S4.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP1S4_STEP[0].done THEN
					EDTLV0401.control.auto_operate := TRUE;
					STFP14.control.auto_operate := TRUE;
					STFLV1401.control.auto_operate := TRUE;
					STFLV1402.control.auto_operate := TRUE;
					EDTXV0404.control.auto_operate := TRUE;
					EDTXV0405.control.auto_operate := TRUE;
					EDTP1S4_STEP[0].done := TRUE;
				END_IF;
		END_CASE;
	END_IF;
	
	//人工确认步骤可用
//	IF (EDTP1S4.status.run_step = 1) OR (EDTP1S4.status.run_step = 5) THEN
//		EDTP1S4.status.confirm_enable := TRUE;
//	ELSE
//		EDTP1S4.status.confirm_enable := FALSE;
//	END_IF;
	


	
	//v07放料
	IF v07_release_start THEN
		CASE v07_release_step OF
			0:
				EDTXV0404.control.auto_operate := TRUE;
				EDTXV0405.control.auto_operate := TRUE;
				
				EDTXV0405.input.auto_open_signal := TRUE;
				IF EDTXV0405.input.open_feedback_state THEN
					EDTXV0404.input.auto_open_signal := TRUE;
					IF EDTXV0404.input.open_feedback_state THEN
						v07_release_step := 1;
					END_IF;
				END_IF;
			1:
				TON_6.PT := DINT_TO_TIME(EDTP1S4_PARA_T1 * 60 * 1000);
				TON_6.IN := TRUE;
				IF TON_6.Q AND (EDTLIT0401.status.value <= 0.0) THEN
					TON_6.IN := FALSE;
					v07_release_step := 2;
				END_IF;
			2:
				EDTXV0404.input.auto_open_signal := FALSE;
				EDTXV0405.input.auto_open_signal := FALSE;
				IF EDTXV0404.input.close_feedback_state AND EDTXV0405.input.close_feedback_state THEN
					v07_release_step := 3;
				END_IF;
			3:
				v07_release_step := 0;
				v07_release_start := FALSE;
		END_CASE;
		TON_6();
	END_IF;
	
	//v07进料
	IF v07_add_start THEN
		CASE v07_add_step OF
			0:
				EDTLV0401.control.auto_operate := TRUE;
				STFP14.control.auto_operate := TRUE;
				STFLV1401.control.auto_operate := TRUE;
				STFLV1402.control.auto_operate := TRUE;
				EDTXV0404.control.auto_operate := TRUE;
				EDTXV0405.control.auto_operate := TRUE;
				
				EDTLV0401.input.auto_open_signal := TRUE;
				EDTXV0405.input.auto_open_signal := TRUE;
				STFLV1401.input.auto_open_signal := TRUE;
				STFLV1402.input.auto_open_signal := FALSE;
				IF EDTLV0401.input.open_feedback_state AND EDTXV0405.input.open_feedback_state AND
					STFLV1401.input.open_feedback_state AND STFLV1402.input.close_feedback_state THEN
					v07_add_step := 1;
				END_IF;
			1:
				LiquidAdd_4(level_value := EDTLIT0401.status.value,
				sp_value := EDTP1S4_PARA_L1,
				sp_accumulation := EDTP1S4_PARA_AC1,
				sp_time := DINT_TO_TIME(EDTP1S4_PARA_T2 * 1000),
				flowmeter := STFFQIT1402,
				done := v07_add_done);
				STFP14.input.auto_run_signal := LiquidAdd_4.run;
				IF v07_add_done AND (NOT STFP14.input.run_feedback) AND (NOT STFP14.input.auto_run_signal) THEN
					v07_add_step := 2;
				END_IF;
			2:
				IF STFFQIT1402.flowrate <= flowrate_threshold THEN
					EDTLV0401.input.auto_open_signal := FALSE;
					EDTXV0405.input.auto_open_signal := FALSE;
					v07_add_step := 3;
				END_IF;
			3:
				v07_add_step := 0;
				v07_add_done := FALSE;
				v07_add_start := FALSE;
		END_CASE;
	END_IF;
END_ACTION
