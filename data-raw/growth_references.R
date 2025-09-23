
# Load growth curve data from various growth references

require(readxl)

ref_Berkeley <- read_excel("data-raw/maturation.xlsx", sheet = "Berkeley ref")
ref_SWE <- read_excel("data-raw/maturation.xlsx", sheet = "Sweden ref")
ref_CDC <- read_excel("data-raw/maturation.xlsx", sheet = "CDC ref")
ref_UK90 <- read_excel("data-raw/maturation.xlsx", sheet = "UK90 ref")
ref_TK <- read_excel("data-raw/maturation.xlsx", sheet = "Turkey ref")
ref_BE <- read_excel("data-raw/maturation.xlsx", sheet = "Belgium ref")
ref_NO <- read_excel("data-raw/maturation.xlsx", sheet = "Norway ref")

usethis::use_data(ref_Berkeley, overwrite = TRUE)
usethis::use_data(ref_SWE, overwrite = TRUE)
usethis::use_data(ref_CDC, overwrite = TRUE)
usethis::use_data(ref_UK90, overwrite = TRUE)
usethis::use_data(ref_TK, overwrite = TRUE)
usethis::use_data(ref_BE, overwrite = TRUE)
usethis::use_data(ref_NO, overwrite = TRUE)
