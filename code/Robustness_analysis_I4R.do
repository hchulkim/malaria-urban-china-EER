*************************************************************************************
* Stata code used to create all the robustness analyses in the report.
* Make sure you manually set the path directory.
*************************************************************************************
clear all


use SouthChinaPixelLevelMain, clear

estimates drop _all

global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   i.RiverB     i.ClimateZoneGroup  i.Macro


*************************************************************************************
*Table 4: Malaria Suitability, Urbanization and Industrial Activity
*************************************************************************************
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store a1
estadd local "Allcontrols"="Yes"  , replace : a1	
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)  // variable is in percentage
estimates store a2
estadd local "Allcontrols"="Yes"  , replace : a2	
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store a3
estadd local "Allcontrols"="Yes"  , replace : a3	
				
esttab  a* ///
	using "Table4rob_1.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))				

*************************************************************************************
* Robustness
*************************************************************************************				

*+++++++++++++++++++
* No controls
*++++++++++++++++++

xi: reg    UrbanShare1990  MSMSD       ,  cluster(Grid2) // variable is in percentage
estimates store b1
xi: reg    UrbanShare2010  MSMSD      ,  cluster(Grid2)  // variable is in percentage
estimates store b2
xi: reg    ManufacturingShare1990  MSMSD     ,  cluster(Grid2) // variable is in percentage
estimates store b3

esttab  b* ///
	using "Table4rob_2.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))				

	
*+++++++++++++++++++
* Elevation only
*++++++++++++++++++	
				
xi: reg    UrbanShare1990  MSMSD   elev	,  cluster(Grid2) // variable is in percentage
estimates store c1
xi: reg    UrbanShare2010  MSMSD      elev 	  ,  cluster(Grid2)  // variable is in percentage
estimates store c2
xi: reg    ManufacturingShare1990  MSMSD    elev 	,  cluster(Grid2) // variable is in percentage
estimates store c3


esttab  c* ///
	using "Table4rob_3.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( elev "Elevation" )  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))
				

								
*+++++++++++++++++++
* Elevation only - log
*++++++++++++++++++

ge lelev = ln(elev)	

pwcorr 	MSMSD	lelev

xi: reg    UrbanShare1990  MSMSD   lelev  	,  cluster(Grid2) // variable is in percentage
estimates store d1
xi: reg    UrbanShare2010  MSMSD      lelev 	   ,  cluster(Grid2)  // variable is in percentage
estimates store d2
xi: reg    ManufacturingShare1990  MSMSD    lelev 	,  cluster(Grid2) // variable is in percentage
estimates store d3

esttab  d* ///
	using "Table4rob_4.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( lelev "Elevation (log)" )  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))

*++++++++++++++++++	
*** Original results with base controls
*++++++++++++++++++						
				
xi: reg    UrbanShare1990  MSMSD   area  temperature  tempSQ x AbsY	,  cluster(Grid2) // variable is in percentage
estimates store e1
estadd local "Basecontrols"="Yes"  , replace : e1
xi: reg    UrbanShare2010  MSMSD    area  temperature  tempSQ x AbsY	  ,  cluster(Grid2)  // variable is in percentage
estimates store e2
estadd local "Basecontrols"="Yes"  , replace : e2
xi: reg    ManufacturingShare1990  MSMSD   area  temperature  tempSQ x AbsY	,  cluster(Grid2) // variable is in percentage
estimates store e3
estadd local "Basecontrols"="Yes"  , replace : e3

esttab  e* ///
	using "Table4rob_5.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" x "Longitude" AbsY "Abs latitude")  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats( Basecontrols N ,label( "Base Controls" "Observations"  ))	

*++++++++++++++++++
*** Base controls without temperature and temperature SQ	
*++++++++++++++++++							
				
