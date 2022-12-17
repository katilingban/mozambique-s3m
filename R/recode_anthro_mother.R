################################################################################
#
#'
#' Recode mother anthro indicators
#'
#
################################################################################

recode_anthro_mother <- function(.data, 
                                 bmi_labs = FALSE, 
                                 muac_labs = FALSE) {
  x <- .data |>
    subset(select = c(mother_age, mweight, mheight, mmuac, wh1)) |>
    dplyr::mutate(
      mweight = ifelse(mother_age < 15 | mother_age > 49, NA, mweight),
      mweight = ifelse(wh1 == 1, NA, mweight),
      mheight = ifelse(mother_age < 15 | mother_age > 49, NA, mheight),
      mheight = ifelse(wh1 == 1, NA, mheight),
      mmuac = ifelse(mother_age < 15 | mother_age > 49, NA, mmuac)
    )
  
  ## Apply fixes form first round of BMI checks
  x$mheight[x$mheight == 1478.00] <- 147.80
  x$mheight[x$mheight == 1489.00] <- 148.90
  x$mheight[x$mheight == 104.50]  <- 145.00
  x$mheight[x$mheight == 104.40]  <- 144.00
  x$mweight[x$mweight == 151.0]   <- 51.0
  x$mweight[x$mweight == 160.8]   <- 60.8
  x$mheight[x$mheight == 64.60]   <- 164.6
  x$mheight[x$mheight == 63.70]   <- 163.7
  x$mheight[x$mheight == 61.40]   <- 161.40
  x$mheight[x$mheight == 62.00]   <- 162.00
  x$mheight[x$mheight == 53.90]   <- 153.90
  x$mheight[x$mheight == 62.20]   <- 162.2
  x$mheight[x$mheight == 60.50]   <- 160.50
  x$mheight[x$mheight == 50.60]   <- 150.60
  x$mheight[x$mheight == 52.50]   <- 152.50
  x$mheight[x$mheight == 48.00]   <- 148.00
  x$mweight[x$mweight == 517.0]   <- 51.7
  x$mweight[x$mweight == 73.0]    <- 53.0
  x$mheight[x$mheight == 54.80]   <- 154.80
  x$mheight[x$mheight == 43.70]   <- 143.70
  x$mweight[x$mweight == 147.0]   <- 47.0
  x$mheight[x$mheight == 45.80]   <- 145.80
  x$mheight[x$mheight == 26.00]   <- 162.00
  x$mweight[x$mweight == 152.0]   <- 52.0
  x$mheight[x$mheight == 42.00]   <- 142.00
  x$mweight[x$mweight == 4630.0]  <- 46.3
  x$mheight[x$mheight == 15.10]   <- 151.00
  x$mheight[x$mheight == 15.70]   <- 157.00
  x$mheight[x$mheight == 15.50]   <- 155.00
  x$mheight[x$mheight == 1.59]    <- 159.00
  x$mheight[x$mheight == 1.59]    <- 159.00
  x$mheight[x$mheight == 1.52]    <- 152.00
  x$mheight[x$mheight == 1.65]    <- 165.00
  x$mheight[x$mheight == 1.50]    <- 150.00
  x$mheight[x$mheight == 1.62]    <- 162.00
  x$mheight[x$mheight == 1.55]    <- 155.00
  x$mheight[x$mheight == 1.70]    <- 170.00
  x$mheight[x$mheight == 1.65]    <- 165.00
  x$mheight[x$mheight == 1.58]    <- 158.00
  x$mheight[x$mheight == 1.48]    <- 148.00
  x$mheight[x$mheight == 1.54]    <- 154.00
  x$mheight[x$mheight == 1.58]    <- 158.00
  x$mheight[x$mheight == 1.62]    <- 162.00
  x$mheight[x$mheight == 1.51]    <- 151.00
  x$mheight[x$mheight == 1.00]    <- 100.00
  x$mweight[x$mweight == 23.0]    <- 53.0
  x$mweight[x$mweight == 24.1]    <- 54.1
  x$mweight[x$mweight == 24.8]    <- 54.8
  
    
  x <- x |>
    dplyr::mutate(
      bmi = mweight / ((mheight / 100) ^ 2),
      bmi_class = classify_bmi(bmi, labs = bmi_labs),
      bmi_underweight = ifelse(bmi_class != 1, 0, 1),
      bmi_overweight = ifelse(bmi_class != 3, 0, 1),
      bmi_obese = ifelse(bmi_class != 4, 0, 1),
      muac_class = classify_muac(mmuac, labs = muac_labs),
      muac_undernutrition = ifelse(muac_class == 1, 1, 0)
    )
  
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  data.frame(core_vars, x)
}



################################################################################
#
#'
#' Classify BMI
#'
#
################################################################################

classify_bmi <- function(bmi, labs = c("underweight", "normal", 
                                       "overweight", "obese")) {
  x <- cut(
    x = bmi,
    breaks = c(0, 18.5, 25, 30, Inf),
    labels = labs,
    include.lowest = TRUE
  )
  
  x
}


################################################################################
#
#'
#' Classify MUAC
#'
#
################################################################################

classify_muac <- function(muac, labs = c("acute malnutrition", "normal")) {
  x <- cut(
    x = muac,
    breaks = c(0, 18.5, Inf),
    labels = labs,
    include.lowest = TRUE
  )
  
  x
}