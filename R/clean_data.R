################################################################################
#
#'
#' Clean respondent data
#'
#'
#
################################################################################

clean_respondent_data <- function(respondent_data) {
  x <- respondent_data |>
    subset(as.Date(today) > as.Date("2022-04-03")) |>
    dplyr::mutate(
      mweight = ifelse(mpeso == 0, NA, mpeso),
      mheight = ifelse(maltura == 0, NA, maltura),
      mmuac = ifelse(mbraco == 0, NA, mbraco)
    )
  
  ## Return
  x
}

################################################################################
#
#'
#' Clean child data
#'
#
################################################################################

clean_child_data <- function(child_data) {
  x <- child_data |>
    subset(as.Date(today) > as.Date("2022-04-03")) |>
    dplyr::mutate(
      cweight = ifelse(cpeso == 0, NA, cpeso),
      cheight = ifelse(caltura == 0, NA, caltura),
      cmuac = ifelse(cbraco == 0, NA, cbraco),
      cweight1 = ifelse(flag == 1, cpeso1, cpeso),
      cheight1 = ifelse(flag == 1, caltura1, caltura),
      cmuac1 = ifelse(flag == 1, cbraco1, cbraco),
      age_years = ifelse(
        is.na(child_birthdate),
        child_age / 12,
        (as.Date(today) - as.Date(child_birthdate)) / 365.25
      ),
      age_months = ifelse(
        is.na(child_birthdate),
        child_age,
        (as.Date(today) - as.Date(child_birthdate)) / (365.25 / 12)
      ),
      age_days = ifelse(
        is.na(child_birthdate),
        child_age * (365.25 / 12),
        as.Date(today) - as.Date(child_birthdate)
      )
    )
  
  ## Return
  x
}


################################################################################
#
#'
#' Clean FGH Identifiers
#' 
#' @param .data Data.frame to get information on FGH identifiers to clean.
#'   Default to respondent_data_clean
#' @param sample_list Data.frame of enumeration areas for endline survey with
#'   information on FGH identifiers. Default to endline_sample_list
#' @param moz_country sp class object for Mozambique to use for getting 
#'   CRS value.
#'   
#'
#
################################################################################




clean_fgh_id <- function(.data = respondent_data_clean, 
                         sample_list = endline_sample_list, 
                         moz_country) {
  ## Create df of geocoordinates per FGH ID
  geocoordinates <- .data |>
    subset(select = c(id, today, enumid, fgh_id)) |>
    (\(x) 
     data.frame(
       x, 
       "fgh_id_match" = ifelse(
         x$fgh_id %in% sample_list[["FGH_ID"]], TRUE, FALSE
        )
      )
    )() |>
    data.frame(do.call(rbind, respondent_data_clean$geolocation)) |>
    (\(x) 
      { 
        names(x) <- c(
          "id", "today", "enumid", "fgh_id", "fgh_id_match", 
          "latitude", "longitude"
        )
        x 
      }
    )()
  
  ##
  x <- geocoordinates |>
    dplyr::filter(fgh_id_match)
  
  ##
  y <- geocoordinates |>
    dplyr::filter(!fgh_id_match)
  
  y_sp <- sp::SpatialPoints(
    coords = y[ , c("longitude", "latitude")], 
    sp::CRS(sf::as_Spatial(moz_country) |> sp::proj4string())
  )
  
  ##
  z <- spatialsampler::get_nearest_point(
    data = x, data.x = "longitude", data.y = "latitude", 
    query = y_sp, duplicate = TRUE
  ) |>
    dplyr::select(fgh_id) |>
    dplyr::rename(new_fgh_id = fgh_id) |>
    (\(x) dplyr::bind_cols(y, x))() |>
    dplyr::select(id, enumid, fgh_id, new_fgh_id)
    
  ## Return
  z
}



create_fgh_geo <- function(.data = respondent_data_clean, 
                           sample_list = endline_sample_list) {
  ## Create df of geocoordinates per FGH ID
  geocoordinates <- .data |>
    subset(select = c(id, today, enumid, fgh_id)) |>
    (\(x) 
     data.frame(
       x, 
       "fgh_id_match" = ifelse(
         x$fgh_id %in% sample_list[["FGH_ID"]], TRUE, FALSE
       )
     )
    )() |>
    data.frame(do.call(rbind, .data$geolocation)) |>
    (\(x) 
     { 
       names(x) <- c(
         "id", "today", "enumid", "fgh_id", "fgh_id_match", 
         "latitude", "longitude"
       )
       x 
    }
    )()
  
  ##
  geocoordinates
}

################################################################################
#
#'
#'
#'
#'
#
################################################################################

subset_fgh_geo <- function(fgh, df = respondent_data_clean) {
  geo_sp <- sp::SpatialPointsDataFrame(
    coords = df[ , c("longitude", "latitude")],
    data = df, 
    proj4string = sp::CRS("+proj=longlat +datum=WGS84 +no_defs")
  ) |>
    subset(fgh_id == fgh | !fgh_id_match)

  no_match <- df |>
    subset(!fgh_id_match)
  
  sp::plot(
    geo_sp |> subset(fgh_id == fgh), 
    pch = NA,
    main = fgh,
    cex.main = 2
  )
  
  sp::plot(
    geo_sp,
    #pch = "x",
    col = ifelse(geo_sp$fgh_id_match, "darkgreen", "red"),
    cex = 2,
    add = TRUE
  )
  
  #box()
  
  text(
    no_match[, c("longitude", "latitude")],
    labels = no_match$fgh_id,
    cex = 2,
    pos = 4,
    offset = 1
  )
}

