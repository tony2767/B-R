
ACTION S9_ACT: 
	//设定时间
	FOR i := 0 TO MBAS9_STEP_NUM DO
		IF MBAS9_ST[i] < T#5s THEN
			MBAS9_ST[i] := T#5s;
		END_IF;
		MBAS9_STEP[i].set_time := MBAS9_ST[i];
	END_FOR;

	//流程步骤
	ProcessHandleFC(MBAS9,MBAS9_STEP[0],MBAS9_STEP_NUM);
	
	//object 手自动切换
	IF (MBAS9.status.mode <> 0) AND (NOT MBAS9.auto_mode_edge) THEN
		MBAS9.auto_mode_edge := TRUE;
		MBAS9.manual_mode_edge := FALSE;
		
		MBAXV0714.control.auto_operate := TRUE;
		MBAXV0718.control.auto_operate := TRUE;
		MBAP08.control.auto_operate := TRUE;
		MBAXV0717.control.auto_operate := TRUE;
		MBAXV0715.control.auto_operate := TRUE;
		MBAXV0901.control.auto_operate := TRUE;
		MBAXV0902.control.auto_operate := TRUE;
		MBAP12.control.auto_operate := TRUE;
		MBAXV0903.control.auto_operate := TRUE;
		STFLV0101.control.auto_operate := TRUE;
		STFLV0102.control.auto_operate := TRUE;
		STFP01.control.auto_operate := TRUE;
		MBAXV0721.control.auto_operate := TRUE;
		MBAXV0813.control.auto_operate := TRUE;
		MBAXV0716.control.auto_operate := TRUE;
		MBAXV0713.control.auto_operate := TRUE;
		MBAXV0719.control.auto_operate := TRUE;
		MBATV0702F.control.auto_operate := TRUE;
		MBATV0702E.control.auto_operate := TRUE;
		MBATV0702D.control.auto_operate := TRUE;
		MBATV0702C.control.auto_operate := TRUE;
		MBAR10.control.auto_operate := TRUE;
		MBAP11.control.auto_operate := TRUE;
		MBATV0702B.control.auto_operate := TRUE;
		MBATV0702A.control.auto_operate := TRUE;
		MBAXV0812.control.auto_operate := TRUE;
		MBAXV0712.control.auto_operate := TRUE;
	END_IF;
	
	IF (MBAS9.status.mode = 0) AND (NOT MBAS9.manual_mode_edge) THEN
		MBAS9.manual_mode_edge := TRUE;
		MBAS9.auto_mode_edge := FALSE;
		MBAXV0714.control.manual_operate := TRUE;
		MBAXV0718.control.manual_operate := TRUE;
		MBAP08.control.manual_operate := TRUE;
		MBAXV0717.control.manual_operate := TRUE;
		MBAXV0715.control.manual_operate := TRUE;
		MBAXV0901.control.manual_operate := TRUE;
		MBAXV0902.control.manual_operate := TRUE;
		MBAP12.control.manual_operate := TRUE;
		MBAXV0903.control.manual_operate := TRUE;
		STFLV0101.control.manual_operate := TRUE;
		STFLV0102.control.manual_operate := TRUE;
		STFP01.control.manual_operate := TRUE;
		MBAXV0721.control.manual_operate := TRUE;
		MBAXV0813.control.manual_operate := TRUE;
		MBAXV0716.control.manual_operate := TRUE;
		MBAXV0713.control.manual_operate := TRUE;
		MBAXV0719.control.manual_operate := TRUE;
		MBATV0702F.control.manual_operate := TRUE;
		MBATV0702E.control.manual_operate := TRUE;
		MBATV0702D.control.manual_operate := TRUE;
		MBATV0702C.control.manual_operate := TRUE;
		MBAR10.control.manual_operate := TRUE;
		MBAP11.control.manual_operate := TRUE;
		MBATV0702B.control.manual_operate := TRUE;
		MBATV0702A.control.manual_operate := TRUE;
		MBAXV0812.control.manual_operate := TRUE;
		MBAXV0712.control.manual_operate := TRUE;
	END_IF;	
	
	//错误信号停机
	MBAS9.input.error_signal := (MBAXV0714.status.valve_status >= 2) OR(MBAXV0718.status.valve_status >= 2) OR
	(MBAP08.status.motor_status >= 2) OR(MBAXV0717.status.valve_status >= 2) OR(MBAXV0715.status.valve_status >= 2) OR
	(MBAXV0901.status.valve_status >= 2) OR(MBAXV0902.status.valve_status >= 2) OR(MBAP12.status.motor_status >= 2) OR
	(MBAXV0903.status.valve_status >= 2) OR(STFLV0101.status.valve_status >= 2) OR(STFLV0102.status.valve_status >= 2) OR
	(STFP01.status.motor_status >= 2) OR(MBAXV0721.status.valve_status >= 2) OR(MBAXV0813.status.valve_status >= 2) OR
	(MBAXV0716.status.valve_status >= 2) OR(MBAXV0713.status.valve_status >= 2) OR(MBAXV0719.status.valve_status >= 2) OR
	(MBATV0702F.status.valve_status >= 2) OR(MBATV0702E.status.valve_status >= 2) OR(MBATV0702D.status.valve_status >= 2) OR
	(MBATV0702C.status.valve_status >= 2) OR(MBAR10.status.motor_status >= 2) OR(MBAP11.status.motor_status >= 2) OR
	(MBATV0702B.status.valve_status >= 2) OR(MBATV0702A.status.valve_status >= 2) OR(MBAXV0812.status.valve_status >= 2) OR
	(MBAXV0712.status.valve_status >= 2) OR (MBAFQIT0503.comm_timeout = 0) OR (STFFQIT0102.comm_timeout = 0);

	
	IF MBAS9.status.run_state = 1 THEN
		//步骤执行动作
		CASE MBAS9.status.run_step OF 
			0:
				MBAS9_STEP[0].done := TRUE;
			1:
				MBAXV0714.input.auto_open_signal := FALSE;
				MBAXV0718.input.auto_open_signal := FALSE;
				MBAP08.input.auto_run_signal := TRUE;
				MBAXV0717.input.auto_open_signal := TRUE;
				MBAXV0715.input.auto_open_signal := TRUE;
				MBAS9_STEP[1].done := TRUE;
			2:
				//人工抽料
			3:
				MBAXV0715.input.auto_open_signal := FALSE;
				MBAXV0717.input.auto_open_signal := FALSE;
				MBAP08.input.auto_run_signal := FALSE;
				MBAXV0714.input.auto_open_signal := TRUE;
				MBAXV0718.input.auto_open_signal := TRUE;
				MBAS9_STEP[3].done := TRUE;
			4:
				LiquidTransfer_3(sp_time := DINT_TO_TIME(MBAS9_PARA_T1 * 1000), sp_accumulation := MBAS9_PARA_AC1, done := MBAS9_STEP[4].done, flowmeter := MBAFQIT0503);
				MBAXV0901.input.auto_open_signal := LiquidTransfer_3.run;
			5:
				LiquidTransfer_6(sp_time := DINT_TO_TIME(MBAS9_PARA_T2 * 1000), sp_accumulation := MBAS9_PARA_AC2, done := MBAS9_STEP[5].done, flowmeter := MBAFQIT0503);
				MBAXV0902.input.auto_open_signal := LiquidTransfer_6.run;
			6:
				MBAP12.input.auto_run_signal := TRUE;
				LiquidTransfer_8(sp_time := DINT_TO_TIME(MBAS9_PARA_T3 * 1000), sp_accumulation := MBAS9_PARA_AC3, done := MBAS9_STEP[6].done, flowmeter := STFFQIT0102);
				IF LiquidTransfer_8.run THEN
					MBAXV0903.input.auto_open_signal := TRUE;
					STFLV0101.input.auto_open_signal := FALSE;
					STFLV0102.input.auto_open_signal := FALSE;
					STFP01.input.auto_run_signal := TRUE;
				ELSE
					STFP01.input.auto_run_signal := FALSE;
					MBAXV0903.input.auto_open_signal := FALSE;
				END_IF;
			7:
				LiquidTransfer_9(sp_time := DINT_TO_TIME(MBAS9_PARA_T4 * 1000), sp_accumulation := MBAS9_PARA_AC4, done := MBAS9_STEP[7].done, flowmeter := STFFQIT0102);
				IF LiquidTransfer_9.run THEN
					MBAXV0721.input.auto_open_signal := TRUE;
					STFLV0101.input.auto_open_signal := FALSE;
					STFLV0102.input.auto_open_signal := FALSE;
					STFP01.input.auto_run_signal := TRUE;
				ELSE
					STFP01.input.auto_run_signal := FALSE;
					MBAXV0721.input.auto_open_signal := FALSE;
				END_IF;
			8:
				LiquidTransfer_10(sp_time := DINT_TO_TIME(MBAS9_PARA_T5 * 1000), sp_accumulation := MBAS9_PARA_AC5, done := MBAS9_STEP[8].done, flowmeter := STFFQIT0102);
				IF LiquidTransfer_10.run THEN
					MBAXV0813.input.auto_open_signal := TRUE;
					STFLV0101.input.auto_open_signal := FALSE;
					STFLV0102.input.auto_open_signal := FALSE;
					STFP01.input.auto_run_signal := TRUE;
				ELSE
					STFP01.input.auto_run_signal := FALSE;
					MBAXV0813.input.auto_open_signal := FALSE;
					MBAP12.input.auto_run_signal := FALSE;
				END_IF;
			9:
				//人工投料
			10:
				IF (MBALIT0701.status.value > MBAS9_PARA_L1) AND (NOT MBAS9_STEP[10].done) THEN
					MBAXV0716.input.auto_open_signal := TRUE;
					MBAXV0713.input.auto_open_signal := TRUE;
					MBAXV0719.input.auto_open_signal := TRUE;
				END_IF;
				IF MBALIT0701.status.value <= MBAS9_PARA_L1 THEN
					MBAXV0713.input.auto_open_signal := FALSE;
					MBAXV0714.input.auto_open_signal := FALSE;
					MBAS9_STEP[10].done := TRUE;
				END_IF;
			11:
				IF (NOT flag_record_MBATIT0702) AND (NOT MBAS9_STEP[11].done) THEN
					last_value_MBATIT0702 := MBATIT0702.status.value;
					flag_record_MBATIT0702 := TRUE;
				END_IF;
				HeatPot_6(ST1 := DINT_TO_TIME(MBAS9_PARA_T6 * 1000),
				ST2 := DINT_TO_TIME(MBAS9_PARA_T7 * 1000),
				V3 := MBATV0702F,
				V4 := MBATV0702E,
				V5 := MBATV0702D,
				V6 := MBATV0702C,
				done := MBAS9_STEP[11].done);
				IF MBAS9_STEP[11].done THEN
					flag_record_MBATIT0702 := FALSE;
				END_IF;
			12:
				IF MBATIT0702.status.value - last_value_MBATIT0702 >= MBAS9_PARA_Temp1 THEN
					MBAR10.input.auto_run_signal := TRUE;
					MBATV0702F.input.auto_open_signal := FALSE;
					MBAP11.input.auto_run_signal := TRUE;
					MBAP12.input.auto_run_signal := TRUE;
					MBAS9_STEP[12].done := TRUE;
				END_IF;
			13:
				TON_11.PT := DINT_TO_TIME(MBAS9_PARA_T8 * 1000);
				IF (MBATIT0702.status.value >= MBAS9_PARA_Temp2) AND (NOT MBAS9_STEP[13].done) THEN
					TON_11.IN := TRUE;
				END_IF;
				IF TON_11.Q THEN
					TON_11.IN := FALSE;
					MBAXV0716.input.auto_open_signal := FALSE;
					MBAXV0718.input.auto_open_signal := FALSE;
					MBATV0702E.input.auto_open_signal := FALSE;
					MBAP11.input.auto_run_signal := FALSE;
					MBAP12.input.auto_run_signal := FALSE;
					MBAS9_STEP[13].done := TRUE;
				END_IF;
				TON_11();
			14:
				MBAXV0715.input.auto_open_signal := TRUE;
				MBAXV0717.input.auto_open_signal := TRUE;
				MBAP08.input.auto_run_signal := TRUE;
				IF (NOT flag_record_MBATIT0702) AND (NOT MBAS9_STEP[14].done) THEN
					last_value_MBATIT0702 := MBATIT0702.status.value;
					flag_record_MBATIT0702 := TRUE;
				END_IF;
				IF last_value_MBATIT0702 - MBATIT0702.status.value >= MBAS9_PARA_Temp3 THEN
					MBATV0702E.input.auto_open_signal := TRUE;
					flag_record_MBATIT0702 := FALSE;
					MBAS9_STEP[14].done := TRUE;
				END_IF;
			15:
				IF (MBAPIT0702.status.value <= MBAS9_PARA_P1) AND (MBATIT0702.status.value >= MBAS9_PARA_Temp4) THEN
					
				END_IF;
				CoolPot_4(
					time := cool_pot_time,
					V1 := MBATV0702A,
					V2 := MBATV0702B,
					V3 := MBATV0702C,
					V4 := MBATV0702E,
					V5 := MBATV0702D,
				done := MBAS9_STEP[15].done);
			16:
				MBAXV0719.input.auto_open_signal := FALSE;
				MBAXV0717.input.auto_open_signal := FALSE;
				MBAXV0715.input.auto_open_signal := FALSE;
				MBAP08.input.auto_run_signal := FALSE;
				MBAXV0718.input.auto_open_signal := TRUE;
				MBAXV0714.input.auto_open_signal := TRUE;
				MBAS9_STEP[16].done := TRUE;
			17:
				//人工确认
			18:
				ReverseDelay_1(set_time := DINT_TO_TIME(MBAS9_PARA_T9 * 1000), done := MBAS9_STEP[18].done);
				IF ReverseDelay_1.run THEN
					MBAXV0812.input.auto_open_signal := TRUE;
					MBAXV0712.input.auto_open_signal := TRUE;
				ELSE
					MBAXV0712.input.auto_open_signal := FALSE;
					MBAXV0812.input.auto_open_signal := FALSE;
					MBAR10.input.auto_run_signal := FALSE;
				END_IF;
			19:
			//人工确认
		END_CASE;	
		
		//人工确认步骤可用
		IF (MBAS9.status.run_state) AND (NOT MBAS9_STEP[MBAS9.status.run_step].done AND ((MBAS9.status.run_step = 2) OR (MBAS9.status.run_step = 9) OR (MBAS9.status.run_step = 17) OR (MBAS9.status.run_step = 19))) THEN
			MBAS9.status.confirm_enable := TRUE;
		ELSE
			MBAS9.status.confirm_enable := FALSE;
		END_IF;
	END_IF;
END_ACTION
