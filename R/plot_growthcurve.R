#' Height (current + predicted) vs reference growth curves
#'
#' This function returns a ggplot object showing the \bold{current} and \bold{predicted height} vs \bold{US} or \bold{UK} normal male growth charts.
#'
#' Data for US growth charts was obtained from the National Center for Health Statistics. Please visit \url{https://www.cdc.gov/growthcharts/percentile_data_files.htm} to learn more.
#'
#' Data for UK growth charts was obtained from the British 1990 growth reference. Please visit \url{https://www.healthforallchildren.com/shop-base/software/lmsgrowth/} and/or refer to the \code{\bold{sitar}} package to learn more.
#'
#' Be aware, players from different populations to the one used on these growth charts may not be well represented.
#'
#'
#'
#' @param data A data frame. The object containing the raw data we wish to analyze.
#' @param athlete A character string with the name of the athlete we wish to plot.
#' @param date A character vector. Dates to filter the data (in yyyy-mm-dd).
#' @param reference A character string. Choose US (CDC) or UK (UK90) growth references.
#' @param gender A character vector. Gender of athletes to include in the plot (default to include ALL athletes)
#' @return A plot (\code{\bold{ggplot}})
#'
#' @export
#' @examples
#' plot_growthcurve(data_sample, "Athlete 08", "2020-07-01","UK", "Male")
#' plot_growthcurve(data_sample, "Athlete 17", "2020-07-01","US", "Female")
#'

plot_growthcurve <- function(data, athlete, date, reference, gender) {

  data <- maturation_cm(data)

  if (reference == "US") {
    curve_data <- ageR::CDC_curves
  } else if (reference == "UK") {
    curve_data <- ageR::UK90_curves
  } else {
    stop("Invalid reference parameter. Please use 'US' or 'UK'.")
  }

  if (gender != "Male" && gender != "Female") {
    warning("Invalid gender parameter. Please use 'Male' or 'Female'.")
    return(NULL)
  }

  if (missing(athlete) || is.null(athlete) || length(athlete) == 0) {
    stop("Invalid athlete parameter. Insert athlete name.")
  }

  if (!is.null(date)) {
    date <- as.Date(date)
    data <- data[data$`Testing Date` %in% date, ]
  }

  Subtitle <- if (reference == "UK") {
    if (gender == "Male") {
      "vs. Standard Male Growth Curves: United Kingdom \n"
    } else {
      "vs. Standard Female Growth Curves: United Kingdom \n"
    }
  } else if (reference == "US") {
    if (gender == "Male") {
      "vs. Standard Male Growth Curves: United States \n"
    } else {
      "vs. Standard Female Growth Curves: United States \n"
    }
  }

  curve <- curve_data %>%
    dplyr::select(Gender, Age, everything(), -`L (Power)`, -`M (Median)`, -`S (CV)`) %>%
    dplyr::filter(Gender == gender)

  athlete <- data %>% dplyr::filter(`Player Name` %in% c(athlete))

  plot <- ggplot2::ggplot(curve) +
    ggplot2::annotate("rect", xmin = 7.9, xmax = 12, ymin = 187, ymax = 216, fill = "white") +
    ggplot2::annotate("text", x = 10.9, y = 215, label = "Normal Growth Curve", color = "black", size = 3) +
    ggplot2::annotate("rect", xmin = 8, xmax = 8.6, ymin = 205, ymax = 210, fill = "skyblue1") +
    ggplot2::annotate("text", x = 10, y = 208, label = "3-97 Percentiles", color = "black", size = 2) +
    ggplot2::annotate("rect", xmin = 8, xmax = 8.6, ymin = 200, ymax = 205, fill = "skyblue2") +
    ggplot2::annotate("text", x = 10, y = 203, label = "5-95 Percentiles", color = "black", size = 2) +
    ggplot2::annotate("rect", xmin = 8, xmax = 8.6, ymin = 195, ymax = 200, fill = "skyblue3") +
    ggplot2::annotate("text", x = 10, y = 198, label = "10-90 Percentiles", color = "black", size = 2) +
    ggplot2::annotate("rect", xmin = 8, xmax = 8.6, ymin = 190, ymax = 195, fill = "skyblue4") +
    ggplot2::annotate("text", x = 10, y = 193, label = "25-75 Percentiles", color = "black", size = 2) +
    ggplot2::annotate("rect", xmin = 20, xmax = 22, ymin = max(curve$P3), ymax = max(curve$P97), fill = "black", alpha = .8) +
    ggplot2::annotate("text", x = 21.5, y = 75, label = "Adult Years", color = "black", size = 3) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin=P3, ymax=P97, x=Age), fill = "skyblue1") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin=P5, ymax=P95, x=Age), fill = "skyblue2") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin=P10, ymax=P90, x=Age), fill = "skyblue3") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin=P25, ymax=P75, x=Age), fill = "skyblue4") +
    ggplot2::geom_line(ggplot2::aes(y=P50, x=Age), colour = "gray", linetype = 2) +
    ggplot2::geom_vline(ggplot2::aes(xintercept = 20), color = "black") +
    ggplot2::geom_curve(data = athlete, ggplot2::aes(x = Age, y = `Height (CM)`, xend = 16.5, yend = 135), color = "black", curvature = 0.2, linewidth = 0.5, linetype = 1) +
    ggplot2::annotate("text", x = 17, y = 125, label = "Current \n Height", color = "black", size = 3) +
    ggplot2::geom_point(data = athlete, ggplot2::aes(Age, `Height (CM)`), color = "deeppink", size = 3) +
    ggplot2::geom_point(data = athlete %>% dplyr::mutate(Age = 21), ggplot2::aes(Age, `Estimated Adult Height (CM)`), color = "deeppink", size = 3) +
    ggplot2::geom_text(data = athlete %>% dplyr::mutate(Age = 21), ggplot2::aes(Age, `Estimated Adult Height (CM)`, label = `Estimated Adult Height (CM)`), color = "deeppink", size = 3, vjust = -1) +
    ggplot2::geom_curve(data = athlete %>% dplyr::mutate(Age2 = 21), ggplot2::aes(x = Age, y = `Height (CM)`, xend = Age2, yend = `Estimated Adult Height (CM)`), color = "deeppink", curvature = -0.05, linewidth = 0.5, linetype = 1) +
    ggplot2::scale_x_continuous(breaks = seq(0, 20, by = 2.5)) +
    ggplot2::ylim(75, 220) +
    ggplot2::ylab("Height (CM) \n") + ggplot2::xlab("Age") +
    ggplot2::labs(title = "Predicted Height (CM)", subtitle = Subtitle, caption = "For more information about growth charts visit https://www.cdc.gov/growthcharts/") +
    ggplot2::theme_light() +
    ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 1),
          axis.title.y = ggplot2::element_text(color = "grey", hjust = 1),
          plot.subtitle = ggplot2::element_text(color = "darkgray"),
          plot.caption = ggplot2::element_text(color = "lightblue"),
          panel.grid.minor = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_line(linetype = 2),
          legend.title = ggplot2::element_blank())

  plot

}
