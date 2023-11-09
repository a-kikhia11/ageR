
# Load US and UK growth curves data from the CDC and British 1990 growth references

require(readxl)

CDC_curves <- read_excel("data-raw/maturation.xlsx", sheet = "CDC curves")
UK90_curves <- read_excel("data-raw/maturation.xlsx", sheet = "UK90 curves")

usethis::use_data(CDC_curves, overwrite = TRUE)
usethis::use_data(UK90_curves, overwrite = TRUE)
