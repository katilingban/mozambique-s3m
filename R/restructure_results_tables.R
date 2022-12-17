################################################################################
#
#'
#' Restructure results tables
#'
#
################################################################################

## Spread table by districts (for table reporting) -----------------------------

spread_table_by_district <- function(df) {
  df |>
    subset(select = -sd) |>
    tidyr::pivot_wider(
      names_from = district,
      values_from = c(estimate, lcl, ucl)
    ) |>
      (\(x) 
        x[ , c(1, 2, 3, 4:16 |> lapply(FUN = seq, to = 42, by = 13) |> unlist())]
      )()
}

## Spread table by districts for multiple indicators ---------------------------

create_results_table_by_district <- function(results_table, format = TRUE) {
  if (format) {
    results_table <- results_table |>
      dplyr::mutate(
        estimate = ifelse(
          stringr::str_detect(indicator, pattern = "Mean"),
          round(estimate, digits = 3),
          round(estimate * 100, digits = 2)
        ),
        lcl = ifelse(
          stringr::str_detect(indicator, pattern = "Mean"),
          round(lcl, digits = 3),
          round(lcl * 100, digits = 2)
        ),
        ucl = ifelse(
          stringr::str_detect(indicator, pattern = "Mean"),
          round(ucl, digits = 3),
          round(ucl * 100, digits = 2)
        )
      )
  }
  
  df_list <- split(
    x = results_table,
    f = factor(
      x = results_table[["indicator"]],
      levels = unique(results_table[["indicator"]])
    )
  )
  
  Map(
    f = spread_table_by_district,
    df = df_list
  ) |>
    dplyr::bind_rows()
}

## Create table by indicator (for mapping) -------------------------------------

create_table_by_indicator <- function(df) {
  df |>
    dplyr::mutate(
      estimate = ifelse(
        stringr::str_detect(indicator, pattern = "Mean"),
        round(estimate, digits = 3),
        round(estimate * 100, digits = 2)
      ),
      lcl = ifelse(
        stringr::str_detect(indicator, pattern = "Mean"),
        round(lcl, digits = 3),
        round(lcl * 100, digits = 2)
      ),
      ucl = ifelse(
        stringr::str_detect(indicator, pattern = "Mean"),
        round(ucl, digits = 3),
        round(ucl * 100, digits = 2)
      )
    ) |>
    (\(x)
      {
        names(x)[5] <- unique(x$indicator_variable)
        x
      }
    )() |>
    subset(
      select = c(-indicator_set, -indicator_variable, -indicator, -lcl, -ucl, -sd)
    )
}

## Create table by multiple indicators -----------------------------------------

create_tables_by_indicator <- function(results_table) {
  df_list <- split(
    x = results_table,
    f = factor(
      x = results_table[["indicator"]],
      levels = unique(results_table[["indicator"]])
    )
  )
  
  Map(
    f = create_table_by_indicator,
    df = df_list
  ) |>
    (\(x)
      Reduce(
        f = function(a, b) merge(a, b),
        x = x
      )
    )()
}
