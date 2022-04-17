################################################################################
#
#'
#' Tally records by EA
#'
#
################################################################################

tally_ea_total <- function(raw_data, selected_ea_complete) {
  x <- data.frame(table(raw_data$ea_code)) 
  x[ , 1] <- as.character(x[ , 1])
  
  y <- selected_ea_complete$AES
  
  rbind(
    x, 
    data.frame(
      Var1 = c("Total", "Total records with incorrect EA CODE"),
      Freq = c(sum(x$Freq), sum(x$Freq[!x$Var1 %in% y]))
    )
  )
}


################################################################################
#
#'
#' Tally records by SP
#'
#
################################################################################

tally_sp_total <- function(raw_data, selected_ea_complete) {
  x <- data.frame(table(raw_data$spid)) 
  x[ , 1] <- as.character(x[ , 1])
  
  y <- selected_ea_complete$spid
  
  rbind(
    x, 
    data.frame(
      Var1 = c("Total", "Total records with incorrect SP ID"),
      Freq = c(sum(x$Freq), sum(x$Freq[!x$Var1 %in% y]))
    )
  )
}


################################################################################
#
#'
#' Tally records by EA by date
#'
#
################################################################################

tally_ea_date_total <- function(raw_data, selected_ea_complete) {
  x <- cbind(
    table(raw_data$ea_code, raw_data$today)
  ) 
  
  y <- data.frame(x)
  names(y) <- colnames(x)
  
  Total <- colSums(y)
  `Total records with incorrect EA code per day` <- 
    colSums(y[!row.names(y) %in% selected_ea_complete$AES, ])

  
  z <- rbind(
    y, 
    Total, 
    `Total records with incorrect EA code per day`
  )
  
  `EA Code` <- row.names(z)
  
  z <- cbind(
    `EA Code`, 
    z,
    `Total records by EA code per day` = rowSums(z)
  )
  
  z$`EA Code`[nrow(z) - 1] <- "Total"
  z$`EA Code`[nrow(z)] <- "Total records with incorrect EA code per day"
  
  z
}


################################################################################
#
#'
#' Tally records by SP by date
#'
#
################################################################################

tally_sp_date_total <- function(raw_data, selected_ea_complete) {
  x <- cbind(
    table(raw_data$spid, raw_data$today)
  ) 
  
  y <- data.frame(x)
  names(y) <- colnames(x)
  
  Total <- colSums(y)
  `Total records with incorrect SP ID per day` <- 
    colSums(y[!row.names(y) %in% selected_ea_complete$spid, ])
  
  
  z <- rbind(
    y, 
    Total, 
    `Total records with incorrect SP ID per day`
  )
  
  `SP ID` <- row.names(z)
  
  z <- cbind(
    `SP ID`, 
    z,
    `Total records by SP ID per day` = rowSums(z)
  )
  
  z$`SP ID`[nrow(z) - 1] <- "Total"
  z$`SP ID`[nrow(z)] <- "Total records with incorrect SP ID per day"
  
  z
}


################################################################################
#
#'
#' Tally records by survey teams
#'
#
################################################################################

tally_team_total <- function(raw_data) {
  x <- data.frame(table(raw_data$ad2)) 

  rbind(
    x, 
    data.frame(
      Var1 = "Total",
      Freq = sum(x$Freq)
    )
  )
}


################################################################################
#
#'
#' Tally records by survey teams by date
#'
#
################################################################################

tally_team_date_total <- function(raw_data) {
  x <- cbind(
    table(raw_data$ad2, raw_data$today)
  ) 
  
  y <- data.frame(x)
  names(y) <- colnames(x)
  
  Total <- colSums(y)
  
  z <- rbind(y, Total)
  
  `Survey Team` <- row.names(z)
  
  z <- cbind(
    `Survey Team`, 
    z,
    `Total records by Survey Team per day` = rowSums(z)
  )
  
  z$`Survey Team`[nrow(z)] <- "Total"

  z
}


################################################################################
#
#'
#' Map of records by enumeration areas
#'
#
################################################################################

check_ea_geo <- function(ea, raw_data, complete_ea_sf) {
  geo_sf <- raw_data |>
    subset(!is.na(spid)) |>
    (\(x) data.frame(x[ , c("ad2", "ea_code")], do.call(rbind, x$geolocation)))() |>
    (\(x) { names(x) <- c("ad2", "ea_code", "longitude", "latitude"); x })() |>
    sf::st_as_sf(
      coords = c("longitude", "latitude"),
      crs = 4326
    ) |>
    subset(ea_code == ea)
  
  ea_sf <- complete_ea_sf |>
    subset(AES == ea)

  plot(
    sf::st_geometry(geo_sf),
    pch = "x",
    col = "darkgreen",
    cex = 1,
    main = unique(geo_sf$ea_code),
    cex.main = 2
  )
  
  plot(
    sf::st_geometry(ea_sf),
    lwd = 1.5,
    border = "blue",
    add = TRUE
  )
}


check_ea <- function(ea, raw_data, complete_ea_sf) {
  geo_sf <- raw_data |>
    subset(!is.na(spid)) |>
    (\(x) data.frame(x[ , c("id", "ad2", "ea_code")], do.call(rbind, x$geolocation)))() |>
    (\(x) { names(x) <- c("id", "ad2", "ea_code", "longitude", "latitude"); x })() |>
    sf::st_as_sf(
      coords = c("longitude", "latitude"),
      crs = 4326
    ) |>
    subset(ea_code == ea)
  
  ea_sf <- complete_ea_sf |>
    subset(AES == ea)
  
  test_ea <- sf::st_join(
    geo_sf, ea_sf, join = sf::st_within
  )
  
  eas_within <- table(test_ea$AES) |>
    data.frame()
  
  if (nrow(eas_within) == 0) {
    eas_within <- data.frame(ea, 0)
  }
  
  eas_within <- data.frame(
    ea = eas_within[ , 1],
    n_in = eas_within[ , 2],
    n_out = nrow(geo_sf) - eas_within[ , 2], 
    total = nrow(geo_sf)
  )

  eas_within
}


check_ea_table <- function(ea, raw_data, complete_ea_sf, check = c("in", "out")) {
  check <- match.arg(check)
  
  geo_sf <- raw_data |>
    subset(!is.na(spid)) |>
    (\(x) data.frame(x[ , c("id", "ad2", "ad3", "ea_code")], do.call(rbind, x$geolocation)))() |>
    (\(x) { names(x) <- c("id", "ad2", "ad3", "ea_code", "longitude", "latitude"); x })() |>
    sf::st_as_sf(
      coords = c("longitude", "latitude"),
      crs = 4326
    ) |>
    subset(ea_code == ea)
  
  ea_sf <- complete_ea_sf |>
    subset(AES == ea)
  
  test_ea <- sf::st_join(
    geo_sf, ea_sf, join = sf::st_within
  )
  
  ## Format output
  if (check == "in") {
    test_ea <- test_ea |>
      subset(!is.na(AES))
  } else {
    test_ea <- test_ea |>
      subset(is.na(AES))
  }
  
  ## Convert to tibble
  test_ea_table <- raw_data |>
    subset(
      subset = id %in% test_ea$id,
      select = c(id, ad2, ad3, today, ea_code)
    ) |>
    (\(x) x[order(x$today), ])()
  
  ## Return
  test_ea_table
}

