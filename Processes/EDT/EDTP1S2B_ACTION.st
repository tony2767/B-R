
ACTION P1S2B_ACT: 
	//设定时间
	FOR i := 0 TO EDTP1S2_STEP_NUM DO
		IF EDTP1S2B_ST[i] < T#5s THEN
			EDTP1S2B_ST[i] := T#5s;
		END_IF;
		EDTP1S2B_STEP[i].set_time := EDTP1S2B_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(EDTP1S2B,EDTP1S2B_STEP[0],EDTP1S2_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP1S2B.status.mode <> 0) AND (NOT EDTP1S2B.auto_mode_edge) THEN
		
		EDTP1S2B.auto_mode_edge := TRUE;
		EDTP1S2B.manual_mode_edge := FALSE;
		
		EDTP01.control.auto_operate := TRUE;
		EDTXV0206.control.auto_operate := TRUE;
		STFLV0701.control.auto_operate := TRUE;
		STFLV0702.control.auto_operate := TRUE;
		EDTLV0202.control.auto_operate := TRUE;
		STFP07.control.auto_operate := TRUE;
		EDTR07B.control.auto_operate := TRUE;
		EDTTV0202A.control.auto_operate := TRUE;
		EDTTV0202B.control.auto_operate := TRUE;
		EDTXV0202.control.auto_operate := TRUE;
		EDTXV0203.control.auto_operate := TRUE;
		EDTXV0505.control.auto_operate := TRUE;
		EDTFQV0203B.control.auto_operate := TRUE;
		EDTP26.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP1S2B.status.mode = 0) AND (NOT EDTP1S2B.manual_mode_edge) THEN
		
		EDTP1S2B.manual_mode_edge := TRUE;
		EDTP1S2B.auto_mode_edge := FALSE;
		
		EDTP01.control.manual_operate := TRUE;
		EDTXV0206.control.manual_operate := TRUE;
		STFLV0701.control.manual_operate := TRUE;
		STFLV0702.control.manual_operate := TRUE;
		EDTLV0202.control.manual_operate := TRUE;
		STFP07.control.manual_operate := TRUE;
		EDTR07B.control.manual_operate := TRUE;
		EDTTV0202A.control.manual_operate := TRUE;
		EDTTV0202B.control.manual_operate := TRUE;
		EDTXV0202.control.manual_operate := TRUE;
		EDTXV0203.control.manual_operate := TRUE;
		EDTXV0505.control.manual_operate := TRUE;
		EDTFQV0203B.control.manual_operate := TRUE;
		EDTP26.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	EDTP1S2B.input.error_signal := (EDTP01.status.motor_status >= 2) OR (EDTXV0206.status.valve_status >= 2) OR 
	(STFLV0701.status.valve_status >= 2) OR (STFLV0702.status.valve_status >= 2) OR (EDTLV0202.status.valve_status >= 2) OR
	(STFP07.status.motor_status >= 2) OR (EDTR07B.status.motor_status >= 2) OR 
	(EDTTV0202A.status.valve_status >= 2) OR (EDTTV0202B.status.valve_status >= 2) OR (EDTXV0202.status.valve_status >= 2) OR
	(EDTP26.status.motor_status >= 2) OR (EDTFQV0203B.status.valve_status >= 2) OR (EDTXV0505.status.valve_status >= 2) OR
	(EDTXV0203.status.valve_status >= 2);
	

	IF EDTP1S2B.status.run_state = 1 THEN
		CASE EDTP1S2B.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP1S2B_STEP[0].done THEN
					EDTP01.control.auto_operate := TRUE;
					EDTXV0206.control.auto_operate := TRUE;
					STFLV0701.control.auto_operate := TRUE;
					STFLV0702.control.auto_operate := TRUE;
					EDTLV0202.control.auto_operate := TRUE;
					STFP07.control.auto_operate := TRUE;
					EDTR07B.control.auto_operate := TRUE;
					EDTTV0202A.control.auto_operate := TRUE;
					EDTTV0202B.control.auto_operate := TRUE;
					EDTXV0202.control.auto_operate := TRUE;
					EDTXV0203.control.auto_operate := TRUE;
					EDTXV0505.control.auto_operate := TRUE;
					EDTFQV0203B.control.auto_operate := TRUE;
					EDTP26.control.auto_operate := TRUE;
					EDTP1S2B_STEP[0].done := TRUE;
				END_IF;
			1:
				//人工确认投料
			2:
				//滴加
				CASE p1_step2_2b OF
					0:
						IF NOT EDTP1S2B_STEP[2].done THEN
							p1_step2_2b := 1;
						END_IF;
					1:
						EDTXV0202.input.auto_open_signal := TRUE;
						EDTR07B.input.auto_run_signal := TRUE;
						IF EDTXV0202.input.open_feedback_state AND EDTR07B.input.run_feedback THEN
							p1_step2_2b := 2;
						END_IF;
					2:
						IF EDTTIT0202.status.value <= EDTP1S2_PARA_Temp1 THEN
							p1_step2_2b := 3;
						END_IF;
					3:
						TON_5.PT := DINT_TO_TIME(EDTP1S2_PARA_T5 * 60 * 1000);
						TON_5.IN := TRUE;
						IF EDTTIT0202.status.value <= EDTP1S2_PARA_Temp2 THEN
							EDTTV0202A.input.auto_open_signal := TRUE;
							EDTTV0202B.input.auto_open_signal := TRUE;
						END_IF;
						IF EDTTIT0202.status.value >= EDTP1S2_PARA_Temp3 THEN
							EDTTV0202A.input.auto_open_signal := FALSE;
							EDTTV0202B.input.auto_open_signal := FALSE;
						END_IF;
						IF TON_5.Q THEN
							TON_5.IN := FALSE;
							EDTXV0202.input.auto_open_signal := FALSE;
							EDTTV0202A.input.auto_open_signal := TRUE;
							EDTTV0202B.input.auto_open_signal := TRUE;
							p1_step2_2b := 4;
						END_IF;
					4:
						TON_5.PT := DINT_TO_TIME(EDTP1S2_PARA_T6 * 60 * 1000);
						TON_5.IN := TRUE;
						IF TON_5.Q THEN
							TON_5.IN := FALSE;
							EDTTV0202A.input.auto_open_signal := FALSE;
							EDTTV0202B.input.auto_open_signal := FALSE;
							p1_step2_2b := 5;
						END_IF;
					5:
						IF EDTTV0202A.input.close_feedback_state AND EDTTV0202B.input.close_feedback_state THEN
							EDTP1S2B_STEP[2].done := TRUE;
							p1_step2_2b := 0;
						END_IF;
				END_CASE;
				TON_5();
			3:
				//取样确认
			4:
				TON_18.PT := DINT_TO_TIME(EDTP1S2_PARA_T7 * 60 * 1000);
				EDTR07B.input.auto_run_signal := FALSE;
				IF NOT EDTR07B.input.run_feedback THEN
					TON_18.IN := TRUE;
				END_IF;
				IF TON_18.Q THEN
					TON_18.IN := FALSE;
					EDTP1S2B_STEP[4].done := TRUE;
				END_IF;
				TON_18();
		END_CASE;
	END_IF;
	
	//R07A进ABC溶液
	IF r07b_add THEN
		CASE p1_step2_4b OF
			0:
				EDTXV0203.input.auto_open_signal := FALSE;
				EDTXV0202.input.auto_open_signal := TRUE;
				IF EDTXV0203.input.close_feedback_state AND EDTXV0202.input.open_feedback_state THEN
					p1_step2_4b := 1;
				END_IF;
			1:
				EDTXV0505.input.auto_open_signal := TRUE;
				EDTFQV0203B.input.auto_open_signal := TRUE;
				IF EDTXV0505.input.open_feedback_state AND EDTFQV0203B.input.open_feedback_state THEN
					p1_step2_4b := 2;
				END_IF;
			2:
				//等待液体充满泵后，再启动P26防止抽空。
				TON_55.PT := DINT_TO_TIME(EDTP1S2B_PARA_T4 * 1000);
				TON_55.IN := TRUE;
				IF TON_55.Q THEN
					TON_55.IN := FALSE;
					p1_step2_4b := 3;
				END_IF;
			3:
				LiquidTransfer_5(sp_time := DINT_TO_TIME(EDTP1S2B_PARA_T8 * 1000),
				sp_accumulation := EDTP1S2B_PARA_AC2,
				done := p1_step2_4b_3_done,
				flowmeter := EDTFQIT0203);
				EDTP26.input.auto_run_signal := LiquidTransfer_5.run;
				IF p1_step2_4b_3_done AND (NOT EDTP26.input.run_feedback) AND (NOT EDTP26.input.auto_run_signal) THEN
					p1_step2_4b := 4;
					p1_step2_4b_3_done := FALSE;
				END_IF;
			4:
				IF EDTFQIT0203.flowrate <= flowrate_threshold THEN
					EDTXV0505.input.auto_open_signal := FALSE;
					EDTFQV0203B.input.auto_open_signal := FALSE;
				END_IF;
				IF EDTXV0505.input.close_feedback_state AND EDTFQV0203B.input.close_feedback_state THEN
					r07b_add := FALSE;
					p1_step2_4b := 0;
				END_IF;
		END_CASE;
		TON_55();
	END_IF;
	
	//V02B（SSS溶液）进料
	IF v02b_add THEN
		CASE p1_step2_1b OF
			0:
				p1_step2_1b := 1;
			1:
				EDTXV0206.input.auto_open_signal := TRUE;
				IF EDTXV0206.input.open_feedback_state THEN
					p1_step2_1b := 2;
				END_IF;
			2:
				LiquidAddSimple_1(level_value := EDTLIT0204.status.value,
				sp_value := EDTP1S2B_PARA_L2,
				sp_time := DINT_TO_TIME(EDTP1S2B_PARA_T1 * 60 * 1000),
				done := p1_step2_1b_2_done);
				EDTP01.input.auto_run_signal := LiquidAddSimple_1.run;
				IF p1_step2_1b_2_done AND (NOT EDTP01.input.run_feedback) AND (NOT EDTP01.input.auto_run_signal) THEN
					p1_step2_1b := 3;
					p1_step2_1b_2_done := FALSE;
				END_IF;
			3:
				TON_4.PT := DINT_TO_TIME(EDTP1S2B_PARA_T2 * 1000);
				TON_4.IN := TRUE;
				IF TON_4.Q THEN
					TON_4.IN := FALSE;
					p1_step2_1b := 4;
				END_IF;
			4:
				EDTXV0206.input.auto_open_signal := FALSE;
				IF EDTXV0206.input.close_feedback_state THEN
					v02b_add := FALSE;
					p1_step2_1b := 0;
				END_IF;
		END_CASE;
		TON_4();
	END_IF;
	
	//V03B（MCE）进料
	IF v03b_add THEN
		CASE p1_step2_3b OF
			0:
				p1_step2_3b := 1;
			1:
				STFLV0702.input.auto_open_signal := FALSE;
				STFLV0701.input.auto_open_signal := FALSE;
				EDTLV0202.input.auto_open_signal := TRUE;
				IF EDTLV0202.input.open_feedback_state AND STFLV0701.input.close_feedback_state
					AND STFLV0702.input.close_feedback_state THEN
					p1_step2_3b := 2;
				END_IF;
			2:
				LiquidAdd_5(level_value := EDTLIT0202.status.value,
				sp_value := EDTP1S2B_PARA_L1,
				sp_accumulation := EDTP1S2B_PARA_AC1,
				sp_time := DINT_TO_TIME(EDTP1S2B_PARA_T3 * 1000),
				flowmeter := STFFQIT0702,
				done := p1_step2_3b_2_done);
				STFP07.input.auto_run_signal := LiquidAdd_5.run;
				IF p1_step2_3b_2_done AND (NOT STFP07.input.run_feedback) AND (NOT STFP07.input.auto_run_signal) THEN
					p1_step2_3b := 3;
				END_IF;
			3:
				IF STFFQIT0702.flowrate <= flowrate_threshold THEN
					EDTLV0202.input.auto_open_signal := FALSE;
				END_IF;
				IF EDTLV0202.input.close_feedback_state THEN
					p1_step2_3b_2_done := FALSE;
					p1_step2_3b := 0;
					v03b_add := FALSE;
				END_IF;
		END_CASE;
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP1S2B.status.run_state) AND (NOT EDTP1S2B_STEP[EDTP1S2B.status.run_step].done AND ((EDTP1S2B.status.run_step = 1) OR (EDTP1S2B.status.run_step = 3))) THEN
		EDTP1S2B.status.confirm_enable := TRUE;
	ELSE
		EDTP1S2B.status.confirm_enable := FALSE;
	END_IF;
		END_ACTION
