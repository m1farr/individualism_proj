cd "/Users/tess/Desktop/stata_idv_data"
cap mkdir "/Users/tess/Desktop/stata_idv_data/name_changes"
cap mkdir "/Users/tess/Desktop/stata_idv_data/dta_files"

* import and rename countries for island and elevation data (controls)
import excel using "input/country_name_changes.xlsx", firstrow clear
keep country_name name_ie
drop if name_ie == ""
save "name_changes/country_name_changes_ie.dta", replace
import excel using "input/island_elev_data.xlsx", firstrow clear
rename country name_ie
merge 1:1 name_ie using "name_changes/country_name_changes_ie.dta"
replace name_ie = country_name if country_name != ""
drop country_name _merge
rename name_ie country_name
save "dta_files/island_elev_data.dta", replace

* import and rename countries for landlocked data (controls)
import excel using "input/country_name_changes.xlsx", firstrow clear
keep country_name name_cepii
drop if name_cepii == ""
save "name_changes/country_name_changes_cepii.dta", replace
import excel using "input/geo_cepii.xlsx", firstrow clear
keep country landlocked
rename country name_cepii
duplicates drop name_cepii, force
merge 1:1 name_cepii using "name_changes/country_name_changes_cepii.dta"
replace name_cepii = country_name if country_name != ""
drop country_name _merge
rename name_cepii country_name
save "dta_files/landlocked_data.dta", replace

* import and rename countries for ruggedness, distance to coast, and continents (controls)
import excel using "input/country_name_changes.xlsx", firstrow clear
keep country_name name_rugged
drop if name_rugged == ""
save "name_changes/country_name_changes_rugged.dta", replace
import excel using "input/rugged_data.xlsx", firstrow clear
keep country rugged dist_coast cont_africa cont_asia cont_europe cont_oceania cont_north_america cont_south_america
rename country name_rugged
merge 1:1 name_rugged using "name_changes/country_name_changes_rugged.dta"
replace name_rugged = country_name if country_name != ""
drop country_name _merge
rename name_rugged country_name
gen cont_america = (cont_north_america == 1 | cont_south_america == 1)
drop cont_north_america cont_south_america
save "dta_files/rugged_data.dta", replace

* import and rename countries for Hofstede dimensions
import excel using "input/country_name_changes.xlsx", firstrow clear
keep country_name name_hof
drop if name_hof == ""
save "name_changes/country_name_changes_hof.dta", replace
import excel using "input/hofstede_dimensions.xls", firstrow clear
keep country idv
rename country name_hof
duplicates drop name_hof, force
merge 1:1 name_hof using "name_changes/country_name_changes_hof.dta"
replace name_hof = country_name if country_name != ""
drop country_name _merge
rename name_hof country_name
save "dta_files/hofstede_data.dta", replace

* import and rename countries for WVS timeseries
import excel using "input/country_name_changes.xlsx", firstrow clear
keep country_name name_wvs
drop if name_wvs == ""
save "name_changes/country_name_changes_wvs.dta", replace
import excel using "input/wvs_ts.xlsx", firstrow clear
drop ISO31661alpha3countrycode
rename WVSwave wave
rename CountryISO31661Numericcode name_wvs
rename Importantchildqualitiesobedi obedience
rename Oneofmaingoalsinlifehasbe parents_proud
rename Privatevsstateownershipofbu gov_owner
rename JustifiableHomosexuality homosexuality
rename JustifiableAbortion abortion
rename JustifiableDivorce divorce
rename Doyoulivewithyourparentsy live_with_parents

*code variables properly
replace obedience = "1" if obedience == "Important"
replace obedience = "0" if obedience == "Not mentioned"
replace live_with_parents = "2" if live_with_parents == "Yes"
replace live_with_parents = "1" if live_with_parents == "No"
replace parents_proud = "1" if parents_proud == "Agree strongly"
replace parents_proud = "2" if parents_proud == "Agree"
replace parents_proud = "3" if parents_proud == "Disagree"
replace parents_proud = "4" if parents_proud == "Strongly disagree"
replace gov_owner = "1" if gov_owner == "Private ownership of business should be increased"
replace gov_owner = "10" if gov_owner == "Government ownership of business should be increased"
replace homosexuality = "1" if homosexuality == "Never justifiable"
replace homosexuality = "10" if homosexuality == "Always justifiable"
replace abortion = "1" if abortion == "Never justifiable"
replace abortion = "10" if abortion == "Always justifiable"
replace divorce = "1" if divorce == "Never justifiable"
replace divorce = "10" if divorce == "Always justifiable"

