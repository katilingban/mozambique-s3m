################################################################################
#
#'
#' 
#'
#
################################################################################

summarise_univariate_outliers_mother <- function(outlier_weight_mother,
                                                 outlier_height_mother,
                                                 outlier_muac_mother) {
  n_outlier_weight <- nrow(outlier_weight_mother)
  n_outlier_height <- nrow(outlier_height_mother)
  n_outlier_muac <- nrow(outlier_muac_mother)
  
  x <- c("Weight outlier", "Height outlier", "MUAC outlier") |>
    data.frame(
      c(n_outlier_weight, n_outlier_height, n_outlier_muac)
    )
  
  names(x) <- c("Outlier type", "n")
  
  x
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_univariate_outliers_mother <- function(outlier_weight_mother,
                                             outlier_height_mother,
                                             outlier_muac_mother) {
  x <- outlier_weight_mother |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "mweight", "mheight", "mmuac")])()
  
  y <- outlier_height_mother |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "mweight", "mheight", "mmuac")])()
  
  z <- outlier_muac_mother |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "mweight", "mheight", "mmuac")])()
  
  xyz <- rbind(x, y, z) |>
    dplyr::mutate(
      weight_outlier = ifelse(id %in% x$id, "red", "black"),
      height_outlier = ifelse(id %in% y$id, "red", "black"),
      muac_outlier = ifelse(id %in% z$id, "red", "black")
    ) |>
    (\(x) x[!duplicated(x), ])()
  
  xyz$today <- as.Date(xyz$today)
  
  xyz <- xyz[order(xyz$today), ]
  
  xyz
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_unique_univariate_outliers_mother <- function(outlier_table_univariate_mother,
                                                    raw_data_clean) {
  n <- nrow(outlier_table_univariate_mother)
  
  p <- (n / nrow(raw_data_clean)) |>
    scales::percent(accuracy = 0.1)
  
  list(
    n = n,
    p = p
  )
}


################################################################################
#
#'
#'
#'
#
################################################################################

