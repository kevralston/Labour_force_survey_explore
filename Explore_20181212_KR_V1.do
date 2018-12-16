
** Kevin Ralston 2018

/* this file is an exploration of the LFS. I have the 75, 85 95, 05, 15 LFS. 

I am just feeling it out for a couple of projects.
I am intersted in intergenerational ineqiality
I am also interested in country of birth and occupation in the context of brexit.

Basically it’s an occupational history of immigrants. Showing the occupations and sectors they undertake/took within the labour market and regionally, by sex, age and in 
comparison to the non-immigrant population. 

Occupation
In comparison to non-migrants
	Across regions
	By age and sex and levels of education

	
LDA course	
E:\Work\Courses&Code\LDA Course\Stata_files	

*/ 

************ LFS 1975


global path1 "E:\Datasets\LFS\LFS_1975\UKDA-1758-stata6\stata6"

use $path1\lfs75.dta


************ LFS 2015

global path2 "E:\Datasets\LFS\LFS_2015"


************ LFS 2005

global path3 "E:\Datasets\LFS\LFS_2005"


************ Save file


global path_s "E:\Datasets\LFS\LFS_2015\Save"


******************************************************************************************************

*** age

summarize var26 /* agea */

rename var26 age

*** sex

tab var25 /* sexa */

label define var25l 1"Men" 2"Women" 
		label values var25 var25l
		label variable var25 "Sex"

rename var25 sex		

tab sex, miss		

*** var37, econpoa, economic position
*** var38 econstata, Economic status 
*** var41 empstata, Status, Employment 

tab1 var37 var38 var41


*** var38 econstata

*** 4 status not knows Full time worker
*** 5 status not knows Part time worker
*** 6 not applicable

label define var38l 0"Employer" 1"Self emp no employees" 2"Employee FT" 3"Employee PT" 4"Satus not known FT" 5"Satus not known PT" 6"not-applicable"
		label values var38 var38l
		label variable var38 "Economic status"


*** var41 empstata, Status, Employment 	

label define var41l 0"Not-stated" 1"Self emp with employees" 2"Self emp with employees" 3"Employee" 
		label values var41 var41l
		label variable var41 "Employment status"

	
*** var37, econpoa, economic position

*** 0 to 5 are classified economically active, 3 to 5 are out of employemnt 
*** 6 to 9 are economically inactive
*** 10 not known
*** 11 U16

label define var37l 0"Self-employed" 1"Employee" 2"not-stated" 3"seeking work" 4"waiting to take up job" 5"sick" 6"student" 7"retired" 8"housewife" 9"other inactive" ///
		10"not-known" 11"Under 16"
		label values var37 var37l
		label variable var37 "Employment status"
		
tab var37		
rename var37 emp_stat

tab emp_stat	

*********************************************************************************

*** associations, age sex and employment status 

tab emp_stat sex

*** age 22 to 32

tab emp_stat sex if age>=22 & age<=32, col chi V gamma 

*** age less than 22 but over 16

tab emp_stat sex if age>=16 & age<=21, col chi V gamma 


******************* save the file as a 75 for appending *************************

*** generate a year varibale

gen year = 1975

*

keep year emp_stat sex age

save $path_s\a75.dta, replace

*********************************************************************************

*** occupations 

*** var39, KOSA Key occupations for Statistical Purposes
*** var40, KOSGROA Key Occupation Groups - main Job


******************************************************************************************************

*** LFS 2005

*** LFS 2005 april to june: lfsp_aj05
*** LFS 2005 january to march: lfsp_jm05
*** LFS 2005 july to september: lfsp_js05
*** LFS 2005 october to december: lfsp_od05


use $path3\lfsp_aj05.dta

append using "$path2\lfsp_jm05"
append using "$path2\lfsp_js05"
append using "$path2\lfsp_od05"

numlabel INECAC05, add

tab INECAC05, missing


******************************************************************************************************

*** LFS 2015

*** LFS 2015 april to june: lfsp_aj15_eul.dta
*** LFS 2015 january to march: lfsp_jm15_eul.dta
*** LFS 2015 july to september: lfsp_js15_eul.dta
*** LFS 2015 october to december: lfsp_od15_end_user.dta


************ LFS 2015

clear

global path2 "E:\Datasets\LFS\LFS_2015"

use $path2\lfsp_aj15_eul.dta