xi: reg    UrbanShare1990  MSMSD  area     x AbsY ,  cluster(Grid2) // variable is in percentage
estimates store f1
xi: reg    UrbanShare2010  MSMSD   area     x AbsY  ,  cluster(Grid2)  // variable is in percentage
estimates store f2
xi: reg    ManufacturingShare1990  MSMSD   area     x AbsY ,  cluster(Grid2) // variable is in percentage
estimates store f3

esttab  f* ///
	using "Table4rob_6.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" x "Longitude" AbsY "Abs latitude")  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label(  "Observations"  ))	

*++++++++++++++++++	
*** Base controls without  X	Aby
*++++++++++++++++++
				
xi: reg    UrbanShare1990  MSMSD  area  temperature  tempSQ 	,  cluster(Grid2) // variable is in percentage
estimates store g1
xi: reg    UrbanShare2010  MSMSD   area  temperature  tempSQ 	  ,  cluster(Grid2)  // variable is in percentage
estimates store g2
xi: reg    ManufacturingShare1990  MSMSD   area  temperature  tempSQ 	,  cluster(Grid2) // variable is in percentage
estimates store g3


esttab  g* ///
	using "Table4rob_7.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" )  ///		
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))
				
		

*++++++++++++++++++	
*** Logs of dependent variable
*++++++++++++++++++		
		
local yvar "UrbanShare1990 UrbanShare2010 ManufacturingShare1990"	
	
foreach i of local 	yvar{
	ge l`i' = ln(`i')
}
	
xi: reg    lUrbanShare1990  MSMSD    $CrossSection   	,  cluster(Grid2) // variable is in percentage
estimates store k1
estadd local "Allcontrols"="Yes"  , replace : k1
xi: reg    lUrbanShare2010  MSMSD       $CrossSection  	   ,  cluster(Grid2)  // variable is in percentage
estimates store k2
estadd local "Allcontrols"="Yes"  , replace : k2
xi: reg    lManufacturingShare1990  MSMSD   $CrossSection  	,  cluster(Grid2) // variable is in percentage
estimates store k3
estadd local "Allcontrols"="Yes"  , replace : k3

esttab  k* ///
	using "Table4rob_8.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))
		
		
	
local yvar "UrbanShare1990 UrbanShare2010 ManufacturingShare1990"	
foreach i of local 	yvar{
	sum `i', det
	ge tr_`i' = `i'
	replace tr_`i' = . if `i' > r(p95)
	replace tr_`i' = . if `i' < r(p5)	
}
		
twoway (kdensity UrbanShare1990) (kdensity tr_UrbanShare1990)	 
	
	

*++++++++++++++++++	
*** Winsorizing
*++++++++++++++++++		
	
xi: reg    tr_UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store h1
estadd local "Allcontrols"="Yes"  , replace : h1
xi: reg    tr_UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)  // variable is in percentage
estimates store h2
estadd local "Allcontrols"="Yes"  , replace : h2
xi: reg    tr_ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store h3
estadd local "Allcontrols"="Yes"  , replace : h3

esttab  h* ///
	using "Table4rob_9.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))
		
		
*++++++++++++++++++	
*** Further analysis: controlling for 1893 shares
*++++++++++++++++++			
		
xi: reg    UrbanShare1990  MSMSD UrbanShare1893   $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store l1
estadd local "Allcontrols"="Yes"  , replace : l1	
xi: reg    UrbanShare2010  MSMSD UrbanShare1893   $CrossSection   ,  cluster(Grid2)  // variable is in percentage
estimates store l2
estadd local "Allcontrols"="Yes"  , replace : l2	
xi: reg    ManufacturingShare1990  MSMSD  UrbanShare1893  $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store l3
estadd local "Allcontrols"="Yes"  , replace : l3	
				
esttab  l* ///
	using "Table4rob_10.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))				
		
		
*++++++++++++++++++	
*** Placebo
*++++++++++++++++++	
	
use NorthChinaPixelLevel, clear

estimates drop _all

ge lelev = ln(elev)	

xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2)
estimates store m1
estadd local "Allcontrols"="Yes"  , replace : m1
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2)
estimates store m2
estadd local "Allcontrols"="Yes"  , replace : m2
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2)
estimates store m3
estadd local "Allcontrols"="Yes"  , replace : m3
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
estimates store m4
estadd local "Allcontrols"="Yes"  , replace : m4
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
estimates store m5
estadd local "Allcontrols"="Yes"  , replace : m5
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)
estimates store m6
estadd local "Allcontrols"="Yes"  , replace : m6

esttab  m* ///
	using "TableC17rob_1.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))				

				
xi: reg    Seats1893 MSMSD     ,  cluster(Grid2)
estimates store n1
estadd local "Allcontrols"="Yes"  , replace : n1
xi: reg    UrbanShare1893 MSMSD     ,  cluster(Grid2)
estimates store n2
estadd local "Allcontrols"="Yes"  , replace : n2
xi: reg    Hierarchy1893 MSMSD      ,  cluster(Grid2)
estimates store n3
estadd local "Allcontrols"="Yes"  , replace : n3
xi: reg    UrbanShare1990  MSMSD    ,  cluster(Grid2)
estimates store n4
estadd local "Allcontrols"="Yes"  , replace : n4
xi: reg    ManufacturingShare1990  MSMSD      ,  cluster(Grid2)
estimates store n5
estadd local "Allcontrols"="Yes"  , replace : n5
xi: reg    UrbanShare2010  MSMSD      ,  cluster(Grid2)
estimates store n6
estadd local "Allcontrols"="Yes"  , replace : n6

esttab  n* ///
	using "TableC17rob_2.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))					
				

xi: reg    Seats1893 MSMSD   elev  ,  cluster(Grid2)
estimates store r1
estadd local "Allcontrols"="Yes"  , replace : r1
xi: reg    UrbanShare1893 MSMSD elev    ,  cluster(Grid2)
estimates store r2
estadd local "Allcontrols"="Yes"  , replace : r2
xi: reg    Hierarchy1893 MSMSD   elev   ,  cluster(Grid2)
estimates store r3
estadd local "Allcontrols"="Yes"  , replace : r3
xi: reg    UrbanShare1990  MSMSD elev   ,  cluster(Grid2)
estimates store r4
estadd local "Allcontrols"="Yes"  , replace : r4
xi: reg    ManufacturingShare1990  MSMSD  elev    ,  cluster(Grid2)
estimates store r5
estadd local "Allcontrols"="Yes"  , replace : r5
xi: reg    UrbanShare2010  MSMSD  elev    ,  cluster(Grid2)
estimates store r6
estadd local "Allcontrols"="Yes"  , replace : r6

esttab  r* ///
	using "TableC17rob_3.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( elev "Elevation" )  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))	
	
xi: reg    Seats1893 MSMSD   lelev  ,  cluster(Grid2)
estimates store p1
estadd local "Allcontrols"="Yes"  , replace : p1
xi: reg    UrbanShare1893 MSMSD lelev    ,  cluster(Grid2)
estimates store p2
estadd local "Allcontrols"="Yes"  , replace : p2
xi: reg    Hierarchy1893 MSMSD   lelev   ,  cluster(Grid2)
estimates store p3
estadd local "Allcontrols"="Yes"  , replace : p3
xi: reg    UrbanShare1990  MSMSD lelev   ,  cluster(Grid2)
estimates store p4
estadd local "Allcontrols"="Yes"  , replace : p4
xi: reg    ManufacturingShare1990  MSMSD  lelev    ,  cluster(Grid2)
estimates store p5
estadd local "Allcontrols"="Yes"  , replace : p5
xi: reg    UrbanShare2010  MSMSD  lelev    ,  cluster(Grid2)
estimates store p6
estadd local "Allcontrols"="Yes"  , replace : p6

esttab  p* ///
	using "TableC17rob_4.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( lelev "Elevation (log)" )  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))
	
	
	
*++++++++++++++++++	
*** Original results with base controls
*++++++++++++++++++						
				
