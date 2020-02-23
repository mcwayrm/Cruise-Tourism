***************************************************************
//				~ Resetting Stata ~
***************************************************************

clear
set more off
clear matrix
clear mata
log close _all
timer clear

***************************************************************
//					 ~ Macros ~
***************************************************************

// local home "E:\Thesis" // External Hard Drive

local input_dir "../input/"
local edit_dir "../edit/"
local log_file "../log_files/"

***************************************************************
//				  ~ Start Log File ~
***************************************************************

cd `log_file'
cap log using 7_Collapse_To_City.smcl,  replace 

/*******************************
********************************
	Title: Collapse to City Level
	Author: Ryan McWay

	Description:
	Collapse the Ship information to City by Year. Prepares dataframe for treatment effect measures before combining with individual and household level data.
	
	Steps:
		1. Prepare Data for Collapse
		2. Create Treatment Variables
		3. Collapse to Port by Year
		4. Save Data as .dta
		
*******************************
********************************/

/*****************
Description:
	Merge city to households
*****************/

***************************************************************
//			Step 1:	Prepare Data for Collapse
***************************************************************

timer on 1

drop if within_15_km = 0

// Preparing for the Collapse
split date_time, parse(" ")
rename (date_time1 date_time2) (date time)
split date, parse("-")
rename (date1 date2 date3) (year month day) 
rename km_to_port_id km_ship_to_port

***************************************************************
//			Step 2:	Create Treatment Variables
***************************************************************

// 	Create treatment_count, treatment_capacity, treatment_intensity 
gen treatment_count = 1 if km_ship_to_port < 15
gen treatment_time = 
gen treatment_capacity =
gen treatment_intensity = treatment_time * (.5 * crew + .75 * capacity)

***************************************************************
//			Step 3:	Collapse to Port by Year
***************************************************************

//	Collapse to Port by Year
destring year, replace
drop if year < 2009
sort year port_id
// (median) min_in_port (sum) treatment_intensity 
collapse (median) crew capacity km_ship_to_port (sum) treatment_count treatment_time treatment_capacity treatment_intensity (firstnm) port_lat port_lon city_name country_name alpha_2_code alpha_3_code port_size city_size port_type body_of_water, by(year port_id)

***************************************************************
//			Step 4:	Export Data
***************************************************************

//	Save to edits
sort port_id year
order port_id city_name country_name alpha* port_lat port_lon crew capacity year

cd ../../edit
save port_level_treatment.dta, replace

timer off 1


***************************************************************
//				  ~ Complete Log File ~
***************************************************************

// Reminder these are in seconds
timer list
cap log close
cd `log_file'
translate 7_Collapse_To_City.smcl 7_Collapse_To_City.pdf, replace