summarise_bivariate_outliers_mother <- function(outlier_weight_height_mother,
                                                outlier_weight_muac_mother,
                                                outlier_height_muac_mother) {
  n_outlier_weight_height <- nrow(outlier_weight_height_mother)
  n_outlier_weight_muac <- nrow(outlier_weight_muac_mother)
  n_outlier_height_muac <- nrow(outlier_height_muac_mother)
  
  x <- c("Weight by height outlier", 
         "Weight by MUAC outlier", 
         "Height by MUAC outlier") |>
    data.frame(
      c(n_outlier_weight_height, n_outlier_weight_muac, n_outlier_height_muac)
    )
  
  names(x) <- c("Outlier type", "n")
  
  x
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_bivariate_outliers_mother <- function(outlier_weight_height_mother,
                                            outlier_weight_muac_mother,
                                            outlier_height_muac_mother) {
  x <- outlier_weight_height_mother |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "mweight", "mheight", "mmuac")])()
  
  y <- outlier_weight_muac_mother |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "mweight", "mheight", "mmuac")])()
  
  z <- outlier_height_muac_mother |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "mweight", "mheight", "mmuac")])()
  
  xyz <- rbind(x, y, z) |>
    dplyr::mutate(
      weight_outlier = ifelse(id %in% c(x$id, y$id), "red", "black"),
      height_outlier = ifelse(id %in% c(x$id, z$id), "red", "black"),
      muac_outlier = ifelse(id %in% c(y$id, z$id), "red", "black")
    ) |>
    (\(x) x[!duplicated(x), ])()
  
  xyz$today <- as.Date(xyz$today)
  
  xyz <- xyz[order(xyz$today), ]
  
  xyz
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_unique_bivariate_outliers_mother <- function(outlier_table_bivariate_mother,
                                                  raw_data_clean) {
  n <- nrow(outlier_table_bivariate_mother)
  
  p <- (n / nrow(raw_data_clean)) |>
    scales::percent(accuracy = 0.1)
  
  list(
    n = n,
    p = p
  )
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_total_unique_outliers_mother <- function(outlier_table_univariate_mother,
                                               outlier_table_bivariate_mother,
                                               raw_data_clean) {
  x <- rbind(
    outlier_table_univariate_mother,
    outlier_table_bivariate_mother
  ) |>
    (\(x) x[!duplicated(x), ])()
    
  n <- nrow(x)
  
  p <- (n / nrow(raw_data_clean)) |>
    scales::percent(accuracy = 0.1)
  
  list(
    n = n,
    p = p
  )
}


################################################################################
#
#'
#' 
#'
#
################################################################################

summarise_univariate_outliers <- function(outlier_weight,
                                          outlier_height,
                                          outlier_muac) {
  n_outlier_weight <- nrow(outlier_weight)
  n_outlier_height <- nrow(outlier_height)
  n_outlier_muac <- nrow(outlier_muac)
  
  x <- c("Weight outlier", "Height outlier", "MUAC outlier") |>
    data.frame(
      c(n_outlier_weight, n_outlier_height, n_outlier_muac)
    )
  
  names(x) <- c("Outlier type", "n")
  
  x
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_univariate_outliers <- function(outlier_weight,
                                      outlier_height,
                                      outlier_muac) {
  x <- outlier_weight |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  y <- outlier_height |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  z <- outlier_muac |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  xyz <- rbind(x, y, z) |>
    dplyr::mutate(
      weight_outlier = ifelse(id %in% x$id, "red", "black"),
      height_outlier = ifelse(id %in% y$id, "red", "black"),
      muac_outlier = ifelse(id %in% z$id, "red", "black")
    ) |>
    (\(x) x[!duplicated(x), ])()
  
  xyz$age_months <- floor(xyz$age_months)
  
  xyz$today <- as.Date(xyz$today)
  
  xyz <- xyz[order(xyz$today), ]
  
  xyz
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_univariate_outliers_adj <- function(outlier_weight_adj,
                                          outlier_height_adj,
                                          outlier_muac_adj) {
  x <- outlier_weight_adj |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight1", "cheight1", "cmuac1", "age_months", "flag")])()
  
  y <- outlier_height_adj |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight1", "cheight1", "cmuac1", "age_months", "flag")])()
  
  z <- outlier_muac_adj |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight1", "cheight1", "cmuac1", "age_months", "flag")])()
  
  xyz <- rbind(x, y, z) |>
    dplyr::mutate(
      weight_outlier = ifelse(id %in% x$id, "red", "black"),
      height_outlier = ifelse(id %in% y$id, "red", "black"),
      muac_outlier = ifelse(id %in% z$id, "red", "black")
    ) |>
    (\(x) x[!duplicated(x), ])()
  
  xyz$age_months <- floor(xyz$age_months)
  
  xyz$today <- as.Date(xyz$today)
  
  xyz <- xyz[order(xyz$today), ]
  
  xyz
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_unique_univariate_outliers <- function(outlier_table_univariate,
                                             raw_data_clean) {
  n <- nrow(outlier_table_univariate)
  
  p <- (n / nrow(raw_data_clean)) |>
    scales::percent(accuracy = 0.1)
  
  list(
    n = n,
    p = p
  )
}


################################################################################
#
#'
#'
#'
#
################################################################################

summarise_bivariate_outliers <- function(outlier_weight_height,
                                         outlier_weight_muac,
                                         outlier_height_muac,
                                         outlier_weight_age,
                                         outlier_height_age,
                                         outlier_muac_age) {
  n_outlier_weight_height <- nrow(outlier_weight_height)
  n_outlier_weight_muac <- nrow(outlier_weight_muac)
  n_outlier_height_muac <- nrow(outlier_height_muac)
  n_outlier_weight_age <- nrow(outlier_weight_age)
  n_outlier_height_age <- nrow(outlier_height_age)
  n_outlier_muac_age <- nrow(outlier_muac_age)
  
  x <- c("Weight by height outlier", "Weight by MUAC outlier", 
         "Height by MUAC outlier", "Weight by age outlier", 
         "Height by age outiler", "MUAC by age outlier") |>
    data.frame(
      c(n_outlier_weight_height, n_outlier_weight_muac, n_outlier_height_muac, 
        n_outlier_weight_age, n_outlier_height_age, n_outlier_muac_age)
    )
  
  names(x) <- c("Outlier type", "n")
  
  x
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_bivariate_outliers <- function(outlier_weight_height,
                                     outlier_weight_muac,
                                     outlier_height_muac,
                                     outlier_weight_age,
                                     outlier_height_age,
                                     outlier_muac_age) {
  x <- outlier_weight_height |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  y <- outlier_weight_muac |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  z <- outlier_height_muac |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  a <- outlier_weight_age |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  b <- outlier_height_age |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  c <- outlier_muac_age |>
    (\(x) x[ , c("today", "id", "ad2", "ad3", "cweight", "cheight", "cmuac", "age_months", "flag")])()
  
  xyzabc <- rbind(x, y, z, a, b, c) |>
    dplyr::mutate(
      weight_outlier = ifelse(id %in% c(x$id, y$id, a$id), "red", "black"),
      height_outlier = ifelse(id %in% c(x$id, z$id, b$id), "red", "black"),
      muac_outlier = ifelse(id %in% c(y$id, z$id, c$id), "red", "black"),
      age_outlier = ifelse(id %in% c(a$id, b$id, c$id), "red", "black")
    ) |>
    (\(x) x[!duplicated(x), ])()
  
  xyzabc$age_months <- floor(xyzabc$age_months)
  
  xyzabc$today <- as.Date(xyzabc$today)
  
  xyzabc <- xyzabc[order(xyzabc$today), ]
  
  xyzabc
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_unique_bivariate_outliers <- function(outlier_table_bivariate,
                                            raw_data_clean) {
  n <- nrow(outlier_table_bivariate)
  
  p <- (n / nrow(raw_data_clean)) |>
    scales::percent(accuracy = 0.1)
  
  list(
    n = n,
    p = p
  )
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_total_unique_outliers <- function(outlier_table_univariate,
                                        outlier_table_bivariate,
                                        raw_data_clean) {
  x <- rbind(
    outlier_table_univariate,
    outlier_table_bivariate
  ) |>
    (\(x) x[!duplicated(x), ])()
  
  n <- nrow(x)
  
  p <- (n / nrow(raw_data_clean)) |>
    scales::percent(accuracy = 0.1)
  
  list(
    n = n,
    p = p
  )
}


################################################################################
#
#'
#' Boxplot for weight, height and MUAC
#'
#
################################################################################

plot_anthro_outliers <- function(.data = child_data) {
  withr::with_par(
    new = list(par(mfrow = c(1, 3))),
    {
      with(.data, 
           {
             #boxplot(age, width = 5, ylab = "Age (months)")
             boxplot(cweight, width = 3, ylab = "kgs", main = "Weight", cex.main = 2, cex.lab = 1.5)
             boxplot(cheight, width = 3, ylab = "cms", main = "Height", cex.main = 2, cex.lab = 1.5)
             boxplot(cmuac, width = 3, ylab = "cms", main = "MUAC", cex.main = 2, cex.lab = 1.5)
           }
      )
    }
  )
}


################################################################################
#
#'
#' Plot bivariate outliers
#'
#
################################################################################

plot_anthro_bivariate <- function(.data = raw_data_clean,
                                  outlier_weight_height,
                                  outlier_weight_muac, 
                                  outlier_height_muac, 
                                  outlier_weight_age,
                                  outlier_height_age, 
                                  outlier_muac_age) {
  withr::with_par(
    new = list(par(mfrow = c(1, 3))),
    {
      with(
        .data,
        {
          plot(
            cweight, cheight, 
            pch = ifelse(id %in% outlier_weight_height$id, 20, 1), 
            col = ifelse(id %in% outlier_weight_height$id, "red", "black"),
            main = "Weight by Height",
            xlab = "Weight (kgs)", ylab = "Height (cms)",
            cex.main = 2, cex.lab = 1.5
          )
          plot(
            cweight, cmuac,
            pch = ifelse(id %in% outlier_weight_muac$id, 20, 1), 
            col = ifelse(id %in% outlier_weight_muac$id, "red", "black"),
            main = "Weight by MUAC",
            xlab = "Weight (kgs)", ylab = "MUAC (cms)",
            cex.main = 2, cex.lab = 1.5
          )
          plot(
            cheight, cmuac,
            pch = ifelse(id %in% outlier_height_muac$id, 20, 1), 
            col = ifelse(id %in% outlier_height_muac$id, "red", "black"),
            main = "Height by MUAC",
            xlab = "Height (cms)", ylab = "MUAC (cms)",
            cex.main = 2, cex.lab = 1.5
          )
          plot(
            age_months, cweight,
            pch = ifelse(id %in% outlier_weight_age$id, 20, 1), 
            col = ifelse(id %in% outlier_weight_age$id, "red", "black"),
            main = "Weight by Age",
            xlab = "Age (months)", ylab = "Weight (kgs)",
            cex.main = 2, cex.lab = 1.5
          )
          plot(
            age_months, cheight,
            pch = ifelse(id %in% outlier_height_age$id, 20, 1), 
            col = ifelse(id %in% outlier_height_age$id, "red", "black"),
            main = "Height by Age",
            xlab = "Age (months)", ylab = "Height (cms)",
            cex.main = 2, cex.lab = 1.5
          )
          plot(
            age_months, cmuac,
            pch = ifelse(id %in% outlier_muac_age$id, 20, 1), 
            col = ifelse(id %in% outlier_muac_age$id, "red", "black"),
            main = "MUAC by Age",
            xlab = "Age (months)", ylab = "MUAC (cms)",
            cex.main = 2, cex.lab = 1.5
          )
        }
      )
    }
  )
}


################################################################################
#
#'
#' Calculate z-scores and flag problematic values
#'
#
################################################################################

calculate_zscore <- function(.data = raw_data_clean) {
  ## Calculate z-score and apply WHO flagging criteria
  child_data_zscore <- .data |>
    zscorer::addWGSR(
      sex = "sex",
      firstPart = "cweight",
      secondPart = "age_days",
      index = "wfa"
    ) |>
    zscorer::addWGSR(
      sex = "sex",
      firstPart = "cheight",
      secondPart = "age_days",
      standing = "position",
      index = "hfa"
    ) |>
    zscorer::addWGSR(
      sex = "sex",
      firstPart = "cweight",
      secondPart = "cheight",
      standing = "position",
      index = "wfh"
    ) |>
    dplyr::mutate(
      flag_hfaz = ifelse(hfaz < -6 | hfaz > 6, 1, 0),
      flag_hfaz = ifelse(
        is.na(hfaz) & !is.na(cheight) & !is.na(cweight), 1, flag_hfaz
      ),
      flag_wfhz = ifelse(wfhz < -5 | wfhz > 5, 2, 0),
      flag_wfhz = ifelse(
        is.na(wfhz) & !is.na(cweight) & !is.na(cheight), 2, flag_wfhz
      ),
      flag_wfaz = ifelse(wfaz < -6 | wfaz > 5, 4, 0),
      flag_wfaz = ifelse(
        is.na(wfaz) & !is.na(cweight) & !is.na(height), 4, flag_wfaz
      ),
      flag_zscore = ifelse(
        is.na(cweight) & is.na(cheight), 
        NA,
        flag_hfaz + flag_wfhz + flag_wfaz
      ),
      flag_description = ifelse(flag_zscore == 0, "No flagged measurements",
        ifelse(flag_zscore == 1, "Check height and age measurements",
          ifelse(flag_zscore == 2, "Check weight and height measurements",
            ifelse(flag_zscore == 3, "Check height measurement",
              ifelse(flag_zscore == 4, "Check weight and age measurements",
                ifelse(flag_zscore == 5, "Check age measurement",
                  ifelse(flag_zscore == 6, "Check weight measurement",
                    "Check age, height and weight measurements"
                  )
                )
              )
            )
          )
        )
      )
    )

  ## Return
  tibble::tibble(child_data_zscore)
}


################################################################################
#
#'
#'
#'
#'
#
################################################################################

calculate_zscore_adj <- function(.data = raw_data_clean) {
  ## Calculate z-score and apply WHO flagging criteria
  child_data_zscore <- .data |>
    zscorer::addWGSR(
      sex = "sex",
      firstPart = "cweight1",
      secondPart = "age_days",
      index = "wfa"
    ) |>
    zscorer::addWGSR(
      sex = "sex",
      firstPart = "cheight1",
      secondPart = "age_days",
      standing = "position",
      index = "hfa"
    ) |>
    zscorer::addWGSR(
      sex = "sex",
      firstPart = "cweight1",
      secondPart = "cheight1",
      standing = "position",
      index = "wfh"
    ) |>
    dplyr::mutate(
      flag_hfaz = ifelse(hfaz < -6 | hfaz > 6, 1, 0),
      flag_hfaz = ifelse(
        is.na(hfaz) & !is.na(cheight1) & !is.na(cweight1), 1, flag_hfaz
      ),
      flag_wfhz = ifelse(wfhz < -5 | wfhz > 5, 2, 0),
      flag_wfhz = ifelse(
        is.na(wfhz) & !is.na(cweight1) & !is.na(cheight1), 2, flag_wfhz
      ),
      flag_wfaz = ifelse(wfaz < -6 | wfaz > 5, 4, 0),
      flag_wfaz = ifelse(
        is.na(wfaz) & !is.na(cweight1) & !is.na(height1), 4, flag_wfaz
      ),
      flag_zscore = ifelse(
        is.na(cweight1) & is.na(cheight1), 
        NA,
        flag_hfaz + flag_wfhz + flag_wfaz
      ),
      flag_description = ifelse(flag_zscore == 0, "No flagged measurements",
        ifelse(flag_zscore == 1, "Check height and age measurements",
          ifelse(flag_zscore == 2, "Check weight and height measurements",
            ifelse(flag_zscore == 3, "Check height measurement",
              ifelse(flag_zscore == 4, "Check weight and age measurements",
                ifelse(flag_zscore == 5, "Check age measurement",
                  ifelse(flag_zscore == 6, "Check weight measurement",
                    "Check age, height and weight measurements"
                  )
                )
              )
            )
          )
        )
      )
    )

  ## Return
  tibble::tibble(child_data_zscore)
}


################################################################################
#
# Skew and kurtosis
#
################################################################################



################################################################################
#
#'
#'
#'
#
################################################################################

classify_age_heaping <- function(age_heaping) {
  ifelse(
    age_heaping$p < 0.05, 
    paste0("Marked age heaping at whole years (p = ", round(age_heaping$p, 4), ")"),
    paste0("No marked age heaping at whole years (p = ", round(age_heaping$p, 4), ")")
  )
}




################################################################################
#
#'
#' Calculate u5mr
#'
#
################################################################################

calculate_u5mr_census <- function(pop = c(1072751, 1027673, 991164, 967276, 953438),
                                  .data = child_data) {
  ep <- pop / sum(pop)
  expected <- ep * nrow(.data)
  t <- 0:4 
  x <- lm(log(pop) ~ t)
  u5mr <- (abs(x$coefficients[2]) / 365.25) * 10000
  u5mr
}


################################################################################
#
#'
#' Age ratio
#'
#'
#
################################################################################

calculate_age_ratio <- function(.data = child_data) {
  .data <- .data |>
    dplyr::mutate(
      age_months = ifelse(
        is.na(child_birthdate), 
        child_age, 
        (as.Date(today) - as.Date(child_birthdate)) / (365.25 / 12)
      )
    ) |>
    dplyr::filter(age_months >= 6 & age_months < 60)
  
  ageGroup <- with(.data,
                   {
                     ifelse(age %in% 6:29, 1, 2)                 
                   }
  )
  
  age_ratio <- sum(ageGroup == 1) / sum(ageGroup == 2)
  
  age_ratio
}


################################################################################
#
#'
#' Age model
#'
#'
#
################################################################################

calculate_age_model <- function(.data = child_data, u5mr = u5mr_census) {
  .data <- .data |>
    dplyr::mutate(
      age_years = ifelse(
        is.na(child_birthdate), 
        child_age, 
        (as.Date(today) - as.Date(child_birthdate)) / (365.25 / 12)
      )
    ) |>
    dplyr::filter(age_months >= 6 & age_months < 60)
  
  ageGroup <- with(.data,
                   {
                     ifelse(age %in% 6:29, 1, 2)                 
                   }
  )
  
  age_ratio <- sum(ageGroup == 1) / sum(ageGroup == 2)
  
  age_ratio
}



################################################################################
#
#' 
#' Plot age by sex structure
#'
#
################################################################################

plot_age_structure <- function(.data = raw_data_clean) {
  .data <- .data |>
    dplyr::filter(age_months >= 6 & age_months < 60) |>
    dplyr::mutate(
      age_group = cut(
        age_months, 
        breaks = c(0, 17, 29, 41, 53, 59),
        labels = c("6 to 17", "18 to 29", "30 to 41", "42 to 53", "54 to 59"))
    )
  
  pyramid.plot(
    .data$age_group, .data$sex, 
    main = "Age group (months)", 
    xlab = "Frequency (Males | Females)", 
    ylab = "Year-centred age-group", 
    cex.names = 0.9
  )
}


