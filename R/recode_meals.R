################################################################################
#
#'
#' Recode ICFI - meals
#' 
#' food_num	How many times did **${child_random_name}** eat any solid, 
#'   semi-solid or soft foods yesterday during the day or night?
#'
#
################################################################################

meal_recode_response <- function(x, na_values, binary = TRUE) {
  na_type <- get_na_type(x)
  
  if (binary) {
    ifelse(
      x %in% na_values, na_type,
      ifelse(x == 2, 0, 1)
    )
  } else {
    ifelse(x %in% na_values, na_type, x)
  }  
}


meal_recode_responses <- function(vars, .data, 
                                  na_values = 9,
                                  binary = FALSE) {
  x <- .data[vars]
  
  Map(
    f = meal_recode_response,
    x = x,
    na_values = na_values,
    binary = binary
  ) |>
    dplyr::bind_cols() |>
    (\(x) 
     {
       data.frame(
         age_months = .data[["age_months"]],
         x
       ) 
    } 
    )()
}


meal_recode <- function(vars, .data) {
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  meal_frequency <- meal_recode_response(
    x = .data[[vars]], na_values = 9, binary = FALSE
  )
  
  data.frame(core_vars, meal_frequency)
}