xi: reg    Seats1893 MSMSD   area  temperature  tempSQ x AbsY  ,  cluster(Grid2)
estimates store o1
estadd local "Basecontrols"="Yes"  , replace : o1
xi: reg    UrbanShare1893 MSMSD area  temperature  tempSQ x AbsY    ,  cluster(Grid2)
estimates store o2
estadd local "Basecontrols"="Yes"  , replace : o2
xi: reg    Hierarchy1893 MSMSD   area  temperature  tempSQ x AbsY   ,  cluster(Grid2)
estimates store o3
estadd local "Basecontrols"="Yes"  , replace : o3
xi: reg    UrbanShare1990  MSMSD area  temperature  tempSQ x AbsY   ,  cluster(Grid2)
estimates store o4
estadd local "Basecontrols"="Yes"  , replace : o4
xi: reg    ManufacturingShare1990  MSMSD  area  temperature  tempSQ x AbsY    ,  cluster(Grid2)
estimates store o5
estadd local "Basecontrols"="Yes"  , replace : o5
xi: reg    UrbanShare2010  MSMSD  area  temperature  tempSQ x AbsY    ,  cluster(Grid2)
estimates store o6
estadd local "Basecontrols"="Yes"  , replace : o6				

esttab  o* ///
	using "TableC17rob_5.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" x "Longitude" AbsY "Abs latitude")  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats( Basecontrols N ,label("Base controls" "Observations"  ))	

*++++++++++++++++++
*** Base controls without temperature and temperature SQ	
*++++++++++++++++++							
				
xi: reg    Seats1893 MSMSD   area     x AbsY  ,  cluster(Grid2)
estimates store r1
estadd local "Basecontrols"="Yes"  , replace : r1
xi: reg    UrbanShare1893 MSMSD area     x AbsY    ,  cluster(Grid2)
estimates store r2
estadd local "Basecontrols"="Yes"  , replace : r2
xi: reg    Hierarchy1893 MSMSD   area     x AbsY   ,  cluster(Grid2)
estimates store r3
estadd local "Basecontrols"="Yes"  , replace : r3
xi: reg    UrbanShare1990  MSMSD area     x AbsY   ,  cluster(Grid2)
estimates store r4
estadd local "Basecontrols"="Yes"  , replace : r4
xi: reg    ManufacturingShare1990  MSMSD  area     x AbsY    ,  cluster(Grid2)
estimates store r5
estadd local "Basecontrols"="Yes"  , replace : r5
xi: reg    UrbanShare2010  MSMSD  area     x AbsY    ,  cluster(Grid2)
estimates store r6
estadd local "Basecontrols"="Yes"  , replace : r6	

esttab  r* ///
	using "TableC17rob_6.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" x "Longitude" AbsY "Abs latitude")  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))	

*++++++++++++++++++	
*** Base controls without  X	Aby
*++++++++++++++++++
				
xi: reg    Seats1893 MSMSD   area  temperature  tempSQ  ,  cluster(Grid2)
estimates store q1
estadd local "Basecontrols"="Yes"  , replace : q1
xi: reg    UrbanShare1893 MSMSD area  temperature  tempSQ   ,  cluster(Grid2)
estimates store q2
estadd local "Basecontrols"="Yes"  , replace : q2
xi: reg    Hierarchy1893 MSMSD  area  temperature  tempSQ   ,  cluster(Grid2)
estimates store q3
estadd local "Basecontrols"="Yes"  , replace : q3
xi: reg    UrbanShare1990  MSMSD area  temperature  tempSQ   ,  cluster(Grid2)
estimates store q4
estadd local "Basecontrols"="Yes"  , replace : q4
xi: reg    ManufacturingShare1990  MSMSD  area  temperature  tempSQ   ,  cluster(Grid2)
estimates store q5
estadd local "Basecontrols"="Yes"  , replace : q5
xi: reg    UrbanShare2010  MSMSD  area  temperature  tempSQ    ,  cluster(Grid2)
estimates store q6
estadd local "Basecontrols"="Yes"  , replace : q6


