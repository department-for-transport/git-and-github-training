#Install and load packages

packages <- c("openxlsx",
              "knitr",
              "lubridate",
              "dplyr",
              "scales")

options(pkgType = "binary")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
# Load packages
lapply(packages, library, character.only = T)