
# Load table with Biological Age based on %AH

require(readxl)

ba <- read_excel("data-raw/maturation.xlsx", sheet = "Bio Age")

usethis::use_data(ba, overwrite = TRUE)
