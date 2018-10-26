# WBG-Poverty and Equity Global Practice

## Introduction

&emsp; The purpose of these exercises is to assess the following capabilities: [1] Programing skills in Stata to produce self-contained and automated code, [2] intuitive visualization skills and sophisticated management of Microsoft Excel, [3] economic analysis, and [4] writing skills. Thus, as we know that not everybody is proficient in each of the fourth skills above, each of the following exercises assess a different set of skills.

&emsp; We are looking for organized and clear methods to solving problems; not necessarily the most complicated or complex approaches. We expect you to solve these exercises by yourself, relying on internet and books, if needed. When assessing the do-file/s, we will consider readability, efficiency, and use of different techniques in Stata, so compose the Stata do-file with emphasis on efficiency.1

&emsp; Finally, structure your do-file/s in such a way that we can easily run it from different computers. If we are not able to run your do-file due to directory path dependency, we will count it as a failing do-file. In addition, your do-file/s and Excel file should be flexible enough so that you can make changes easily in case your Team Leader requires additional calculations or specifications from you.2 One more thing to keep in mind is that, in The World Bank Group, we intensively work with Microsoft Office Word and Excel, so although your skills on creating charts in Stata are an asset, we value more your skills on integrating Stata with Microsoft Office and careful programming. We also accept visualizations in Tableau, but knowing this software is not required, though highly desired.

## 1 Stata skills, Excel visualizations, economic analysis, and writing
  
&emsp; The objective is to create a dynamic Excel tool to easily understand the results of the macro-accounting decomposition methodology. This methodology consists on decomposing the growth rates of total economic output (i.e., GDP) into growth rates of factor inputs (i.e., capital, labor, and human capital) and a residual (i.e., GDP growth that is unexplained by increases in factor inputs). This residual will be interpreted as growth in productivity, known as Total Factor Productivity (TFP). Part of your goal is to estimate the TFP based on the models described below.
  
&emsp; Using the information of the dta file (growth_accounting.dta) the project will estimate, based on the two models below, the contribution of TFP growth to total growth of the economy (GPD) and compare it with the corresponding contribution of Labor and Capital growth contributions. Given that the depreciation rate of capital (𝛿) and the income share of capital (𝛼) are unknown values, the project will create several scenarios with different values for these two parameters. (The depreciation rate could be defined with the values 3%, 6%, and 8%, and for the income share of capital the values are 20%, 30%, and 40%). Also, assume the initial year is 1990.

&emsp; The project will do all the calculations using Stata, export the results into an Excel file, and create a pivot table that allows the user to select the model, the country, the depreciation rate of capital, and the income share of capital.
The pivot table (or pivot chart) will include the contribution of capital, labor, and TFP to the total growth rate of GDP that can be filtered by country and the different values of the parameters. More pivot tables with relevant information will also be attached in the Excel files, such as annual growth for each component or comparison of different countries’ performance.

## 2 Advanced Stata skills, econometrics skills

&emsp; The dta file predictLcons.dta is an artificial household survey database with unique values at the household level (hhid). The survey is stratified by region and a primary sample unit (psu). The data is composed of two types of variables. [1] Your variable of interest, the log of household consumption, and [2] a set of household characteristics (x1-x20) that, irrespectively of their qualitative interpretation, vary on type and distribution among themselves. Your task is simple: estimate up to five models to predict the log of consumption for those observations with missing values. We expect from you the following:
1. Well-organized Stata code with all the prediction models used.
2. Short .doc file explaining the econometric intuition of each model and why the best model outperform the others. We would need to assess your understanding of the relationship between variance and bias, margin of error, and accuracy. So, it would be ideal to know how the different models that you picked differ from each other in these aspects.

&emsp; Things to keep in mind
Stata has a huge repository of official and user-written commands for prediction. Though using these commands is not discouraged, we value more your ability to code such statistical procedures by yourself. Of course, we don’t expect you to code a complete ado-file to predict missing values, but we would like to see your ability to code econometric procedures.; Coding in MATA is more efficient and desirable for this kind of procedure.


