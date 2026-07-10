# Set working directory to the script's own folder (portable)
setwd(dirname(sys.frame(1)$ofile))

library(meta)
library(grid)
library(dplyr)
library(writexl)

datos <- read.csv("Data/Model-C-meta-table.csv")



meta_result_cog <- metagen(TE = logHR, seTE = SE, studlab = country, data = datos, sm = "HR", method.tau = "REML")

pdf("Figures/forest_plot_metagen_ModelC.pdf", width = 20, height = 25)

forest(meta_result_cog,
  colgap = unit(20, "mm"), # Adjust space between columns
  cex = 0.75,
  layout = "BMJ", xlim = c(0.5, 5)
)

dev.off()

summary(meta_result_cog)

total_weight_common <- sum(meta_result_cog$w.fixed)
total_weight_random <- sum(meta_result_cog$w.random)

# Extract information from the forest plot, including percentage weights
data_to_save <- data.frame(
  Study = meta_result_cog$studlab, # Study name
  logHR = meta_result_cog$TE, # logHR for each study
  SE_logHR = meta_result_cog$seTE, # SE of the logHR
  HR_fixed = exp(meta_result_cog$TE.fixed), # Hazard Ratio for fixed effect
  Lower_CI_fixed = exp(meta_result_cog$lower.fixed), # Lower CI limit for fixed effect
  Upper_CI_fixed = exp(meta_result_cog$upper.fixed), # Upper CI limit for fixed effect
  Weight_percent_fixed = (meta_result_cog$w.fixed / total_weight_common) * 100, # Fixed effect weight (%)
  HR_random = exp(meta_result_cog$TE.random), # Hazard Ratio for random effect
  Lower_CI_random = exp(meta_result_cog$lower.random), # Lower CI limit for random effect
  Upper_CI_random = exp(meta_result_cog$upper.random), # Upper CI limit for random effect
  Weight_percent_random = (meta_result_cog$w.random / total_weight_random) * 100 # Random effect weight (%)
)

# Add rows for overall fixed and random effects (without individual weights)
data_to_save <- rbind(
  data_to_save,
  data.frame(
    Study = "Global Effect Common",
    logHR = NA,
    SE_logHR = NA,
    HR_fixed = exp(meta_result_cog$TE.fixed),
    Lower_CI_fixed = exp(meta_result_cog$lower.fixed),
    Upper_CI_fixed = exp(meta_result_cog$upper.fixed),
    Weight_percent_fixed = NA,
    HR_random = NA,
    Lower_CI_random = NA,
    Upper_CI_random = NA,
    Weight_percent_random = NA
  ),
  data.frame(
    Study = "Global Effect Random",
    logHR = NA,
    SE_logHR = NA,
    HR_fixed = NA,
    Lower_CI_fixed = NA,
    Upper_CI_fixed = NA,
    Weight_percent_fixed = NA,
    HR_random = exp(meta_result_cog$TE.random),
    Lower_CI_random = exp(meta_result_cog$lower.random),
    Upper_CI_random = exp(meta_result_cog$upper.random),
    Weight_percent_random = NA
  )
)


# Save results to an Excel file
write_xlsx(data_to_save, "Data/forest_plot_metagen_ModelC.xlsx")


pdf("Figures/funnel_plot_ModelC.pdf", width = 6, height = 6)

funnel(
  meta_result_cog,
  xlab = "log(HR)",
  ylab = "Standard Error",
  studlab = TRUE,
  contour = c(0.90, 0.95, 0.99),
  col.contour = c("darkgray", "gray", "lightgray")
)

dev.off()
