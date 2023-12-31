% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_time2phv_Mirwald.R
\name{plot_time2phv_Mirwald}
\alias{plot_time2phv_Mirwald}
\title{Time to PHV Dumbbell Plot (Mirwald)}
\usage{
plot_time2phv_Mirwald(
  data,
  athlete = NULL,
  date = NULL,
  agegroup = NULL,
  gender = NULL
)
}
\arguments{
\item{data}{A data frame. The object containing the raw data we wish to analyze.}

\item{athlete}{A character vector. Names of athletes to include in the plot.}

\item{date}{A character vector. Dates to filter the data (in yyyy-mm-dd).}

\item{agegroup}{A character vector. Age Group of athletes at time of testing.}

\item{gender}{A character vector. Gender of athletes to include in the plot (default to include ALL athletes)}
}
\value{
A dumbbell plot (\code{\bold{ggplot}})
}
\description{
This function returns a dumbbell plot showing the difference (in years) between current age and estimated age at PHV for each athlete in the dataset using the Mirwald Maturity Offset method. Can be further filtered by athlete, age, and date.
}
\details{
Athletes are ordered by the difference between current and estimated age at PHV, as shown on the right side of the plot, from highest to lowest.

Check the references cited on this package for further details on how these metrics are calculated.
}
\examples{
plot_time2phv_Mirwald(data_sample)

}
