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
cap log using 6_Descriptive.smcl,  replace 

/*****************
Description:
	Step 6 - Descriptive Stats
		Cruise Ship Time Series
		Country Panel 
		Port Panel
*****************/

**************************************************************************
// cd "`home'"

***************************************************************
//					Cruise Ship Time Series
***************************************************************
timer on 1
use "`edit_dir'/clean_cruise.dta", clear
// xtset callsign year

// tsline stopped_minutes if year > 2008 & stopped_minutes > 0, by(port_id) name(stop_mins, replace) 
// stop
// tsline in_port if year > 2008, name(port_stops, replace) 
// tsline cruise if year > 2008, name(cruise_ts, replace) 
// tsline log_cruise if year > 2008, name(log_cruise_ts, replace) 

timer off 1
***************************************************************
//					Country Panel
***************************************************************
timer on 2
use "`edit_dir'\master.dta", clear

collapse (count) treated (sum) in_port cruise log_cruise stopped_minutes (median) capacity, by(country_dhs_code year)
xtset country_dhs_code year
drop if year < 2009

tab country year

timer off 2
***************************************************************
//					Port Panel
***************************************************************
timer on 3
use "`edit_dir'/master.dta", clear
collapse (count) treated (sum) in_port cruise log_cruise stopped_minutes (median) capacity, by(std_adm_region_code year)
xtset std_adm_region_code year
drop if year < 2009

tab std_adm_region_code year

timer off 3

***************************************************************
//				  ~ Complete Log File ~
***************************************************************
cd `log_file'
// Reminder these are in seconds
timer list
cap log close
translate 6_Descriptive.smcl 6_Descriptive.pdf, replace