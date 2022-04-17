################################################################################
#
#'
#' Clean raw data
#'
#'
#
################################################################################

clean_raw_data <- function(raw_data) {
  x <- raw_data |>
    #subset(as.Date(today) > as.Date("2022-04-03")) |>
    dplyr::mutate(
      mweight = ifelse(mpeso == 0, NA, mpeso),
      mheight = ifelse(maltura == 0, NA, maltura),
      mmuac = ifelse(mbraco == 0, NA, mbraco),
      cweight = ifelse(cpeso == 0, NA, cpeso),
      cheight = ifelse(caltura == 0, NA, caltura),
      cbraco = as.numeric(cbraco),
      cmuac = ifelse(cbraco == 0, NA, cbraco),
      cweight1 = ifelse(flag == 1, cpeso1, cpeso),
      cheight1 = ifelse(flag == 1, caltura1, caltura),
      cmuac1 = ifelse(flag == 1, cbraco1, cbraco),
      age_years = ((as.Date(today) - as.Date(child_dob)) / 365.25) |>
        as.numeric(),
      age_months = ((as.Date(today) - as.Date(child_dob)) / (365.25 / 12)) |>
        as.numeric(),
      age_days = (as.Date(today) - as.Date(child_dob)) |>
        as.numeric()
    )
  
  ## Return
  x
}

