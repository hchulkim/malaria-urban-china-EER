*set working directory
*cd

        ******************************
		*         Appendices         *
        ******************************
		


*************************************************************************************
*Appendix A
*************************************************************************************
*Figure A.2
************
*load Mann et al. 2009 data
use MannEtAl2009Data, clear

*run cross-section regressions 500 CE- 1800C E
xi: reg     MSMMannRelative  MSMRelative   if  year==500, robust level(90)
outreg2   using "MannDataStability.xls", replace ci level(90) nocons dec(3) keep(MSMRelative) 
forvalues y =600(100)1800{
	xi: reg     MSMMannRelative  MSMRelative   if  year==`y', robust level(90)
	outreg2   using "MannDataStability.xls", append ci level(90) nocons dec(3) keep(MSMRelative) 
		}

		
*************************************************************************************
*Appendix B
*************************************************************************************
*Table B.1: Descriptive Statistics County-Level Variables
************
use CountyLevelDataset, clear
sum ShareUrban IndustryShare LNManuOutputPC LNIncomePC HanShare NaturalRateIncrease ChildShare InMigrationShare MSMSD


*************************************************************************************
*Appendix C
*************************************************************************************
*Table C.1: Malaria Effect 200 BCE - 1900 CE.
************

*Regressions of Panel A correspond to Figure 2 and are provided in "SouthChinaRegressionsMainPart.do"
use PanelPooledChina, clear
global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   i.RiverB     i.ClimateZoneGroup  i.Macro

*Panel B: Pooled
xi: reg    Seats  MSMSD    $CrossSection    if  year==-200, cluster(Grid2)
outreg2   using "PooledPanel.xls", replace se nocons dec(3) keep(MSMSD) 
forvalues y =-100(100)1900{
	xi: reg    Seats  MSMSD    $CrossSection    if year==`y', cluster(Grid2)
	outreg2   using "PooledPanel.xls", append se nocons dec(3) keep(MSMSD) 
		
	}

*Panel C: Restrict to North China
keep if SouthChina==0
drop MSMSD
egen MSMSD=std(MSM)
xi: reg    Seats  MSMSD    $CrossSection    if  year==-200, cluster(Grid2)
outreg2   using "NorthPanel.xls", replace se nocons dec(3) keep(MSMSD) 
forvalues y =-100(100)1900{
	xi: reg    Seats  MSMSD    $CrossSection    if year==`y', cluster(Grid2)
	outreg2   using "NorthPanel.xls", append se nocons dec(3) keep(MSMSD) 
		
	}


************
*Table C.2: Malaria Effect in South China 200 BCE - 1900 CE: Successively Adding Controls
************
use PanelSouthChina, clear
*Choose either of the sets of control variables
global CrossSection area  temperature  tempSQ x AbsY

*climate controls
global CrossSection area  precipitation temperature  tempSQ precSQ temp_x_prec x AbsY 

*geographical controls
global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   


xi: reg    Seats  MSMSD    $CrossSection    if  year==-200, cluster(Grid2)
outreg2   using "ControlsVariationPanel.xls", replace se nocons dec(3) keep(MSMSD) 
forvalues y =-100(100)1900{
	xi: reg    Seats  MSMSD    $CrossSection    if year==`y', cluster(Grid2)
	outreg2   using "ControlsVariationPanel.xls", append se nocons dec(3) keep(MSMSD) 
		
	}
	
	
************
*Table C.3: Malaria Suitability Effect on Level of Hierarchy: Ordered Logit
************
use SouthChinaPixelLevelMain, clear
global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   i.RiverB     i.ClimateZoneGroup  i.Macro

xi: ologit     Hierarchy1893 MSMSD   $CrossSection   ,  cluster(Grid2)
xi: reg    ShareHYDE MSMSD    $CrossSection   ,  cluster(Grid2)

************
*Table C.4 - C.8: Additional controls
************
*define either of following variables as additional controls:
*WheatSuitability
*RiceSuitability
*TeaSuitability
*i.SoilSuitabilty
*i.GeoRegions 

global Additional WheatSuitability

