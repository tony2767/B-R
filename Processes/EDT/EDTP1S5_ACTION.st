
ACTION P1S5_ACT: 
	//设定时间
	FOR i := 0 TO EDTP1S5_STEP_NUM DO
		IF EDTP1S5_ST[i] < T#5s THEN
			EDTP1S5_ST[i] := T#5s;
		END_IF;
		EDTP1S5_STEP[i].set_time := EDTP1S5_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(EDTP1S5,EDTP1S5_STEP[0],EDTP1S5_STEP_NUM);
	
	//object 手自动切换
	IF (EDTP1S5.status.mode <> 0) AND (NOT EDTP1S5.auto_mode_edge) THEN
		EDTP1S5.auto_mode_edge := TRUE;
		EDTP1S5.manual_mode_edge := FALSE;
		
		EDTXV0406.control.auto_operate := TRUE;
		EDTXV0407.control.auto_operate := TRUE;
		EDTXV0410.control.auto_operate := TRUE;
		EDTTV0403G.control.auto_operate := TRUE;
		EDTR19.control.auto_operate := TRUE;
		EDTP03.control.auto_operate := TRUE;
		EDTTV0403A.control.auto_operate := TRUE;
		EDTTV0403B.control.auto_operate := TRUE;
		EDTTV0403C.control.auto_operate := TRUE;
		EDTTV0403D.control.auto_operate := TRUE;
		EDTTV0403E.control.auto_operate := TRUE;
		EDTTV0403F.control.auto_operate := TRUE;
		EDTXV0411.control.auto_operate := TRUE;
		EDTPV0401.control.auto_operate := TRUE;
	END_IF;
	
	IF (EDTP1S5.status.mode = 0) AND (NOT EDTP1S5.manual_mode_edge) THEN
		EDTP1S5.manual_mode_edge := TRUE;
		EDTP1S5.auto_mode_edge := FALSE;
		
		EDTXV0406.control.manual_operate := TRUE;
		EDTXV0407.control.manual_operate := TRUE;
		EDTXV0410.control.manual_operate := TRUE;
		EDTTV0403G.control.manual_operate := TRUE;
		EDTR19.control.manual_operate := TRUE;
		EDTP03.control.manual_operate := TRUE;
		EDTTV0403A.control.manual_operate := TRUE;
		EDTTV0403B.control.manual_operate := TRUE;
		EDTTV0403C.control.manual_operate := TRUE;
		EDTTV0403D.control.manual_operate := TRUE;
		EDTTV0403E.control.manual_operate := TRUE;
		EDTTV0403F.control.manual_operate := TRUE;
		EDTXV0411.control.manual_operate := TRUE;
		EDTPV0401.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	EDTP1S5.input.error_signal := (EDTXV0406.status.valve_status >= 2) OR (EDTXV0407.status.valve_status >= 2) OR
	(EDTXV0410.status.valve_status >= 2) OR (EDTTV0403G.status.valve_status >= 2) OR
	(EDTR19.status.motor_status >= 2) OR (EDTP03.status.motor_status >= 2) OR (EDTTV0403A.status.valve_status >= 2) OR
	(EDTTV0403B.status.valve_status >= 2) OR (EDTTV0403C.status.valve_status >= 2) OR (EDTTV0403D.status.valve_status >= 2) OR
	(EDTTV0403E.status.valve_status >= 2) OR (EDTTV0403F.status.valve_status >= 2) OR (EDTXV0411.status.valve_status >= 2) OR
	(EDTPV0401.status.valve_status >= 2);

	IF EDTP1S5.status.run_state = 1 THEN
		//步骤执行动作
		CASE EDTP1S5.status.run_step OF 
			0:
				//初始化
				IF NOT EDTP1S5_STEP[0].done THEN
					EDTXV0406.control.auto_operate := TRUE;
					EDTXV0407.control.auto_operate := TRUE;
					EDTXV0410.control.auto_operate := TRUE;
					EDTTV0403G.control.auto_operate := TRUE;
					EDTR19.control.auto_operate := TRUE;
					EDTP03.control.auto_operate := TRUE;
					EDTTV0403A.control.auto_operate := TRUE;
					EDTTV0403B.control.auto_operate := TRUE;
					EDTTV0403C.control.auto_operate := TRUE;
					EDTTV0403D.control.auto_operate := TRUE;
					EDTTV0403E.control.auto_operate := TRUE;
					EDTTV0403F.control.auto_operate := TRUE;
					EDTXV0411.control.auto_operate := TRUE;
					EDTPV0401.control.auto_operate := TRUE;
					EDTP1S5_STEP[0].done := TRUE;
				END_IF;
			1:
				//确认V07空闲
			2:
				EDTXV0405.input.auto_open_signal := FALSE;
				IF EDTXV0405.input.close_feedback_state THEN
					EDTXV0406.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0406.input.open_feedback_state THEN
					EDTXV0407.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0407.input.open_feedback_state THEN
					EDTXV0410.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0410.input.open_feedback_state THEN
					EDTTV0403G.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV0403G.input.open_feedback_state THEN
					EDTXV0411.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTXV0406.input.open_feedback_state AND EDTXV0407.input.open_feedback_state AND EDTXV0405.input.close_feedback_state
					AND EDTXV0410.input.open_feedback_state AND EDTTV0403G.input.open_feedback_state AND EDTXV0411.input.open_feedback_state THEN
					EDTR19.input.auto_run_signal := TRUE;
					EDTP03.input.auto_run_signal := TRUE;
					IF EDTR19.input.run_feedback AND EDTP03.input.run_feedback THEN
						EDTP1S5_STEP[2].done := TRUE;
					END_IF;
				END_IF;
			3:			
				CASE p1_step5_3 OF
					0:
						IF NOT EDTP1S5_STEP[3].done THEN
							p1_step5_3 := 1;
						END_IF;
					1:
						HeatPot_13(ST1 := DINT_TO_TIME(EDTP1S5_PARA_T1 * 1000),
						ST2 := DINT_TO_TIME(EDTP1S5_PARA_T2 * 1000),
						V3 := EDTTV0403C,
						V4 := EDTTV0403D,
						V5 := EDTTV0403E,
						V6 := EDTTV0403F,
						done := p1_step5_3_1_done);
						IF p1_step5_3_1_done THEN
							p1_step5_3_1_done := FALSE;
							p1_step5_3 := 2;
						END_IF;
					2:
						IF EDTTIT0403.status.value >= EDTP1S5_PARA_Temp1 THEN
							EDTTV0403C.input.auto_open_signal := FALSE;
							IF EDTTIT0403.status.value >= EDTP1S5_PARA_Temp2 THEN
								p1_step5_3 := 3;
							END_IF;
						END_IF;
					3:
						TON_45.PT := DINT_TO_TIME(EDTP1S5_PARA_T3 * 60 * 1000);
						TON_45.IN := TRUE;
						IF TON_45.Q THEN
							TON_45.IN := FALSE;
							EDTTV0403D.input.auto_open_signal := FALSE;
							EDTTV0403E.input.auto_open_signal := FALSE;
							p1_step5_3 := 4;
						END_IF;
					4:
						TON_45.PT := DINT_TO_TIME(EDTP1S5_PARA_T4 * 60 * 1000);
						TON_45.IN := TRUE;
						IF TON_45.Q THEN
							TON_45.IN := FALSE;
							EDTTV0403F.input.auto_open_signal := TRUE;
							p1_step5_3 := 5;
						END_IF;
					5:
						TON_45.PT := DINT_TO_TIME(EDTP1S5_PARA_T5 * 1000);
						TON_45.IN := TRUE;
						IF TON_45.Q THEN
							TON_45.IN := FALSE;
							EDTTV0403F.input.auto_open_signal := FALSE;
							p1_step5_3 := 6;
						END_IF;
					6:
						IF EDTTV0403C.input.close_feedback_state AND EDTTV0403D.input.close_feedback_state AND EDTTV0403E.input.close_feedback_state AND EDTTV0403F.input.close_feedback_state THEN
							EDTP1S5_STEP[3].done := TRUE;
							p1_step5_3 := 0;
						END_IF;
				END_CASE;
				TON_45();
			4:
				CASE p1_step5_4 OF
					0:
						IF NOT EDTP1S5_STEP[4].done THEN
							p1_step5_4 := 1;
						END_IF;
					1:
						EDTTV0403A.input.auto_open_signal := TRUE;
						IF	EDTTV0403A.input.open_feedback_state THEN
							EDTTV0403B.input.auto_open_signal := TRUE;
							IF EDTTV0403B.input.open_feedback_state THEN
								p1_step5_4 := 2;
							END_IF;
						END_IF;
					2:
						IF EDTTIT0403.status.value <= EDTP1S5_PARA_Temp4 THEN
							EDTPV0401.input.auto_open_signal := TRUE;
							p1_step5_4 := 3;
						END_IF;
					3:
						IF EDTPIT0401.status.value >= EDTP1S5_PARA_P1 THEN
							EDTTV0403G.input.auto_open_signal := FALSE;
							EDTP03.input.auto_run_signal := FALSE;
							EDTXV0406.input.auto_open_signal := FALSE;
							EDTXV0407.input.auto_open_signal := FALSE;
							EDTXV0410.input.auto_open_signal := FALSE;
							EDTTV0403A.input.auto_open_signal := FALSE;
							EDTTV0403B.input.auto_open_signal := FALSE;
							p1_step5_4 := 4;
						END_IF;
					4:
						IF EDTPIT0401.status.value >= EDTP1S5_PARA_P2 THEN
							EDTPV0401.input.auto_open_signal := FALSE;
							EDTXV0411.input.auto_open_signal := FALSE;
							EDTR19.input.auto_run_signal := FALSE;
							p1_step5_4 := 5;
						END_IF;
					5:
						EDTP1S5_STEP[4].done := TRUE;
						p1_step5_4 := 0;
				END_CASE;
		END_CASE;		
	END_IF;
	
	//人工确认步骤可用
	IF (EDTP1S5.status.run_state) AND (NOT EDTP1S5_STEP[EDTP1S5.status.run_step].done AND ((EDTP1S5.status.run_step = 1))) THEN
		EDTP1S5.status.confirm_enable := TRUE;
	ELSE
		EDTP1S5.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
