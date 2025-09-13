#' Returns plot of previously-calculated endemic channels
#'
#' This function returns a ggplot2 object that is a plot of a previously-calculated
#' endemic channel.
#'
#' @param df A dataframe containing columns `epiweek`, `mean`, `upper` and `lower`.
#' @return A ggplot2 object of the endemic channel
#'
#' @examples
#' \dontrun{
#' p <- plot_endemic_channel(df)
#' print(p)
#' }
#' @export
plot_endemic_channel <- function(df){
  df_channel <- df %>% mutate(lower_aux = 0)
  p <- ggplot(df_channel) +
    geom_line(aes(x = epiweek, y = mean), color = 'black') +
    geom_line(aes(x = epiweek, y = upper), color = 'black') +
    geom_line(aes(x = epiweek, y = lower), color = 'black') +
    geom_ribbon(aes(
      x = epiweek,
      ymin = lower_aux,
      ymax = lower,
      fill = "Below expected", # #0bc82c
    ),
    alpha = 0.8) +
    geom_ribbon(aes(
      x = epiweek,
      ymin = lower,
      ymax = mean,
      fill = "Expected", # #edea44
    ),
    alpha = 0.8) +
    geom_ribbon(aes(
      x = epiweek,
      ymin = mean,
      ymax = upper,
      fill = "Alert", # #fe3d3d
    ),
    alpha = 0.8) +
    geom_ribbon(aes(
      x = epiweek,
      ymin = upper,
      ymax = Inf,
      fill = "Epidemic", # #ba0606
    ),
    alpha = 0.8) +
    scale_fill_manual(
      name = "",
      values = c(
        "Below expected" = "#0bc82c",
        "Expected" = "#edea44",
        "Alert" = "#fe3d3d",
        "Epidemic" = "#ba0606"
      ),
      breaks = c("Below expected", "Expected", "Alert", "Epidemic")
    ) +
    theme_minimal() +
    xlab('Epidemiological week') +
    ylab('Incidence')
  return(p)
}
