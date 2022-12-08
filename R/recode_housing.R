################################################################################
#
#'
#'
#'
#
################################################################################

housing_recode <- function(.data) {
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  roof_type <- ifelse(.data[["sdh1"]] %in% c(88, 99), NA, .data[["sdh1"]]) |>
    spread_vector_to_columns(fill = 1:9, prefix = "roof_type")
  
  floor_type <- ifelse(.data[["sdh2"]] %in% 8:9, NA, .data[["sdh2"]]) |>
    spread_vector_to_columns(fill = 1:9, prefix = "floor_type")
  
  no_of_rooms <- ifelse(.data[["sdh3"]] >= 10, NA, .data[["sdh3"]])
  
  no_of_bedrooms <- ifelse(.data[["sdh4"]] >= 10, NA, .data[["sdh4"]])
  
  persons_per_bedroom <- ifelse(.data[["sdh5"]] >= 10, NA, .data[["sdh5"]])
  
  overcrowded <- ifelse(persons_per_bedroom >= 3, 1, 0)
  
  persons_per_overcrowded <- overcrowded * .data$hh_size
  
  rent_home <- ifelse(.data[["sdh7"]] %in% 8:9, NA, .data[["sdh7"]])
  loan_home <- ifelse(.data[["sdh8"]] %in% 8:9, NA, .data[["sdh8"]])
  
  own_home <- ifelse(rent_home == 1 | loan_home == 1, 0, 1)
  
  electricity <- ifelse(
    .data[["cdcg1"]] %in% 8:9, NA,
    ifelse(
      .data[["cdcg1"]] == 1, 1, 0
    )
  )
  
  cooking_fuel <- ifelse(
    .data[["cfegs1"]] %in% c(88, 99), NA, .data[["cfegs1"]] 
  ) |>
    spread_vector_to_columns(fill = 1:8, prefix = "cooking_fuel")
  
  lighting_fuel <- ifelse(
    .data[["cfegs5"]] %in% c(88, 99), NA, .data[["cfegs5"]] 
  ) |>
    spread_vector_to_columns(fill = 1:7, prefix = "lighting_fuel")
  
  cooking_location <- ifelse(
    .data[["cfegs3"]] %in% c(88, 99), NA, .data[["cfegs3"]]
  ) |>
    spread_vector_to_columns(fill = 1:3, prefix = "cooking_location")
  
  separate_kitchen <- ifelse(
    .data[["cfegs4"]] %in% 8:9, NA,
    ifelse(
      .data[["cfegs4"]] == 1, 1, 0
    )
  )
  
  data.frame(
    core_vars, roof_type, floor_type, overcrowded, persons_per_overcrowded,
    own_home, electricity, cooking_fuel, lighting_fuel, cooking_location,
    separate_kitchen
  )
}

