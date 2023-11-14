
#' Maturation and Bio-banding Metrics (in)
#'
#' This function returns a dataframe with computed growth and maturation metrics in inches (in) calculated from the imported data. See references for further details about the methodology behind each metric.
#' For the same calculations in centimeters (cm) use `maturation_cm()`
#'
#' @param data A data frame. See data_sample for formatting reference.
#' @format A data frame with the following columns:
#' \describe{
#'          \item{`Player Name`}{A chracter string. The name of the athlete}
#'          \item{`Age Group @ Testing`}{A chracter string. Athletes Age Group at the time of testing}
#'          \item{`Gender`}{A character String. The gender of the athlete}
#'          \item{`Testing Date`}{A date. The data collection date for each athlete}
#'          \item{`Birth Year`}{The year of birth for every athlete}
#'          \item{`Quarter`}{The yearly quarter in which athletes were born}
#'          \item{`Age`}{The age of the athlete in years}
#'          \item{`Height (IN)`}{The height in inches for each athlete at the time of testing}
#'          \item{`Height (FT'IN")`}{The height in feet and inches for each athlete at the time of testing}
#'          \item{`Estimated Adult Height (IN)`}{The estimated adult height in inches of the athlete using the Khamis-Roche method. See references for further details}
#'          \item{`Estimated Adult Height (FT'IN")`}{The estimated adult height in feet and inches of the athlete using the Khamis-Roche method. See references for further details}
#'          \item{`% Adult Height`}{Their current height expressed as %, compared to their predicted adult height}
#'          \item{`Z-Score`}{Estimated biological maturity status expressed as a z-score, using the percentage of adult stature attained at observation and age-specific means and standard deviations followed longitudinally in the Berkeley Growth Study. See references for further details}
#'          \item{`Maturity Status (%AH)`}{A z-score of -0.5 to +0.5 was used to define average maturity status; a z-score greater than +0.5 defined early while a z-score below -0.5 defined late status. See references for further details}
#'          \item{`Remaining Growth (IN)`}{The difference between their predicted adult height and current height, in inches}
#'          \item{`Mirwald MO (years)`}{Difference between their current age and their estimated age at PHV, espressed in years, using the Mirwald Method}
#'          \item{`Age @ PHV (Mirwald)`}{The estimated age of the player at the time of Peak Height Velocity. Calculated using the Mirwald equation. See references for further details}
#'          \item{`Fransen MO (years)`}{Difference between their current age and their estimated age at PHV, espressed in years, using the Fransen Method}
#'          \item{`Age @ PHV (Fransen)`}{The estimated age of the player at the time of Peak Height Velocity. Calculated using the Fransen equation. See references for further details}
#'          \item{`Bio-Band`}{Categries for bio-banding based on the work from Cumming et al, 2017. See references for further details}
#'          }
#'
#' @references
#'     - Khamis, H. J., & Roche, A. F, (1994). Predicting adult height without using skeletal age: The Khamis-Roche method. Pediatrics, 94, 504–507
#'     - Sean P. Cumming, Rhodri S. Lloyd, John L. Oliver, Joey C. Eisenmann & Robert M. Malina, (2017). Bio-banding in Sport: Applications to competition, talent identification and strength and conditioning of youth athletes, National Strength and Conditioning Association, vol.39, 2
#'     - Mirwald, R.L., Baxter-Jones, A.D.G., Bailey, D.A., & Beunen, G.P., (2002). An assessment of maturity from anthropometric measurements. Medicine and Science Sports Exercise, 34,4, pp. 689–694.
#'     - Johnson DM, Williams S, Bradley B, Sayer S, Fisher JM. Growing pains : Maturity associated variation in injury risk in academy football. Eur J Sport Sci . 2019:1–9.
#'     - Fransen, J., Bush, S., Woodcock, S., Novak, A., Deprez, D., Baxter-Jones, A. D. G., Vaeyens, R., & Lenoir, M. (2018). Improving the Prediction of Maturity From Anthropometric Variables Using a Maturity Ratio. Pediatric exercise science, 30(2), 296–307.
#'     - Hill, M., Scott, S., Malina, R. M., McGee, D., & Cumming, S. P. (2020). Relative age and maturation selection biases in academy football. Journal of sports sciences, 38(11-12), 1359–1367.
#'
#' @export
#' @examples
#' maturation_in(data_sample)
#'

