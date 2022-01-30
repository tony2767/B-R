
ACTION S6_ACT: 
	//设定时间
	FOR i := 0 TO MBAS6_STEP_NUM DO
		IF MBAS6_ST[i] < T#5s THEN
			MBAS6_ST[i] := T#5s;
		END_IF;
		MBAS6_STEP[i].set_time := MBAS6_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(MBAS6,MBAS6_STEP[0],MBAS6_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS6.status.mode <> 0) AND (NOT MBAS6.auto_mode_edge) THEN
		MBAS6.auto_mode_edge := TRUE;
		MBAS6.manual_mode_edge := FALSE;
		
		MBAXV0510.control.auto_operate := TRUE;
		MBAXV0526.control.auto_operate := TRUE;
		MBAXV0507.control.auto_operate := TRUE;
		MBAR02.control.auto_operate := TRUE;
		MBAXV0305.control.auto_operate := TRUE;
		MBAAV0301.control.auto_operate := TRUE;
		MBAXV0517.control.auto_operate := TRUE;
		MBATV0501C.control.auto_operate := TRUE;
		MBATV0501B.control.auto_operate := TRUE;
		MBATV0501E.control.auto_operate := TRUE;
		MBATV0501F.control.auto_operate := TRUE;
		MBAXV0515.control.auto_operate := TRUE;
		MBAXV0518.control.auto_operate := TRUE;
		MBAXV0512.control.auto_operate := TRUE;
		MBAXV0514.control.auto_operate := TRUE;
		MBAXV0524.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS6.status.mode = 0) AND (NOT MBAS6.manual_mode_edge) THEN
		MBAS6.manual_mode_edge := TRUE;
		MBAS6.auto_mode_edge := FALSE;

		MBAXV0510.control.manual_operate := TRUE;
		MBAXV0526.control.manual_operate := TRUE;
		MBAXV0507.control.manual_operate := TRUE;
		MBAR02.control.manual_operate := TRUE;
		MBAXV0305.control.manual_operate := TRUE;
		MBAAV0301.control.manual_operate := TRUE;
		MBAXV0517.control.manual_operate := TRUE;
		MBATV0501C.control.manual_operate := TRUE;
		MBATV0501B.control.manual_operate := TRUE;
		MBATV0501E.control.manual_operate := TRUE;
		MBATV0501F.control.manual_operate := TRUE;
		MBAXV0515.control.manual_operate := TRUE;
		MBAXV0518.control.manual_operate := TRUE;
		MBAXV0512.control.manual_operate := TRUE;
		MBAXV0514.control.manual_operate := TRUE;
		MBAXV0524.control.manual_operate := TRUE;
	END_IF;
	
	//错误信号停机
	MBAS6.input.error_signal := (MBAXV0510.status.valve_status >= 2) OR (MBAXV0526.status.valve_status >= 2) OR
	(MBAR02.status.motor_status >= 2) OR (MBAXV0507.status.valve_status >= 2) OR (MBAXV0305.status.valve_status >= 2) OR
	(MBAAV0301.status.valve_status >= 2) OR (MBAXV0517.status.valve_status >= 2) OR (MBATV0501C.status.valve_status >= 2) OR
	(MBATV0501B.status.valve_status >= 2) OR (MBATV0501E.status.valve_status >= 2) OR (MBATV0501F.status.valve_status >= 2) OR
	(MBAXV0515.status.valve_status >= 2) OR (MBAXV0518.status.valve_status >= 2) OR (MBAXV0512.status.valve_status >= 2) OR 
	(MBAXV0514.status.valve_status >= 2) OR (MBAXV0524.status.valve_status >= 2);

	
	IF MBAS6.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS6.status.run_step OF 
			0:
				MBAXV0510.control.auto_operate := TRUE;
				MBAXV0526.control.auto_operate := TRUE;
				MBAXV0507.control.auto_operate := TRUE;
				MBAR02.control.auto_operate := TRUE;
				MBAXV0305.control.auto_operate := TRUE;
				MBAAV0301.control.auto_operate := TRUE;
				MBAXV0517.control.auto_operate := TRUE;
				MBATV0501C.control.auto_operate := TRUE;
				MBATV0501B.control.auto_operate := TRUE;
				MBATV0501E.control.auto_operate := TRUE;
				MBATV0501F.control.auto_operate := TRUE;
				MBAXV0515.control.auto_operate := TRUE;
				MBAXV0518.control.auto_operate := TRUE;
				MBAXV0512.control.auto_operate := TRUE;
				MBAXV0514.control.auto_operate := TRUE;
				MBAXV0524.control.auto_operate := TRUE;
				//				is_liquid_R06 := 0;
				is_press_ok_R06 := FALSE;
				//				popup_is_liquid_R06 := FALSE;
				step9_temp_enable := FALSE;
				MBAS6_STEP[0].done := TRUE;
			1:
				//R02进料
			2:
				//试漏
			3:
				//进料
				CASE step6_3 OF
					0:
						IF NOT MBAS6_STEP[3].done THEN
							step6_3 := 1;
						END_IF;
					1:
						MBAR02.input.auto_run_signal := TRUE;
						TON_9.PT := DINT_TO_TIME(MBAS6_PARA_T2 * 60 * 1000);
						TON_9.IN := TRUE;
						IF TON_9.Q THEN
							TON_9.IN := FALSE;
							step6_3 := 2;
						END_IF;
					2:
						MBAXV0305.input.auto_open_signal := TRUE;
						IF MBAXV0305.input.open_feedback_state THEN
							step6_3 := 3;
						END_IF;
					3:
						IF MBAPIT0501.status.value <= MBAS6_PARA_P3 THEN
							MBAXV0510.input.auto_open_signal := TRUE;
							step6_3 := 4;
						END_IF;
					4:
						TON_9.PT := DINT_TO_TIME(MBAS6_PARA_T3 * 60 * 1000);
						TON_9.IN := TRUE;
						IF TON_9.Q THEN
							TON_9.IN := FALSE;
							MBAS6_STEP[3].done := TRUE;
							step6_3 := 0;	
						END_IF;
				END_CASE;
				TON_9();
			4:
				//确认R02转移完毕
			5:
				MBAR02.input.auto_run_signal := FALSE;
				MBAS6_STEP[5].done := TRUE;
			6:
				//清洗管线
				TON_21.PT := DINT_TO_TIME(MBAS6_PARA_T4 * 60 * 1000);
				IF NOT MBAS6_STEP[6].done THEN
					MBAAV0301.input.auto_open_signal := TRUE;
					IF MBAAV0301.input.open_feedback_state THEN
						TON_21.IN := TRUE;
					END_IF;
				END_IF;
				IF TON_21.Q THEN
					TON_21.IN := FALSE;
					MBAXV0305.input.auto_open_signal := FALSE;
					MBAAV0301.input.auto_open_signal := FALSE;
					MBAS6_STEP[6].done := TRUE;
				END_IF;
				TON_21();
				//========================溶解==========================
			7:
				//准备 人工打开MBAR06搅拌
				MBAXV0517.input.auto_open_signal := TRUE;
			8:
				HeatPot_2(ST1 := DINT_TO_TIME(MBAS6_PARA_T5 * 1000),
				ST2 := DINT_TO_TIME(MBAS6_PARA_T6 * 1000),
				V3 := MBATV0501C,
				V4 := MBATV0501B,
				V5 := MBATV0501E,
				V6 := MBATV0501F,
				done := MBAS6_STEP[8].done);
			9:
				IF MBATIT0501.status.value >= MBAS6_PARA_Temp1 THEN
					MBATV0501C.input.auto_open_signal := FALSE;
					MBAXV0510.input.auto_open_signal := FALSE;
					step9_temp_enable := TRUE;
					IF MBATV0501C.input.close_feedback_state AND MBAXV0510.input.close_feedback_state THEN
						MBAS6_STEP[9].done := TRUE;
					END_IF;
				END_IF;
			10:
				//现场观察溶解清透 R08空闲
			11:
				step9_temp_enable := FALSE;
				MBATV0501B.input.auto_open_signal := FALSE;
				MBATV0501E.input.auto_open_signal := FALSE;
				MBATV0501F.input.auto_open_signal := TRUE;
				IF MBATV0501B.input.close_feedback_state AND MBATV0501E.input.close_feedback_state AND MBATV0501F.input.open_feedback_state THEN
					MBAS6_STEP[11].done := TRUE;
				END_IF;
			12:
				MBAXV0515.input.auto_open_signal := TRUE;
				MBAXV0518.input.auto_open_signal := TRUE;
				MBAXV0512.input.auto_open_signal := TRUE;
				MBAXV0524.input.auto_open_signal := TRUE;
				IF MBAXV0515.input.open_feedback_state AND MBAXV0518.input.open_feedback_state AND MBAXV0512.input.open_feedback_state AND MBAXV0524.input.open_feedback_state THEN
					MBAS6_STEP[12].done := TRUE;
				END_IF;
			13:
				CASE step6_13 OF
					0:
						IF NOT MBAS6_STEP[13].done THEN
							step6_13 := 1;
						END_IF;
					1:
						MBAXV0526.input.auto_open_signal := TRUE;
						step6_13 := 2;
					2:
						IF MBAPIT0501.status.value <= MBAS6_PARA_P6 THEN
							MBAXV0526.input.auto_open_signal := FALSE;
							MBAXV0514.input.auto_open_signal := TRUE;
							step6_13 := 3;
						END_IF;
					3:
						IF MBAXV0514.input.open_feedback_state THEN
							step6_13 := 0;
							MBAS6_STEP[13].done := TRUE;
						END_IF;
				END_CASE;
			14:	
				IF MBATIT0501.status.value >= MBAS6_PARA_Temp5 THEN
					MBATV0501F.input.auto_open_signal := TRUE;
					IF MBATV0501F.input.open_feedback_state THEN
						MBATV0501B.input.auto_open_signal := FALSE;
						IF MBATV0501B.input.close_feedback_state THEN
							MBATV0501E.input.auto_open_signal := FALSE;
						END_IF;
					END_IF;
				ELSIF MBATIT0501.status.value <= MBAS6_PARA_Temp4 THEN
					MBATV0501E.input.auto_open_signal := TRUE;
					MBATV0501F.input.auto_open_signal := FALSE;
					IF MBATV0501E.input.open_feedback_state THEN
						MBATV0501B.input.auto_open_signal := TRUE;
					END_IF;
				END_IF;
				IF MBAPIT0501.status.value >= MBAS6_PARA_P7 THEN
					MBAXV0526.input.auto_open_signal := TRUE;
				ELSIF MBAPIT0501.status.value <= MBAS6_PARA_P8 THEN
					MBAXV0526.input.auto_open_signal := FALSE;
				END_IF;
				//观察R08进料管
			15:
				MBATV0501B.input.auto_open_signal := FALSE;
				IF MBATV0501B.input.close_feedback_state THEN
					MBATV0501E.input.auto_open_signal := FALSE;
				END_IF;	
				MBATV0501F.input.auto_open_signal := TRUE;
				MBAXV0514.input.auto_open_signal := FALSE;
				MBAXV0512.input.auto_open_signal := FALSE;
				MBAXV0526.input.auto_open_signal := FALSE;
				//手动停R06
			16:
			//清理
		END_CASE;		
	END_IF;
	
	//step9 温控
	IF step9_temp_enable THEN
		IF MBATIT0501.status.value >= MBAS6_PARA_Temp2 OR MBAPIT0501.status.value >= MBAS6_PARA_P4 THEN
			MBATV0501B.input.auto_open_signal := FALSE;
		ELSIF MBATIT0501.status.value <= MBAS6_PARA_Temp3 OR MBAPIT0501.status.value <= MBAS6_PARA_P5 THEN
			MBATV0501B.input.auto_open_signal := TRUE;
		END_IF;
	END_IF;
	
	//R06试漏
	IF press_test_R06 THEN
		CASE step6_2 OF
			0:
				MBAXV0510.control.auto_operate := TRUE;
				MBAXV0526.control.auto_operate := TRUE;
				MBAXV0507.control.auto_operate := TRUE;
				is_press_ok_R06 := FALSE;
				step6_2 := 1;
			1:
				MBAXV0510.input.auto_open_signal := FALSE;
				MBAXV0526.input.auto_open_signal := FALSE;
				IF MBAXV0510.input.close_feedback_state AND MBAXV0526.input.close_feedback_state THEN
					step6_2 := 2;
				END_IF;
			2:
				MBAXV0507.input.auto_open_signal := TRUE;
				step6_2 := 3;
			3:
				IF MBAPIT0501.status.value >= MBAS6_PARA_P1 THEN
					MBAXV0507.input.auto_open_signal := FALSE;
					step6_2 := 4;
				END_IF;
			4:
				TON_3.PT := DINT_TO_TIME(MBAS6_PARA_T1 * 60 * 1000);
				TON_3.IN := TRUE;
				IF TON_3.Q THEN
					TON_3.IN := FALSE;
					step6_2 := 5;
				END_IF;
			5:
				IF MBAS6_PARA_P1 - MBAPIT0501.status.value <= MBAS6_PARA_P2 THEN
					is_press_ok_R06 := TRUE;
				ELSE
					is_press_ok_R06 := FALSE;
				END_IF;
				step6_2 := 6;
			6:
				press_test_R06 := FALSE;
				step6_2 := 0;	
		END_CASE;
		TON_3();
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS6.status.run_state) AND (NOT MBAS6_STEP[MBAS6.status.run_step].done AND ((MBAS6.status.run_step = 1) OR (MBAS6.status.run_step = 2) OR (MBAS6.status.run_step = 4) OR (MBAS6.status.run_step = 7) OR (MBAS6.status.run_step = 10) OR
		(MBAS6.status.run_step = 14) OR (MBAS6.status.run_step = 15) OR (MBAS6.status.run_step = 16))) THEN
		MBAS6.status.confirm_enable := TRUE;
	ELSE
		MBAS6.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
