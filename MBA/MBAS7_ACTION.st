
ACTION S7_ACT: 
	//设定时间
	FOR i := 0 TO MBAS7_STEP_NUM DO
		IF MBAS7_ST[i] < T#5s THEN
			MBAS7_ST[i] := T#5s;
		END_IF;
		MBAS7_STEP[i].set_time := MBAS7_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(MBAS7,MBAS7_STEP[0],MBAS7_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS7.status.mode <> 0) AND (NOT MBAS7.auto_mode_edge) THEN
		MBAS7.auto_mode_edge := TRUE;
		MBAS7.manual_mode_edge := FALSE;
		
		MBAXV0515.control.auto_operate := TRUE;
		MBAXV0518.control.auto_operate := TRUE;
		MBAXV0512.control.auto_operate := TRUE;
		MBAXV0524.control.auto_operate := TRUE;
		MBAXV0526.control.auto_operate := TRUE;
		MBAXV0514.control.auto_operate := TRUE;
		MBATV0501C.control.auto_operate := TRUE;
		MBATV0501E.control.auto_operate := TRUE;
		MBATV0501F.control.auto_operate := TRUE;
		MBAXV0519.control.auto_operate := TRUE;	
		MBAXV0517.control.auto_operate := TRUE;	
		MBATVT0510.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS7.status.mode = 0) AND (NOT MBAS7.manual_mode_edge) THEN
		MBAS7.manual_mode_edge := TRUE;
		MBAS7.auto_mode_edge := FALSE;
		
		MBAXV0515.control.manual_operate := TRUE;
		MBAXV0518.control.manual_operate := TRUE;
		MBAXV0512.control.manual_operate := TRUE;
		MBAXV0524.control.manual_operate := TRUE;
		MBAXV0526.control.manual_operate := TRUE;
		MBAXV0514.control.manual_operate := TRUE;
		MBATV0501C.control.manual_operate := TRUE;
		MBATV0501E.control.manual_operate := TRUE;
		MBATV0501F.control.manual_operate := TRUE;
		MBAXV0519.control.manual_operate := TRUE;	
		MBAXV0517.control.manual_operate := TRUE;
		MBATVT0510.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS7.input.error_signal := (MBAXV0515.status.valve_status >= 2) OR (MBAXV0518.status.valve_status >= 2) OR
	(MBAXV0512.status.valve_status >= 2) OR (MBAXV0524.status.valve_status >= 2) OR (MBAXV0526.status.valve_status >= 2) OR
	(MBAXV0514.status.valve_status >= 2) OR (MBATV0501C.status.valve_status >= 2) OR (MBATV0501E.status.valve_status >= 2) OR
	(MBATV0501F.status.valve_status >= 2) OR (MBAXV0519.status.valve_status >= 2) OR (MBAXV0517.status.valve_status >= 2);

	IF MBAS7.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS7.status.run_step OF 
			0:
				IF NOT MBAS7_STEP[0].done THEN
					MBAXV0515.control.auto_operate := TRUE;
					MBAXV0518.control.auto_operate := TRUE;
					MBAXV0512.control.auto_operate := TRUE;
					MBAXV0524.control.auto_operate := TRUE;
					MBAXV0526.control.auto_operate := TRUE;
					MBAXV0514.control.auto_operate := TRUE;
					MBATV0501C.control.auto_operate := TRUE;
					MBATV0501E.control.auto_operate := TRUE;
					MBATV0501F.control.auto_operate := TRUE;
					MBAXV0519.control.auto_operate := TRUE;	
					MBAXV0517.control.auto_operate := TRUE;	
					MBATVT0510.control.auto_operate := TRUE;
					r08_add := FALSE;
					MBAS7_STEP[0].done := TRUE;
				END_IF;
			1:
				MBAXV0515.input.auto_open_signal := TRUE;
				MBAXV0518.input.auto_open_signal := TRUE;
				MBAXV0512.input.auto_open_signal := TRUE;
				MBAXV0524.input.auto_open_signal := TRUE;
				IF MBAXV0515.input.open_feedback_state AND MBAXV0518.input.open_feedback_state AND MBAXV0512.input.open_feedback_state AND MBAXV0524.input.open_feedback_state THEN
					MBAS7_STEP[1].done := TRUE;
				END_IF;
			2:
				CASE step7_2 OF
					0:
						IF NOT MBAS7_STEP[2].done THEN
							step7_2 := 1;
						END_IF;
					1:
						MBAXV0526.input.auto_open_signal := TRUE;
						step7_2 := 2;
					2:
						IF MBAPIT0501.status.value <= MBAS7_PARA_P1 THEN
							MBAXV0514.input.auto_open_signal := TRUE;
							IF MBAXV0514.input.open_feedback_state THEN
								step7_2 := 3;
							END_IF;
						END_IF;
					3:
						r08_add := TRUE;
						step7_2 := 0;
						MBAS7_STEP[2].done := TRUE;
				END_CASE;
			3:
				//观察R08进料视镜无液，反馈中控进料结束
			4:
				r08_add := FALSE;
				MBATV0501C.input.auto_open_signal := FALSE;
				IF MBATV0501C.input.close_feedback_state THEN
					MBATV0501E.input.auto_open_signal := FALSE;
				END_IF;	
				MBATV0501F.input.auto_open_signal := TRUE;
				MBAXV0514.input.auto_open_signal := FALSE;
				MBAXV0512.input.auto_open_signal := FALSE;
				MBAXV0526.input.auto_open_signal := FALSE;
				//手动停R06
			5:
				CASE step7_5 OF
					0:
						IF NOT MBAS7_STEP[5].done THEN
							step7_5 := 1;
						END_IF;
					1:
						IF MBATIT0502.status.value <= MBAS7_PARA_Temp3 THEN
							MBAXV0519.input.auto_open_signal := TRUE;
							step7_5 := 2;
						END_IF;
					2:
						IF MBATIT0502.status.value <= MBAS7_PARA_Temp4 THEN
							MBAXV0519.input.auto_open_signal := FALSE;
							step7_5 := 3;
						END_IF;
					3:
						TON_5.PT := DINT_TO_TIME(MBAS7_PARA_T1 * 60 * 1000);
						TON_5.IN := TRUE;
						IF TON_5.Q THEN
							TON_5.IN := FALSE;
							step7_5 := 4;
						END_IF;
					4:
						MBAXV0518.input.auto_open_signal := FALSE;
						MBAXV0515.input.auto_open_signal := FALSE;
						MBAXV0517.input.auto_open_signal := FALSE;
						IF MBAXV0518.input.close_feedback_state AND MBAXV0515.input.close_feedback_state AND  MBAXV0517.input.close_feedback_state THEN
							step7_5 := 0;
							MBAS7_STEP[5].done := TRUE;
						END_IF;
				END_CASE;
				TON_5();
		END_CASE;		
	END_IF;
	
	//转移物料控制温度压力
	IF r08_add THEN
		IF MBATIT0501.status.value >= MBAS7_PARA_Temp1 THEN
			MBATV0501F.input.auto_open_signal := TRUE;
			MBATV0501C.input.auto_open_signal := FALSE;
			MBATV0501E.input.auto_open_signal := FALSE;
		ELSIF MBATIT0501.status.value <= MBAS7_PARA_Temp2 THEN
			MBATV0501E.input.auto_open_signal := TRUE;
			MBATV0501F.input.auto_open_signal := FALSE;
			IF MBATV0501E.input.open_feedback_state THEN
				MBATV0501C.input.auto_open_signal := TRUE;
			END_IF;
		END_IF;
		IF MBAPIT0501.status.value >= MBAS7_PARA_P2 THEN
			MBAXV0526.input.auto_open_signal := TRUE;
		ELSIF MBAPIT0501.status.value <= MBAS7_PARA_P3 THEN
			MBAXV0526.input.auto_open_signal := FALSE;
		END_IF;
	END_IF;
	
	//TSV0510调节
	R_TRIG_1(CLK := MBATVT0510.status.auto_mode);
	IF R_TRIG_1.Q THEN
		MTBasicsPID_0.Enable := TRUE;
	END_IF;
	F_TRIG_1(CLK := MBATVT0510.status.auto_mode);
	IF F_TRIG_1.Q THEN
		MTBasicsPID_0.Enable := FALSE;
	END_IF;
	//MTBasicsPID_0.Enable := TRUE;
	MTBasicsPID_0.Invert := TRUE;
	MTBasicsPID_0.PIDParameters.Gain := MBAPid0510Para.gain;
	MTBasicsPID_0.PIDParameters.IntegrationTime := MBAPid0510Para.integration_time;
	MTBasicsPID_0.PIDParameters.DerivativeTime := MBAPid0510Para.derivative_time;
	MTBasicsPID_0.MinOut := 0.0;
	MTBasicsPID_0.MaxOut := 100.0;
	MTBasicsPID_0.SetValue := MBAPid0510Para.set_value;
	MTBasicsPID_0.ActValue := MBATIT0510.status.value;
	MTBasicsPID_0.Update := MBAPid0510.update;
	MTBasicsPID_0();
	MBAPid0510.out := MTBasicsPID_0.Out;
	IF MTBasicsPID_0.Active THEN
		MBATVT0510.input.auto_degree_set := MTBasicsPID_0.Out;
	ELSE
		MBATVT0510.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_0.UpdateDone THEN
		MBAPid0510.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS7.status.run_state) AND (NOT MBAS7_STEP[MBAS7.status.run_step].done AND ((MBAS7.status.run_step = 3) OR (MBAS7.status.run_step = 4))) THEN
		MBAS7.status.confirm_enable := TRUE;
	ELSE
		MBAS7.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