append using "$path2\lfsp_jm15_eul.dta"
append using "$path2\lfsp_js15_eul.dta"
append using "$path2\lfsp_od15_end_user.dta"


numlabel INECAC05, add

tab INECAC05, missing

/* I want to harmonise with the 1957 coding

1975 coding	

label define var37l 0"Self-employed" 1"Employee" 2"not-stated" 3"seeking work" 4"waiting to take up job" 5"sick" 6"student" 7"retired" 8"housewife" 9"other inactive" ///
		10"not-known" 11"Under 16"
		label values var37 var37l
		label variable var37 "Employment status"

		*/ 

		
* INECAC05 3. Government employment - coded as seeking work category 3
* INECAC05 5. ILO Unemployed  - coded as seeking work category 3 
		*** - seeking work, that is, had taken specific steps in a specified recent period to seek paid employment or self-employment. 
		*** - https://stats.oecd.org/glossary/detail.asp?ID=2791			
* INECAC05  17	Inactive, not seeking, would like, believes no jobs availabl
*			18	Inactive, not seeking, would like, not yet started looking
*			19	Inactive, not seeking, would like, does not need or want emp
*			CODED AS 9 OTHER INACTIVE
		

capture drop emp_stat		
gen emp_stat = . 
	replace emp_stat = 0  if INECAC05 ==2
	replace emp_stat = 1  if INECAC05 ==1
	replace emp_stat = 2  if INECAC05 ==11 | INECAC05 ==22 | INECAC05 ==33
	replace emp_stat = 3  if INECAC05==3 | INECAC05==5 | (INECAC05 >=6 & INECAC05 <=11)
	replace emp_stat = 4  if INECAC05 ==12 | INECAC05 ==23	
	replace emp_stat = 5  if INECAC05 ==7 | INECAC05 ==8 | INECAC05 ==15 | INECAC05 ==16 | INECAC05 ==26 | INECAC05 ==27 
	replace emp_stat = 6  if INECAC05 ==6 | INECAC05 ==13 | INECAC05 ==24
	replace emp_stat = 7  if INECAC05 ==20 | INECAC05 ==31
	replace emp_stat = 8  if INECAC05 ==4 | INECAC05 ==7 | INECAC05 ==14 | INECAC05 ==25
	replace emp_stat = 9  if INECAC05 ==10 | INECAC05 ==17 | INECAC05 ==18 | INECAC05 ==19 | INECAC05 ==21 | INECAC05 ==28 |INECAC05 ==29 |INECAC05 ==30 | INECAC05 ==32
*	replace emp_stat = 10 if INECAC05 
	replace emp_stat = 11 if INECAC05 ==34
	
tab emp_stat	


label define emp_statl 0"Self-employed" 1"Employee" 2"not-stated" 3"seeking work" 4"waiting to take up job" 5"sick" 6"student" 7"retired" 8"housewife" 9"other inactive" ///
		10"not-known" 11"Under 16"
		label values emp_stat emp_statl
		label variable emp_stat "Employment status"

		
numlabel emp_statl, add		
tab emp_stat, miss	

***

tab INECAC05 emp_stat, miss	

*********************************************************************************

summarize AGE

tab SEX

*** associations, age sex and employment status 

tab emp_stat SEX, row
tab emp_stat SEX, col

*** age 22 to 32

tab emp_stat SEX if AGE>=22 & AGE<=32, col chi V gamma 

*** age less than 22 but over 16

tab emp_stat SEX if AGE>=16 & AGE<=21, col chi V gamma 

*********************************************************************************
******************* save the file as a 75 for appending *************************

*** need to rename age and sex

rename AGE age

rename SEX sex

*** generate a year varibale

gen year = 2015


keep year emp_stat sex age

save $path_s\a15.dta, replace

*********************************************************************************

use $path_s\a15.dta, clear
append using $path_s\a75.dta

tab year
summarize


sort year sex
by year sex: tab emp_stat 

by year: tab emp_stat sex, row V


by year: tab emp_stat sex if age>=22 & age<=32, col V
by year: tab emp_stat sex if age>=16 & age<=21, col V



statsby "tab emp_stat sex if age>=22 & age<=32, V" astat1=r(CramersV) , ///
     by(year) saving($path_s\stby1.dta) replace

	 
use $path_s\stby1.dta, clear
	 
summarize
list
	 
graph twoway (bar astat1 year , bcolor(gs7) barwidth(1.2)) 

///	 
	 
	 
	 