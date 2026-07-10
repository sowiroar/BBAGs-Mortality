# Script to install the required R packages for the Meta-Analysis
# Run this script before executing any of the meta_analys_*.R files.

options(timeout = 600) # Increase download timeout for large packages
install.packages(c("meta", "dplyr", "writexl"), dependencies = TRUE, repos = "http://cran.us.r-project.org")
cat("Dependencies installed successfully!\n")
