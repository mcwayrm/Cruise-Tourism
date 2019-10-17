clear
set more off
clear matrix
clear mata
log close _all

/*****************
Description:
	Step 4 - Clean Datasets
		Cruise Ships
		DHS
		Census
		LSMS
*****************/

local home "E:\Thesis"
local input_dir "`home'\input"
local edit_dir "`home'\edit"
**************************************************************************
cd "`home'"

***************************************************************
//					Cruise Ship Dataset
***************************************************************
* Need to replace this is the code from before to combine the 3 datasets
use "`edit_dir'\cruise.dta", clear
/*
// Turn them into dta form before starting the merge
set excelxlsxlargefile on
import excel `input'\output_ships.xlsx, first clear
sort callsign
save `edit'\output_ships.dta, replace
import excel `input'\output_daily_ship_location.xlsx, first clear
sort callsign
save `edit'\output_daily_ship_location.dta, replace
import excel `input'\output_cities.xlsx, first clear
rename city port_city_name
sort port_city_name
save `edit'\output_cities.dta, replace

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

save `edit'\cruise.dta, replace
*/


// 	1. Create variables
foreach i in year month{
	gen `i' = `i'(date), after(date)
}
egen port_total = total(stopped_minutes), by(port_city_name year)
replace port_total = port_total/60
label var port_total "port stopped hours per year"
egen port_id = group(port_city_name)
// gen in_port2 = port lat lon matches ship lat lon

//	2. Clean observations and variables
drop if stopped_minutes == 0
	// Only 3% of the observations are from before 2009. This is a problem!!!
rename (country lat lon) (port_country port_lat port_lon)
	
// 	3. Create treatment variables
gen cruise = (stopped_minutes*capacity)/60 		// Should we make it a z-score??
label var cruise "hour effect from single tourist"
gen log_cruise = log(cruise)
gen cruise_inport = cruise if in_port == 1
label var cruise "cruise treatment if in port"

//	4. Collapse to Port by Year
sort port_id year
collapse (count) in_port num_periods (median) capacity port_lat port_lon port_total (sum) stopped_minutes cruise log_cruise cruise_inport (firstnm) port_city_name port_city_country port_country country_code, by(year port_id)

//	5. Save to edits
sort port_id year
order year port_id port_city_name port_city_country port_country country_code port_lat port_lon in_port port_total cruise log_cruise cruise_inport
save "`edit_dir'\clean_cruise.dta", replace
stop
***************************************************************
//					DHS Dataset 
***************************************************************
use "`input_dir'\global_xsection_mother.dta", clear

//	1. Remove countries and years that don't have cruise ship data

drop if dhsyear < 2003

drop if (dhscc == "AL" | dhscc == "AO" | dhscc == "AM" | dhscc == "AZ" | dhscc == "BD" | dhscc == "BJ" | dhscc == "BF" | dhscc == "BU" | country == "CAR" | dhscc == "CM" | dhscc == "TD" | dhscc == "KM" | dhscc == "CG" | dhscc == "CD" | dhscc == "CI" | dhscc == "ET" | dhscc == "GA" | dhscc == "GH" | dhscc == "GN" | dhscc == "GY" | dhscc == "KE" | dhscc == "KY" | dhscc == "LS" | dhscc == "LB" | dhscc == "MD" | dhscc == "MW" | dhscc == "MV" | dhscc == "ML" | dhscc == "MB" | dhscc == "NM" | dhscc == "NG" | dhscc == "NI" | dhscc == "PK" | dhscc == "RW" | dhscc == "ST" | dhscc == "SN" | dhscc == "SL" | dhscc == "SZ" | dhscc == "TL" | dhscc == "TG" | dhscc == "UG" | dhscc == "YE" | dhscc == "ZM" | dhscc == "ZW")

// 	2. Remove unneccessary variables

//	3. Drop unnecessary observations

//	4. Merge with DHS Location Data
//merge m:m dhsid dhsyear using "`input_dir'\DHS_gps_locations.dta" // This is not good...

//drop _merge

//	4. Save to edits
save "`edit_dir'\clean_dhs.dta", replace

***************************************************************
//					Census Dataset 
***************************************************************


//	1. Remove countries that don't have cruise ship data

// 	2. Remove unneccessary variables

//	3. Drop unnecessary observations

***************************************************************
//					LSMS Dataset 
***************************************************************


//	1. Remove countries that don't have cruise ship data

// 	2. Remove unneccessary variables

//	3. Drop unnecessary observations


***************************************************************
//					Crime Dataset 
***************************************************************


//	1. Remove countries that don't have cruise ship data

// 	2. Remove unneccessary variables

//	3. Drop unnecessary observations

***************************************************************
//					Climate Dataset 
***************************************************************


//	1. Remove countries that don't have cruise ship data

// 	2. Remove unneccessary variables

//	3. Drop unnecessary observations