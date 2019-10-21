clear
set more off
clear matrix
clear mata
log close _all

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

local home "E:\Thesis"
local input_dir "`home'\input"
local edit_dir "`home'\edit"
**************************************************************************
cd "`home'"

***************************************************************
//					Append Household Datasets
***************************************************************


***************************************************************
//					Merge Cruise Ship Data
***************************************************************
/*For location merge:
	For each city in dataset I should have a port_key uniform across all datasets
*/
use "`edit_dir'\clean_dhs.dta", clear

*lat lon with lat lon in cruise match
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1379688-distance-computation-using-geodist-package
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1395002-combining-spatial-datasets-using-coordinates

* find nearest neighbor of each A obs using locations in B
geonear myid lat lon using "`edit_dir'\clean_cruise.dta", n(port_id port_lat port_lon)

* merge other variables from B based on the nearest neighbor id
rename nid port_id
merge m:m port_id using "`edit_dir'\clean_cruise.dta", //keep(master match) nogen 
/*
	Desceptive. Only 250,000 match for analysis.
. tab _merge

                 _merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
         using only (2) |      3,495        0.49        0.49
            matched (3) |    706,730       99.51      100.00
------------------------+-----------------------------------
                  Total |    710,225      100.00

*/

***************************************************************
//					Merge Night Lights
***************************************************************
/*
	For nighlights, make the polygons for the ports and then label by portkey. 
*/

***************************************************************
//					Post-Merge Edits
***************************************************************
gen treated = 0
replace treated = 1 if cruise != .
label define treatment 0 "Control" 1 "Treated"
label values treated treatment



***************************************************************
//					Random Sample
***************************************************************

//*** 	Create a random sample of the final dataset to use for tests of code before applying to whole dataset. Will save time and energy.
*sample 10, by(country year treated)
save "`edit_dir'\master.dta", replace
