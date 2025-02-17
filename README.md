# individualism_proj

## Project
This repo contains the work I did for the final project in my class **Economics of Political Institutions**. I am interested in the relationship between individualism and economic development, and I explored the effects of economic growth (measured by ln GDP per capita) on individualism. The project also covers the interaction between urbanisation and economic development, various measures of individualism, and the use of settler mortality as an instrumental variable for economic development.

## Contents
This repo includes the 2 Stata do-files that I wrote to combine and prepare the datatsets for regression output. I have additionally included PNGs of the regression table outputs in the ``table_results`` folder. The tables are produced with ``outreg2`` in Stata, and I made edits to the format and text in the Word documents produced.

## Data
All data files that I used in this project are included in the ``input`` folder. The ``country_name_changes`` file is a spreadsheet that I compiled, comparing the namings of countries between datasets. In the ``data_preparation`` do-file, this file is used to convert country names across all files to match the naming conventions of the World Bank's World Development Indicators dataset.

All variables from the World Bank's WDI dataset are reported for the 217 listed countries for the previous 50 years (1974-2023). The variables are:

1. GDP per capita (in constant 2015 US$)
2. Urban population as % of total population
3. Average preciptation in depth (mm per year)
4. A custom indicator calculated by dividing patent applications (residents) by the total population and multiplying by 1,000,000

The ``island_elev_data`` file is transcribed from the CIA Factbook's ["Elevation"](https://www.cia.gov/the-world-factbook/field/elevation/) webpage and Encyclopedia Britannica's ["List of islands"](https://www.britannica.com/topic/list-of-islands-2041456) webpage.

Other citations are as follows:

- ``geo_cepii_data``: Mayer, T. & Zignago, S. (2011), "Notes on CEPII’s distances measures : the GeoDist Database", CEPII Working Paper 2011-25.
- ``hief_data``: Drazanova, L. (2020) ‘Introducing the Historical Index of Ethnic Fractionalization (HIEF) Dataset: Accounting for Longitudinal Changes in Ethnic Diversity’, *Journal of Open Humanities Data*, 6(1), p. 6. Available at: https://doi.org/10.5334/johd.16.
- ``hofstede_data``: Hofstede, G. (1980) *Culture’s consequences: International differences in work-related values*, SAGE Publications.
- ``rugged_data``: Nunn, N., and D. Puga. (2012). “Ruggedness: The blessing of bad geography in Africa”, in *The Review of Economics and Statistics*, 94(1), 20-36.
- ``settler_mortality``: Acemoglu, D., S. Johnson, and J. A. Robinson. (2001) “The Colonial Origins of Comparative Development: An Empirical Investigation”, in *The American Economic Review*, 91(5), p. 1369-1401.
- ``wdi_data``: World Bank. (2025). “World Bank Development Indicators,” Available at: https://databank.worldbank.org/source/world-development-indicators.
- ``wvs_ts``: Haerpfer, C., Inglehart, R., Moreno, A., Welzel, C., Kizilova, K., Diez-Medrano J., M. Lagos, P. Norris, E. Ponarin & B. Puranen et al. (eds.). (2022). "World Values Survey Trend File (1981-2022) Cross-National Data-Set", Madrid, Spain & Vienna, Austria: JD Systems Institute & WVSA Secretariat. Data File Version 4.0.0, doi:10.14281/18241.27
