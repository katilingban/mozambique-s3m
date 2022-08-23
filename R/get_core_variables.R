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
