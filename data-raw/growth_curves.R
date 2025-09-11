
# Load growth curve data from various growth references

require(readxl)

CDC_curves <- read_excel("data-raw/maturation.xlsx", sheet = "CDC curves")
UK90_curves <- read_excel("data-raw/maturation.xlsx", sheet = "UK90 curves")
TK_curves <- read_excel("data-raw/maturation.xlsx", sheet = "Turkey curves")
BE_curves <- read_excel("data-raw/maturation.xlsx", sheet = "Belgium curves")
NO_curves <- read_excel("data-raw/maturation.xlsx", sheet = "Norway curves")

usethis::use_data(CDC_curves, overwrite = TRUE)
usethis::use_data(UK90_curves, overwrite = TRUE)
usethis::use_data(TK_curves, overwrite = TRUE)
usethis::use_data(BE_curves, overwrite = TRUE)
usethis::use_data(NO_curves, overwrite = TRUE)
