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
cap log using 5_Merge.smcl,  replace 

/*****************
Description:
	Step 5 - Merge Datasets
		Household Data:
			DHS
			Census
			LSMS
		Cruise Ships
		Night Lights
		Violent Crime
		Port City Climate
*****************/

**************************************************************************
// cd "`home'"

***************************************************************
//					Append Household Datasets
***************************************************************
timer on 1

timer off 1
***************************************************************
//					Merge Cruise Ship Data
***************************************************************
timer on 2
//	Notes for Geonear Spatial Match
//			> Will need to do this for each Dataset
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1379688-distance-computation-using-geodist-package
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1395002-combining-spatial-datasets-using-coordinates

// 		DHS
use "`edit_dir'/clean_dhs.dta", clear

gen year = interview_year
geonear dhsid latnum longnum using "`edit_dir'/clean_cruise.dta", n(port_id port_lat port_lon) radius(50) // TODO: This is wrong because it will only have treatment ports not control ports

rename nid port_id
merge m:1 port_id year using "`edit_dir'/clean_cruise.dta"
/*
	Match Rate:
		88.43 %
*/
drop if _merge == 2 // Ports without subjects
drop _merge

// 		Census

//		LSMS

timer off 2
***************************************************************
//					Merge GDP Data
***************************************************************
timer on 3

timer off 3
***************************************************************
//					Merge Night Lights
***************************************************************
timer on 4
/*
	For nighlights, make the polygons for the ports and then label by portkey. 
*/

timer off 4
***************************************************************
//					Post-Merge Edits
***************************************************************
timer on 5

gen treated = 0
replace treated = 1 if cruise != 0
label define treatment 0 "Control" 1 "Treated"
label values treated treatment
sum treated
/*
	Percent Treated:
		60.6 %
*/
tab port_id treated

timer off 5
***************************************************************
//					Random Sample
***************************************************************
timer on 6
// 	Create a random sample of the final dataset to use for tests of code before applying to whole dataset. Will save time and energy.
*sample 10, by(country year treated source)
save "`edit_dir'/master.dta", replace

timer off 6

***************************************************************
//				  ~ Complete Log File ~
***************************************************************
cd `log_file'
// Reminder these are in seconds
timer list
cap log close
translate 5_Merge.smcl 5_Merge.pdf, replace