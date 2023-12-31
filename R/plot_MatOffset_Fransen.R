#' Maturity Offset Plot (Fransen)
#'
#' This function returns a lollipop ggplot showing the offset in years from current age to estimated age at PHV for each athlete in the dataset using the Fransen calculation method. This function can be filtered by athlete(s), date, and age.
#'
#' Refer to references cited on this package for further details on how these metrics are calculated.
#'
#'
#' @param data A data frame containing the raw data we wish to analyze.
#' @param athlete A character vector. Names of athletes to include in the plot.
#' @param date A character vector. Dates to filter the data (in yyyy-mm-dd).
#' @param agegroup A character vector. Age Group of athletes at time of testing.
#' @return A lollipop plot (\code{\bold{ggplot}})
#'
#' @export
#' @examples
#' plot_MatOffset_Fransen(data_sample)
#'

plot_MatOffset_Fransen <- function(data, athlete = NULL, date = NULL, agegroup = NULL) {

  data <- maturation_cm(data)

  data <- data[data$Gender == "Male", ]

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

  # Calculate x-max
  max_value <- max(data$`Fransen MO (years)`, na.rm = TRUE)
  all_values_less_than_0 <- all(data$`Fransen MO (years)` < 0)
  right_labels <- ifelse(all_values_less_than_0, 0.2, max_value + 0.3)

  plot <- data %>%
    dplyr::select(`Player Name`, `Fransen MO (years)`) %>%
    dplyr::mutate(Type = ifelse(`Fransen MO (years)` > 0, "Past PHV", "Before PHV")) %>%
    ggplot2::ggplot(ggplot2::aes(x = `Fransen MO (years)`, y = reorder(`Player Name`, `Fransen MO (years)`), color = Type)) +
    ggplot2::geom_segment(ggplot2::aes(xend = 0, yend = `Player Name`), linewidth = 1) +
    ggplot2::geom_vline(ggplot2::aes(xintercept = 0), color = "white") +
    ggplot2::geom_point(size = 3) +
    ggplot2::geom_text(ggplot2::aes(x = 0, y = -0.2, label = "PHV"), color = "grey", size = 3) +
    ggplot2::geom_text(ggplot2::aes(x = 0, y = -1, label = ""), color = "transparent") +
    ggplot2::geom_text(fontface = "bold", size = 3, colour = "black", ggplot2::aes(x = right_labels, y = `Player Name`,
                                                                                   label = ifelse(`Fransen MO (years)` == 0, paste0(as.character(`Fransen MO (years)`)),
                                                                                                  ifelse(`Fransen MO (years)` > 0, paste0("",as.character(`Fransen MO (years)`)), paste(as.character(`Fransen MO (years)`)))))) +
    ggplot2::scale_color_manual(name="Time", values = c("Past PHV" = "deepskyblue3", "Before PHV" = "darkred")) +
    ggplot2::ylab("Player Name(s) \n") + ggplot2::xlab("\n Years") +
    ggplot2::labs(title = "Fransen Maturity Offset", subtitle = "Length of time (in years) from PHV \n") +
    ggplot2::theme_light() +
    ggplot2::theme(axis.title.x = ggplot2::element_text(color = "grey", hjust = 1),
          axis.title.y = ggplot2::element_text(color = "grey", hjust = 1),
          plot.subtitle = ggplot2::element_text(color = "darkgray"),
          panel.grid.minor = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_line(linetype = 2),
          legend.title = ggplot2::element_text(face = "bold"))

  plot

}
