cd "/Users/tess/Desktop/stata_idv_data"
cap mkdir "/Users/tess/Desktop/stata_idv_data/plots"
cap mkdir "/Users/tess/Desktop/stata_idv_data/tables"


*** AVERAGE: country averages taken for period 1990-2010 (HOFSTEDE)
use "dta_files/model_data_average.dta"
graph twoway (scatter idv gdp_2015) (lfit idv gdp_2015)
graph export "plots/gdp_hof.png", replace
graph twoway (scatter idv ln_gdp) (lfit idv ln_gdp)
graph export "plots/ln_gdp_hof.png", replace
graph twoway (scatter idv urban_pop) (lfit idv urban_pop)
graph export "plots/urban_hof.png", replace
graph twoway (scatter ln_gdp urban_pop) (lfit ln_gdp urban_pop)
graph export "plots/urban_ln_gdp.png", replace

*initial regression introducing controls to full baseline model
reg idv ln_gdp
outreg2 using "tables/table_01.doc", replace
reg idv ln_gdp urban_pop precip mean_elevation island landlocked rugged dist_coast
outreg2 using "tables/table_01.doc", append
reg idv ln_gdp cont_africa cont_asia cont_europe cont_oceania cont_america
* remove due to collinearity
reg idv ln_gdp cont_asia cont_europe cont_oceania cont_america
outreg2 using "tables/table_01.doc", append
reg idv ln_gdp urban_pop precip mean_elevation island landlocked rugged dist_coast cont_asia cont_europe cont_oceania cont_america
outreg2 using "tables/table_01.doc", append

* create interaction between urban population and ln GDP per capita
gen gdp_urban_int = ln_gdp * urban_pop
reg idv ln_gdp urban_pop gdp_urban_int precip mean_elevation island landlocked rugged dist_coast cont_asia cont_europe cont_oceania cont_america
outreg2 using "tables/table_01.doc", append

* add to IV 2 stage regression
factor urban_pop precip mean_elevation island landlocked rugged dist_coast cont_asia cont_europe cont_oceania cont_america
predict geo_index

* first stage
reg ln_gdp logem4 geo_index
outreg2 using "tables/table_04.doc", replace

* second stage
ivregress 2sls idv geo_index (ln_gdp = logem4)
outreg2 using "tables/table_05.doc", replace


*** WAVE: data consists of country averages for each wave of the WVS (WVS)
use "dta_files/model_data_waves.dta", clear
graph twoway (scatter idv_construct ln_gdp) (lfit idv_construct ln_gdp)
graph export "plots/ln_gdp_wvs.png", replace

* create interaction and control variables
gen gdp_urban_int = ln_gdp * urban_pop
factor urban_pop precip mean_elevation island landlocked rugged dist_coast cont_asia cont_europe cont_oceania cont_america
predict geo_index

reg idv_construct ln_gdp geo_index
outreg2 using "tables/table_02.doc", replace
reg idv_construct ln_gdp geo_index gdp_urban_int
outreg2 using "tables/table_02.doc", append

* create run regression by wave, waves 1&2 excluded due to insufficient data
reg idv_construct ln_gdp geo_index gdp_urban_int if wave == "1994-1998"
outreg2 using "tables/table_03.doc", replace
reg idv_construct ln_gdp geo_index gdp_urban_int if wave == "1999-2004"
outreg2 using "tables/table_03.doc", append
reg idv_construct ln_gdp geo_index gdp_urban_int if wave == "2005-2009"
outreg2 using "tables/table_03.doc", append
reg idv_construct ln_gdp geo_index gdp_urban_int if wave == "2010-2014"
outreg2 using "tables/table_03.doc", append
reg idv_construct ln_gdp geo_index gdp_urban_int if wave == "2017-2022"
outreg2 using "tables/table_03.doc", append

* IV two stages with WVS individualism construct
reg ln_gdp logem4 geo_index if wave == "2017-2022"
outreg2 using "tables/table_04.doc", append
ivregress 2sls idv_construct geo_index (ln_gdp = logem4) if wave == "2017-2022"
outreg2 using "tables/table_05.doc", append


*** ANNUAL: country data taken annually for period 1974-2023 (PATENT, EFINDEX)
use "dta_files/model_data_annual.dta", clear
graph twoway (scatter efindex ln_gdp) (lfit efindex ln_gdp)
graph export "plots/ln_gdp_efindex.png", replace
graph twoway (scatter patents ln_gdp) (lfit patents ln_gdp)
graph export "plots/ln_gdp_patents.png", replace

* log transform patents variable due to plots/gdp_hof
gen ln_patents = log(patents)
graph twoway (scatter ln_patents ln_gdp) (lfit ln_patents ln_gdp)
graph export "plots/ln_gdp_ln_patents.png", replace

* create interaction and control variables
gen gdp_urban_int = ln_gdp * urban_pop
factor urban_pop precip mean_elevation island landlocked rugged dist_coast cont_asia cont_europe cont_oceania cont_america
predict geo_index

* baseline and interaction regressions for patent measure
reg ln_patents ln_gdp geo_index
outreg2 using "tables/table_02.doc", append
reg ln_patents ln_gdp geo_index gdp_urban_int
outreg2 using "tables/table_02.doc", append

* IV two stages with patents for most recent year of observation (2021)
reg ln_gdp logem4 geo_index if year == 2021
outreg2 using "tables/table_04.doc", append
ivregress 2sls ln_patents geo_index (ln_gdp = logem4) if year == 2021
outreg2 using "tables/table_05.doc", append

* baseline and interaction regressions for ethnic fractionalisation
reg efindex ln_gdp geo_index
outreg2 using "tables/table_02.doc", append
reg efindex ln_gdp geo_index gdp_urban_int
outreg2 using "tables/table_02.doc", append

*IV two stages with ethnic frac for most recent year of observation (2013)
reg ln_gdp logem4 geo_index if year == 2013
outreg2 using "tables/table_04.doc", append
ivregress 2sls efindex geo_index (ln_gdp = logem4) if year == 2013
outreg2 using "tables/table_05.doc", append
