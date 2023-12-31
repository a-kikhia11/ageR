#' Adult Height vs Fransen Maturity Offset in Years
#'
#' This function returns a scatterplot showing the percent of Adult Height vs Fransen Maturity Offset (in years).
#'
#' @param data A data frame. Containing the raw data we wish to analyze.
#' @param athlete A character vector. Names of athletes to include in the plot.
#' @param date A character vector. Dates to filter the data (in yyyy-mm-dd).
#' @param agegroup A character vector. Age Group of athletes at time of testing.
#' @return A plot (\code{\bold{ggplot}})
#'
#' @export
#' @examples
#' plot_MatStages_Fransen(data_sample)
#'

plot_MatStages_Fransen <- function(data, athlete = NULL, date = NULL, agegroup = NULL) {

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

  athlete_colors <- rainbow(length(unique(data$`Player Name`)))

  max_value <- max(data$`Fransen MO (years)`, na.rm = TRUE)
  min_value <- min(data$`Fransen MO (years)`, na.rm = TRUE)
  pre_puberty_x <- ifelse(min_value <= -1, ((min_value - 0.65) - 1) / 2, -1)
  post_puberty_x <- ifelse(max_value >= 1.5, ((max_value + 0.3) + 1) / 2, 1)
  if (min_value <= 0.3 && max_value >= -0.3) {
    puberty_x <- 0
  } else if (max_value < 0 && max_value >= -1) {
    puberty_x <- max_value + 0.05
  } else if (min_value > 0 && min_value <= 1) {
    puberty_x <- ((min_value - 0.6) + 1) / 2
  } else {
    puberty_x <- 0
  }

  plot <- data %>%
    ggplot2::ggplot(ggplot2::aes(x = `Fransen MO (years)`, y = `% Adult Height`, color = `Player Name`)) +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = 100, ymax = 102, fill = "black") +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = 85, fill = "gray", alpha = 0.4) +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = 85, ymax = 96, fill = "gray", alpha = 0.6) +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = 96, ymax = 100, fill = "gray", alpha = 0.8) +
    if (any(data$`Fransen MO (years)` > -1 & data$`Fransen MO (years)` < 1)) {
      plot <- plot +
        ggplot2::annotate("text", x = puberty_x, y = 101, label = "Puberty", size = 3, color = "white")
    }
    if (min_value <= -1) {
      plot <- plot +
        ggplot2::annotate("text", x = pre_puberty_x, y = 101, label = "Pre-Puberty", size = 3, color = "white")
    }
    if (max_value >= 1.5) {
      plot <- plot +
        ggplot2::annotate("text", x = post_puberty_x, y = 101, label = "Post-Puberty", size = 3, color = "white")
    }

  plot <- plot +
    ggplot2::annotate("text", x = min_value - 0.4, y = 84 + (85 - 84) / 2, label = "< 85%", size = 3, color = "black") +
    ggplot2::annotate("text", x = min_value - 0.4, y = 85 + (96 - 85) / 2, label = "85-96%", size = 3, color = "black") +
    ggplot2::annotate("text", x = min_value - 0.4, y = 96 + (100 - 96) / 2, label = "> 96%", size = 3, color = "black")
    if (min_value <= -0.6) {
      plot <- plot + ggplot2::geom_vline(xintercept = -1, color = "white")
    }
    if (max_value >= 1) {
      plot <- plot + ggplot2::geom_vline(xintercept = 1, color = "white")
    }

  plot <- plot +
    ggplot2::geom_point(size = 2.3, alpha = 0.5) +
    ggplot2::scale_x_continuous(breaks = seq(-10, 10, by = 0.5)) +
    ggplot2::ylab("% Adult Height") + ggplot2::xlab("Fransen MO (years)") +
    ggplot2::ggtitle("\n % Adult Height", subtitle =  "       vs. Fransen Maturity Offset") +
    ggplot2::theme_light() +
    ggplot2::theme(panel.grid = ggplot2::element_blank(),
                   panel.border = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_text(color = "darkgrey", hjust = 0.8),
                   axis.title.y = ggplot2::element_text(color = "darkgrey", hjust = 0.65),
                   axis.text.y = ggplot2::element_blank(),
                   axis.ticks.y = ggplot2::element_blank(),
                   plot.subtitle = ggplot2::element_text(color = "darkgray"),
                   legend.title = ggplot2::element_blank(),
                   legend.position = "bottom",  # Adjust legend position
                   legend.box = "horizontal",  # Horizontal legend
                   legend.margin = ggplot2::margin(t = 10))
    ggplot2::scale_color_manual(name = "Player Name", values = athlete_colors)

 plot

}
