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

split_select_multiple <- function(x, fill, na_rm = FALSE, prefix) {
  if (na_rm) {
    if (is.na(x)) {
      rep(NA_integer_, times = length(fill)) |>
        (\(x) { names(x) <- paste0(prefix, "_", fill); x })()
    } else {
      stringr::str_split(x, pattern = " ") |> 
        unlist() |> 
        as.integer() |> 
        spread_vector_to_columns(fill = fill, prefix = prefix) |>
        colSums(na.rm = TRUE)
    }
  } else {
    stringr::str_split(x, pattern = " ") |> 
      unlist() |> 
      as.integer() |> 
      spread_vector_to_columns(fill = fill, prefix = prefix) |>
      colSums(na.rm = TRUE)
  }
}

split_select_multiples <- function(x, fill, na_rm = FALSE, prefix) {
  lapply(
    X = x,
    FUN = split_select_multiple,
    fill = fill,
    na_rm = na_rm,
    prefix = prefix
  ) |>
    dplyr::bind_rows()
}


################################################################################
#
#'
#' Get NA types
#'
#
################################################################################

get_na_type <- function(x) {
  if (inherits(x, "character")) {
    na_type <- NA_character_
  }
  
  if (inherits(x, "integer")) {
    na_type <- NA_integer_
  }
  
  if (inherits(x, "numeric")) {
    na_type <- NA_real_
  }
  
  na_type
}