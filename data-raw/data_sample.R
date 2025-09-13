
# Load dataset sample for demo purposes. The data on this sample is not real

require(readxl)

data_sample <- read_excel("data-raw/maturation.xlsx", sheet = "maturation")
data_sample2 <- read_excel("data-raw/maturation.xlsx", sheet = "maturation2")

usethis::use_data(data_sample, overwrite = TRUE)
usethis::use_data(data_sample2, overwrite = TRUE)
