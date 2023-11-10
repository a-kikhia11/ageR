#' Predicted Adult Height Plot (in)
#'
#' This function returns a ggplot object showing the predicted adult height in inches for each athlete in the dataset. Can be further filtered by athlete name, date, and age.
#' For the same plot in centimeters use **`plot_PAH_cm()`** and for feet and inches use **`plot_PAH_ftin()`**
#'
#' @param data A data frame. Containing the raw data we wish to analyze.
#' @param athlete A character vector. Names of athletes to include in the plot.
#' @param date A character vector. Dates to filter the data (in yyyy-mm-dd).
#' @param agegroup A character vector. Age Group of athletes at time of testing.
#' @return A plot `(ggplot)`
#'
#' @export
#' @examples
#' plot_PAH_in(data_sample)
#'

plot_PAH_in <- function(data, athlete = NULL, date = NULL, agegroup = NULL) {

  data <- maturation_in(data)

  if (!is.null(athlete)) {
    data <- data[data$`Player Name` %in% athlete, ]
  }

  if (!is.null(date)) {
    data <- data[data$`Testing Date` %in% date, ]
  }

  if (!is.null(agegroup)) {
    data <- data[data$`Age Group @ Testing` %in% date, ]
  }

  dat <- data %>%
    dplyr::mutate(`Error (IN)` = ifelse(Gender == "Male", 2.1 / 2, 1.7 / 2))

  plot <- ggplot2::ggplot(data = dat, ggplot2::aes(x = `Estimated Adult Height (IN)`, y = reorder(`Player Name`, `Estimated Adult Height (IN)`))) +
    ggplot2::geom_pointrange(ggplot2::aes(xmin = `Estimated Adult Height (IN)` - `Error (IN)`, xmax = `Estimated Adult Height (IN)` + `Error (IN)`)) +
    ggplot2::facet_wrap(~Gender, scales = "free_y") +
    ggplot2::scale_x_continuous(breaks = seq(0, 300, by = 5)) +
    ggplot2::ylab("") + ggplot2::xlab("\n Inches") +
    ggplot2::ggtitle("\n Estimated Adult Height (IN) \n") +
    ggplot2::theme_light() +
    ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 1),
                   panel.grid.minor = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_line(linetype = 2),
                   strip.background = ggplot2::element_rect(fill = "black"),
                   panel.spacing = ggplot2::unit(2, "lines"))

  plot

}
