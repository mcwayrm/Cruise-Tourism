clear
set more off
clear matrix
clear mata
log close _all

/*****************
Description:
	Step 6 - Analysis
		OLS
		Fixed Effects
		Fuzzy Diff n Diff
*****************/

local home "E:\Thesis"
local input_dir "`home'\input"
local edit_dir "`home'\edit"
**************************************************************************
cd "`home'"

use "`edit_dir'\master.dta", clear
***************************************************************
//					OLS Regression
***************************************************************
/*
	Treatment Variable:
		cruise
		log_cruise
		cruise_inport
	Outcome Variables:
		hh_wealth_ind 
		w_employed 
		age_firstmarriage 
		w_literate_atall
		edu_singleyrs
*/
foreach v of varlist cruise log_cruise cruise_inport{
	di " --------------------------------------"
	di "`v'"
	di " --------------------------------------"
	reg w_employed `v' 
	reg hh_wealth_ind `v'
	reg age_firstmarriage `v' 
	reg w_literate_atall `v'
	reg edu_singleyrs `v' 
}

***************************************************************
//					Fixed Effects Regression
***************************************************************
xtset myid year

foreach v of varlist cruise log_cruise cruise_inport{
	di " --------------------------------------"
	di "`v'"
	di " --------------------------------------"
	xtreg w_employed `v' 
	xtreg hh_wealth_ind `v'
	xtreg age_firstmarriage `v' 
	xtreg w_literate_atall `v'
	xtreg edu_singleyrs `v' 
}

***************************************************************
//					Fuzzy Diff in Diff Regression
***************************************************************

***************************************************************
//					Fuzzy Diff in Diff with FE Regression
***************************************************************
