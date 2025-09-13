
# Load growth curve data from various growth references

require(readxl)

curves_CDC <- read_excel("data-raw/maturation.xlsx", sheet = "CDC curves")
curves_UK90 <- read_excel("data-raw/maturation.xlsx", sheet = "UK90 curves")
curves_TK <- read_excel("data-raw/maturation.xlsx", sheet = "Turkey curves")
curves_BE <- read_excel("data-raw/maturation.xlsx", sheet = "Belgium curves")
curves_NO <- read_excel("data-raw/maturation.xlsx", sheet = "Norway curves")

usethis::use_data(curves_CDC, overwrite = TRUE)
usethis::use_data(curves_UK90, overwrite = TRUE)
usethis::use_data(curves_TK, overwrite = TRUE)
usethis::use_data(curves_BE, overwrite = TRUE)
usethis::use_data(curves_NO, overwrite = TRUE)