esttab  q* ///
	using "TableC17rob_7.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" )  ///		
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))
				
		


*************************************************************************************
*Table 3: Malaria Suitability and Qualitative Features of Administrative Seats in 1893
*************************************************************************************
*load pixel-level cross-section dataset

** Two coefficients not identical

use SouthChinaPixelLevelMain, clear

estimates drop _all

global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   i.RiverB     i.ClimateZoneGroup  i.Macro

xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2) // 7 values
estimates store a1
estadd local "Allcontrols"="Yes"  , replace : a1
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2) // This seems to be in percentage rather than share
estimates store a2
estadd local "Allcontrols"="Yes"  , replace : a2
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2) // 4 values -  ordered logit
estimates store a3
estadd local "Allcontrols"="Yes"  , replace : a3
*xi: reg    UrbanShare1893 Seats1893    $CrossSection   ,  cluster(Grid2)
*estimates store a4
*estadd local "Allcontrols"="Yes"  , replace : a4

esttab  a* ///
	using "Table3rob_1.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))
	
	
*************************************************************************************
* Robustness
*************************************************************************************				

*+++++++++++++++++++
* No controls
*++++++++++++++++++

xi: reg    Seats1893 MSMSD        ,  cluster(Grid2) // variable is in percentage
estimates store b1
xi: reg   UrbanShare1893 MSMSD      ,  cluster(Grid2)  // variable is in percentage
estimates store b2
xi: reg    Hierarchy1893 MSMSD     ,  cluster(Grid2) // variable is in percentage
estimates store b3

esttab  b* ///
	using "Table3rob_2.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))				

	
*+++++++++++++++++++
* Elevation only
*++++++++++++++++++	
				
xi: reg    Seats1893 MSMSD   elev	,  cluster(Grid2) // variable is in percentage
estimates store c1
xi: reg    UrbanShare1893  MSMSD      elev 	  ,  cluster(Grid2)  // variable is in percentage
estimates store c2
xi: reg    Hierarchy1893  MSMSD    elev 	,  cluster(Grid2) // variable is in percentage
estimates store c3


esttab  c* ///
	using "Table3rob_3.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( elev "Elevation" )  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))
				

								
*+++++++++++++++++++
* Elevation only - log
*++++++++++++++++++

ge lelev = ln(elev)	

pwcorr 	MSMSD	lelev

xi: reg     Seats1893 MSMSD    lelev  	,  cluster(Grid2) // variable is in percentage
estimates store d1
xi: reg    UrbanShare1893  MSMSD      lelev 	   ,  cluster(Grid2)  // variable is in percentage
estimates store d2
xi: reg    Hierarchy1893  MSMSD    lelev 	,  cluster(Grid2) // variable is in percentage
estimates store d3

esttab  d* ///
	using "Table3rob_4.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( lelev "Elevation (log)" )  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))

*++++++++++++++++++	
*** Original results with base controls
*++++++++++++++++++						
				
xi: reg     Seats1893 MSMSD    area  temperature  tempSQ x AbsY	,  cluster(Grid2) // variable is in percentage
estimates store e1
estadd local "Basecontrols"="Yes"  , replace : e1
xi: reg    UrbanShare1893  MSMSD    area  temperature  tempSQ x AbsY	  ,  cluster(Grid2)  // variable is in percentage
estimates store e2
estadd local "Basecontrols"="Yes"  , replace : e2
xi: reg    Hierarchy1893  MSMSD   area  temperature  tempSQ x AbsY	,  cluster(Grid2) // variable is in percentage
estimates store e3
estadd local "Basecontrols"="Yes"  , replace : e3

esttab  e* ///
	using "Table3rob_5.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" x "Longitude" AbsY "Abs latitude")  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats( Basecontrols N ,label( "Base Controls" "Observations"  ))	

