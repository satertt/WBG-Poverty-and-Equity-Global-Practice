*******************************************************
**** 2. Advanced Stata skills, econometrics skills ****
*******************************************************
set more off

***********************************
* 2.1 preinstall program in stata * 
***********************************
 
net from https://stats.idre.ucla.edu/stat/stata/ado/analysis/
net install collin

********************************
* 2.2 Use the data from GitHub *
******************************** 
use "https://raw.githubusercontent.com/satertt/WBG-Poverty-and-Equity-Global-Practice/master/predictLcons.dta", clear

**************************
* 2.3 Summerize the data *
**************************
sum

* Notes: 1. The dataset contians 4,566 observations in 8 regions and 30 psu 
*        2. In all X (x1 - x20) varibales, there are 8 dummies and 12 conitunes variables
*        3. There is 1,383 missing value in "lncons" (4,566-3,183) 

***********************************
* 2.4 Prediction model estimation *
***********************************

** 2.4.1 Model with all x variables (Model 1) **

drop x21
** Notes: x21 is dropped for the convinionce of coding

reg lncons  x*
** Notes: x13 and x16 are omitted due to collinearity. 
**        Next step we will drop X13 and x16

********************************************************************************

** 2.4.2 Model without x13 and x16 (Model 2) **

*** 2.4.2.1 Regression 
drop x13 x16
reg lncons x*

estat ic

*** 2.4.2.2 Regression Dianostics

*** Check multicollinearity
vif

*** Check Model Specification
linktest
ovtest

*** check heteroskedasticity
estat hettest

*** Checking Normality of Residuals
predict r, resid
kdensity r, normal name(kdensity1)
pnorm r, name(pnorm1)
qnorm r, name(qnorm1)
swilk r

*** Notes: We will further test the multicollinearity, and generate an alternative prediction model

********************************************************************************

** 2.4.3 alternative prediction model (trail 1)

use "https://raw.githubusercontent.com/satertt/WBG-Poverty-and-Equity-Global-Practice/master/predictLcons.dta", clear

*** 2.4.3.1 Test collinearity for all x variables 
collin x*
*** Notes: VIF for x8 and x13 are iregular, so in alternative model they will be dropped.

*** 2.4.3.2 Model without x8 and x13 (Model 3) ***
drop x8 x13 x21
reg lncons x*

estat ic

*** 2.4.3.3 Regression Dianostics
*** Check multicollinearity
vif

*** Check Model Specification
linktest
ovtest

*** check heteroskedasticity
estat hettest

*** Checking Normality of Residuals
predict r, resid
kdensity r, normal name(kdensity2)
pnorm r, name(pnorm2)
qnorm r, name(qnorm2)
swilk r

*** Note: Similar non normality conclsion

**********************************************************************************

** 2.4.4 alternative prediction model (trail 2)

use "https://raw.githubusercontent.com/satertt/WBG-Poverty-and-Equity-Global-Practice/master/predictLcons.dta", clear

*** 2.4.4.1 Model without x8, x13 and x16 (Model 4) ***

drop x8 x13 x16 x21
reg lncons x*

estat ic

*** 2.4.4.2 Regression Dianostics ***

*** Check multicollinearity
vif

*** Check Model Specification
linktest
ovtest

*** check  heteroskedasticity
estat hettest

** One of the main assumptions for the ordinary least squares regression is the homogeneity of variance of the residuals.

*** Checking Normality of Residuals
predict r, resid
kdensity r, normal name(kdensity3)
pnorm r, name(pnorm3)
qnorm r, name(qnorm3)
swilk r

*** Note: 1. the residual is normally distributed
***       2. Although Model 4 does not have lowest AIC and BIC, but with a normally distributed
***          error terms. It is the most preferred model here. 

********************************************************************

************************************
* 2.5 Perform above test with mata *
************************************

use "https://raw.githubusercontent.com/satertt/WBG-Poverty-and-Equity-Global-Practice/master/predictLcons.dta", clear


** 2.5.1 Model 4 **

drop x8 x13 x16 x21
gen select=1 if lncons==.
replace select=0 if select==.
mata
st_view(Data=., ., "lncons x*",0)
st_view(Data_test=., ., "lncons x*","select")
st_subview(y=.,Data,.,1)
st_subview(X=.,Data,.,(2\.))
st_subview(X_test=.,Data_test,.,(2\.))
XX = cross(X,1 , X,1)
Xy = cross(X,1 , y,0)
b = invsym(XX)*Xy

X = X, J(rows(X), 1, 1)
X_test = X_test, J(rows(X_test), 1, 1)
e = y - X*b
n = rows(X)
k = cols(X)
s2= (e'e)/(n-k)
V = s2*invsym(XX)
se = sqrt(diagonal(V))
(b, se, b:/se, 2*ttail(n-k, abs(b:/se)))

// prediction

pred1 = X_test*b
pred1

end
   
