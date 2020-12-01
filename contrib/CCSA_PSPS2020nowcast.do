********************************************************************************
/* 
Author: Nishant Yonzan
Date: 11 November 2020
Purpose: Data from the Poverty and Shared Prosperity Report 2020 for 
	nowcasting global extreme poverty from 2015-2021.
*/
********************************************************************************
clear all
* global CCSA2020 "c:/Users/wb384996/OneDrive - WBG/WorldBank/DECDG/ccsa-mockup/data/"
********************************************************************************
 
//========================================================
// Projection data from PSPR2020
//========================================================
 
* use "${CCSA2020}Projections_constant2019.dta", clear
use "data/Projections_constant2019.dta", clear
keep if inrange(year,2018,2021)
// keep distribution-neutral scenario only
keep if inlist(alpha,0,.) 
// keep the necessary growth scenarios 
keep if inlist(growth,"gbaseline","gdownside","gprecovid","") 
 
collapse FGT0_19 (rawsum) pop [aw=pop] , by(year growth) 
tempfile pspr
save 	`pspr'
 
//========================================================
// Historical global data from PovcalNet 
//========================================================

cap which povcalnet
if (_rc) {
	net install povcalnet, from("https://raw.githubusercontent.com/worldbank/povcalnet/master/")
}

povcalnet wb, year(all) povline(1.9) fillgaps clear 
keep if region=="World Total"
keep if inrange(year,2015,2017)
replace povertyline=povertyline*10
 
ren headcount FGT0_
replace FGT0_ = FGT0_ * 100
ren population pop
 
keep year povertyline FGT0_ pop
reshape wide FGT0_, i(year pop) j(povertyline)
 
label var pop          "Total global population in millions"
label var FGT0_19      "Poverty rate (%) below $1.90"
 
tempfile pcn
save 	`pcn'
 
//========================================================
//  Append PSPR with PovcalNet data
//========================================================
use `pcn', clear
append using `pspr'
 
// generate the number of poor 
ren FGT0_19 rate
gen poor = rate/100 * pop
drop pop

replace growth = "June 2020 GEP, baseline"      if growth == "gbaseline"
replace growth = "June 2020 GEP, downside"    	if growth == "gdownside"
replace growth = "January 2020 GEP, precovid" 	if growth == "gprecovid"
replace growth = "historical"         			if growth == ""

label var year		"Year"
label var poor  	"Number of poor (million) below $1.90"
label var growth 	"Vintage of growth forecast used"

order year growth rate poor
sort year growth
format rate poor %4.1f

