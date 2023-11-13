#' Predicted Adult Height Plot (FT'IN")
#'
#' This function returns a ggplot object showing the predicted adult height in feet and inches for each athlete in the dataset. Can be further filtered by athlete name, date, and age.
#' For the same plot in centimeters use **`plot_PAH_cm()`** and for inches use **`plot_PAH_in()`**
#'
#' @param data A data frame. Containing the raw data we wish to analyze.
#' @param athlete A character vector. Names of athletes to include in the plot.
#' @param date A character vector. Dates to filter the data (in yyyy-mm-dd).
#' @param agegroup A character vector. Age Group of athletes at time of testing.
#' @return A plot `(ggplot)`
#'
#' @export
#' @examples
#' plot_PAH_ftin(data_sample)
#'

plot_PAH_ftin <- function(data, athlete = NULL, date = NULL, agegroup = NULL) {

  data <- maturation_in(data)

  if (!is.null(athlete)) {
    data <- data[data$`Player Name` %in% athlete, ]
  }

  if (!is.null(date)) {
    data <- data[data$`Testing Date` %in% date, ]
  }

  if (!is.null(agegroup)) {
    data <- data[data$`Age Group @ Testing` %in% agegroup, ]
  }

  inches_to_feet <- function(inches) {
    feet <- floor(inches / 12)
    remaining_inches <- round(inches %% 12,2)
    return(paste0(feet, "'", remaining_inches, '"'))
  }

  dat <- data %>%
    dplyr::mutate(`Error (IN)` = ifelse(Gender == "Male", 2.1 / 2, 1.7 / 2)) %>%
    dplyr::mutate(`Error (FT'IN")` = inches_to_feet(`Error (IN)`))

  plot <- ggplot2::ggplot(data = dat, ggplot2::aes(x = `Estimated Adult Height (IN)`, y = reorder(`Player Name`, `Estimated Adult Height (IN)`))) +
    ggplot2::geom_pointrange(ggplot2::aes(xmin = `Estimated Adult Height (IN)` - `Error (IN)`, xmax = `Estimated Adult Height (IN)` + `Error (IN)`)) +
    ggplot2::facet_wrap(~Gender, scales = "free_y") +
    ggplot2::scale_x_continuous(breaks = seq(0, 300, by = 5), labels = function(x) sapply(x, inches_to_feet)) +
    ggplot2::ylab("") + ggplot2::xlab("\n Feet & Inches") +
    ggplot2::ggtitle("\n Predicted Adult Height (FT'IN\") \n") +
    ggplot2::theme_light() +
    ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 1),
                   panel.grid.minor = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_line(linetype = 2),
                   strip.background = ggplot2::element_rect(fill = "black"),
                   panel.spacing = ggplot2::unit(2, "lines"))

  plot

}
