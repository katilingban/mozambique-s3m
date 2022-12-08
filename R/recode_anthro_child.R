################################################################################
#
#'
#' Clean and recode child anthropometry
#'
#
################################################################################

recode_anthro_child <- function(.data) {
  ## Get anthro variables and do some basic (obvious) clean-up
  df <- .data |>
    subset(
      select = c(age_months, age_days, sex, cweight, cheight, cmuac, oedema)
    ) |>
    dplyr::mutate(
      cmuac = ifelse(
        cmuac == 99999, NA,
        ifelse(
          cmuac == 159, 15.9, cmuac
        )
      )
    )
  
  ## Calculate z-scores and flag records
  flagged_df <- df |>
    addWGSR(
      sex = "sex", 
      firstPart = "cheight", 
      secondPart = "age_days", 
      index = "hfa"
    ) |>
    addWGSR(
      sex = "sex", 
      firstPart = "cweight", 
      secondPart = "age_days", 
      index = "wfa"
    ) |>
    addWGSR(
      sex = "sex", 
      firstPart = "cweight", 
      secondPart = "cheight",  
      index = "wfh"
    ) |>
    addWGSR(
      sex = "sex", 
      firstPart = "cmuac", 
      secondPart = "age_days",  
      index = "mfa"
    ) |>
    dplyr::mutate(
      flag = 0,
      flag = ifelse(!is.na(hfaz) & (hfaz < -6 | hfaz > 6), flag + 1, flag),
      flag = ifelse(!is.na(wfhz) & (wfhz < -5 | wfhz > 5), flag + 2, flag),
      flag = ifelse(!is.na(wfaz) & (wfaz < -6 | wfaz > 5), flag + 4, flag),
      flag = ifelse(!is.na(mfaz) & (mfaz < -6 | mfaz > 5), flag + 8, flag)
    )

  ## Check actions
  actions <-c(
    "No flags", "Check height and age", "Check weight and height",
    "Check height", "Check weight and age", "Check age", "Check weight",
    "Check age, height and weight", "Check MUAC and age"
  )
  
  flagged_df <- flagged_df |>
    dplyr::mutate(flag_action = actions[flag +1])
  
  ## Clean up measurements
  anthro_df <- flagged_df |>
    dplyr::mutate(
      cweight = ifelse(flag %in% c(2, 4, 6:7), NA, cweight),
      cheight = ifelse(flag %in% c(1:3, 7), NA, cheight),
      cmuac = ifelse(flag == 8, NA, cmuac),
      hfaz = ifelse(!is.na(hfaz) & (hfaz < -6 | hfaz > 6), NA, hfaz),
      wfhz = ifelse(!is.na(wfhz) & (wfhz < -5 | wfhz > 5), NA, wfhz),
      wfaz = ifelse(!is.na(wfaz) & (wfaz < -6 | wfaz > 5), NA, wfaz),
      global_stunting = ifelse(hfaz < -2, 1, 0),
      moderate_stunting = ifelse(hfaz >= -3 & hfaz < -2, 1, 0),
      severe_stunting = ifelse(hfaz < -3, 1, 0),
      global_underweight = ifelse(wfaz < -2, 1, 0),
      moderate_underweight = ifelse(wfaz >= -3 & wfaz < -2, 1, 0),
      severe_underweight = ifelse(wfaz < -3, 1, 0),
      global_wasting_whz = ifelse(wfhz < -2, 1, 0),
      moderate_wasting_whz = ifelse(wfhz >= -3 & wfhz < -2, 1, 0),
      severe_wasting_whz = ifelse(wfhz < -3, 1, 0),
      global_wasting_muac = ifelse(cmuac < 12.5, 1, 0),
      moderate_wasting_muac = ifelse(cmuac >= 11.5 & cmuac < 12.5, 1, 0),
      severe_wasting_muac = ifelse(cmuac < 11.5, 1, 0)
    )
  
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  data.frame(core_vars, anthro_df)
}

