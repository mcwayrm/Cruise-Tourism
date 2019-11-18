clear
set more off
clear matrix
clear mata
log close _all
timer clear

// local log_file "C:\Users\Ryry\Dropbox\Thesis\log_files" // Dropbox
local output_dir "C:\Users\Ryry\Dropbox\Thesis\output"
// local log_file "../log_files/" // Cluster
// local output_dir "../output/" 
cd `log_file'
cap log using 3_Power_Calc.smcl,  replace 
timer on 1

/*****************
Description:
	 Step 3 - Power Calculation
		Power Calculation
		Minimum Detectable Effect
*****************/
 
/*
	Observations: 
				DHS has ~ 300,000
				Census has ~ 40 Million
				LSMS has ~ 100,000
	Port Cities: 
				518
*/


***************************************************************
//					Minimum Detectable Effect
***************************************************************
power twomeans 0, n(40000000) k1(50) k2(50) power(.8, .9, .95) alpha(.01, .05, .1) cluster graph
graph export "`output_dir'\MDE.png", replace

timer off 1
// Reminder these are in seconds
timer list
cd `log_file'
cap log close
translate 3_Power_Calc.smcl 3_Power_Calc.pdf, replace