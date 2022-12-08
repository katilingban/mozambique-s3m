################################################################################
#
#'
#' Recode assets data/indicators
#'
#
################################################################################

asset_recode <- function(.data) {
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  radio <- ifelse(
    .data[["cdcg2"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg2"]] == 1, 1, 0
    )
  )
  
  tv <- ifelse(
    .data[["cdcg3"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg3"]] == 1, 1, 0
    )
  )
  
  cellphone <- ifelse(
    .data[["cdcg4"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg4"]] == 1, 1, 0
    )
  )
  
  computer <- ifelse(
    .data[["cdcg7"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg7"]] == 1, 1, 0
    )
  )
  
  bicycle <- ifelse(
    .data[["cdcg8"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg8"]] == 1, 1, 0
    )
  )
  
  motorcycle <- ifelse(
    .data[["cdcg9"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg9"]] == 1, 1, 0
    )
  )
  
  motorcar <- ifelse(
    .data[["cdcg10"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg10"]] == 1, 1, 0
    )
  )
  
  fridge <- ifelse(
    .data[["cdcg11"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg11"]] == 1, 1, 0
    )
  )
  
  food_preserver <- ifelse(
    .data[["cdcg11a"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg11a"]] == 1, 1, 0
    )
  )
  
  fridge_or_food_preserver <- ifelse(
    fridge == 1 | food_preserver == 1, 1, 0
  )
  
  data.frame(
    core_vars, radio, tv, cellphone, computer, bicycle, motorcycle,
    motorcar, fridge, food_preserver, fridge_or_food_preserver
  )
}