*++++++++++++++++++
*** Base controls without temperature and temperature SQ	
*++++++++++++++++++							
				
xi: reg    Seats1893 MSMSD  area     x AbsY ,  cluster(Grid2) // variable is in percentage
estimates store f1
xi: reg    UrbanShare1893  MSMSD   area     x AbsY  ,  cluster(Grid2)  // variable is in percentage
estimates store f2
xi: reg    Hierarchy1893  MSMSD   area     x AbsY ,  cluster(Grid2) // variable is in percentage
estimates store f3

esttab  f* ///
	using "Table3rob_6.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" x "Longitude" AbsY "Abs latitude")  ///	
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label(  "Observations"  ))	

*++++++++++++++++++	
*** Base controls without  X	Aby
*++++++++++++++++++
				
xi: reg     Seats1893 MSMSD   area  temperature  tempSQ 	,  cluster(Grid2) // variable is in percentage
estimates store g1
xi: reg    UrbanShare1893  MSMSD   area  temperature  tempSQ 	  ,  cluster(Grid2)  // variable is in percentage
estimates store g2
xi: reg    Hierarchy1893  MSMSD   area  temperature  tempSQ 	,  cluster(Grid2) // variable is in percentage
estimates store g3


esttab  g* ///
	using "Table3rob_7.tex" ///	
	,nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	drop(_cons)  ///
	coeflabels( area "Area" temperature "Temperature" tempSQ "Temperature sq" )  ///		
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///		
	stats(  N ,label( "Observations"  ))
				
		

*++++++++++++++++++	
*** Logs of dependent variable
*++++++++++++++++++		
		
local yvar " Seats1893   UrbanShare1893 Hierarchy1893"	
	
foreach i of local 	yvar{
	ge l`i' = ln(`i')
}
	
xi: reg    lSeats1893 MSMSD     $CrossSection   	,  cluster(Grid2) // variable is in percentage
estimates store k1
estadd local "Allcontrols"="Yes"  , replace : k1
xi: reg    lUrbanShare1893  MSMSD       $CrossSection  	   ,  cluster(Grid2)  // variable is in percentage
estimates store k2
estadd local "Allcontrols"="Yes"  , replace : k2
xi: reg    lHierarchy1893  MSMSD   $CrossSection  	,  cluster(Grid2) // variable is in percentage
estimates store k3
estadd local "Allcontrols"="Yes"  , replace : k3

esttab  k* ///
	using "Table3rob_8.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))
		
		
	
local yvar " Seats1893   UrbanShare1893 Hierarchy1893"	
foreach i of local 	yvar{
	sum `i', det
	ge tr_`i' = `i'
	replace tr_`i' = . if `i' > r(p95)
	replace tr_`i' = . if `i' < r(p5)	
}
		
twoway (kdensity UrbanShare1893) (kdensity tr_UrbanShare1893)	 
	
	

*++++++++++++++++++	
*** Winsorizing
*++++++++++++++++++		
	
xi: reg    tr_Seats1893 MSMSD     $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store h1
estadd local "Allcontrols"="Yes"  , replace : h1
xi: reg    tr_UrbanShare1893  MSMSD    $CrossSection   ,  cluster(Grid2)  // variable is in percentage
estimates store h2
estadd local "Allcontrols"="Yes"  , replace : h2
xi: reg    tr_Hierarchy1893  MSMSD    $CrossSection   ,  cluster(Grid2) // variable is in percentage
estimates store h3
estadd local "Allcontrols"="Yes"  , replace : h3

esttab  h* ///
	using "Table3rob_9.tex" ///	
	, nogap fragment eqlabels(none)  nomtitles  replace  star(* 0.1 ** 0.05 *** 0.01) nonotes ///
	keep(MSMSD) ///
	nolines nonumbers ///
	substitute("\sym{*}" "*" "\sym{**}" "**" "\sym{***}" "***") ///	
	stats( Allcontrols N ,label( "All Controls" "Observations"  ))
	
