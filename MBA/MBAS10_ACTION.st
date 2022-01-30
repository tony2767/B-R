
ACTION S10_ACT: 
	//设定时间
	FOR i := 0 TO MBAS10_STEP_NUM DO
		IF MBAS10_ST[i] < T#5s THEN
			MBAS10_ST[i] := T#5s;
		END_IF;
		MBAS10_STEP[i].set_time := MBAS10_ST[i];
	END_FOR;
	
	//流程步骤
	ProcessHandleFC(MBAS10,MBAS10_STEP[0],MBAS10_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS10.status.mode <> 0) AND (NOT MBAS10.auto_mode_edge) THEN
		MBAS10.auto_mode_edge := TRUE;
		MBAS10.manual_mode_edge := FALSE;

		MBAR11.control.auto_operate := TRUE;
		MBAXV0811.control.auto_operate := TRUE;
		MBAXV0807.control.auto_operate := TRUE;
		MBAXV0808.control.auto_operate := TRUE;
		MBAXV0809.control.auto_operate := TRUE;
		MBAP09.control.auto_operate := TRUE;
		MBATV0801A.control.auto_operate := TRUE;
		MBATV0801B.control.auto_operate := TRUE;
		MBAXV0806.control.auto_operate := TRUE;
		MBAXV0812.control.auto_operate := TRUE;
		MBATVT0802.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS10.status.mode = 0) AND (NOT MBAS10.manual_mode_edge) THEN
		MBAS10.manual_mode_edge := TRUE;
		MBAS10.auto_mode_edge := FALSE;
		
		MBAR11.control.manual_operate := TRUE;
		MBAXV0811.control.manual_operate := TRUE;
		MBAXV0807.control.manual_operate := TRUE;
		MBAXV0808.control.manual_operate := TRUE;
		MBAXV0809.control.manual_operate := TRUE;
		MBAP09.control.manual_operate := TRUE;
		MBATV0801A.control.manual_operate := TRUE;
		MBATV0801B.control.manual_operate := TRUE;
		MBAXV0806.control.manual_operate := TRUE;
		MBAXV0812.control.manual_operate := TRUE;
		MBATVT0802.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS10.input.error_signal := (MBAR11.status.motor_status >= 2) OR (MBAXV0811.status.valve_status >= 2) OR
	(MBAXV0807.status.valve_status >= 2) OR (MBAXV0808.status.valve_status >= 2) OR (MBAXV0809.status.valve_status >= 2) OR
	(MBAP09.status.motor_status >= 2) OR (MBATV0801A.status.valve_status >= 2) OR (MBATV0801B.status.valve_status >= 2) OR
	(MBAXV0806.status.valve_status >= 2) OR (MBAXV0812.status.valve_status >= 2) OR (MBATVT0802.status.regulator_status >= 2);

	
	//MBAXV0814 玻璃塔出料自动
	SquareWave_0(open_time := DINT_TO_TIME(MBAXV0814_Open_Time * 1000), close_time := DINT_TO_TIME(MBAXV0814_Close_Time * 1000), on_off := TRUE, out := MBAXV0814.input.auto_open_signal);
	IF MBAS10.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS10.status.run_step OF 
			0:
				MBAS10_STEP[0].done := TRUE;
			1:
				//人工加料
			2:
				MBAR11.input.auto_run_signal := TRUE;
				MBAXV0811.input.auto_open_signal := TRUE;
				MBAXV0807.input.auto_open_signal := TRUE;
				MBAXV0808.input.auto_open_signal := TRUE;
				MBAXV0809.input.auto_open_signal := TRUE;
				MBAP09.input.auto_run_signal := TRUE;
				MTBasicsPID_1.Enable := TRUE;
				MBAS10_STEP[2].done := TRUE;
			3:
				IF (MBATIT0801.status.value < MBAS10_PARA_Temp1) AND (NOT MBAS10_STEP[3].done) THEN
	 				MBATV0801A.input.auto_open_signal := TRUE;
				END_IF;
				IF MBATIT0801.status.value >= MBAS10_PARA_Temp1 THEN
					MBATV0801B.input.auto_open_signal := TRUE;
					MBATV0801A.input.auto_open_signal := FALSE;
					MBAS10_STEP[3].done := TRUE;
				END_IF;
			4:
				
			5:
				IF MBATIT0803.status.value >= MBAS10_PARA_Temp2 THEN
					MBAXV0806.input.auto_open_signal := TRUE;
					MBAXV0807.input.auto_open_signal := FALSE;
					MBAXV0808.input.auto_open_signal := FALSE;
					MBAS10_STEP[5].done := TRUE;
				END_IF;
			6:
				IF MBATIT0801.status.value >= MBAS10_PARA_Temp3 THEN
					MBATV0801B.input.auto_open_signal := FALSE;
					MBAXV0807.input.auto_open_signal := TRUE;
					MBAXV0808.input.auto_open_signal := TRUE;
					MBAXV0806.input.auto_open_signal := FALSE;
					MBAXV0809.input.auto_open_signal := FALSE;
					MBAS10_STEP[6].done := TRUE;
				END_IF;
			7:
				IF MBATIT0801.status.value <= MBAS10_PARA_Temp4 THEN
					MBAXV0807.input.auto_open_signal := FALSE;
					MBAXV0808.input.auto_open_signal := FALSE;
					MBAXV0812.input.auto_open_signal := TRUE;
					MBAP09.input.auto_run_signal := FALSE;
					MBAS10_STEP[7].done := TRUE;
				END_IF;
			8:
			//人工操作
		END_CASE;		
	END_IF;
			
	//TSV0510调节
	R_TRIG_3(CLK := MBATVT0802.status.auto_mode);
	IF R_TRIG_3.Q THEN
		MTBasicsPID_1.Enable := TRUE;
	END_IF;
	F_TRIG_3(CLK := MBATVT0802.status.auto_mode);
	IF F_TRIG_3.Q THEN
		MTBasicsPID_1.Enable := FALSE;
	END_IF;
	//MTBasicsPID_1.Enable := TRUE;
	MTBasicsPID_1.Invert := TRUE;
	MTBasicsPID_1.PIDParameters.Gain := MBAPid0802Para.gain;
	MTBasicsPID_1.PIDParameters.DerivativeTime := MBAPid0802Para.derivative_time;
	MTBasicsPID_1.PIDParameters.IntegrationTime := MBAPid0802Para.integration_time;
	MTBasicsPID_1.MinOut := 0.0;
	MTBasicsPID_1.MaxOut := 100.0;
	MTBasicsPID_1.SetValue := MBAPid0802Para.set_value;
	MTBasicsPID_1.ActValue := MBATIT0802.status.value;
	MTBasicsPID_1.Update := MBAPid0802.update;
	MTBasicsPID_1();
	MBAPid0802.out := MTBasicsPID_1.Out;
	IF MTBasicsPID_1.Active THEN
		MBATVT0802.input.auto_degree_set := MTBasicsPID_1.Out;
	ELSE
		MBATVT0802.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_1.UpdateDone THEN
		MBAPid0802.update := FALSE;
	END_IF;
	
	//人工确认步骤可用
	IF (MBAS10.status.run_state) AND (NOT MBAS10_STEP[MBAS10.status.run_step].done AND ((MBAS10.status.run_step = 1) OR (MBAS10.status.run_step = 4) OR (MBAS10.status.run_step = 8))) THEN
		MBAS10.status.confirm_enable := TRUE;
	ELSE
		MBAS10.status.confirm_enable := FALSE;
	END_IF;
END_ACTION
