
ACTION P4S3_ACT: 
	//EDTR08脱溶
	//常压回收
	IF r08_recover_1 THEN
		CASE r08_recover_1_step OF
			0:	
				EDTXV1605.control.auto_operate := TRUE;
				EDTXV1608.control.auto_operate := TRUE;
				EDTXV1611.control.auto_operate := TRUE;
				EDTXV1609.control.auto_operate := TRUE;
				EDTXV1616.control.auto_operate := TRUE;
				EDTFVT1601.control.auto_operate := TRUE;
				EDTR08.control.auto_operate := TRUE;
				EDTTV1601C.control.auto_operate := TRUE;
				EDTTV1601D.control.auto_operate := TRUE;
				EDTTV1601E.control.auto_operate := TRUE;
				EDTTV1601F.control.auto_operate := TRUE;
				EDTTV1601A.control.auto_operate := TRUE;
				EDTTV1601B.control.auto_operate := TRUE;
				r08_recover_1_step := 1;
			1:
				EDTXV1605.input.auto_open_signal := TRUE;
				EDTXV1608.input.auto_open_signal := TRUE;
				EDTXV1611.input.auto_open_signal := TRUE;
				EDTXV1609.input.auto_open_signal := TRUE;
				EDTXV1616.input.auto_open_signal := TRUE;
				MTBasicsPID_14.Enable := FALSE;
				EDTFVT1601.input.auto_degree_set := 0.0;
				EDTR08.input.auto_run_signal := TRUE;
				IF EDTXV1605.input.open_feedback_state AND EDTXV1608.input.open_feedback_state AND EDTXV1611.input.open_feedback_state AND
					EDTXV1609.input.open_feedback_state AND EDTXV1616.input.open_feedback_state AND EDTR08.input.auto_run_signal THEN
					r08_recover_1_step := 2;
				END_IF;
			2:
				HeatPot_19(ST1 := DINT_TO_TIME(EDTP4S3_PARA_T1 * 1000),
				ST2 := DINT_TO_TIME(EDTP4S3_PARA_T2 * 1000),
				V3 := EDTTV1601C,
				V4 := EDTTV1601D,
				V5 := EDTTV1601E,
				V6 := EDTTV1601F,
				done := HeatPot_19_done);
				IF HeatPot_19_done THEN
					HeatPot_19_done := FALSE;
					r08_recover_1_step := 3;
				END_IF;
			3:
				IF EDTTIT1601.status.value >=  EDTP4S3_PARA_Temp1 THEN
					EDTTV1601C.input.auto_open_signal := FALSE;
					r08_recover_1_step := 4;
				END_IF;
			4:
				TON_87.PT := DINT_TO_TIME(EDTP4S3_PARA_T3 * 60 * 1000);
				TON_87.IN := TRUE;
				IF TON_87.Q THEN
					TON_87.IN := FALSE;
					MTBasicsPID_14.Enable := TRUE;
					r08_recover_1_step := 5;
				END_IF;
			5:
				IF EDTTIT1601.status.value >= EDTP4S3_PARA_Temp2 THEN
					EDTTV1601D.input.auto_open_signal := FALSE;
					EDTTV1601E.input.auto_open_signal := FALSE;
					EDTTV1601F.input.auto_open_signal := TRUE;
					IF EDTTV1601D.input.close_feedback_state AND EDTTV1601E.input.close_feedback_state AND EDTTV1601F.input.open_feedback_state THEN
						r08_recover_1_step := 6;
					END_IF;
				END_IF;
			6:
				TON_87.PT := DINT_TO_TIME(EDTP4S3_PARA_T4 * 1000);
				TON_87.IN := TRUE;
				IF TON_87.Q THEN
					TON_87.IN := FALSE;
					r08_recover_1_step := 7;
				END_IF;
			7:
				EDTTV1601F.input.auto_open_signal := FALSE;
				IF EDTTV1601F.input.close_feedback_state THEN
					EDTTV1601A.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1601A.input.open_feedback_state THEN
					EDTTV1601B.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1601A.input.open_feedback_state AND EDTTV1601B.input.open_feedback_state AND EDTTV1601F.input.close_feedback_state THEN
					r08_recover_1_step := 8;
				END_IF;
			8:
				IF EDTTIT1601.status.value <= EDTP4S3_PARA_Temp3 THEN
					MTBasicsPID_14.Enable := FALSE;
					EDTFVT1601.input.auto_degree_set := 0.0;
					EDTTV1601B.input.auto_open_signal := FALSE;
					IF EDTTV1601B.input.close_feedback_state THEN
						EDTTV1601A.input.auto_open_signal := FALSE;
						IF EDTTV1601A.input.close_feedback_state THEN
							r08_recover_1_step := 9;
						END_IF;
					END_IF;
				END_IF;
			9:
				EDTR08.input.auto_run_signal := FALSE;
				EDTXV1605.input.auto_open_signal := FALSE;
				EDTXV1608.input.auto_open_signal := FALSE;
				IF (NOT EDTR08.input.run_feedback) AND EDTXV1605.input.close_feedback_state AND EDTXV1608.input.close_feedback_state THEN
					r08_recover_1_step := 0;
					r08_recover_1 := FALSE;
				END_IF;	
		END_CASE;
		TON_87();
	END_IF;

	
	
	//减压回收
	IF r08_recover_2 THEN
		CASE r08_recover_2_step OF
			0:
				EDTR08.control.auto_operate := TRUE;
				EDTXV1612.control.auto_operate := TRUE;
				EDTXV1614.control.auto_operate := TRUE;
				EDTFVT1601.control.auto_operate := TRUE;
				EDTTV1601A.control.auto_operate := TRUE;
				EDTTV1601B.control.auto_operate := TRUE;
				EDTTV1601C.control.auto_operate := TRUE;
				EDTTV1601D.control.auto_operate := TRUE;
				EDTTV1601E.control.auto_operate := TRUE;
				EDTTV1601F.control.auto_operate := TRUE;
				EDTXV1620.control.auto_operate := TRUE;
				EDTP24.control.auto_operate := TRUE;
				EDTXV1610.control.auto_operate := TRUE;
				EDTXV1613.control.auto_operate := TRUE;
				EDTXV1605.control.auto_operate := TRUE;
				EDTXV1616.control.auto_operate := TRUE;
				EDTXV1611.control.auto_operate := TRUE;
				EDTXV1609.control.auto_operate := TRUE;
				r08_recover_2_step := 1;
			1:
				EDTXV1605.input.auto_open_signal := TRUE;
				EDTR08.input.auto_run_signal := TRUE;
				EDTXV1612.input.auto_open_signal := TRUE;
				EDTXV1614.input.auto_open_signal := TRUE;
				EDTXV1616.input.auto_open_signal := FALSE;
				MTBasicsPID_14.Enable := FALSE;
				EDTFVT1601.input.auto_degree_set := 0.0;
				IF EDTR08.input.run_feedback AND EDTXV1612.input.open_feedback_state AND EDTXV1614.input.open_feedback_state 
					AND EDTXV1605.input.open_feedback_state AND EDTXV1616.input.close_feedback_state THEN
					r08_recover_2_step := 2;
				END_IF;
			2:
				IF EDTTIT1601.status.value >= EDTP4S3_PARA_Temp4 THEN
					EDTTV1601A.input.auto_open_signal := TRUE;
					EDTTV1601B.input.auto_open_signal := TRUE;
					r08_recover_2_step := 3;
				ELSE
					r08_recover_2_step := 4;
				END_IF;
			3:
				IF EDTTIT1601.status.value <= EDTP4S3_PARA_Temp5 THEN
					EDTTV1601A.input.auto_open_signal := FALSE;
					EDTTV1601B.input.auto_open_signal := FALSE;
					IF EDTTV1601A.input.close_feedback_state AND EDTTV1601B.input.close_feedback_state THEN
						r08_recover_2_step := 4;
					END_IF;
				END_IF;
			4:
				EDTXV1620.input.auto_open_signal := TRUE;
				IF EDTXV1620.input.open_feedback_state THEN
					EDTP24.input.auto_run_signal := TRUE;
					IF EDTP24.input.run_feedback THEN
						r08_recover_2_step := 5;
					END_IF;
				END_IF;
			5:
				HeatPot_20(ST1 := DINT_TO_TIME(EDTP4S3_PARA_T1 * 1000),
				ST2 := DINT_TO_TIME(EDTP4S3_PARA_T2 * 1000),
				V3 := EDTTV1601C,
				V4 := EDTTV1601D,
				V5 := EDTTV1601E,
				V6 := EDTTV1601F,
				done := HeatPot_20_done);
				IF HeatPot_20_done THEN
					HeatPot_20_done := FALSE;
					r08_recover_2_step := 6;
				END_IF;
			6:
				IF EDTTIT1601.status.value >=  EDTP4S3_PARA_Temp6 THEN
					EDTTV1601C.input.auto_open_signal := FALSE;
					r08_recover_2_step := 7;
				END_IF;
			7:
				TON_88.PT := DINT_TO_TIME(EDTP4S3_PARA_T5 * 60 * 1000);
				TON_88.IN := TRUE;
				IF TON_88.Q THEN
					TON_88.IN := FALSE;
					MTBasicsPID_14.Enable := TRUE;
					r08_recover_2_step := 8;
				END_IF;
			8:
				IF EDTTIT1601.status.value >= EDTP4S3_PARA_Temp7 THEN
					EDTTV1601D.input.auto_open_signal := FALSE;
					EDTTV1601E.input.auto_open_signal := FALSE;
					EDTTV1601F.input.auto_open_signal := TRUE;
					IF EDTTV1601D.input.close_feedback_state AND EDTTV1601E.input.close_feedback_state AND EDTTV1601F.input.open_feedback_state THEN
						r08_recover_2_step := 9;
					END_IF;
				END_IF;
			9:
				TON_88.PT := DINT_TO_TIME(EDTP4S3_PARA_T6 * 1000);
				TON_88.IN := TRUE;
				IF TON_88.Q THEN
					TON_88.IN := FALSE;
					r08_recover_2_step := 10;
				END_IF;
			10:
				EDTTV1601F.input.auto_open_signal := FALSE;
				IF EDTTV1601F.input.close_feedback_state THEN
					EDTTV1601A.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1601A.input.open_feedback_state THEN
					EDTTV1601B.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1601A.input.open_feedback_state AND EDTTV1601B.input.open_feedback_state AND EDTTV1601F.input.close_feedback_state THEN
					r08_recover_2_step := 11;
				END_IF;
			11:
				IF EDTTIT1601.status.value <= EDTP4S3_PARA_Temp8 THEN
					EDTTV1601B.input.auto_open_signal := FALSE;
					IF EDTTV1601B.input.close_feedback_state THEN
						EDTTV1601A.input.auto_open_signal := FALSE;
						IF EDTTV1601A.input.close_feedback_state THEN
							r08_recover_2_step := 12;
						END_IF;
					END_IF;
				END_IF;
			12:
				EDTXV1610.input.auto_open_signal := TRUE;
				EDTXV1613.input.auto_open_signal := TRUE;
				IF EDTXV1610.input.open_feedback_state AND EDTXV1613.input.open_feedback_state THEN
					r08_recover_2_step := 13;
				END_IF;
			13:
				IF EDTPIT1601.status.value >= EDTP4S3_PARA_P1 THEN
					EDTP24.input.auto_run_signal := FALSE;
					IF NOT EDTP24.input.run_feedback THEN
						EDTXV1620.input.auto_open_signal := FALSE;
						IF EDTXV1620.input.close_feedback_state THEN
							r08_recover_2_step := 14;
						END_IF;
					END_IF;
				END_IF;
			14:
				IF EDTPIT1601.status.value >= EDTP4S3_PARA_P2 THEN
					EDTXV1610.input.auto_open_signal := FALSE;
					EDTXV1613.input.auto_open_signal := FALSE;
					MTBasicsPID_14.Enable := FALSE;
					EDTFVT1601.input.auto_degree_set := 100.0;
					EDTXV1616.input.auto_open_signal := TRUE;
					EDTR08.input.auto_run_signal := FALSE;
					EDTXV1605.input.auto_open_signal := FALSE;
					EDTXV1612.input.auto_open_signal := FALSE;
					EDTXV1611.input.auto_open_signal := FALSE;
					EDTXV1609.input.auto_open_signal := FALSE;
					EDTXV1614.input.auto_open_signal := FALSE;
					r08_recover_2_step := 0;
					r08_recover_2 := FALSE;
				END_IF;
		END_CASE;
		TON_88();
	END_IF;

	//V59转移 减压
	IF v59_transfer_2 THEN
		CASE v59_transfer_2_step OF
			0:
				IF r08_recover_2_step >= 12 OR (NOT r08_recover_2) THEN
					v59_transfer_2 := FALSE;
				ELSE
					EDTFVT1601.control.auto_operate := TRUE;
					EDTXV1614.control.auto_operate := TRUE;
					EDTXV1612.control.auto_operate := TRUE;
					EDTXV1613.control.auto_operate := TRUE;
					EDTXV1621.control.auto_operate := TRUE;
					EDTXV1618.control.auto_operate := TRUE;
					v59_transfer_2_step := 1;
				END_IF;
			1:
				MTBasicsPID_14.Enable := FALSE;
				EDTFVT1601.input.auto_degree_set := 0.0;
				EDTXV1614.input.auto_open_signal := FALSE;
				EDTXV1612.input.auto_open_signal := FALSE;
				IF EDTXV1614.input.close_feedback_state AND EDTXV1612.input.close_feedback_state THEN
					EDTXV1613.input.auto_open_signal := TRUE;
					v59_transfer_2_step := 2;
				END_IF;
			2:
				TON_89.PT := DINT_TO_TIME(EDTP4S3_PARA_T7 * 1000);
				TON_89.IN := TRUE;
				IF TON_89.Q THEN
					TON_89.IN := FALSE;
					EDTXV1613.input.auto_open_signal := FALSE;
					EDTXV1621.input.auto_open_signal := TRUE;
					v59_transfer_2_step := 3;
				END_IF;
			3:
				TON_89.PT := DINT_TO_TIME(EDTP4S3_PARA_T8 * 1000);
				TON_89.IN := TRUE;	
				IF TON_89.Q THEN
					TON_89.IN := FALSE;
					EDTXV1621.input.auto_open_signal := FALSE;
					EDTXV1618.input.auto_open_signal := TRUE;
					v59_transfer_2_step := 4;
				END_IF;
			4:
				TON_89.PT := DINT_TO_TIME(EDTP4S3_PARA_T9 * 1000);
				TON_89.IN := TRUE;	
				IF TON_89.Q THEN
					TON_89.IN := FALSE;
					EDTXV1618.input.auto_open_signal := FALSE;
					EDTXV1614.input.auto_open_signal := TRUE;
					v59_transfer_2_step := 5;
				END_IF;
			5:
				IF EDTPIT1601.status.value <= EDTP4S3_PARA_P3 THEN
					EDTXV1612.input.auto_open_signal := TRUE;
					MTBasicsPID_14.Enable := TRUE;
					v59_transfer_2_step := 0;
					v59_transfer_2 := FALSE;
				END_IF;
		END_CASE;
		TON_89();
	END_IF;
	//V59转移 常压
	IF v59_transfer_1 THEN
		CASE v59_transfer_1_step OF
			0:
				IF r08_recover_2 THEN
					v59_transfer_1 := FALSE;
				ELSE
					EDTXV1621.control.auto_operate := TRUE;
					EDTXV1618.control.auto_operate := TRUE;
					v59_transfer_1_step := 1;
				END_IF;
			1:
				EDTXV1621.input.auto_open_signal := TRUE;
				v59_transfer_1_step := 2;
			2:
				TON_90.PT := DINT_TO_TIME(EDTP4S3_PARA_T8 * 1000);
				TON_90.IN := TRUE;	
				IF TON_90.Q THEN
					TON_90.IN := FALSE;
					EDTXV1621.input.auto_open_signal := FALSE;
					EDTXV1618.input.auto_open_signal := TRUE;
					v59_transfer_1_step := 3;
				END_IF;
			3:
				TON_90.PT := DINT_TO_TIME(EDTP4S3_PARA_T9 * 1000);
				TON_90.IN := TRUE;	
				IF TON_90.Q THEN
					TON_90.IN := FALSE;
					EDTXV1618.input.auto_open_signal := FALSE;
					v59_transfer_1_step := 0;
					v59_transfer_1 := FALSE;
				END_IF;
		END_CASE;
		TON_90();
	END_IF;
	
	
	//EDTR09脱溶
	//常压回收
	IF r09_recover_1 THEN
		CASE r09_recover_1_step OF
			0:	
				EDTTVT1502.control.auto_operate := TRUE;
				EDTXV1505.control.auto_operate := TRUE;
				EDTXV1508.control.auto_operate := TRUE;
				EDTXV1506.control.auto_operate := TRUE;
				EDTXV1525.control.auto_operate := TRUE;
				EDTFVT1502.control.auto_operate := TRUE;
				EDTR09.control.auto_operate := TRUE;
				EDTTV1501C.control.auto_operate := TRUE;
				EDTTV1501D.control.auto_operate := TRUE;
				EDTTV1501E.control.auto_operate := TRUE;
				EDTTV1501F.control.auto_operate := TRUE;
				EDTTV1501A.control.auto_operate := TRUE;
				EDTTV1501B.control.auto_operate := TRUE;
				r09_recover_1_step := 1;
			1:
				EDTXV1505.input.auto_open_signal := TRUE;
				EDTXV1508.input.auto_open_signal := TRUE;
				EDTXV1506.input.auto_open_signal := TRUE;
				EDTXV1525.input.auto_open_signal := TRUE;
				MTBasicsPID_13.Enable := FALSE;
				EDTFVT1502.input.auto_degree_set := 0.0;
				EDTR09.input.auto_run_signal := TRUE;
				IF EDTXV1505.input.open_feedback_state AND EDTXV1508.input.open_feedback_state AND
					EDTXV1506.input.open_feedback_state AND EDTXV1525.input.open_feedback_state AND EDTR09.input.auto_run_signal THEN
					r09_recover_1_step := 2;
				END_IF;
			2:
				HeatPot_4(ST1 := DINT_TO_TIME(EDTP4S3_PARA_T1 * 1000),
				ST2 := DINT_TO_TIME(EDTP4S3_PARA_T2 * 1000),
				V3 := EDTTV1501C,
				V4 := EDTTV1501D,
				V5 := EDTTV1501E,
				V6 := EDTTV1501F,
				done := HeatPot_4_done);
				IF HeatPot_4_done THEN
					HeatPot_4_done := FALSE;
					r09_recover_1_step := 3;
				END_IF;
			3:
				IF EDTTIT1501.status.value >=  EDTP4S3_PARA_Temp1 THEN
					EDTTV1501C.input.auto_open_signal := FALSE;
					r09_recover_1_step := 4;
				END_IF;
			4:
				TON_91.PT := DINT_TO_TIME(EDTP4S3_PARA_T3 * 60 * 1000);
				TON_91.IN := TRUE;
				IF TON_91.Q THEN
					TON_91.IN := FALSE;
					MTBasicsPID_13.Enable := TRUE;
					r09_recover_1_step := 5;
				END_IF;
			5:
				IF EDTTIT1501.status.value >= EDTP4S3_PARA_Temp2 THEN
					EDTTV1501D.input.auto_open_signal := FALSE;
					EDTTV1501E.input.auto_open_signal := FALSE;
					EDTTV1501F.input.auto_open_signal := TRUE;
					IF EDTTV1501D.input.close_feedback_state AND EDTTV1501E.input.close_feedback_state AND EDTTV1501F.input.open_feedback_state THEN
						r09_recover_1_step := 6;
					END_IF;
				END_IF;
			6:
				TON_91.PT := DINT_TO_TIME(EDTP4S3_PARA_T4 * 1000);
				TON_91.IN := TRUE;
				IF TON_91.Q THEN
					TON_91.IN := FALSE;
					r09_recover_1_step := 7;
				END_IF;
			7:
				EDTTV1501F.input.auto_open_signal := FALSE;
				IF EDTTV1501F.input.close_feedback_state THEN
					EDTTV1501A.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1501A.input.open_feedback_state THEN
					EDTTV1501B.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1501A.input.open_feedback_state AND EDTTV1501B.input.open_feedback_state AND EDTTV1501F.input.close_feedback_state THEN
					r09_recover_1_step := 8;
				END_IF;
			8:
				IF EDTTIT1501.status.value <= EDTP4S3_PARA_Temp3 THEN
					MTBasicsPID_13.Enable := FALSE;
					EDTFVT1502.input.auto_degree_set := 0.0;
					EDTTV1501B.input.auto_open_signal := FALSE;
					IF EDTTV1501B.input.close_feedback_state THEN
						EDTTV1501A.input.auto_open_signal := FALSE;
						IF EDTTV1501A.input.close_feedback_state THEN
							r09_recover_1_step := 9;
						END_IF;
					END_IF;
				END_IF;
			9:
				EDTR09.input.auto_run_signal := FALSE;
				EDTXV1505.input.auto_open_signal := FALSE;
				IF (NOT EDTR09.input.run_feedback) AND EDTXV1505.input.close_feedback_state THEN
					r09_recover_1_step := 0;
					r09_recover_1 := FALSE;
				END_IF;	
		END_CASE;
		TON_91();
	END_IF;

	

	//减压回收
	IF r09_recover_2 THEN
		CASE r09_recover_2_step OF
			0:
				EDTR09.control.auto_operate := TRUE;
				EDTXV1514.control.auto_operate := TRUE;
				EDTXV1516.control.auto_operate := TRUE;
				EDTFVT1502.control.auto_operate := TRUE;
				EDTTV1501A.control.auto_operate := TRUE;
				EDTTV1501B.control.auto_operate := TRUE;
				EDTTV1501C.control.auto_operate := TRUE;
				EDTTV1501D.control.auto_operate := TRUE;
				EDTTV1501E.control.auto_operate := TRUE;
				EDTTV1501F.control.auto_operate := TRUE;
				EDTXV1515.control.auto_operate := TRUE;
				EDTXV1507.control.auto_operate := TRUE;
				EDTTVT1502.control.auto_operate := TRUE;
				EDTXV1525.control.auto_operate := TRUE;
				EDTXV1508.control.auto_operate := TRUE;
				EDTXV1506.control.auto_operate := TRUE;
				r09_recover_2_step := 1;
			1:
				EDTR09.input.auto_run_signal := TRUE;
				EDTXV1514.input.auto_open_signal := TRUE;
				EDTXV1516.input.auto_open_signal := TRUE;
				EDTXV1525.input.auto_open_signal := FALSE;
				MTBasicsPID_13.Enable := FALSE;
				EDTFVT1502.input.auto_degree_set := 0.0;
				IF EDTR09.input.run_feedback AND EDTXV1514.input.open_feedback_state AND EDTXV1516.input.open_feedback_state THEN
					r09_recover_2_step := 2;
				END_IF;
			2:
				IF EDTTIT1501.status.value >= EDTP4S3_PARA_Temp4 THEN
					EDTTV1501A.input.auto_open_signal := TRUE;
					EDTTV1501B.input.auto_open_signal := TRUE;
					r09_recover_2_step := 3;
				ELSE
					r09_recover_2_step := 4;
				END_IF;
			3:
				IF EDTTIT1501.status.value <= EDTP4S3_PARA_Temp5 THEN
					EDTTV1501A.input.auto_open_signal := FALSE;
					EDTTV1501B.input.auto_open_signal := FALSE;
					IF EDTTV1501A.input.close_feedback_state AND EDTTV1501B.input.close_feedback_state THEN
						r09_recover_2_step := 4;	
					END_IF;
				END_IF;
			4:
				EDTP23_open := TRUE;
				IF EDTPIT1501.status.value < -10.0 THEN
					r09_recover_2_step := 5;
				END_IF;
			5:
				HeatPot_21(ST1 := DINT_TO_TIME(EDTP4S3_PARA_T1 * 1000),
				ST2 := DINT_TO_TIME(EDTP4S3_PARA_T2 * 1000),
				V3 := EDTTV1501C,
				V4 := EDTTV1501D,
				V5 := EDTTV1501E,
				V6 := EDTTV1501F,
				done := HeatPot_21_done);
				IF HeatPot_21_done THEN
					HeatPot_21_done := FALSE;
					r09_recover_2_step := 6;
				END_IF;
			6:
				IF EDTTIT1501.status.value >=  EDTP4S3_PARA_Temp6 THEN
					EDTTV1501C.input.auto_open_signal := FALSE;
					r09_recover_2_step := 7;
				END_IF;
			7:
				TON_92.PT := DINT_TO_TIME(EDTP4S3_PARA_T5 * 60 * 1000);
				TON_92.IN := TRUE;
				IF TON_92.Q THEN
					TON_92.IN := FALSE;
					MTBasicsPID_13.Enable := TRUE;
					r09_recover_2_step := 8;
				END_IF;
			8:
				IF EDTTIT1501.status.value >= EDTP4S3_PARA_Temp7 THEN
					EDTTV1501D.input.auto_open_signal := FALSE;
					EDTTV1501E.input.auto_open_signal := FALSE;
					EDTTV1501F.input.auto_open_signal := TRUE;
					IF EDTTV1501D.input.close_feedback_state AND EDTTV1501E.input.close_feedback_state AND EDTTV1501F.input.open_feedback_state THEN
						r09_recover_2_step := 9;
					END_IF;
				END_IF;
			9:
				TON_92.PT := DINT_TO_TIME(EDTP4S3_PARA_T6 * 1000);
				TON_92.IN := TRUE;
				IF TON_92.Q THEN
					TON_92.IN := FALSE;
					r09_recover_2_step := 10;
				END_IF;
			10:
				EDTTV1501F.input.auto_open_signal := FALSE;
				IF EDTTV1501F.input.close_feedback_state THEN
					EDTTV1501A.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1501A.input.open_feedback_state THEN
					EDTTV1501B.input.auto_open_signal := TRUE;
				END_IF;
				IF EDTTV1501A.input.open_feedback_state AND EDTTV1501B.input.open_feedback_state AND EDTTV1501F.input.close_feedback_state THEN
					r09_recover_2_step := 11;
				END_IF;
			11:
				IF EDTTIT1501.status.value <= EDTP4S3_PARA_Temp8 THEN
					EDTTV1501B.input.auto_open_signal := FALSE;
					IF EDTTV1501B.input.close_feedback_state THEN
						EDTTV1501A.input.auto_open_signal := FALSE;
						IF EDTTV1501A.input.close_feedback_state THEN
							r09_recover_2_step := 12;
						END_IF;
					END_IF;
				END_IF;
			12:
				EDTXV1515.input.auto_open_signal := TRUE;
				EDTXV1507.input.auto_open_signal := TRUE;
				IF EDTXV1515.input.open_feedback_state AND EDTXV1507.input.open_feedback_state THEN
					r09_recover_2_step := 13;
				END_IF;
			13:
				IF EDTPIT1501.status.value >= EDTP4S3_PARA_P1 THEN
					EDTP23_close := TRUE;
					r09_recover_2_step := 14;
				END_IF;
			14:
				IF EDTPIT1501.status.value >= EDTP4S3_PARA_P2 THEN
					EDTXV1515.input.auto_open_signal := FALSE;
					EDTXV1507.input.auto_open_signal := FALSE;
					MTBasicsPID_13.Enable := FALSE;
					EDTFVT1502.input.auto_degree_set := 100.0;
					EDTXV1525.input.auto_open_signal := TRUE;
					EDTR09.input.auto_run_signal := FALSE;
					EDTXV1514.input.auto_open_signal := FALSE;
					EDTXV1508.input.auto_open_signal := FALSE;
					EDTXV1506.input.auto_open_signal := FALSE;
					EDTXV1516.input.auto_open_signal := FALSE;
					r09_recover_2_step := 0;
					r09_recover_2 := FALSE;
				END_IF;
		END_CASE;
		TON_92();
	END_IF;

	//V50转移
	IF v50_transfer THEN
		CASE v50_transfer_step OF
			0:
				EDTXV1522.control.auto_operate := TRUE;
				EDTXV1532.control.auto_operate := TRUE;
				EDTXV1533.control.auto_operate := TRUE;
				v50_transfer_step := 1;
			1:
				EDTXV1522.input.auto_open_signal := TRUE;
				v50_transfer_step := 2;
			2:
				TON_93.PT := DINT_TO_TIME(EDTP4S3_PARA_T10 * 1000);
				TON_93.IN := TRUE;	
				IF TON_93.Q THEN
					TON_93.IN := FALSE;
					EDTXV1532.input.auto_open_signal := TRUE;
					v50_transfer_step := 3;
				END_IF;
			3:
				TON_93.PT := DINT_TO_TIME(EDTP4S3_PARA_T11 * 1000);
				TON_93.IN := TRUE;	
				IF TON_93.Q THEN
					TON_93.IN := FALSE;
					EDTXV1532.input.auto_open_signal := FALSE;
					EDTXV1533.input.auto_open_signal := TRUE;
					v50_transfer_step := 4;
				END_IF;
			4:
				TON_93.PT := DINT_TO_TIME(EDTP4S3_PARA_T12 * 1000);
				TON_93.IN := TRUE;	
				IF TON_93.Q THEN
					TON_93.IN := FALSE;
					EDTXV1522.input.auto_open_signal := FALSE;
					EDTXV1533.input.auto_open_signal := FALSE;
					v50_transfer_step := 0;
					v50_transfer := FALSE;
				END_IF;
		END_CASE;
		TON_93();
	END_IF;			
	
	
	//EDTTVT1502 pid调节
	R_TRIG_10(CLK := EDTTVT1502.status.auto_mode);
	IF R_TRIG_10.Q THEN
		MTBasicsPID_2.Enable := TRUE;
	END_IF;
	F_TRIG_10(CLK := EDTTVT1502.status.auto_mode);
	IF F_TRIG_10.Q THEN
		MTBasicsPID_2.Enable := FALSE;
	END_IF;
	//	MTBasicsPID_2.Enable := TRUE;
	MTBasicsPID_2.Invert := TRUE;
	MTBasicsPID_2.PIDParameters.Gain := EDTPid1503Para.gain;
	MTBasicsPID_2.PIDParameters.IntegrationTime := EDTPid1503Para.integration_time;
	MTBasicsPID_2.PIDParameters.DerivativeTime := EDTPid1503Para.derivative_time;
	MTBasicsPID_2.MinOut := 0.0;
	MTBasicsPID_2.MaxOut := 100.0;
	MTBasicsPID_2.SetValue := EDTPid1503Para.set_value;
	MTBasicsPID_2.ActValue := EDTTIT1503.status.value;
	MTBasicsPID_2.Update := EDTPid1503.update;
	MTBasicsPID_2();
	EDTPid1503.out := MTBasicsPID_2.Out;
	IF MTBasicsPID_2.Active THEN
		EDTTVT1502.input.auto_degree_set := MTBasicsPID_2.Out;
		//	ELSE
		//		EDTTVT1502.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_2.UpdateDone THEN
		EDTPid1503.update := FALSE;
	END_IF;
	
	
	//FVT1502 pid调节
	R_TRIG_11(CLK := EDTFVT1502.status.auto_mode);
	IF R_TRIG_11.Q THEN
		MTBasicsPID_13.Enable := TRUE;
	END_IF;
	F_TRIG_11(CLK := EDTFVT1502.status.auto_mode);
	IF F_TRIG_11.Q THEN
		MTBasicsPID_13.Enable := FALSE;
	END_IF;
	//	MTBasicsPID_13.Enable := TRUE;
	MTBasicsPID_13.PIDParameters.Gain := EDTPidFVT1502Para.gain;
	MTBasicsPID_13.PIDParameters.IntegrationTime := EDTPidFVT1502Para.integration_time;
	MTBasicsPID_13.PIDParameters.DerivativeTime := EDTPidFVT1502Para.derivative_time;
	MTBasicsPID_13.MinOut := 0.0;
	MTBasicsPID_13.MaxOut := 100.0;
	MTBasicsPID_13.SetValue := EDTPidFVT1502Para.set_value;
	MTBasicsPID_13.ActValue := EDTFIT1502.flowrate;
	MTBasicsPID_13.Update := EDTPidFVT1502.update;
	MTBasicsPID_13();
	EDTPidFVT1502.out := MTBasicsPID_13.Out;
	IF MTBasicsPID_13.Active THEN
		EDTFVT1502.input.auto_degree_set := MTBasicsPID_13.Out + EDTPidFVT1502Para.min_out;
		//	ELSE
		//		EDTFVT1502.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_13.UpdateDone THEN
		EDTPidFVT1502.update := FALSE;
	END_IF;
	
	
	//FVT1601 pid调节
	R_TRIG_12(CLK := EDTFVT1601.status.auto_mode);
	IF R_TRIG_12.Q THEN
		MTBasicsPID_14.Enable := TRUE;
	END_IF;
	F_TRIG_12(CLK := EDTFVT1601.status.auto_mode);
	IF F_TRIG_12.Q THEN
		MTBasicsPID_14.Enable := FALSE;
	END_IF;
	//MTBasicsPID_14.Enable := TRUE;
	MTBasicsPID_14.PIDParameters.Gain := EDTPidFVT1601Para.gain;
	MTBasicsPID_14.PIDParameters.IntegrationTime := EDTPidFVT1601Para.integration_time;
	MTBasicsPID_14.PIDParameters.DerivativeTime := EDTPidFVT1601Para.derivative_time;
	MTBasicsPID_14.MinOut := 0.0;
	MTBasicsPID_14.MaxOut := 100.0;
	MTBasicsPID_14.SetValue := EDTPidFVT1601Para.set_value;
	MTBasicsPID_14.ActValue := EDTFIT1601.flowrate;
	MTBasicsPID_14.Update := EDTPidFVT1601.update;
	MTBasicsPID_14();
	EDTPidFVT1601.out := MTBasicsPID_14.Out;
	IF MTBasicsPID_14.Active THEN
		EDTFVT1601.input.auto_degree_set := MTBasicsPID_14.Out + EDTPidFVT1601Para.min_out;
		//	ELSE
		//		EDTFVT1601.input.auto_degree_set := 0.0;
	END_IF;
	IF MTBasicsPID_14.UpdateDone THEN
		EDTPidFVT1601.update := FALSE;
	END_IF;
	
END_ACTION
