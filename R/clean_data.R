################################################################################
#
#'
#' Clean raw data
#'
#'
#
################################################################################

clean_raw_data <- function(raw_data, survey_codebook, survey_questions) {
  x <- raw_data |>
    #subset(as.Date(today) > as.Date("2022-04-03")) |>
    dplyr::mutate(
      mweight = ifelse(as.numeric(mpeso) == 0, NA, as.numeric(mpeso)),
      mheight = ifelse(as.numeric(maltura) == 0, NA, as.numeric(maltura)),
      mmuac = ifelse(as.numeric(mbraco) == 0, NA, as.numeric(mbraco)),
      cpeso = as.numeric(cpeso),
      cpeso1 = as.numeric(cpeso1),
      cweight = ifelse(cpeso == 0, NA, cpeso),
      caltura = as.numeric(caltura),
      caltura1 = as.numeric(caltura1),
      cheight = ifelse(caltura == 0, NA, caltura),
      cbraco = as.numeric(cbraco),
      cbraco1 = as.numeric(cbraco1),
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
  
  ## Get select multiple variables
  select_multiple_vars <- survey_questions |> 
    subset(stringr::str_detect(type, "multiple")) |> 
    dplyr::pull(type) |> 
    stringr::str_remove_all(pattern = "select_multiple ")
  
  integer_vars <- survey_codebook |>
    subset(!choice_names %in% c("", select_multiple_vars)) |>
    (\(x) x$vars)()
  
  x[ , integer_vars] <- x[ , integer_vars] |>
    apply(MARGIN = 2, FUN = function(x) as.integer(x))
  
  x[ , c("q02a", "q03")] <- x[ , c("q02a", "q03")] |>
    apply(MARGIN = 2, FUN = function(x) as.integer(x))
  
  x[ , c("gi2t", "gi3t", "wt1t")] <- x[ , c("gi2t", "gi3t", "wt1t")] |>
    apply(MARGIN = 2, FUN = function(x) as.integer(x))
  
  x[ , c("wt3a", "wt3b")] <- x[ , c("wt3a", "wt3b")] |>
    apply(MARGIN = 2, FUN = function(x) as.integer(x))
  
  x[ , paste0("fcs", 1:16)] <- x[ , paste0("fcs", 1:16)] |>
    apply(MARGIN = 2, FUN = function(x) as.integer(x))
  
  x[ , paste0("rcsi", 1:5)] <- x[ , paste0("rcsi", 1:5)] |>
    apply(MARGIN = 2, FUN = function(x) as.integer(x))
    
  ## Return
  x
}

