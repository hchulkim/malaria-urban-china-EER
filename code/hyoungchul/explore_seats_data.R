if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, data.table, dplyr, ggplot2, fixest, texreg, kableExtra, broom, glue, modelsummary)


# load the panel data
panel_data <- haven::read_dta(here("data", "raw", "PanelSouthChina.dta")) |> as.data.table()


# plot histogram
ggplot(panel_data, aes(x = Seats)) +
  geom_histogram(binwidth = 1) +
  labs(x = "Seats", y = "Count") +
  theme_bw(base_size = 12)

# save the plot
ggsave(here("output", "figures", "author_appendix_fig_a1.png"), width = 10, height = 6)



# plot histogram of Seats by year

seat_dup <- panel_data[year == -200][, .(n = .N), by = .(Seats)][order(Seats)]
