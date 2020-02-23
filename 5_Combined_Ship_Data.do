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
cap log using 5_Combined_Ship_Data.smcl,  replace 

/*******************************
********************************
	Title: Combine Raw Ship Data
	Author: Ryan McWay

	Description:
	Append the raw ship data together and conncet ship locations with city locations.
	
	Steps:
		1. Prepare Raw Ship Data
		2. Append Ship Locations
		3. Merge Locations with Ship Info.
		4. Link Ships with Cities
		5. Save Data as .csv
		
*******************************
********************************/


***************************************************************
//			Step 1:	Prepare Raw Ship Data
***************************************************************

timer on 1
cd `input_dir'/ships/

// Turn daily .csv into .dta
local ship_list 2AGH7 V4CH2 9HA3288 IBNZ ICGS IBWX IBNR ICDH ICLP ICSJ IBUK IBRL IBGU ICPE ICUP IBNP WDA8860 WDF3297 WDH7491 MMHE5 3FLU9 ZCDU9 9HOB8 9HOM8 CQMC CQAE7 SIJW UBRP5 9HGB9 3DQF 3FZO8 3FPQ9 3ETA7 H3GR 3FOC5 H3GS C6FM9 3EBL5 3FPS9 H3WI C6FN2 C6FM5 9HA3667 HPYE 3ETA8 H3VS 3FJB3 3FOB5 H3VU C6FM8 9HA3097 3EUS C6FN5 C6FN4 H3VR 3FFL8 3EMB9 V4FW3 9HA4960 9HJI9 9HJB9 9HXC9 9HA4612 9HXD9 HC6354 9HJD9 9HJF9 9HA3047 9HA2583 9HRJ9 9HJC9 HC2083 HC4228 9HA2978 9HA3027 C6AY8 C6OP6 H9CK CQSD FNIR C6KA9 IBWP VMQ8808 D5MU2 ICRA IBLQ ICIC IBHD IBJD IBCX ICPO ICPK IBNY ICGU IBQQ IBCF IBDU IBCR ICJA ICAZ IBCA IBAD IBLC FNTU FIQC C6CP4 ZCDG2 CQNH C6JZ7 CQRH C6EG8 CQRV VOSM MEYE7 2DXT6 WDD4938 C6CL7 C6SY3 C6MY5 DA5093 ZCEF2 ZCEF6 ZCEF3 OWFU2 C6TN4 C6YR6 C6ZL6 C6PT7 C6QM8 D5OY2 C6AV6 C6BO5 C6BO4 WDG2742 J8VE3 9HA2738 C6II4 C6RS5 C6VA3 C6SY7 UGYU C6ED7 C6JC3 C6QK8 9HA3283 C6EJ3 C6ED6 V2OT2 CQAL6 IBNC GNHV 9HA2479 PBAD PHOS PBGJ PFRO PBWQ PBCO PHET PBKH PDGS PHFV PHEO PCHM PINX PDAN PBIG PCEP C6WC2 LDBE LADA7 LACN8 LGIY LIXN LEFO3 LASQ LHCW LATU3 LHYG LGWH LAZP7 LFEK LLVT LLZY 3FDZ8 HOGV JPEI HC4658 OGBF C6CA6 HGQY HC5241 C6WR2 HC4654 C6TE3 WDJ3521 WAK8004 WUR9646 C6RU6 9HA2326 IBWC V4MR2 V4RU2 ZQOE9 CQSC 3FZK4 9HA2188 C6SL5 9HA2381 9HA2336 9HUI9 9HA4324 9HJH9 T8A3049 5BUY2 H8EW 9HA4902 3FFA5 3ETR7 9HA5063 AWIC HOPW 3FLO4 9HA4455 3EFK6 H3FV 3EJF3 3EPL4 3FOA6 AWFI 9HA4638 9HA4777 H8XH 3FZI8 UCKE WNBE E5U2246 C6UU6 3FNT4 7JBI C6BG2 C6TQ2 C6Z02 C6DL4 C6ZJ3 C6FT7 C6EF4 C6XP7 C6BR3 C6VG8 C6ZJ4 C6WK7 C6TX6 C6CX3 C6VG7 C6PZ8 C6TQ6 C6FR3 C6RN3 V4BV3 V7DM2 V7SK2 V7DM4 ZCDS4 V7DM3 V7WO5 V7RX6 5BMC3 ZCDN2 ZCDW9 ZCEE2 2HHG5 ZCDN9 GVSN 2IYN3 2AGH7 MAQK9 C6EG9 ZCDT2 3FNQ2 C6ZV6 9HA4306 T2DK4 V7RM9 C6CN4 C6VE9 C6CY5 5BEA5 DMLQ PBGH 9HKQ9 9HOX7 9HTT8 C6OX6 FLTU FLSY FLDT FLBP FLDS FLBD C6ZL7 FIRS FGZZ FIHV CSBM CQTK CQUU UCJT C6JR3 PC5412 J8B4685 ZCDG8 ZCDF4 ZCDM6 2HFZ7 ZCDP8 ZCDA9 ZCBU5 ZCDG4 MABI4 ZCDS3 ZCEK6 ZCEI3 ZCDY2 2HFZ6 ZCBU3 ZCEV9 ZCDD6 ZCBU6 9HOC8 9HYZ9 9HA3314 C6HK9 9HUE9 9HXM8 C6PG6 C6CB6 C6ZR5 C6US3 C6PJ8 CQAJ7 C6TH9 V7QK9 C6VV8 C6ZI9 C6SW3 C6RW4 9HA4800 C6SA3 C6XS8 C6BI7 C6SJ5 C6CM8 C6FZ7 C6SE4 C6UZ7 C6SE3 C6BX8 C6WW4 C6FW9 C6VQ8 C6FZ8 C6FV9 C6FU4 C6XS7 C6BX9 C6BH8 C6SE7 C6UA2 C6FV8 C6DQ5 C6DF6 C6SE8 C6SE5 9HA2415 9HA2950 9HOF8 C6ZU 9HA2295 5IM672 LEJP UBDF 9HA4692 9HOM2 9HUE6 C6XC6 C6YZ5 C6YA5 C6CG4 C6CV5 C6PW8 C6PW9 C6BZ6 HZFR C6MQ5 C6OZ3 C6TA8 HC4403 C6DC5 C6FN6 C6XU6 C6FN7 C6FG2 9HA2796 9HA2513 9HA2512 C6AV5 C6LG6 C6LG5 C6DM2 C6II5 IBHE 9HA4677 MLTN8 CBST CBVS 9HA4683 9HA4883 9HA3062 9HA3513 9HA3858 9HA4330 9HJG9 PBQK C6SK4 DC8432 DC2226 DC5388 HE7408 HE7550 HE7468 HE7521 HE7421 HE7448 HE7467 DMBU HE7415 HE7460 HE7462 HE7551 HE7494 HE7466 HE7407 HE7418 HE7390 HE7516 HE7461 HE7459 HE7478 HE7469 HE7388 UAQG-5 HE7465 HE7420 LAYP7 HE7547 HE7477 HE7476 HE7308 HE7464 HE7496 HE7449 HE7489 HE7518 HE7499 HE7387 HE7389 LAYQ7 HE7374 HE7419 HE7548 UAWG-8 LAWP7 HE7695 UUAO8 HE7414 HE7498 LAYU7 DC5428 LAIW6 LAYT7 HE7549 HE7416 UAWG2 HE7417 HE7517 HE7497 HE7546 HE7519 HE7470 HOBW C6S2077 C6FR4 C6FR6 C6FR5 C6CB2 C6CY9 C6CA9 C6IO6
foreach ship of local ship_list{
	import delimited location_`ship'.csv, clear
	replace callsign = "`ship'"
	keep utcdatetime unix* lat lon callsign 
	sort unixutctimestamp
	save location_`ship'.dta, replace
}

***************************************************************
//			Step 2:	Append Ship Locations
***************************************************************

// Append locations, then save as a .dta
use location_2AGH7.dta, clear

// Need to add in the ships that misbehaved if you are able to get their location data
local ship_list_2 V4CH2 9HA3288 IBNZ ICGS IBWX IBNR ICDH ICLP ICSJ IBUK IBRL IBGU ICPE ICUP IBNP WDA8860 WDF3297 WDH7491 MMHE5 3FLU9 ZCDU9 9HOB8 9HOM8 CQMC CQAE7 SIJW UBRP5 9HGB9 3DQF 3FZO8 3FPQ9 3ETA7 H3GR 3FOC5 H3GS C6FM9 3EBL5 3FPS9 H3WI C6FN2 C6FM5 9HA3667 HPYE 3ETA8 H3VS 3FJB3 3FOB5 H3VU C6FM8 9HA3097 3EUS C6FN5 C6FN4 H3VR 3FFL8 3EMB9 V4FW3 9HA4960 9HJI9 9HJB9 9HXC9 9HA4612 9HXD9 HC6354 9HJD9 9HJF9 9HA3047 9HA2583 9HRJ9 9HJC9 HC2083 HC4228 9HA2978 9HA3027 C6AY8 C6OP6 H9CK CQSD FNIR C6KA9 IBWP VMQ8808 D5MU2 ICRA IBLQ ICIC IBHD IBJD IBCX ICPO ICPK IBNY ICGU IBQQ IBCF IBDU IBCR ICJA ICAZ IBCA IBAD IBLC FNTU FIQC C6CP4 ZCDG2 CQNH C6JZ7 CQRH C6EG8 CQRV VOSM MEYE7 2DXT6 WDD4938 C6CL7 C6SY3 C6MY5 DA5093 ZCEF2 ZCEF6 ZCEF3 OWFU2 C6TN4 C6YR6 C6ZL6 C6PT7 C6QM8 D5OY2 C6AV6 C6BO5 C6BO4 WDG2742 J8VE3 9HA2738 C6II4 C6RS5 C6VA3 C6SY7 UGYU C6ED7 C6JC3 C6QK8 9HA3283 C6EJ3 C6ED6 V2OT2 CQAL6 IBNC GNHV 9HA2479 PBAD PHOS PBGJ PFRO PBWQ PBCO PHET PBKH PDGS PHFV PHEO PCHM PINX PDAN PBIG PCEP C6WC2 LDBE LADA7 LACN8 LGIY LIXN LEFO3 LASQ LHCW LATU3 LHYG LGWH LAZP7 LFEK LLVT LLZY 3FDZ8 HOGV JPEI HC4658 OGBF C6CA6 HGQY HC5241 C6WR2 HC4654 C6TE3 WDJ3521 WAK8004 WUR9646 C6RU6 9HA2326 IBWC V4MR2 V4RU2 ZQOE9 CQSC 3FZK4 9HA2188 C6SL5 9HA2381 9HA2336 9HUI9 9HA4324 9HJH9 T8A3049 5BUY2 H8EW 9HA4902 3FFA5 3ETR7 9HA5063 AWIC HOPW 3FLO4 9HA4455 3EFK6 H3FV 3EJF3 3EPL4 3FOA6 AWFI 9HA4638 9HA4777 H8XH 3FZI8 UCKE WNBE E5U2246 C6UU6 3FNT4 7JBI C6BG2 C6TQ2 C6Z02 C6DL4 C6ZJ3 C6FT7 C6EF4 C6XP7 C6BR3 C6VG8 C6ZJ4 C6WK7 C6TX6 C6CX3 C6VG7 C6PZ8 C6TQ6 C6FR3 C6RN3 V4BV3 V7DM2 V7SK2 V7DM4 ZCDS4 V7DM3 V7WO5 V7RX6 5BMC3 ZCDN2 ZCDW9 ZCEE2 2HHG5 ZCDN9 GVSN 2IYN3 2AGH7 MAQK9 C6EG9 ZCDT2 3FNQ2 C6ZV6 9HA4306 T2DK4 V7RM9 C6CN4 C6VE9 C6CY5 5BEA5 DMLQ PBGH 9HKQ9 9HOX7 9HTT8 C6OX6 FLTU FLSY FLDT FLBP FLDS FLBD C6ZL7 FIRS FGZZ FIHV CSBM CQTK CQUU UCJT C6JR3 PC5412 J8B4685 ZCDG8 ZCDF4 ZCDM6 2HFZ7 ZCDP8 ZCDA9 ZCBU5 ZCDG4 MABI4 ZCDS3 ZCEK6 ZCEI3 ZCDY2 2HFZ6 ZCBU3 ZCEV9 ZCDD6 ZCBU6 9HOC8 9HYZ9 9HA3314 C6HK9 9HUE9 9HXM8 C6PG6 C6CB6 C6ZR5 C6US3 C6PJ8 CQAJ7 C6TH9 V7QK9 C6VV8 C6ZI9 C6SW3 C6RW4 9HA4800 C6SA3 C6XS8 C6BI7 C6SJ5 C6CM8 C6FZ7 C6SE4 C6UZ7 C6SE3 C6BX8 C6WW4 C6FW9 C6VQ8 C6FZ8 C6FV9 C6FU4 C6XS7 C6BX9 C6BH8 C6SE7 C6UA2 C6FV8 C6DQ5 C6DF6 C6SE8 C6SE5 9HA2415 9HA2950 9HOF8 C6ZU 9HA2295 5IM672 LEJP UBDF 9HA4692 9HOM2 9HUE6 C6XC6 C6YZ5 C6YA5 C6CG4 C6CV5 C6PW8 C6PW9 C6BZ6 HZFR C6MQ5 C6OZ3 C6TA8 HC4403 C6DC5 C6FN6 C6XU6 C6FN7 C6FG2 9HA2796 9HA2513 9HA2512 C6AV5 C6LG6 C6LG5 C6DM2 C6II5 IBHE 9HA4677 MLTN8 CBST CBVS 9HA4683 9HA4883 9HA3062 9HA3513 9HA3858 9HA4330 9HJG9 PBQK C6SK4 DC8432 DC2226 DC5388 HE7408 HE7550 HE7468 HE7521 HE7421 HE7448 HE7467 DMBU HE7415 HE7460 HE7462 HE7551 HE7494 HE7466 HE7407 HE7418 HE7390 HE7516 HE7461 HE7459 HE7478 HE7469 HE7388 UAQG-5 HE7465 HE7420 LAYP7 HE7547 HE7477 HE7476 HE7308 HE7464 HE7496 HE7449 HE7489 HE7518 HE7499 HE7387 HE7389 LAYQ7 HE7374 HE7419 HE7548 UAWG-8 LAWP7 HE7695 UUAO8 HE7414 HE7498 LAYU7 DC5428 LAIW6 LAYT7 HE7549 HE7416 UAWG2 HE7417 HE7517 HE7497 HE7546 HE7519 HE7470 HOBW C6S2077 C6FR4 C6FR6 C6FR5 C6CB2 C6CY9 C6CA9 C6IO6

foreach ship of local ship_list_2{
	append using location_`ship'.dta
}
save ships_combined_locations.dta, replace

