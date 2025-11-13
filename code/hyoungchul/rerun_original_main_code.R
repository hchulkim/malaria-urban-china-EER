if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, data.table, dplyr, ggplot2, fixest, texreg, kableExtra, broom, glue, modelsummary)


# load the data

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
  tt <- tidy(m, conf.int = TRUE, vcov = ~ Grid2)
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
  kable(format = "html",
        caption = "Cross-section regressions of Seats on MSMSD (clustered by Grid2)") %>%
  kable_styling(full_width = FALSE)

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
       title = "Effect of MSMSD on Seats over time (95% CI, clustered by Grid2)") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# save the plot
ggsave(here("output", "figures", "author_fig2.png"), width = 10, height = 6)