* replace "Don't know" response with missing value
foreach var in obedience parents_proud gov_owner homosexuality abortion divorce live_with_parents {
	replace `var' = "" if inlist(`var', "Don't know", "Not asked", "No answer", "Not asked in survey", "Missing; Unknown", "Missing; Not available", "Missing")
	destring `var', replace
}

* replace variables for obedience, gov ownership, and living with parents
* with reverse coding
replace obedience = 1 - obedience
replace gov_owner = 11 - gov_owner
replace live_with_parents = 3 - live_with_parents

* calculate averages of variables by country and wave
collapse (mean) obedience parents_proud gov_owner homosexuality abortion divorce live_with_parents, by(name_wvs wave)

* calculate individualism construct by averaging all variables, save
gen idv_construct = (obedience + parents_proud + gov_owner + homosexuality + abortion + divorce + live_with_parents)/7
keep wave name_wvs idv_construct
merge m:1 name_wvs using "name_changes/country_name_changes_wvs.dta"
replace name_wvs = country_name if country_name != ""
drop country_name _merge
rename name_wvs country_name
save "dta_files/idv_construct_data.dta", replace

* import and rename countries for ethnic fractionalisation
import excel using "input/country_name_changes.xlsx", firstrow clear
keep country_name name_hief
drop if name_hief == ""
save "name_changes/country_name_changes_hief.dta", replace
import delimited "input/hief_data.csv", clear
drop if year <= 1973
rename country name_hief
merge m:1 name_hief using "name_changes/country_name_changes_hief.dta"
replace name_hief = country_name if country_name != ""
drop country_name _merge
duplicates drop name_hief year, force
rename name_hief country_name
save "dta_files/hief_data.dta", replace

* import and rename countries for settler mortality
import excel using "input/settler_mortality.xlsx", firstrow clear
rename shortnam country_code
save "dta_files/settler_mortality_data.dta", replace

* import and rename countries for GDP per capita, precipitation, urban pop
import excel using "input/wdi_data.xlsx", firstrow clear
drop SeriesCode
drop if CountryName == ""
replace SeriesName = "gdp_2015" if SeriesName == "GDP per capita (constant 2015 US$)"
replace SeriesName = "precip" if SeriesName == "Average precipitation in depth (mm per year)"
replace SeriesName = "urban_pop" if SeriesName == "Urban population (% of total population)"
replace SeriesName = "patents" if SeriesName == "Patents per million"
reshape long YR, i(CountryName CountryCode SeriesName) j(year)
reshape wide YR, i(CountryName CountryCode year) j(SeriesName) string
rename YRgdp_2015 gdp_2015
rename YRprecip precip
rename YRurban_pop urban_pop
rename YRpatents patents
rename CountryName country_name
rename CountryCode country_code
foreach var in gdp_2015 precip urban_pop patents {
    replace `var' = "" if `var' == ".."
    destring `var', replace
}
gen ln_gdp = log(gdp_2015)
save "dta_files/wdi_data_clean.dta", replace

* merge datasets for regressions (annual)
use "dta_files/wdi_data_clean.dta", clear
merge m:1 country_name using "dta_files/island_elev_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_name using "dta_files/landlocked_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_name using "dta_files/rugged_data.dta"
drop if _merge == 2
drop _merge
merge 1:1 country_name year using "dta_files/hief_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_code using "dta_files/settler_mortality_data.dta"
drop if _merge == 2
drop extmort4 _merge
save "dta_files/model_data_annual.dta", replace

* merge datasets for regressions (period average)
use "dta_files/wdi_data_clean.dta", clear
drop patents
keep if year >= 1970 & year <= 2010
collapse (mean) gdp_2015 precip urban_pop ln_gdp, by(country_name country_code)
merge 1:1 country_name using "dta_files/hofstede_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_name using "dta_files/island_elev_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_name using "dta_files/landlocked_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_name using "dta_files/rugged_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_code using "dta_files/settler_mortality_data.dta"
drop if _merge == 2
drop extmort4 _merge
save "dta_files/model_data_average.dta", replace

* merge datasets for regressions (waves)
use "dta_files/wdi_data_clean.dta", clear
drop patents
gen wave = "1981-1984" if year >= 1981 & year <= 1984
replace wave = "1990-1994" if year >= 1990 & year <= 1994
replace wave = "1994-1998" if year >= 1995 & year <= 1998
replace wave = "1999-2004" if year >= 1999 & year <= 2004
replace wave = "2005-2009" if year >= 2005 & year <= 2009
replace wave = "2010-2014" if year >= 2010 & year <= 2014
replace wave = "2017-2022" if year >= 2017 & year <= 2022
drop if wave == ""
collapse (mean) gdp_2015 precip urban_pop ln_gdp, by(country_name country_code wave)
merge 1:1 country_name wave using "dta_files/idv_construct_data.dta", keep(match)
drop _merge
merge m:1 country_name using "dta_files/island_elev_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_name using "dta_files/landlocked_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_name using "dta_files/rugged_data.dta"
drop if _merge == 2
drop _merge
merge m:1 country_code using "dta_files/settler_mortality_data.dta"
drop if _merge == 2
drop extmort4 _merge
save "dta_files/model_data_waves.dta", replace





