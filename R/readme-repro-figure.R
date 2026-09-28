# Data/code availability and reproducibility by README availability
# Source: Brodeur, Abdul Baki, & Fazio (2026), Table 9
# Output: images/readme_repro.png
#
# Run from the project root:  Rscript R/readme-repro-figure.R

library(ggplot2)
library(tidyr)
suppressMessages(library(dplyr))

# Conditional percentages within each README group (rows sum to 100)
tab9 <- tribble(
  ~readme,   ~outcome,                           ~Fully, ~Partially, ~No,
  "none",    "Raw data",                         36.364, 22.727, 40.909,
  "none",    "Analysis data",                    72.727, 22.727,  4.545,
  "none",    "Cleaning code",                    36.364, 22.727, 40.909,
  "none",    "Analysis code",                    59.091, 31.818,  9.091,
  "none",    "Reproducible from raw data",       27.273, 27.273, 45.455,
  "none",    "Reproducible from analysis data",  50.000, 45.455,  4.545,
  "clear",   "Raw data",                         56.250, 18.750, 25.000,
  "clear",   "Analysis data",                    81.250, 12.500,  6.250,
  "clear",   "Cleaning code",                    50.000, 18.750, 31.250,
  "clear",   "Analysis code",                    81.250, 12.500,  6.250,
  "clear",   "Reproducible from raw data",       31.250, 37.500, 31.250,
  "clear",   "Reproducible from analysis data",  87.500,  6.250,  6.250,
  "unclear", "Raw data",                         48.276, 31.034, 20.690,
  "unclear", "Analysis data",                    72.414, 17.241, 10.345,
  "unclear", "Cleaning code",                    51.724, 27.586, 20.690,
  "unclear", "Analysis code",                    72.414, 27.586,  0.000,
  "unclear", "Reproducible from raw data",       27.586, 37.931, 34.483,
  "unclear", "Reproducible from analysis data",  48.276, 37.931, 13.793
)

readme_labels <- c(
  none    = "A: No README (n = 22)",
  clear   = "B: Clear README (n = 16)",
  unclear = "C: Unclear README (n = 29)"
)

plot_df <- tab9 |>
  pivot_longer(Fully:No, names_to = "status", values_to = "pct") |>
  mutate(
    status  = factor(status, levels = c("Fully", "Partially", "No")),
    readme  = factor(readme_labels[readme], levels = readme_labels),
    # first level plots at the bottom, so reverse to read top-down
    outcome = factor(outcome, levels = rev(unique(tab9$outcome))),
    label   = ifelse(pct >= 10, paste0(floor(pct + 0.5), "%"), "")
  )

# Box the two reproducibility rows in Panel B (clear README):
# 88% from analysis data vs. 31% from raw data
highlight_box <- tibble(
  readme = factor(readme_labels["clear"], levels = readme_labels),
  xmin = -1.5, xmax = 101.5, ymin = 0.5, ymax = 2.5
)

bc_colors <- c(Fully = "#98002E", Partially = "#BC9B6A", No = "#D9D9D9")
label_ink <- c(Fully = "white", Partially = "#1A1A1A", No = "#1A1A1A")

p <- ggplot(plot_df, aes(x = pct, y = outcome, fill = status)) +
  geom_col(
    position = position_stack(reverse = TRUE),
    width = 0.72, color = "white", linewidth = 0.6
  ) +
  geom_text(
    aes(label = label, color = status),
    position = position_stack(vjust = 0.5, reverse = TRUE),
    size = 3.6, fontface = "bold", show.legend = FALSE
  ) +
  geom_rect(
    data = highlight_box, inherit.aes = FALSE,
    aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
    fill = NA, color = "#dc1428", linewidth = 1.6
  ) +
  facet_wrap(~readme, ncol = 3) +
  coord_cartesian(clip = "off") +
  scale_fill_manual(values = bc_colors, name = NULL) +
  scale_color_manual(values = label_ink, guide = "none") +
  # every bar sums to 100% and segments are labeled, so no x-axis needed
  scale_x_continuous(expand = c(0, 0), breaks = NULL) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 16, base_family = "Helvetica") +
  theme(
    legend.position    = "top",
    legend.justification = "left",
    legend.key.size    = unit(0.5, "cm"),
    strip.text         = element_text(face = "bold", hjust = 0, size = 15),
    axis.text.y        = element_text(color = "#1A1A1A"),
    panel.grid         = element_blank(),
    panel.spacing.x    = unit(0.8, "cm"),
    plot.margin        = margin(10, 30, 10, 10),
    plot.background    = element_rect(fill = "white", color = NA)
  )

ggsave("images/readme_repro.png", p,
       width = 13, height = 5.5, dpi = 300, device = ragg::agg_png)
