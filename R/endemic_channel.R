#' Computes endemic channel
#'
#' This function calculates the endemic channel using the geometric or arithmetic
#' mean, following the methodology of Bortman, 1999.
#'
#' @param df A dataframe containing columns `epiyear`, `epiweek`, and `inc`.
#' @param type Indicates the type of mean used. Options: 'geometric' and 'arithmetic', defaults to 'geometric'
#' @param remove_53 Indicates if 53rd epidemiological weeks should be removed, defaults to TRUE
#' @param show_plot Indicated whether to plot endemic channel result, defaults to TRUE
#' @return A named list with:
#' \describe{
#'   \item{df_channel}{The dataframe with columns epiweek, mean, upper, lower}
#'   \item{plot}{A ggplot object of the endemic channel}
#' }
#' @examples
#' \dontrun{
#' res <- endemic_channel(df)
#' res$df_channel
#' res$plot
#' }
#' @export
endemic_channel <- function(df, type = 'geometric', remove_53 = T, show_plot = T){

  # input format: epiyear, epiweek, incidence
  # type: 'geometric' for geometric mean, 'arithmetic' for arithmetic mean (defaults to 'geometric')
  # remove_53: T removes 53rd epidemiological week, F keeps it (defaults to T)
  # show_plot: T shows a plot of endemic channel (defaults to T)
  # output format: list with first element df_channel (endemic channel dataframe) and second element p (plot of endemic channels ggplot object)

  n_years <- length(unique(df$epiyear))

  if(remove_53){
    df <- df %>% filter(epiweek != 53)
  }
  if(type == 'geometric'){
    df <- df %>% ungroup()
    df <- df %>% mutate(inc = inc + 1)
    df <- df %>% mutate(log_inc = log(inc))
    df_channel <- df %>% group_by(epiweek) %>%
      summarise(log_mean = mean(log_inc),
                log_upper = mean(log_inc) + ((qt(0.975, n_years - 1)*sd(log_inc))/(sqrt(n_years))),
                log_lower = mean(log_inc) - ((qt(0.975, n_years - 1)*sd(log_inc))/(sqrt(n_years)))
      )
    df_channel <- df_channel %>% ungroup()
    df_channel <- df_channel %>%
      mutate(mean = exp(log_mean) - 1,
             upper = exp(log_upper) - 1,
             lower = exp(log_lower) - 1)
    df_channel <- df_channel %>% select(epiweek, mean, upper, lower)
    p <- plot_endemic_channel(df_channel)
    if(show_plot){
      print(p)
    }
    return(list(df_channel = df_channel, plot = p))
  }else if(type == 'arithmetic'){
    df <- df %>% ungroup()
    df_channel <- df %>% group_by(epiweek) %>%
      summarise(mean = mean(inc),
                upper = mean(inc) + ((qt(0.975, n_years - 1)*sd(inc))/(sqrt(n_years))),
                lower = mean(inc) - ((qt(0.975, n_years - 1)*sd(inc))/(sqrt(n_years)))
      )
    df_channel <- df_channel %>% ungroup()
    df_channel <- df_channel %>% select(epiweek, mean, upper, lower)
    p <- plot_endemic_channel(df_channel)
    if(show_plot){
      print(p)
    }
    return(list(df_channel = df_channel, plot = p))
  }else{
    print('Type not valid, only valid types are "geometric" and "arithmetic"')
  }
}