maturation_in <- function (data) {

  inches_to_feet <- function(inches) {
    feet <- floor(inches / 12)
    remaining_inches <- round(inches %% 12,2)
    return(paste0(feet, "'", remaining_inches, '"'))
  }

  final_table <- data %>%
    dplyr::mutate(Age = round(lubridate::time_length(difftime(as.Date(`Testing Date`), as.Date(`DOB`)), "years"), 2)) %>%
    dplyr::mutate(`Rounded Age` = round(Age / 0.5) * 0.5) %>%
    dplyr::mutate(`Testing Date` = as.Date(`Testing Date`)) %>%
    dplyr::mutate(`DOB` = as.Date(`DOB`)) %>%
    dplyr::mutate(`Birth Year` = lubridate::year(`DOB`)) %>%
    dplyr::mutate(Quarter = paste("Q", lubridate::quarter(`DOB`), sep = "")) %>%
    dplyr::mutate(`Weight (KG)` = round((`Weight1 (KG)` + `Weight2 (KG)` + `Weight3 (KG)`) / 3, 2),
                  `Weight (LB)` = round(`Weight (KG)` * 2.20462),
                  `Height (CM)` = round((`Height1 (CM)` + `Height2 (CM)` + `Height3 (CM)`) / 3, 2),
                  `Height (IN)` = round(`Height (CM)` * 0.393701,2),
                  `Height (FT'IN")` = inches_to_feet(`Height (IN)`),
                  `Sitting Height (CM)` = ((`Sitting Height1 (CM)` + `Sitting Height2 (CM)` + `Sitting Height3 (CM)`) / 3) - `Bench Height (CM)`,
                  `Leg Length (CM)` = `Height (CM)` - `Sitting Height (CM)`) %>%
    dplyr::mutate(`H-W Ratio` = round(`Height (CM)` / (`Weight (KG)`^ 0.33333),2),
                  `W-H Ratio` = round((`Weight (KG)` / `Height (CM)`) * 100,2),
                  BMI = round((`Weight (KG)` / (`Height (CM)`/100) ^ 2),2),
                  `Sitting/Stand Height` = round(`Sitting Height (CM)` / `Height (CM)`,2),
                  `Leg Length * Sitting Height` =  round(`Leg Length (CM)` * `Sitting Height (CM)`,2),
                  `Age * Leg Length` = `Leg Length (CM)` * Age,
                  `Age * Sitting Height` = `Sitting Height (CM)` * Age,
                  `Age * Weight` = `Weight (KG)` * Age,
                  `Fransen Ratio` = round(6.986547255416 + (0.115802846632 * Age) + (0.001450825199 * (Age^2)) + (0.004518400406 * `Weight (KG)`) - (0.000034086447 * (`Weight (KG)`^2)) - (0.151951447289 * `Height (CM)`) + (0.000932836659*(`Height (CM)`^2)) - (0.000001656585*(`Height (CM)`^3)) + (0.032198263733*`Leg Length (CM)`) - (0.000269025264*(`Leg Length (CM)`^2)) - (0.000760897942*(`Height (CM)`*Age)),2),
                  `Fransen APHV` = round(Age / `Fransen Ratio`),2) %>%
    dplyr::mutate(`Parent Mid Height (CM)` = round((`Mothers Height (CM)` + `Fathers Height (CM)`) / 2, 2)) %>%
    dplyr::mutate(`Parent Mid Height (IN)` = `Parent Mid Height (CM)` * 0.393701) %>%
    dplyr::full_join(ageR::table, by = c("Rounded Age" = "Age")) %>%
    na.omit() %>%
    dplyr::mutate(`Estimated Adult Height (IN)` = ifelse(Gender == "Male", round(`B1` + (`Height (IN)` * `M-Height`) + (`Weight (LB)` * `M-Weight`) + (`Parent Mid Height (IN)` * `M-Midparent Stature`),2), round(`B2` + (`Height (IN)` * `F-Height`) + (`Weight (LB)` * `F-Weight`) + (`Parent Mid Height (IN)` * `F-Midparent Stature`),2))) %>%
    dplyr::mutate(`Estimated Adult Height (FT'IN")` = inches_to_feet(`Estimated Adult Height (IN)`)) %>%
    dplyr::mutate(`Estimated Adult Height (CM)` = round(`Estimated Adult Height (IN)` * 2.54,2)) %>%
    dplyr::mutate(`% Adult Height` = round((`Height (CM)` / `Estimated Adult Height (CM)`) * 100,2)) %>%
    dplyr::mutate(`Z-Score` = ifelse(Gender == "Male", round((`% Adult Height` - `M-Adult Height Attained`) / `M-Standard Deviation`,2), round((`% Adult Height` - `F-Adult Height Attained`) / `F-Standard Deviation`,2))) %>%
    dplyr::mutate(`Maturity Status (%AH)` = ifelse(`Z-Score` > 0.5, "Early", ifelse(`Z-Score` < -0.5, "Late", "On-Time"))) %>%
    dplyr::mutate(`Remaining Growth (CM)` = round((`Estimated Adult Height (CM)` - `Height (CM)`),2)) %>%
    dplyr::mutate(`Remaining Growth (IN)` = round(`Remaining Growth (CM)` * 0.393701,2)) %>%
    dplyr::mutate(`Mirwald MO (years)` = ifelse(Gender == "Male", round(-9.236 + (0.0002728 * (`Leg Length * Sitting Height`)) + (-0.001663 * `Age * Leg Length`) + (0.007216 * `Age * Sitting Height`) + (0.02292 * `W-H Ratio`),2), round(-9.376 + (0.0001882 * (`Leg Length * Sitting Height`)) + (0.0022 * `Age * Leg Length`) + (0.005841 * `Age * Sitting Height`) + (-0.002658 * `Age * Weight`) + (0.07693 * `W-H Ratio`),2))) %>%
    dplyr::mutate(`Age @ PHV (Mirwald)` = Age - `Mirwald MO (years)`) %>%
    dplyr::mutate(`Fransen MO (years)` = ifelse(Gender == "Male", round(Age - `Fransen APHV`,2), "0")) %>%
    dplyr::mutate(`Age @ PHV (Fransen)` = ifelse(Gender == "Male", `Fransen APHV`, "0")) %>%
    dplyr::select(`Player Name`,`Age Group @ Testing`,Gender,`Testing Date`,`Birth Year`,Quarter,Age,`Height (IN)`,`Height (FT'IN")`,`Estimated Adult Height (IN)`,`Estimated Adult Height (FT'IN")`,`% Adult Height`,`Z-Score`,`Maturity Status (%AH)`,`Remaining Growth (IN)`,`Mirwald MO (years)`,`Age @ PHV (Mirwald)`,`Fransen MO (years)`,`Age @ PHV (Fransen)`) %>%
    dplyr::mutate_at(vars(Age, `Height (IN)`, `Estimated Adult Height (IN)`, `% Adult Height`, `Z-Score`, `Remaining Growth (IN)`, `Mirwald MO (years)`, `Age @ PHV (Mirwald)`, `Fransen MO (years)`, `Age @ PHV (Fransen)`), as.numeric) %>%
    dplyr::mutate(`Bio-Band` = ifelse(`% Adult Height` < 85, "Pre-Pubertal",
                                        ifelse(`% Adult Height` >= 85 & `% Adult Height` < 90, "Early Pubertal",
                                               ifelse(`% Adult Height` >= 90 & `% Adult Height` < 95, "Mid-Pubertal", "Late Pubertal"))))

  return(final_table)

}
