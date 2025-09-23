#' Khamis-Roche Model Estimates Tables
#'
#' @details
#' A data frame containing model estimates and predictions by age from the Khamis-Roche method. Also contains age-specific means and standard deviations of percentage of adult stature attained for individuals followed longitudinally in the Berkeley Growth Study.
#'
#' For further details on model estimates visit \url{https://pediatrics.aappublications.org/content/94/4/504.short}
#' Refer to the \code{sitar} package for growth reference derivations
#'
#' @format Data frame with 9 variables and 22 observations:
#' \describe{
#'    \item{\bold{Age}}{Age group in years. Rounded every 6 months.}
#'    \item{\bold{B1}}{Model intercept for males.}
#'    \item{\bold{M-Height}}{Height (inches), for males.}
#'    \item{\bold{M-Weight}}{Weight (lbs) for males.}
#'    \item{\bold{M-Midparent Stature}}{Average stature across mather & father for each age group, for males.}
#'    \item{\bold{B2}}{Model intercept for females.}
#'    \item{\bold{F-Height}}{Height (inches), for females.}
#'    \item{\bold{F-Weight}}{Weight (lbs) for males.}
#'    \item{\bold{F-Midparent Stature}}{Average stature across mather & father for each age group, for females.}
#'
#' }
#' @usage table
#'

"table"
