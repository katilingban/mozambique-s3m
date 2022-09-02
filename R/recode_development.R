################################################################################
#
#'
#' Recode child development indicators
#' 
#' 
#'
#
################################################################################

dev_recode_var <- function(x, na_values) {
  ifelse(
    x %in% na_values, NA,
    ifelse(
      x == 2, 0, 1
    )
  )
}


dev_recode_vars <- function(vars, .data, na_values) {
  vars <- .data[vars]
  
  apply(
    X = vars,
    MARGIN = 2,
    FUN = dev_recode_var,
    na_values = na_values,
    simplify = TRUE
  ) |>
    data.frame() |>
    (\(x) { names(x) <- c("see", "hear"); x })()
}


dev_recode <- function(vars, .data, na_values = c(88, 99)) {
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  recoded_vars <- dev_recode_vars(
    vars = vars,
    .data = .data,
    na_values = na_values
  )
  
  data.frame(core_vars, recoded_vars)
}

