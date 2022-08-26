################################################################################
#
#'
#' Get core variables required for analysis
#'
#' @param raw_data_clean A roughly cleaned/processed raw dataset 
#'
#
################################################################################

get_core_variables <- function(raw_data_clean) {
  raw_data_clean |>
    subset(
      select = c(
        id, spid, district, ea_code, geolocation
      )
    )
}


################################################################################
#
#'
#' Recode yes no responses
#' 
#' @param x A vector to recode 
#' @param na_values A vector of values in x that correspond to an NA. Default
#'   to NULL
#'   
#'
#
################################################################################

recode_yes_no <- function(x, na_values = NULL, detect = c("yes", "no")) {
  ## Which value to detect
  detect <- match.arg(detect)
  
  ## Recode NAs
  if (!is.null(na_values)) {
    x <- ifelse(
      x %in% na_values, NA, x
    )
  }
  
  ## Convert x to uppercase to make recoding rules easier
  if (inherits(x, "character")) {
    x <- toupper(x)
  }

  if (detect == "yes") {
    ## Recode x to 1 and 0  
    x <- ifelse(
      isTRUE(x) | x == "T" | x == 1 | x == "Y" | x == "YES", 1, 0
    )
  } else {
    ## Recode x to 1 and 0
    x <- ifelse(
      isFALSE(x) | x == "F" | x == 0 | x == "N" | x == "NO", 0, 1
    )
  }
  
  ## Return
  x
}


################################################################################
#
#'
#'
#'
#
################################################################################