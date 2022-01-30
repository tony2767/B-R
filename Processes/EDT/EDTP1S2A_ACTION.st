
ACTION P1S2A_ACT: 
	//设定时间
	FOR i := 0 TO EDTP1S2_STEP_NUM DO
		IF EDTP1S2A_ST[i] < T#5s THEN
			EDTP1S2A_ST[i] := T#5s;
		END_IF;
		EDTP1S2A_STEP[i].set_time := EDTP1S2A_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP1S2A,EDTP1S2A_STEP[0],EDTP1S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP1S2A.status.mode <> 0) AND (NOT EDTP1S2A.auto_mode_edge) THEN
		
		EDTP1S2A.auto_mode_edge := TRUE;
		EDTP1S2A.manual_mode_edge := FALSE;
		
		EDTP01.control.auto_operate := TRUE;
		EDTXV0205.control.auto_operate := TRUE;
		STFLV0701.control.auto_operate := TRUE;
		STFLV0702.control.auto_operate := TRUE;
		EDTLV0201.control.auto_operate := TRUE;
		STFP07.control.auto_operate := TRUE;
		EDTR07A.control.auto_operate := TRUE;
		EDTTV0201A.control.auto_operate := TRUE;
		EDTTV0201B.control.auto_operate := TRUE;
		EDTXV0201.control.auto_operate := TRUE;
		EDTXV0204.control.auto_operate := TRUE;
		EDTXV0505.control.auto_operate := TRUE;
		EDTFQV0203A.control.auto_operate := TRUE;
		EDTP26.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP1S2A.status.mode = 0) AND (NOT EDTP1S2A.manual_mode_edge) THEN
		
		EDTP1S2A.manual_mode_edge := TRUE;
		EDTP1S2A.auto_mode_edge := FALSE;
		
		EDTP01.control.manual_operate := TRUE;
		EDTXV0205.control.manual_operate := TRUE;
		STFLV0701.control.manual_operate := TRUE;
		STFLV0702.control.manual_operate := TRUE;
		EDTLV0201.control.manual_operate := TRUE;
		STFP07.control.manual_operate := TRUE;
		EDTR07A.control.manual_operate := TRUE;
		EDTTV0201A.control.manual_operate := TRUE;
		EDTTV0201B.control.manual_operate := TRUE;
		EDTXV0201.control.manual_operate := TRUE;
		EDTXV0204.control.manual_operate := TRUE;
		EDTXV0505.control.manual_operate := TRUE;
		EDTFQV0203A.control.manual_operate := TRUE;
		EDTP26.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP1S2A.input.error_signal := (EDTP01.status.motor_status >= 2) OR (EDTXV0205.status.valve_status >= 2) OR 
	(STFLV0701.status.valve_status >= 2) OR (STFLV0702.status.valve_status >= 2) OR (EDTLV0201.status.valve_status >= 2) OR
	(STFP07.status.motor_status >= 2) OR (EDTR07A.status.motor_status >= 2) OR 
	(EDTTV0201A.status.valve_status >= 2) OR (EDTTV0201B.status.valve_status >= 2) OR (EDTXV0201.status.valve_status >= 2) OR
	(EDTP26.status.motor_status >= 2) OR (EDTFQV0203A.status.valve_status >= 2) OR (EDTXV0505.status.valve_status >= 2) OR
	(EDTXV0204.status.valve_status >= 2);
	

	IF EDTP1S2A.status.run_state = 1 THEN
		CASE EDTP1S2A.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP1S2A_STEP[0].done THEN
					EDTP01.control.auto_operate := TRUE;
					EDTXV0205.control.auto_operate := TRUE;
					STFLV0701.control.auto_operate := TRUE;
					STFLV0702.control.auto_operate := TRUE;
					EDTLV0201.control.auto_operate := TRUE;
					STFP07.control.auto_operate := TRUE;
					EDTR07A.control.auto_operate := TRUE;
					EDTTV0201A.control.auto_operate := TRUE;
					EDTTV0201B.control.auto_operate := TRUE;
					EDTXV0201.control.auto_operate := TRUE;
					EDTXV0204.control.auto_operate := TRUE;
					EDTXV0505.control.auto_operate := TRUE;
					EDTFQV0203A.control.auto_operate := TRUE;
					EDTP26.control.auto_operate := TRUE;
					EDTP1S2A_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工确认投料
			2:
				//滴加
				CASE p1_step2_2a OF
					0:
						IF NOT EDTP1S2A_STEP[2].done THEN
							p1_step2_2a := 1;
						END_IF;
					1:
						EDTXV0201.input.auto_open_signal := TRUE;
						EDTR07A.input.auto_run_signal := TRUE;
						IF EDTXV0201.input.open_feedback_state AND EDTR07A.input.run_feedback THEN
							p1_step2_2a := 2;
						END_IF;
					2:
						IF EDTTIT0201.status.value <= EDTP1S2_PARA_Temp1 THEN
							p1_step2_2a := 3;
						END_IF;
					3:
						TON_2.PT := DINT_TO_TIME(EDTP1S2_PARA_T5 * 60 * 1000);
						TON_2.IN := TRUE;
						IF EDTTIT0201.status.value <= EDTP1S2_PARA_Temp2 THEN
							EDTTV0201A.input.auto_open_signal := TRUE;
							EDTTV0201B.input.auto_open_signal := TRUE;
						END_IF;
						IF EDTTIT0201.status.value >= EDTP1S2_PARA_Temp3 THEN
							EDTTV0201A.input.auto_open_signal := FALSE;
							EDTTV0201B.input.auto_open_signal := FALSE;
						END_IF;
						IF TON_2.Q THEN
							TON_2.IN := FALSE;
							EDTXV0201.input.auto_open_signal := FALSE;
							EDTTV0201A.input.auto_open_signal := TRUE;
							EDTTV0201B.input.auto_open_signal := TRUE;
							p1_step2_2a := 4;
						END_IF;
					4:
						TON_2.PT := DINT_TO_TIME(EDTP1S2_PARA_T6 * 60 * 1000);
						TON_2.IN := TRUE;
						IF TON_2.Q THEN
							TON_2.IN := FALSE;
							EDTTV0201A.input.auto_open_signal := FALSE;
							EDTTV0201B.input.auto_open_signal := FALSE;
							p1_step2_2a := 5;
						END_IF;
					5:
						IF EDTTV0201A.input.close_feedback_state AND EDTTV0201B.input.close_feedback_state THEN
							EDTP1S2A_STEP[2].done := TRUE;
							p1_step2_2a := 0;
						END_IF;
				END_CASE;
				TON_2();
			3:
				//取样确认
			4:
				TON_9.PT := DINT_TO_TIME(EDTP1S2_PARA_T7 * 60 * 1000);
				EDTR07A.input.auto_run_signal := FALSE;
				IF NOT EDTR07A.input.run_feedback THEN
					TON_9.IN := TRUE;
				END_IF;
				IF TON_9.Q THEN
					TON_9.IN := FALSE;
					EDTP1S2A_STEP[4].done := TRUE;
				END_IF;
				TON_9();
		END_CASE;
	END_IF;
	
	//R07A进ABC溶液
	IF r07a_add THEN
		CASE p1_step2_4a OF
			0:
				EDTXV0204.input.auto_open_signal := FALSE;
				EDTXV0201.input.auto_open_signal := TRUE;
				IF EDTXV0204.input.close_feedback_state AND EDTXV0201.input.open_feedback_state THEN
					p1_step2_4a := 1;
				END_IF;
			1:
				EDTXV0505.input.auto_open_signal := TRUE;
				EDTFQV0203A.input.auto_open_signal := TRUE;
				IF EDTXV0505.input.open_feedback_state AND EDTFQV0203A.input.open_feedback_state THEN
					p1_step2_4a := 2;
				END_IF;
			2:
			//等待液体充满泵后，再启动P26防止抽空。		
				TON_54.PT := DINT_TO_TIME(EDTP1S2A_PARA_T4 * 1000);
				TON_54.IN := TRUE;
				IF TON_54.Q THEN
					TON_54.IN := FALSE;
					p1_step2_4a := 3;
				END_IF;
			3:
				LiquidTransfer_4(sp_time := DINT_TO_TIME(EDTP1S2A_PARA_T8 * 1000),
				sp_accumulation := EDTP1S2A_PARA_AC2,
				done := p1_step2_4a_3_done,
				flowmeter := EDTFQIT0203);
				EDTP26.input.auto_run_signal := LiquidTransfer_4.run;
				IF p1_step2_4a_3_done AND (NOT EDTP26.input.run_feedback) AND (NOT EDTP26.input.auto_run_signal) THEN
					p1_step2_4a := 4;
					p1_step2_4a_3_done := FALSE;
				END_IF;
			4:
				IF EDTFQIT0203.flowrate <= flowrate_threshold THEN
					EDTXV0505.input.auto_open_signal := FALSE;
					EDTFQV0203A.input.auto_open_signal := FALSE;
				END_IF;
				IF EDTXV0505.input.close_feedback_state AND EDTFQV0203A.input.close_feedback_state THEN
					r07a_add := FALSE;
					p1_step2_4a := 0;
				END_IF;
		END_CASE;
		TON_54();
	END_IF;
	
	//V02A（SSS溶液）进料
	IF v02a_add THEN
		CASE p1_step2_1a OF
			0:
				p1_step2_1a := 1;
			1:
				EDTXV0205.input.auto_open_signal := TRUE;
				IF EDTXV0205.input.open_feedback_state THEN
					p1_step2_1a := 2;
				END_IF;
			2:
				LiquidAddSimple_0(level_value := EDTLIT0203.status.value,
				sp_value := EDTP1S2A_PARA_L2,
				sp_time := DINT_TO_TIME(EDTP1S2A_PARA_T1 * 60 * 1000),
				done := p1_step2_1a_2_done);
				EDTP01.input.auto_run_signal := LiquidAddSimple_0.run;
				IF p1_step2_1a_2_done AND (NOT EDTP01.input.run_feedback) AND (NOT EDTP01.input.auto_run_signal) THEN
					p1_step2_1a := 3;
					p1_step2_1a_2_done := FALSE;
				END_IF;
			3:
				TON_1.PT := DINT_TO_TIME(EDTP1S2A_PARA_T2 * 1000);
				TON_1.IN := TRUE;
				IF TON_1.Q THEN
					TON_1.IN := FALSE;
					p1_step2_1a := 4;
				END_IF;
			4:
				EDTXV0205.input.auto_open_signal := FALSE;
				IF EDTXV0205.input.close_feedback_state THEN
					v02a_add := FALSE;
					p1_step2_1a := 0;
				END_IF;
		END_CASE;
		TON_1();
	END_IF;
	
	//V03A（MCE）进料
	IF v03a_add THEN
		CASE p1_step2_3a OF
			0:
				p1_step2_3a := 1;
			1:
				STFLV0702.input.auto_open_signal := FALSE;
				STFLV0701.input.auto_open_signal := FALSE;
				EDTLV0201.input.auto_open_signal := TRUE;
				IF EDTLV0201.input.open_feedback_state AND STFLV0701.input.close_feedback_state
					AND STFLV0702.input.close_feedback_state THEN
					p1_step2_3a := 2;
				END_IF;
			2:
				LiquidAdd_3(level_value := EDTLIT0201.status.value,
				sp_value := EDTP1S2A_PARA_L1,
				sp_accumulation := EDTP1S2A_PARA_AC1,
				sp_time := DINT_TO_TIME(EDTP1S2A_PARA_T3 * 1000),
				flowmeter := STFFQIT0702,
				done := p1_step2_3a_2_done);
				STFP07.input.auto_run_signal := LiquidAdd_3.run;
				IF p1_step2_3a_2_done AND (NOT STFP07.input.run_feedback) AND (NOT STFP07.input.auto_run_signal) THEN
					p1_step2_3a := 3;
				END_IF;
			3:
				IF STFFQIT0702.flowrate <= flowrate_threshold THEN
					EDTLV0201.input.auto_open_signal := FALSE;
				END_IF;
				IF EDTLV0201.input.close_feedback_state THEN
					p1_step2_3a_2_done := FALSE;
					p1_step2_3a := 0;
					v03a_add := FALSE;
				END_IF;
		END_CASE;
	END_IF;
		//人工确认步骤可用
		IF (EDTP1S2A.status.run_state) AND (NOT EDTP1S2A_STEP[EDTP1S2A.status.run_step].done AND ((EDTP1S2A.status.run_step = 1) OR (EDTP1S2A.status.run_step = 3))) THEN
			EDTP1S2A.status.confirm_enable := TRUE;
		ELSE
			EDTP1S2A.status.confirm_enable := FALSE;
		END_IF;
		END_ACTION
