clear
set more off
log close _all
// cap log using power_calc.log, text replace 

/*****************
Description:
	 Power Calculation for Cruise Tourism
*****************/


// As of right now, I believe we only have 1 sample (cruise ship port cities). Based on the counterfactual discussion we had on Tuesday, this will probably expand to 2 samples because we need to add non-tourism cities. The question still is do we pick inland cities/municipalities or only coastal cities/municipalities. My thought is the former rather than the later.

// Based on Faber, Gaubert the estimated effect should be something like .0482
sampsi 0 .0482 , a(0.01) n1(518)
// So based on this, I believe that with the 518 cities we have in the dataset, at a 1% alpha and an anticipated MDE of 0.0482 this study is powered at 98.95% of rejecting the null when we should reject the null.

// I am not sure if we need to cluster based on nation because of fixed effects?


power onemean 0, n(518) power(.8) alpha(.05) 

cd `output'
// cap log close
// translate power_calc.log power_calc.pdf, replace 
