use "https://raw.githubusercontent.com/satertt/WBG-Poverty-and-Equity-Global-Practice/master/growth_accounting.dta", clear

drop if year<1990

* check missing years
by countrycode: gen length = year[_N]-year[1]+1
sum length
* Notes: no missing year, every country have 25 years data

* check missing data 
** missing gfk
egen gfk_n = total(!missing(gfk)), by(countrycode)
drop if gfk_n<12
** if there is no more than 10 year growth rate of gfk we cant predict k0

*local missing value
by countrycode: gen local=_n if gfk==.
by countrycode: gen missing =length-gfk_n

*display the missing pattern
egen tag = tag(countrycode)
tab missing if tag==1

** 7 countries miss 1 gfk, 1 country miss 2, 1 country miss 10

** drop if missing=1 and local=1 or 26
drop if missing==1 & local==1
drop if missing==1 & local==26

drop missing gfk_n length
egen gfk_n = total(!missing(gfk)), by(countrycode)
by countrycode: gen length = year[_N]-year[1]+1
by countrycode: gen missing =length-gfk_n
tab missing if tag==1
** 1 country miss 2 and 1 country miss 10

list countrycode missing local if missing==2
drop if missing==2
** Because they are in last 2 years, drop

drop missing gfk_n length
egen gfk_n = total(!missing(gfk)), by(countrycode)
by countrycode: gen length = year[_N]-year[1]+1
by countrycode: gen missing =length-gfk_n
tab missing if tag==1
** 1 country miss 10

list countrycode missing local if missing==10
* missing last 16 years
drop if missing==10

drop missing gfk_n length
egen gfk_n = total(!missing(gfk)), by(countrycode)
by countrycode: gen length = year[_N]-year[1]+1
by countrycode: gen missing =length-gfk_n
tab missing if tag==1
** no missing in gfk
drop missing gfk_n length tag local

********** Estimation of Capital Stock
sort countrycode year
by countrycode: gen I_0=(gfk[1]+gfk[2])/2

by countrycode: gen growth=(gfk - gfk[_n-1])/gfk[_n-1] if _n!=1
egen top = rank (year), by(countrycode)

egen g = mean(growth / (top <12 & top>1)), by(countrycode)

gen ln_l=ln(pop1564+pop65up)
gen ln_y=ln(gdp)

by countrycode: gen d_lny=(ln_y - ln_y[_n-1])/ln_y[_n-1] if _n!=1
by countrycode: gen d_lnl=(ln_l - ln_l[_n-1])/ln_l[_n-1] if _n!=1

local var1 3 6 8
local var2 2 3 4

foreach x of numlist 3 6 8 {
  gen k_0_`x'=I_0*(g+`x')
  by countrycode: gen k_t_`x'=k_0_`x' if _n==1
  by countrycode: replace k_t_`x'=k_0_`x'[_n-1]*(1-(`x'/100))+gfk[_n] if _n!=1
  gen ln_k_`x'=ln(k_t_`x')
  by countrycode: gen d_lnk`x'=(ln_k_`x' - ln_k_`x'[_n-1])/ln_k_`x'[_n-1] if _n!=1
foreach y of numlist 2 3 4 {
gen dlna`x'`y'1=d_lny-(`y'/10)*d_lnk`x'-(1-`y'/10)*d_lnl
}
}

** estimate return to education
** we know that H_t=h_t*L_t, then h_t=H_t/L_t which is the inverse of larbor force participaton rate
** There are 12 missing value in lfpr, all in the last year
** by observing the data, the lfpr is quite stable across years. So I use 5 years average to interpolate the value
gen miss=1 if lfpr==.
egen lfpr_ave=mean(lfpr/(top <26 & top>=21)), by(countrycode)
replace lfpr=lfpr_ave if miss ==1
drop lfpr_ave miss top

gen h=1/lfpr
** we also know that h_t=exp(phi*S_t), then phi=ln(h_t)/s_t
gen phi=ln(h)/years_sch

gen ln_S=ln(years_sch)
by countrycode: gen d_lnS=(ln_S - ln_S[_n-1])/ln_S[_n-1] if _n!=1


foreach x of numlist 3 6 8 {
foreach y of numlist 2 3 4 {
gen dlna`x'`y'2=d_lny-(`y'/10)*d_lnk`x'-(1-`y'/10)*d_lnl-(1-`y'/10)*phi*d_lnS
}
}

drop if d_lny==.

keep countryname countrycode year d_lny d_lnl  d_lnk3 d_lnk6 d_lnk8 phi d_lnS dlna321 dlna331 dlna341 dlna621 dlna631 dlna641 dlna821 dlna831 dlna841 dlna322 dlna332 dlna342 dlna622 dlna632 dlna642 dlna822 dlna832 dlna842

*save "C:\Users\Administrator\OneDrive\World Bank\1.dta", replace

*use "C:\Users\Administrator\OneDrive\World Bank\1.dta", clear

expand 2, gen(model)

foreach x of numlist 3 6 8 {
foreach y of numlist 2 3 4 {
replace dlna`x'`y'1=dlna`x'`y'2 if model==1
drop dlna`x'`y'2
rename dlna`x'`y'1 dlna`x'`y'
}
}

tostring model, replace
replace model="Model 1" if model=="0"
replace model="Model 2" if model=="1"

tostring year, replace
gen id=countrycode+year+model
reshape long dlna, i(id) j(para)

gen parameters = para
tostring parameters, replace
gen a=substr(parameters,1,1)
gen b=substr(parameters,2,2)
replace parameters = "delta="+a+","+"alpha="+b

rename d_lnk3 d_lnk
replace d_lnk=d_lnk6 if a=="6"
replace d_lnk=d_lnk8 if a=="8"
replace phi=. if model=="Model 1"
replace d_lnS=. if model=="Model 1"

drop para a b id d_lnk6 d_lnk8

export excel using "C:\Users\Administrator\OneDrive\World Bank\1.xlsx", firstrow(variables) replace