***************************************************************
//			Step 3:	Merge Locations with Ship Info.
***************************************************************

// Combine ship info to locations with a 1:m
import delimited ships_combined_info.csv, clear
drop if callsign == ""
merge 1:m callsign using ships_combined_locations.dta
drop if _merge == 1
drop _merge
gen daily_id = _n
rename (unixutctimestamp utcdatetime lat lon) (timestamp date_time ship_lat ship_lon)
drop if ship_lon > 180 | ship_lon < -180
export delimited ships_master.csv, replace
save ships_master.dta, replace
timer off 1

***************************************************************
//			Step 4:	Link Locations with Cities
***************************************************************

timer on 2
cd ../cities
import delimited master_port_clean.csv, clear
save master_port_clean.dta, replace
cd ../ships
use ships_master.dta, clear
cd ../cities
geonear daily_id ship_lat ship_lon using master_port_clean.dta, n(port_id port_lat port_lon) long limit(1) within(15)

merge m:1 port_id using master_port_clean.dta
drop if _merge == 2
drop _merge
cd ../ships
merge 1:1 daily_id using ships_master.dta
drop _merge

***************************************************************
//			Step 5:	Export Data
***************************************************************

export delimited ships_pre_time_in_port.csv, replace

timer off 2

***************************************************************
//				  ~ Complete Log File ~
***************************************************************

// Reminder these are in seconds
timer list
cap log close
cd `log_file'
translate 5_Combined_Ship_Data.smcl 5_Combined_Ship_Data.pdf, replace