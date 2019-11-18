clear
set more off
clear matrix
clear mata
log close _all
timer clear

// local home "E:\Thesis" // External Hard Drive
// local home "C:\Users\Ryry\Dropbox\Thesis" // Dropbox

local input_dir "../input/"
local edit_dir "../edit/"
local log_file "../log_files/"

cd `log_file'
cap log using 7_Analysis.smcl,  replace 

/*****************
Description:
	Step 6 - Analysis
		OLS
		Fixed Effects
		Fuzzy Diff n Diff
*****************/

**************************************************************************
// cd "`home'"

cd `edit_dir'
use master.dta, clear
***************************************************************
//					OLS Regression
***************************************************************
timer on 1
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
foreach v of varlist cruise log_cruise {
	di " --------------------------------------"
	di "`v'"
	di " --------------------------------------"
	reg w_employed `v' 
	reg hh_wealth_ind `v'
	reg age_firstmarriage `v' 
	reg w_literate_atall `v'
	reg edu_singleyrs `v' 
}

timer off 1
***************************************************************
//					Fixed Effects Regression
***************************************************************
timer on 2

foreach v of varlist cruise log_cruise {
	reghdfe w_employed `v', absorb(i.country_dhs_code i.year) vce(cluster i.country_dhs_code)
	reghdfe hh_wealth_ind `v', absorb(i.country_dhs_code i.year) vce(cluster i.country_dhs_code)
	reghdfe age_firstmarriage `v', absorb(i.country_dhs_code i.year) vce(cluster i.country_dhs_code)
	reghdfe w_literate_atall `v', absorb(i.country_dhs_code i.year) vce(cluster i.country_dhs_code)
	reghdfe edu_singleyrs `v', absorb(i.country_dhs_code i.year) vce(cluster i.country_dhs_code)
}

timer off 2
***************************************************************
//					Fuzzy Diff in Diff Regression
***************************************************************
timer on 3

timer off 3
***************************************************************
//					Fuzzy Diff in Diff with FE Regression
***************************************************************
timer on 4

timer off 4

***************************************************************
//				  ~ Complete Log File ~
***************************************************************
cd `log_file'
// Reminder these are in seconds
timer list
cap log close
translate 7_Analysis.smcl 7_Analysis.pdf, replace