if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, data.table, dplyr, ggplot2, fixest, texreg, kableExtra, broom, glue, modelsummary)


# load the panel data
panel_data <- haven::read_dta(here("data", "raw", "PanelSouthChina.dta")) |> as.data.table()

# figure 2, table C.1 panel A
# Variables present:
# Seats, MSMSD, year, Grid2,
# area, Yangtze, Yellow, Pearl, AbsY, elev, x, AgriIndexSD, distchinacoast,
# strahler, precipitation, temperature, tempSQ, precSQ, temp_x_prec,
# RiverB, ClimateZoneGroup, Macro

# ----- Controls (CrossSection) -----
cross_controls <- c(
  "area","Yangtze","Yellow","Pearl","AbsY","elev","x",
  "AgriIndexSD","distchinacoast","strahler",
  "precipitation","temperature","tempSQ","precSQ","temp_x_prec"
)

# Factor/dummy sets like Stata's i.
factor_terms <- c("i(RiverBasin)", "i(ClimateZoneGroup)", "i(MacroAll)")

rhs <- paste(c("MSMSD", cross_controls, factor_terms), collapse = " + ")
fmla <- as.formula(paste("Seats ~", rhs))

# ----- Helper to run one clustered cross-section -----
fit_one_year <- function(y) {
  feols(fmla, data = panel_data[year == y], cluster = ~ Grid2)
}

# Base model at year == -200 (BCE 200)
m_base <- fit_one_year(-200)

# Models for -100, 0, 100, ..., 1900
years_seq <- seq(-100, 1900, by = 100)

# Build named list of models (no purrr)
models <- c(list(`-200` = m_base),
            setNames(lapply(years_seq, fit_one_year),
                     as.character(years_seq)))

# ----- (A) Extract MSMSD into a tidy table -----
tidy_list <- lapply(names(models), function(nm) {
  m <- models[[nm]]
  tt <- tidy(m, conf.int = TRUE, conf.level = 0.90, vcov = ~ Grid2)
  tt[tt$term == "MSMSD", c("estimate","std.error","conf.low","conf.high","p.value")]
})

msmsd_tbl <- rbindlist(tidy_list, use.names = TRUE)
msmsd_tbl[, year := as.integer(names(models))]
setcolorder(msmsd_tbl, c("year","estimate","std.error","conf.low","conf.high","p.value"))
setorder(msmsd_tbl, year)

# Pretty table (kableExtra), mirroring keep(MSMSD)
msmsd_tbl_print <- copy(msmsd_tbl)[
  , `:=`(
    year_label = ifelse(year < 0, paste0(abs(year), " BCE"), paste0(year, " CE")),
    estimate   = round(estimate, 3),
    std.error  = round(std.error, 3),
    conf.low   = round(conf.low, 3),
    conf.high  = round(conf.high, 3),
    p.value    = signif(p.value, 3)
  )
][, .(Year = year_label,
      `MSMSD β` = estimate,
      SE = std.error,
      `95% CI Low` = conf.low,
      `95% CI High` = conf.high,
      `p-value` = p.value)]

msmsd_tbl_print %>%
  kable(format = "latex", booktabs = TRUE, linesep = "", digits = 3,
        format.args = list(scientific = FALSE)) |> 
        save_kable(here("output", "tables", "author_table_c1_a.tex"))

# ----- (B) Multi-model regression table (texreg) -----
model_names <- paste0(ifelse(as.integer(names(models)) < 0,
                             paste0(abs(as.integer(names(models))), " BCE"),
                             paste0(as.integer(names(models)), " CE")))
screenreg(unname(models),
          custom.model.names = model_names,
          stars = c(0.01, 0.05, 0.1))


# ----- (C) Plot MSMSD coefficient over time -----
ggplot(msmsd_tbl, aes(x = year, y = estimate)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 20) +
  scale_x_continuous(
    breaks = msmsd_tbl$year,
    labels = ifelse(msmsd_tbl$year < 0,
                    paste0(abs(msmsd_tbl$year), " BCE"),
                    paste0(msmsd_tbl$year, " CE"))
  ) +
  labs(x = "Year", y = "MSMSD coefficient (β)",
       title = "Effect of MSMSD on Seats over time (90% CI, clustered by 2x2 degree grid)") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# save the plot
ggsave(here("output", "figures", "author_fig2.png"), width = 10, height = 6)


## load data for table 3 and 4
pixel_data <- haven::read_dta(here("data", "raw", "SouthChinaPixelLevelMain.dta")) |> as.data.table()

cross_controls <- c(
  "area","Yangtze","Yellow","Pearl","AbsY","elev","x",
  "AgriIndexSD","distchinacoast","strahler",
  "precipitation","temperature","tempSQ","precSQ","temp_x_prec"
)


## Table 3


# Factor/dummy sets like Stata's i.
factor_terms <- c("i(RiverBasin)", "i(ClimateZoneGroup)", "i(MacroAll)")

