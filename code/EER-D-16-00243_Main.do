*set working directory


        ******************************
		*    Pixel-Level Analysis    *
        ******************************

*************************************************************************************
*Table 1: Descriptive Statistics Key Variables
*************************************************************************************
*load Pixel-level cross-section dataset
use SouthChinaPixelLevelMain, clear
sum UrbanShare1893 UrbanShare1990 UrbanShare2010 ManufacturingShare1990 MSMSD


*************************************************************************************
*Table 2: Correlation: Malaria Suitability, Malaria Prevalence and Population Density
*************************************************************************************
xi: reg    Prevalence1950  MSMSD   temperature  tempSQ area AbsY,  cluster(Grid2)
xi: reg    Prevalence1950  UrbanShare1893   temperature  tempSQ area AbsY,  cluster(Grid2)
xi: reg    Prevalence1950  UrbanShare1990   temperature  tempSQ area AbsY,  cluster(Grid2)
xi: reg    UrbanShare1893  MSMSD   temperature  tempSQ area AbsY,  cluster(Grid2)
xi: reg    UrbanShare1893  Prevalence1950   temperature  tempSQ area AbsY,  cluster(Grid2)


*************************************************************************************
*Figure 2 & Table C.1 PanelA
*************************************************************************************
*load Panel Data
use PanelSouthChina, clear

* set of control variables
global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   i.RiverB     i.ClimateZoneGroup  i.Macro

*Run cross-section regressions for years 200 BCE - 1900 CE
xi: reg   Seats  MSMSD    $CrossSection    if  year==-200, cluster(Grid2)
outreg2   using "PanelSouthChinaMain.xls", replace se nocons dec(3) keep(MSMSD) 
forvalues y =-100(100)1900{
	xi: reg   Seats  MSMSD    $CrossSection    if year==`y', cluster(Grid2)
	outreg2   using "PanelSouthChinaMain.xls", append se nocons dec(3) keep(MSMSD) 
	}
	
	
	

	

*************************************************************************************
*Table 3: Malaria Suitability and Qualitative Features of Administrative Seats in 1893
*************************************************************************************
*load pixel-level cross-section dataset
use SouthChinaPixelLevelMain, clear
global CrossSection area      Yangtze Yellow Pearl AbsY  elev     x  AgriIndexSD    distchinacoast strahler  precipitation temperature  tempSQ precSQ temp_x_prec   i.RiverB     i.ClimateZoneGroup  i.Macro

xi: reg    Seats1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    Hierarchy1893 MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare1893 Seats1893    $CrossSection   ,  cluster(Grid2)


*************************************************************************************
*Table 4: Malaria Suitability, Urbanization and Industrial Activity
*************************************************************************************
xi: reg    UrbanShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    UrbanShare2010  MSMSD    $CrossSection   ,  cluster(Grid2)
xi: reg    ManufacturingShare1990  MSMSD    $CrossSection   ,  cluster(Grid2)

*************************************************************************************



        ******************************
		*    County-Level Analysis   *
        ******************************
		
*************************************************************************************
*Table 5: Malaria Suitability and Disparities at the County Level (1990)	
*************************************************************************************
*load county-level cross-section dataset
use CountyLevelDataset, clear
global CrossSection   yCenter  Yangtze Yellow Pearl   distchinacoast    strahler  elev_cropped  agri_suitR    pre_mean temp_mean  tempSQ precSQ  temp_x_prec    i.MacroZone  i.ClimateZoneGroup i.ARiverBasin

xi: reg    ShareUrban MSMSD     $CrossSection    ,  cluster(Grid2)
xi: reg    IndustryShare MSMSD     $CrossSection    ,  cluster(Grid2)
xi: reg    LNManuOutputPC MSMSD     $CrossSection    ,  cluster(Grid2) 
xi: reg    LNIncomePC MSMSD     $CrossSection    ,  cluster(Grid2) 
xi: reg    HanShare MSMSD     $CrossSection    ,  cluster(Grid2) 
xi: reg    NaturalRateIncrease MSMSD     $CrossSection    ,  cluster(Grid2) 
xi: reg    ChildShare MSMSD     $CrossSection    ,  cluster(Grid2)
xi: reg    InMigrationShare MSMSD     $CrossSection    ,  cluster(Grid2)



