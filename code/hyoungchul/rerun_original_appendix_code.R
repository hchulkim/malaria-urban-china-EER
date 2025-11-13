
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, data.table, dplyr, ggplot2, fixest, texreg, kableExtra, broom, glue, modelsummary)

# Load Mann et al. (2009) dataset
mann <- haven::read_dta(here("data", "raw", "MannEtAl2009Data.dta")) |> as.data.table()


year = seq(500, 1800, by = 100)

plot_coef <- function(year_ref) {
  res <- feols(MSMMannRelative ~ MSMRelative,
        data = mann[year == year_ref]) |> tidy(conf.int = TRUE, conf.level = 0.90) |> as.data.table()
    return(res[term == "MSMRelative", .(year = as.integer(year_ref), estimate, std.error, conf.low, conf.high, p.value)])
}

coef_tbl <- rbindlist(lapply(year, plot_coef))

ggplot(coef_tbl, aes(x = year, y = estimate)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high)) +
  scale_x_continuous(breaks = year) + 
  scale_y_continuous(breaks = c(0.6, 0.8, 1.0, 1.2, 1.4), limits = c(0.6, 1.4)) +
  labs(x = "Year", y = "MSMRelative coefficient (β)",
       title = "Effect of MSMRelative on MSMMannRelative (90% CI, robust)") +
  theme_bw(base_size = 12)

# save the plot
ggsave(here("output", "figures", "author_appendix_fig_a2.png"), width = 10, height = 6)



### table B.1.

county_data <- haven::read_dta(here("data", "raw", "CountyLevelDataset.dta")) |> as.data.table()

datasummary(ShareUrban + IndustryShare + LNManuOutputPC + LNIncomePC + HanShare + NaturalRateIncrease + ChildShare + InMigrationShare + MSMSD ~ Mean + SD + Min + Max + N, data = county_data,
  output = "latex", booktabs = TRUE, linesep = "", digits = 3,  
  format.args = list(scientific = FALSE),
  rename = c("ShareUrban" = "Urban share", "IndustryShare" = "Industry share", "LNManuOutputPC" = "Log manufacturing output per capita", "LNIncomePC" = "Log income per capita", "HanShare" = "Han share", "NaturalRateIncrease" = "Natural rate of increase", "ChildShare" = "Child share", "InMigrationShare" = "In-migration share", "MSMSD" = "Malaria suitability(SD)"),
  file = here("output", "tables", "author_appendix_table_b1.tex"))






### table C.11 conley standard errors

pixel_data <- haven::read_dta(here("data", "raw", "SouthChinaPixelLevelMain.dta")) |> as.data.table()




cross_controls <- c(
  "area","Yangtze","Yellow","Pearl","AbsY","elev","x",
  "AgriIndexSD","distchinacoast","strahler",
  "precipitation","temperature","tempSQ","precSQ","temp_x_prec"
)

# Factor/dummy sets like Stata's i.
factor_terms <- c("i(RiverBasin)", "i(ClimateZoneGroup)", "i(MacroAll)")
rhs <- paste(c("MSMSD", cross_controls, factor_terms), collapse = " + ")
fmla1 <- as.formula(paste("Seats1893 ~", rhs))
fmla2 <- as.formula(paste("UrbanShare1893 ~", rhs))
fmla3 <- as.formula(paste("Hierarchy1893 ~", rhs))
fmla4 <- as.formula(paste("UrbanShare1990 ~", rhs))
fmla5 <- as.formula(paste("ManufacturingShare1990 ~", rhs))
fmla6 <- as.formula(paste("UrbanShare2010 ~", rhs))

# table
res1 <- feols(fmla1, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 100))
res2 <- feols(fmla2, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 100))
res3 <- feols(fmla3, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 100))
res4 <- feols(fmla4, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 100))
res5 <- feols(fmla5, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 100))
res6 <- feols(fmla6, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 100))

texreg(list(res1, res2, res3, res4, res5, res6), digits = 3, file = here("output", "tables", "author_appendix_table_c11.tex"))

res1 <- feols(fmla1, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 200))
res2 <- feols(fmla2, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 200))
res3 <- feols(fmla3, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 200))
res4 <- feols(fmla4, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 200))
res5 <- feols(fmla5, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 200))
res6 <- feols(fmla6, data = pixel_data, vcov = vcov_conley(lat = "y", lon = "x", cutoff = 200))

texreg(list(res1, res2, res3, res4, res5, res6), digits = 3, file = here("output", "tables", "author_appendix_table_c11_200.tex"))
