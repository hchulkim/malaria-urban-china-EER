if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, data.table, dplyr, ggplot2, fixest, texreg, kableExtra, broom, glue, modelsummary)


# load the panel data
panel_data <- haven::read_dta(here("data", "raw", "PanelSouthChina.dta")) |> as.data.table()

# create ggplot of number of 0.5 grids within a 2x2 degree grid
panel_data[, .(n = .N), by = .(Grid2, year)] |> 
#histogram of n
  ggplot(aes(x = n, fill = as.factor(year))) +
  geom_histogram(binwidth = 1) +
  scale_x_continuous(breaks = seq(0, 16, by = 1)) +
  scale_fill_discrete(name = "Year") +
  labs(x = "Number of 0.5 degree grids within a 2x2 degree grid", y = "Count", title = "Histogram of number of 0.5 degree grids within a 2x2 degree grid") +
  theme_bw(base_size = 12)

# save the plot
ggsave(here("output", "figures", "grid_count_histogram.png"), width = 10, height = 6)
