#' Time to PHV Dumbbell Plot (Mirwald)
#'
#' This function returns a dumbbell plot showing the difference (in years) between current age and estimated age at PHV for each athlete in the dataset using the Mirwald Maturity Offset method. Can be further filtered by athlete, age, and date.
#'
#' Athletes are ordered by the difference between current and estimated age at PHV, as shown on the right side of the plot, from highest to lowest.
#'
#' Check the references cited on this package for further details on how these metrics are calculated.
#'
#'
#' @param data A data frame. The object containing the raw data we wish to analyze.
#' @param athlete A character vector. Names of athletes to include in the plot.
#' @param date A character vector. Dates to filter the data (in yyyy-mm-dd).
#' @param agegroup A character vector. Age Group of athletes at time of testing.
#' @param gender A character vector. Gender of athletes to include in the plot (default to include ALL athletes)
#' @return A dumbbell plot (\code{ggplot})
#'
#' @export
#' @examples
#' plot_time2phv_Mirwald(data_sample)
#'

plot_time2phv_Mirwald <- function(data, athlete = NULL, date = NULL, agegroup = NULL, gender = NULL) {

  data <- maturation_cm(data)

  if (!is.null(athlete)) {
    data <- data[data$`Player Name` %in% athlete, ]
  }

  if (!is.null(date)) {
    data <- data[data$`Testing Date` %in% date, ]
  }

  if (!is.null(agegroup)) {
    data <- data[data$`Age Group @ Testing` %in% agegroup, ]
  }

  if (!is.null(gender)) {
    data <- data[data$Gender == gender, ]
  }

  datos <- data %>%
    dplyr::select(`Player Name`, `Current Age` = Age, `Age @ PHV (Mirwald)`)

  base_diff <- datos %>%
    dplyr::mutate(Difference = `Age @ PHV (Mirwald)` - `Current Age`) %>%
    dplyr::arrange(Difference, desc(`Player Name`)) %>%
    dplyr::mutate(Athlete.fact = factor(`Player Name`, levels = unique(`Player Name`)))

  df_diff_gather_age <- base_diff %>%
    tidyr::gather(Metric, Value, -`Player Name`, -Athlete.fact, -Difference) %>%
    dplyr::select(`Player Name`, Athlete.fact, Metric, Value, Difference)

  # Calculate x-max
  max_value <- max(df_diff_gather_age$Value, na.rm = TRUE)

  plot <-  ggplot2::ggplot(data = df_diff_gather_age, ggplot2::aes( y = Athlete.fact, x = Value, color = Metric)) +
    ggplot2::geom_line(ggplot2::aes(group = `Player Name`), color = "grey", linewidth = 1) +
    ggplot2::geom_point(size = 3, pch = 19) +
    ggplot2::geom_text(fontface = "bold", size = 3, colour = "black", ggplot2::aes(x = max_value + 0.6, y = `Player Name`, label =
                                                                   ifelse(Metric == "Age @ PHV (Mirwald)", "",
                                                                          ifelse(Difference == 0, paste0(as.character(Difference)),
                                                                                 ifelse(Difference > 0, paste0("",as.character(round(Difference,1))), paste0(as.character(round(Difference,1)))))))) +
    ggplot2::scale_color_manual(name="Time", values = c("Current Age" = "deepskyblue4", "Age @ PHV (Mirwald)" = "deepskyblue")) +
    ggplot2::ylab("Player Name(s) \n") + ggplot2::xlab("\n Years") +
    ggplot2::labs(title = "Time to PHV", subtitle = "Length of Time (years) Between Current Age and Age at PHV \n") +
    ggplot2::theme_light() +
    ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 0.9),
          axis.title.y = ggplot2::element_text(color = "grey", hjust = 1),
          plot.subtitle = ggplot2::element_text(color = "darkgrey"),
          panel.grid.minor = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_line(linetype = 2),
          legend.title = ggplot2::element_text(face = "bold"))

  plot <- plot +
    ggplot2::geom_text(ggplot2::aes(x = max_value + 0.6, y = -0.2, label = "Diff"), fontface = "bold", size = 3, colour = "black") +
    ggplot2::geom_text(ggplot2::aes(x = max_value + 0.6, y = -1, label = ""), color = "transparent")


  plot

}