xi: reg    Seats1893 MSMSD    $CrossSection  $Additional ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $CrossSection $Additional  ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $CrossSection  $Additional ,  cluster(Grid2)
xi: reg    UrbanShare1990  MSMSD    $CrossSection  $Additional ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection  $Additional ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $CrossSection  $Additional ,  cluster(Grid2)


************
*Table C.9: Robustness Alternative Malaria Suitability Measure: Gething et al. (2011)
************
xi: reg    Seats1893 GethingSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 GethingSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 GethingSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1990  GethingSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  GethingSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  GethingSD    $CrossSection   ,  cluster(Grid2)



************
*Table C.10: Robustness Alternative Malaria Suitability Measure: Mordecai et al. (2013)
************
xi: reg    Seats1893 MordecaiSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MordecaiSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MordecaiSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1990  MordecaiSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MordecaiSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MordecaiSD    $CrossSection   ,  cluster(Grid2)


************
*Table C.11: Robustness Clustering Approaches
************
* Clustering at Province level
xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Admin1)
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Admin1)
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Admin1)
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Admin1)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Admin1)
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Admin1)

*run Conley script
run x_ols
* partial out controls, then run x_ols

xi: reg     MSMSD    $CrossSection   ,  cluster(Admin1)
predict resMSMSD, res

xi: reg    Seats1893     $CrossSection   ,  cluster(Admin1)
predict resSeats1893, res

xi: reg    UrbanShare1893     $CrossSection   ,  cluster(Admin1)
predict resUrbanShare1893,res

xi: reg    Hierarchy1893     $CrossSection   ,  cluster(Admin1)
predict resHierarchy1893, res

xi: reg    UrbanShare1990      $CrossSection   ,  cluster(Admin1)
predict resUrbanShare1990, res

xi: reg    ManufacturingShare1990      $CrossSection   ,  cluster(Admin1)
predict resManufacturingShare1990, res

xi: reg    UrbanShare2010      $CrossSection   ,  cluster(Admin1)
predict resUrbanShare2010, res

gen const=1
gen cutoff1=2
gen cutoff2=2

*run regressions and compute conley standard errors (& write it into txt file)
log using "Conley.txt", replace text
x_ols x y cutoff1 cutoff2 resSeats1893 resMSMSD const, xreg(2) coord(2)
drop epsilon-dis2
x_ols x y cutoff1 cutoff2 resUrbanShare1893 resMSMSD const, xreg(2) coord(2)
drop epsilon-dis2
x_ols x y cutoff1 cutoff2 resHierarchy1893 resMSMSD const, xreg(2) coord(2)
drop epsilon-dis2
x_ols x y cutoff1 cutoff2 resUrbanShare1990 resMSMSD const, xreg(2) coord(2)
drop epsilon-dis2
x_ols x y cutoff1 cutoff2 resManufacturingShare1990 resMSMSD const, xreg(2) coord(2)
drop epsilon-dis2
x_ols x y cutoff1 cutoff2 resUrbanShare2010 resMSMSD const, xreg(2) coord(2)
drop epsilon-dis2
log close

************
*Table C.12: Robustness: Temperature Controls Only
************
global ClimateControls  area x  temperature  tempSQ  AbsY        
xi: reg    Seats1893 MSMSD    $ClimateControls   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $ClimateControls   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $ClimateControls   ,  cluster(Grid2)
xi: reg    UrbanShare1990  MSMSD    $ClimateControls   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $ClimateControls   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $ClimateControls   ,  cluster(Grid2)


************
*Table C.13: Robustness Time Interval Climate Data Construction: 1901 - 1925
************
use SouthChinaPixelLevel19011925, clear
global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   i.RiverB     i.ClimateZoneGroup  i.Macro
xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)

************
*Table C.14: Robustness Time Interval Climate Data Construction: 1926 - 1950
************
use SouthChinaPixelLevel19261950, clear
xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)

************
*Table C.15: Robustness Time Interval Climate Data Construction: 1951 - 1975
************
use SouthChinaPixelLevel19511975, clear
xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)

************
*Table C.16: Robustness Time Interval Climate Data Construction: 1976 - 2000
************
use SouthChinaPixelLevel19762000, clear
xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)

************
*Table C.17: Malaria Suitability Effects in North China
************
use NorthChinaPixelLevel, clear
xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)
