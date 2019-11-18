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
local log_file "`../log_files/"

cd `log_file'
cap log using 4_Clean.smcl,  replace 

/*****************
Description:
	Step 4 - Clean Datasets
		Cruise Ships
		DHS
		Census
		LSMS
		Country GDP
*****************/

**************************************************************************
// cd "`home'"

***************************************************************
//					Cruise Ship Dataset
***************************************************************
timer on 1

//	Combining the three cruise data into single dataset
/*
// Turn them into dta form before starting the merge
set excelxlsxlargefile on
import excel `input_dir'\output_ships.xlsx, first clear
sort callsign
save `edit_dir'\output_ships.dta, replace
import excel `input_dir'\output_daily_ship_location.xlsx, first clear
sort callsign
save `edit_dir'\output_daily_ship_location.dta, replace
import excel `input_dir'\output_cities.xlsx, first clear
rename city port_city_name
sort port_city_name
save `edit_dir'\output_cities.dta, replace

// Merge the 3 datasets
use `edit'\output_ships.dta, clear
merge 1:m callsign using `edit'\output_daily_ship_location.dta, sorted
drop _merge
duplicates report
describe
sort port_city_name
merge m:1 port_city_name using `edit'\output_cities.dta, sorted
drop _merge
duplicates report
describe

save `edit_dir'\cruise.dta, replace
*/

use "`edit_dir'/cruise.dta", clear

// 	1. Create variables
gen year = year(date), after(date)
egen port_id = group(port_city_name)
egen ship_id = group(callsign) // TODO: How do I keep this in the collapse 

//	2. Clean observations and variables
rename (country lat lon) (port_country port_lat port_lon)
	
// 	3. Create treatment variable
gen cruise = (stopped_minutes*capacity)/60 
		// TODO: cruise = (in_port)(stopped_minutes*avg_capacity_wght*capacity)/(60 min/hr * avg_capacity for any cruise ship)
		// TODO: Treatment = the impact of 1 ship for an hour in port at average capactiy for the average cruise ship
label var cruise "hour effect from avg ship at avg capactiy in port"

//	4. Collapse to Port by Year
drop if year < 2009
sort year port_id
collapse (count) in_port num_periods (median) capacity port_lat port_lon (sum) stopped_minutes cruise (firstnm) port_city_name port_city_country port_country country_code, by(year port_id)

//  5. Aggregate Stats
label var in_port "count of ships in entered port"
label var capacity "median ship capacity arriving at port"
label var stopped_minutes "total minutes spent in port"

gen log_cruise = log(cruise)

//	6. Save to edits
sort port_id year
order year port_id port_city_name port_city_country port_country country_code port_lat port_lon in_port cruise log_cruise
save "`edit_dir'/clean_cruise.dta", replace

timer off 1
***************************************************************
//					DHS Dataset 
***************************************************************
timer on 2
use "`input_dir'/global_xsection_mother.dta", clear

//	1. Remove countries and years that don't have cruise ship data

drop if dhsyear < 2003

drop if (dhscc == "AL" | dhscc == "AO" | dhscc == "AM" | dhscc == "AZ" | dhscc == "BD" | dhscc == "BJ" | dhscc == "BF" | dhscc == "BU" | country == "CAR" | dhscc == "CM" | dhscc == "TD" | dhscc == "KM" | dhscc == "CG" | dhscc == "CD" | dhscc == "CI" | dhscc == "ET" | dhscc == "GA" | dhscc == "GH" | dhscc == "GN" | dhscc == "GY" | dhscc == "KE" | dhscc == "KY" | dhscc == "LS" | dhscc == "LB" | dhscc == "MD" | dhscc == "MW" | dhscc == "MV" | dhscc == "ML" | dhscc == "MB" | dhscc == "NM" | dhscc == "NG" | dhscc == "NI" | dhscc == "PK" | dhscc == "RW" | dhscc == "ST" | dhscc == "SN" | dhscc == "SL" | dhscc == "SZ" | dhscc == "TL" | dhscc == "TG" | dhscc == "UG" | dhscc == "YE" | dhscc == "ZM" | dhscc == "ZW")

// 	2. Remove or Add Variables
egen country_dhs_code = group(country)
egen std_adm_region_code = group(country std_adm_region)
gen source = "DHS"

//	3. Save to edits
save "`edit_dir'/clean_dhs.dta", replace

timer off 2
***************************************************************
//					Census Dataset 
***************************************************************
timer on 3
use "`input_dir'/census_clean.dta", clear

//	1. Remove countries that don't have cruise ship data

// 	2. Remove or Add Variables
// gen source = "Census"

//	3. Drop unnecessary observations

timer off 3
***************************************************************
//					LSMS Dataset 
***************************************************************
timer on 4


//	1. Remove countries that don't have cruise ship data

// 	2. Remove or Add Variables
// gen source = "LSMS"

//	3. Drop unnecessary observations

timer off 4
***************************************************************
//					GDP Dataset 
***************************************************************
timer on 5

//	1. Remove countries that don't have cruise ship data

// 	2. Remove unneccessary variables

//	3. Drop unnecessary observations

timer off 5

***************************************************************
//				  ~ Complete Log File ~
***************************************************************
cd `log_file'
// Reminder these are in seconds
timer list
cap log close
translate 4_Clean.smcl 4_Clean.pdf, replace