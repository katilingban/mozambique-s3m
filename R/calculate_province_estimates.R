################################################################################
#
#'
#' Calculate province estimates
#'
#
################################################################################

calculate_province_estimate <- function(df, pop) {
  merge(df, pop) |>
    dplyr::summarise(
      indicator_set = unique(indicator_set),
      indicator_variable = unique(indicator_variable),
      indicator = unique(indicator),
      estimate = sum(estimate * population, na.rm = TRUE) / sum(population),
      se = sqrt(sum(sd ^ 2 * population / sum(population, na.rm = TRUE), na.rm = TRUE)),
      lcl = estimate - 1.96 * se,
      ucl = estimate + 1.96 * se
    ) |>
    dplyr::relocate(se, .after = ucl)
}

## Calculate province estimates for all indicators -----------------------------

calculate_province_estimates <- function(results_table, pop) {
  df_list <- split(
    x = results_table,
    f = factor(
      x = results_table[["indicator"]],
      levels = unique(results_table[["indicator"]])
    )
  )
  
  pop <- rep(list(pop), length(df_list))
  
  Map(
    f = calculate_province_estimate,
    df = df_list,
    pop = pop
  ) |>
    dplyr::bind_rows()
}

