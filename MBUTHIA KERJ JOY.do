** Loading the data
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma

** Declaring the data is Time Series
tsset year, yearly


** Obtaining the summary of the statistics
tabstat co2us co2ken gdpus gdpken infus infken gnius gniken, statistics( mean count sum max min sd skewness kurtosis ) columns(variables)
graph box co2us co2ken gdpus gdpken infus infken gnius gniken

** Establishing the trend of our variables
twoway (tsline gdpus)
twoway (tsline gdpken)
twoway (tsline co2us)
twoway (tsline co2ken)
twoway (tsline infus)
twoway (tsline infken)
twoway (tsline gnius)
twoway (tsline gniken)

* Testing for stationarity in all variables
lmalb  gdpus, lags(52)
lmalb  gdpken, lags(52)
lmalb  co2us, lags(52)
lmalb  co2ken, lags(52)
lmalb  infus, lags(52)
lmalb  infken, lags(52)
lmalb  gnius, lags(52)
lmalb  gniken, lags(52)

** Differencing the variables
*** The [l.gdpus] instructs STATA to take the lag of the GDP of US
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
gen dco2ken= co2ken-l.co2ken
gen dgdpus= gdpus-l.gdpus
gen dgdpken= gdpken-l.gdpken
gen dinfus= infus-l.infus
gen dinfken= infken-l.infken
gen dgnius= gnius-l.gnius
gen dgniken= gniken-l.gniken
** Confirming the variables are now stationary by running the Dickey Filler Test on differenced variables
dfgls dco2us
dfgls dco2ken
dfgls dgdpus
dfgls dgdpken
dfgls dinfus
dfgls dinfken
dfgls dgnius
dfgls dgniken
*** The absolute tau statistic, of the variables is less than the critical value, therefore, we fail to reject the null hypothesis. The variables are still nonsatationary. 

** Creating growth variables for each variable and testing for stationarity
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
gen dco2ken= co2ken-l.co2ken
gen dgdpus= gdpus-l.gdpus
gen dgdpken= gdpken-l.gdpken
gen dinfus= infus-l.infus
gen dinfken= infken-l.infken
gen dgnius= gnius-l.gnius
gen dgniken= gniken-l.gniken

generate gdco2us=dco2us/l.co2us
dfuller gdco2us
generate gdco2ken=dco2ken/l.co2ken
dfuller gdco2ken
generate gdgdpus=dgdpus/l.gdpus
dfuller gdgdpus
generate gdgdpken=dgdpken/l.gdpken
dfuller gdgdpken
generate gdinfus=dinfus/l.infus
dfuller gdinfus
generate gdinfken=dinfken/l.infken
dfuller gdinfken
generate gdgnius= dgnius/l.gnius
dfuller gdgnius
generate gdgniken= dgniken/l.gniken
dfuller gdgniken

** Testing for serial correlation in residuals
regress  gdco2us gdgdpus gdinfus gdgnius
estat dwatson
estat durbinalt
regress  gdco2ken gdgdpken gdinfken gdgniken
estat dwatson
estat durbinalt

*** Correcting for serial correlatin in US Residuals.
prais gdco2us gdgdpus gdinfus gdgnius, rhotype(regress)



* BoxJenkins methodology

** Identification
ac gdco2us, lags(12)
pac gdco2us, lags(12)
ac gdco2ken, lags(12)
pac gdco2ken, lags(12)
** Estimation and diagnostic checking

*** gdco2us
arima gdco2us, arima(0,0,1)
predict usresma1, residuals
lmalb  usresma1, lags(51)
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
generate gdco2us=dco2us/l.co2us
arima gdco2us, arima(1,0,0)
predict usresar1, residuals
lmalb  usresar1, lags(51)
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
generate gdco2us=dco2us/l.co2us
arima gdco2us, arima(3,0,0)
predict usresar3, residuals
lmalb  usresar3, lags(51)

*** gdco2ken
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2ken= co2ken-l.co2ken
generate gdco2ken=dco2ken/l.co2ken
arima gdco2ken, arima(12,0,0)
predict kenresar12, residuals
lmalb  kenresar12, lags(12)


** Model complexity evaluation

*** gdco2us
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
generate gdco2us=dco2us/l.co2us
arima gdco2us, arima(0,0,1)
estat ic
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
generate gdco2us=dco2us/l.co2us
arima gdco2us, arima(1,0,0)
estat ic
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
generate gdco2us=dco2us/l.co2us
arima gdco2us, arima(3,0,0)
estat ic

** Forecasting
*** gdco2us
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2us= co2us-l.co2us
generate gdco2us=dco2us/l.co2us
arima gdco2us, arima(0,0,1)
predict gengdco2us, y
twoway (line gdco2us year) (line gengdco2us year)

*** gdco2ken
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
gen dco2ken= co2ken-l.co2ken
generate gdco2ken=dco2ken/l.co2ken
arima gdco2ken, arima(12,0,0)
predict gengdco2ken, y
twoway (line gdco2ken year) (line gengdco2ken year)


*Testing for cointegration
clear
insheet using "C:\Users\kerjmbuthia\Desktop\School 3.1\Time Series Analysis\Group Work\Kenya and US data.csv", comma
tsset year, yearly
vecrank co2us gdpus infus gnius, trend(constant)
vec co2us gdpus infus gnius, trend(constant) lags(1)
vecrank co2ken gdpken infken gniken, trend(constant) 
vec co2ken gdpken infken gniken, trend(constant) rank(2)



** Impulse response and variance decompositions 
***US
vec co2us gdpus infus gnius, trend(constant) lags(1)
irf create vec1, set(vecintro, replace) step(8)
irf graph fevd, irf(vec1) 
irf table fevd, irf(vec1)
***KEN
vec co2ken gdpken infken gniken, trend(constant) lags(1)
irf create vec1, set(vecintro, replace) step(8)
irf graph fevd, irf(vec1) 
irf table fevd, irf(vec1)


