# Script to install the required R packages for the Meta-Analysis
# Run this script before executing any of the meta_analys_*.R files.

options(timeout = 600) # Increase download timeout for large packages

# Install general dependencies and remotes (to install historical versions)
install.packages(c("remotes", "dplyr", "writexl"), dependencies = TRUE, repos = "http://cran.us.r-project.org")

# Install the exact version of the 'meta' package used for the paper (v7.0-0 supports "BMJ" layout and legacy labels)
remotes::install_version("meta", version = "7.0-0", repos = "http://cran.us.r-project.org", upgrade = "never")

cat("Dependencies installed successfully!\n")
