
PROGRAM _INIT
	(* Insert code here *)
	MBAPid0510Para.set_value := 25;
	MBAPid0802Para.set_value := 30;
	MBAPid0510Para.gain := 400;
	MBAPid0802Para.gain := 60;
	MBAPid0510Para.integration_time := 45;
	MBAPid0802Para.integration_time := 240;
	MBAPid0510Para.derivative_time := 30;
	MBAPid0802Para.derivative_time := 0;

END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	S1A_ACT;
	S1B_ACT;
	S2_ACT;
	S3_ACT;
	S4_ACT;
	S5_ACT;
	S6_ACT;
	S7_ACT;
	S8_ACT;
	S9_ACT;
	S10_ACT;
END_PROGRAM