# table 3
rhs <- paste(c("MSMSD", cross_controls, factor_terms), collapse = " + ")
rhs2 <- paste(c(cross_controls, factor_terms), collapse = " + ")
fmla1 <- as.formula(paste("Seats1893 ~", rhs))
fmla2 <- as.formula(paste("UrbanShare1893 ~", rhs))
fmla3 <- as.formula(paste("Hierarchy1893 ~", rhs))
fmla4 <- as.formula(paste("UrbanShare1893 ~ Seats1893 +", rhs2))

m1 <- feols(fmla1, data = pixel_data, cluster = ~ Grid2)
m2 <- feols(fmla2, data = pixel_data, cluster = ~ Grid2)
m3 <- feols(fmla3, data = pixel_data, cluster = ~ Grid2)
m4 <- feols(fmla4, data = pixel_data, cluster = ~ Grid2)

# save the table
texreg(list(m1, m2, m3, m4), stars = c(0.01, 0.05, 0.1), digits = 3, 
       custom.model.names = c("Number of seats 1893", "Urban population 1893", "Hierarchy level 1893", "Urban population 1893"),
       booktabs = TRUE, linesep = "",
       format.args = list(scientific = FALSE),
       custom.coef.map = list("MSMSD" = "MSM (SD)", "Seats1893" = "Number of seats 1893"),
       use.packages = FALSE,
       table = FALSE,
       file = here("output", "tables", "author_table3.tex"))


## Table 4

# table 4
fmla5 <- as.formula(paste("UrbanShare1990 ~", rhs))
fmla6 <- as.formula(paste("UrbanShare2010 ~", rhs))
fmla7 <- as.formula(paste("ManufacturingShare1990 ~", rhs))
m5 <- feols(fmla5, data = pixel_data, cluster = ~ Grid2)
m6 <- feols(fmla6, data = pixel_data, cluster = ~ Grid2)
m7 <- feols(fmla7, data = pixel_data, cluster = ~ Grid2)

# save the table
texreg(list(m5, m6, m7), stars = c(0.01, 0.05, 0.1), digits = 3, 
       custom.model.names = c("Urban population 1990", "Urban population 2010", "Manufacturing employment 1990"),
       booktabs = TRUE, linesep = "",
       format.args = list(scientific = FALSE),
       custom.coef.map = list("MSMSD" = "MSM (SD)"),
       use.packages = FALSE,
       table = FALSE,
       file = here("output", "tables", "author_table4.tex"))


## Table 5


## load data for table 5
county_data <- haven::read_dta(here("data", "raw", "CountyLevelDataset.dta")) |> as.data.table()


cross_controls <- c(
  "yCenter","Yangtze","Yellow","Pearl", "distchinacoast", "strahler", "elev_cropped", "agri_suitR", "pre_mean", "temp_mean", "tempSQ","precSQ","temp_x_prec"
)

# Factor/dummy sets like Stata's i.
factor_terms <- c("i(ARiverBasin)", "i(ClimateZoneGroup)", "i(MacroZone)")

rhs <- paste(c("MSMSD", cross_controls, factor_terms), collapse = " + ")
fmla1 <- as.formula(paste("ShareUrban ~", rhs))
fmla2 <- as.formula(paste("IndustryShare ~", rhs))
fmla3 <- as.formula(paste("LNManuOutputPC ~", rhs))
fmla4 <- as.formula(paste("LNIncomePC ~", rhs))
fmla5 <- as.formula(paste("HanShare ~", rhs))
fmla6 <- as.formula(paste("NaturalRateIncrease ~", rhs))
fmla7 <- as.formula(paste("ChildShare ~", rhs))
fmla8 <- as.formula(paste("InMigrationShare ~", rhs))

m1 <- feols(fmla1, data = county_data, cluster = ~ Grid2)
m2 <- feols(fmla2, data = county_data, cluster = ~ Grid2)
m3 <- feols(fmla3, data = county_data, cluster = ~ Grid2)
m4 <- feols(fmla4, data = county_data, cluster = ~ Grid2)
m5 <- feols(fmla5, data = county_data, cluster = ~ Grid2)
m6 <- feols(fmla6, data = county_data, cluster = ~ Grid2)
m7 <- feols(fmla7, data = county_data, cluster = ~ Grid2)
m8 <- feols(fmla8, data = county_data, cluster = ~ Grid2)

# save the table
texreg(list(m1, m2, m3, m4, m5, m6, m7, m8), stars = c(0.01, 0.05, 0.1), digits = 3,
       custom.model.names = c("Urban share", "Industry share", "Log manufacturing output per capita", "Log income per capita", "Han share", "Natural rate of increase", "Child share", "In-migration share"),
       booktabs = TRUE, linesep = "",
       format.args = list(scientific = FALSE),
       custom.coef.map = list("MSMSD" = "MSM (SD)"),
       use.packages = FALSE,
       table = FALSE,
       file = here("output", "tables", "author_table5.tex"))
