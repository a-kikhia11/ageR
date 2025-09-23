#' Predicted Adult Height Plot
#'
#' This function returns a ggplot object showing the predicted adult height for each athlete in the dataset. Can be further filtered by athlete name/id and/or age. Can
#' also specify what metric to use; Centimeters (cm), Inches (in), and Feet & Inches (ftin).
#'
#' @param data A data frame. Containing the raw data we wish to analyze.
#' @param athlete A character vector. Names of athletes to include in the plot.
#' @param date A character vector. Dates to filter the data (in yyyy-mm-dd).
#' @param agegroup A character vector. Age Group of athletes at time of testing.
#' @param gender A character vector. Gender of athletes you wish to analyze.
#' @param metric A character vector. Height metric to use (cm, in, ftin).
#' @return A plot (\code{ggplot})
#'
#' @export
#' @examples
#' plot_PAH(data_sample)
#'

plot_PAH <- function(data, athlete = NULL, date = NULL, agegroup = NULL, gender = NULL, metric = "cm") {

  if (metric == "cm") {
    data <- maturation_cm(data)
  } else {
    data <- maturation_in(data)
  }

  if (!is.null(athlete)) {
    data <- data[data$`Player Name` %in% athlete, ]
  }

  if (!is.null(date)) {
    date <- as.Date(date)
    data <- data[data$`Testing Date` %in% date, ]
  }

  if (!is.null(agegroup)) {
    data <- data[data$`Age Group @ Testing` %in% agegroup, ]
  }

  if (!is.null(gender)) {
    data <- data[data$Gender %in% gender, ]
  }

  inches_to_feet <- function(inches) {
    feet <- floor(inches / 12)
    remaining_inches <- round(inches %% 12,2)
    return(paste0(feet, "'", remaining_inches, '"'))
  }

  if (metric == "cm") {
    dat <- data %>% dplyr::mutate(`Error (CM)` = ifelse(Gender == "Male", (2.1 * 2.54) / 2, (1.7 * 2.54) / 2))
    title <- "\n Predicted Adult Height (CM) \n"
    subtitle <- "\n Centimeters"
  } else if (metric == "in") {
    dat <- data %>% dplyr::mutate(`Error (IN)` = ifelse(Gender == "Male", 2.1 / 2, 1.7 / 2))
    title <- "\n Predicted Adult Height (IN) \n"
    subtitle <- "\n Inches"
  } else {
    dat <- data %>% dplyr::mutate(`Error (IN)` = ifelse(Gender == "Male", 2.1 / 2, 1.7 / 2)) %>% dplyr::mutate(`Error (FT'IN")` = inches_to_feet(`Error (IN)`))
    title <- "\n Predicted Adult Height (FT'IN\") \n"
    subtitle <- "\n Feet & Inches"
  }

  dat$`Player Name` <- factor(dat$`Player Name`)

  if (metric == "cm") {
    plot <- ggplot2::ggplot(data = dat, ggplot2::aes(x = `Estimated Adult Height (CM)`, y = reorder(`Player Name`, `Estimated Adult Height (CM)`))) +
    ggplot2::geom_pointrange(ggplot2::aes(xmin = `Estimated Adult Height (CM)` - `Error (CM)`, xmax = `Estimated Adult Height (CM)` + `Error (CM)`)) +
    ggplot2::facet_wrap(~Gender, scales = "free_y") +
    ggplot2::scale_x_continuous(breaks = seq(0, 300, by = 5)) +
    ggplot2::ylab("") + ggplot2::xlab(subtitle) +
    ggplot2::ggtitle(title) +
    ggplot2::theme_light() +
    ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 1),
                   panel.grid.minor = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_line(linetype = 2),
                   strip.background = ggplot2::element_rect(fill = "black"),
                   panel.spacing = ggplot2::unit(2, "lines"))
  } else if (metric == "in") {
    plot <- ggplot2::ggplot(data = dat, ggplot2::aes(x = `Estimated Adult Height (IN)`, y = reorder(`Player Name`, `Estimated Adult Height (IN)`))) +
      ggplot2::geom_pointrange(ggplot2::aes(xmin = `Estimated Adult Height (IN)` - `Error (IN)`, xmax = `Estimated Adult Height (IN)` + `Error (IN)`)) +
      ggplot2::facet_wrap(~Gender, scales = "free_y") +
      ggplot2::scale_x_continuous(breaks = seq(0, 300, by = 5)) +
      ggplot2::ylab("") + ggplot2::xlab(subtitle) +
      ggplot2::ggtitle(title) +
      ggplot2::theme_light() +
      ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 1),
                     panel.grid.minor = ggplot2::element_blank(),
                     panel.grid.major = ggplot2::element_line(linetype = 2),
                     strip.background = ggplot2::element_rect(fill = "black"),
                     panel.spacing = ggplot2::unit(2, "lines"))
  } else {
    plot <- ggplot2::ggplot(data = dat, ggplot2::aes(x = `Estimated Adult Height (IN)`, y = reorder(`Player Name`, `Estimated Adult Height (IN)`))) +
      ggplot2::geom_pointrange(ggplot2::aes(xmin = `Estimated Adult Height (IN)` - `Error (IN)`, xmax = `Estimated Adult Height (IN)` + `Error (IN)`)) +
      ggplot2::facet_wrap(~Gender, scales = "free_y") +
      ggplot2::scale_x_continuous(breaks = seq(0, 300, by = 5), labels = function(x) sapply(x, inches_to_feet)) +
      ggplot2::ylab("") + ggplot2::xlab(subtitle) +
      ggplot2::ggtitle(title) +
      ggplot2::theme_light() +
      ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 1),
                     panel.grid.minor = ggplot2::element_blank(),
                     panel.grid.major = ggplot2::element_line(linetype = 2),
                     strip.background = ggplot2::element_rect(fill = "black"),
                     panel.spacing = ggplot2::unit(2, "lines"))
  }

  plot

}
