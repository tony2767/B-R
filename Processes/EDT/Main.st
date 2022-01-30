(***********************************************************
用CASE体现每一步操作步骤：
1、函数指针在本软件中申明和调用麻烦，容易出错；
2、比SFC增改步骤相对方便；
3、可阅读性强；

流程自动，由MyLibrary中ProcessStep[i].done满足条件后并由
ProcessTimer函数延时后，执行下一步，其中延时时间参数可设。

注意事项：检查每步的done复位情况，检查每个步骤流程数和定义
的是否一致
*************************************************************)
PROGRAM _INIT
	(* Insert code here *)
	EDTPid0701Para.set_value := 35;
	EDTPid0703Para.set_value := 35;
	EDTPid0801Para.set_value := 130;
	EDTPid0802Para.set_value := 130;
	EDTPid1103Para.set_value := 35;
	EDTPid1106Para.set_value := 35;
	EDTPid1109Para.set_value := 35;
	EDTPid1503Para.set_value := 35;
	EDTPid1802Para.set_value := 0;
	EDTPid1803Para.set_value := 35;
	EDTPidFVT1101Para.set_value := 60;
	EDTPidFVT1103Para.set_value := 160;
	EDTPidFVT1105Para.set_value := 80;
	EDTPidFVT1502Para.set_value := 160;
	EDTPidFVT1601Para.set_value := 70;
	
	EDTPid0701Para.gain := 0.003;
	EDTPid0703Para.gain := 0.01;
	EDTPid0801Para.gain := 10;
	EDTPid0802Para.gain := 10;
	EDTPid1103Para.gain := 5;
	EDTPid1106Para.gain := 60;
	EDTPid1109Para.gain := 60;
	EDTPid1503Para.gain := 60;
	EDTPid1802Para.gain := 0.003;
	EDTPid1803Para.gain := 8;
	EDTPidFVT1101Para.gain := 0.005;
	EDTPidFVT1103Para.gain := 0.004;
	EDTPidFVT1105Para.gain := 0.004;
	EDTPidFVT1502Para.gain := 0.004;
	EDTPidFVT1601Para.gain := 0.003;
	
	EDTPid0701Para.integration_time := 100;
	EDTPid0703Para.integration_time := 100;
	EDTPid0801Para.integration_time := 0;
	EDTPid0802Para.integration_time := 0;
	EDTPid1103Para.integration_time := 600;
	EDTPid1106Para.integration_time := 240;
	EDTPid1109Para.integration_time := 240;
	EDTPid1503Para.integration_time := 240;
	EDTPid1802Para.integration_time := 100;
	EDTPid1803Para.integration_time := 0;
	EDTPidFVT1101Para.integration_time := 100;
	EDTPidFVT1103Para.integration_time := 100;
	EDTPidFVT1105Para.integration_time := 100;
	EDTPidFVT1502Para.integration_time := 100;
	EDTPidFVT1601Para.integration_time := 100;

	EDTPid0701Para.derivative_time := 0;
	EDTPid0703Para.derivative_time := 0;
	EDTPid0801Para.derivative_time := 0;
	EDTPid0802Para.derivative_time := 0;
	EDTPid1103Para.derivative_time := 300;
	EDTPid1106Para.derivative_time := 0;
	EDTPid1109Para.derivative_time := 0;
	EDTPid1503Para.derivative_time := 0;
	EDTPid1802Para.derivative_time := 0;
	EDTPid1803Para.derivative_time := 500;
	EDTPidFVT1101Para.derivative_time := 0;
	EDTPidFVT1103Para.derivative_time := 0;
	EDTPidFVT1105Para.derivative_time := 0;
	EDTPidFVT1502Para.derivative_time := 0;
	EDTPidFVT1601Para.derivative_time := 0;

END_PROGRAM

PROGRAM _CYCLIC
	//EDTP1
	P1S1_1_ACT;
	P1S1_ACT;
	P1S2A_ACT;
	P1S2B_ACT;
	P1S3_ACT;
	P1S4_ACT;
	P1S5_ACT;
	//EDTP2
	P2S1_ACT;
	P2S2A_ACT;
	P2S2B_ACT;
	P2S2C_ACT;
	P2S2D_ACT;
	P2S3A_ACT;
	P2S3B_ACT;
	P2S3C_ACT;
	P2S3D_ACT;
	P2S4A_ACT;
	P2S4B_ACT;
	//EDTP3
	P3S1A_ACT;
	P3S1B_ACT;
	P3S2A_ACT;
	P3S2B_ACT;
	P3S2C_ACT;
	P3S3A_ACT;
	P3S3B_ACT;
	P3S3C_ACT;
	
	//EDTP4
	P4S1A_ACT;
	P4S1B_ACT;
	P4S1C_ACT;
	P4S1D_ACT;
	P4S1E_ACT;
	P4S1F_ACT;
	P4S2A_ACT;
	P4S2B_ACT;
	P4S2C_ACT;
	P4S3_ACT;
	
	//EDTP5
	P5S2_ACT;
END_PROGRAM

