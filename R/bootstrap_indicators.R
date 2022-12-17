################################################################################
#
#'
#' Apply blocked weighted bootstrap to indicator datasets
#'
#' A wrapper for \code{bootBW} function in \code{bbw} package.
#'
#' @param indicator A character vector of indicator data.frame names
#' @param county An integer indicating which county to interpolate; 1 for
#'   Greater Monrovia; 2 for Grand Bassa
#' @param w Population dataset
#' @param replicates Number of bootstrap replicates
#' @param core.columns A vector of variable names included in indicator
#'   data.frames
#'
#' @return A data.frame of indicator estimates with lower and upper confidence
#'   limits
#'
#' @examples
#' boot_estimate(indicator = "iycfDF", county = 1, w = psuDataGM, replicates = 9)
#'
#' @export
#'
#
################################################################################

boot_estimate <- function(.data,
                          w,
                          statistic = bbw::bootClassic,
                          vars,
                          labs,
                          indicator_set,
                          replicates = 399) {
  currentDF <- .data[c("spid", "ea_code", "district", vars)] |>
    (\(x) x[!is.na(x$spid) & x$spid != 0, ])()
  
  ##
  params <- vars
    
  ## Rename "eid" to psu
  colnames(currentDF)[1] <- "psu"
  
  w <- w[w$psu %in% currentDF$psu, ]
  
  ##
  outputColumns <- params
    
  ##
  temp <- bbw::bootBW(
    x = currentDF, 
    w = w,
    statistic = statistic,
    params = params,
    outputColumns = outputColumns,
    replicates = replicates
  )
    
  est <- apply(
    X = temp, 
    MARGIN = 2, 
    FUN = quantile,
    probs = c(0.5, 0.025, 0.975), na.rm = TRUE
  )
  
  se <- apply(
    X = temp,
    MARGIN = 2,
    FUN = sd
  )
  
  est <- t(est)
    
  est <- data.frame(
    unique(currentDF$district), indicator_set, vars, labs, est, se
  )
  
  row.names(est) <- 1:nrow(est)
    
  names(est) <- c(
    "district", "indicator_set", "indicator_variable", 
    "indicator", "estimate", "lcl", "ucl", "sd"
  )
  
  est
}

## Bootstrap estimation by district --------------------------------------------

boot_estimates <- function(.data, 
                           w,
                           statistic = bbw::bootClassic,
                           vars, labs, indicator_set,
                           replicates = 399) {
  .data         <- split(x = .data, f = .data$district)
  w             <- rep(list(w), length(.data)) 
  statistic     <- rep(list(statistic), length(.data))
  vars          <- rep(list(vars), length(.data))
  labs          <- rep(list(labs), length(.data))
  indicator_set <- rep(list(indicator_set), length(.data))

  parallel::mcMap(
    f = boot_estimate,
    .data = .data,
    w = w,
    statistic = statistic,
    vars = vars,
    labs = labs,
    indicator_set = indicator_set,
    replicates = replicates,
    mc.cores = 4
  ) |>
    (\(x) do.call(rbind, x))() |>
    (\(x) { row.names(x) <- 1:nrow(x); x })()
}

## Specific bootstrap functions for household indicators groups/sets -----------

boot_estimates_household <- function(.data, w, 
                                     replicates = 399, 
                                     indicator_list) {
  boot_estimates(
    .data = .data,
    w = w,
    vars = indicator_list[["indicator_variable"]],
    labs = indicator_list[["indicator"]],

    indicator_set = indicator_list[["indicator_set"]],
    replicates = replicates
  )
}

## Specific bootstrap functions for carer indicators groups/sets ---------------

boot_estimates_carer <- function(.data, w, 
                                 replicates = 399, indicator_list) {
  boot_estimates(
    .data = .data,
    w = w,
    vars = indicator_list[["indicator_variable"]],
    labs = indicator_list[["indicator"]],
    indicator_set = indicator_list[["indicator_set"]],
    replicates = replicates
  )
}

## Specific bootstrap functions for woman indicators groups/sets ---------------

boot_estimates_woman <- function(.data, w, 
                                 replicates = 399, indicator_list) {
  boot_estimates(
    .data = .data,
    w = w,
    vars = indicator_list[["indicator_variable"]],
    labs = indicator_list[["indicator"]],
    indicator_set = indicator_list[["indicator_set"]],
    replicates = replicates
  )
}

## Specific bootstrap functions for child indicators groups/sets ---------------

boot_estimates_child <- function(.data, w, 
                                 replicates = 399, indicator_list) {
  boot_estimates(
    .data = .data,
    w = w,
    vars = indicator_list[["indicator_variable"]],
    labs = indicator_list[["indicator"]],
    indicator_set = indicator_list[["indicator_set"]],
    replicates = replicates
  )
}

## Bootstrap probit a single district ------------------------------------------

boot_probit <- function(.data,
                        w,
                        vars,
                        labs,
                        indicator_set,
                        THRESHOLD,
                        replicates = 399) {
  currentDF <- .data[c("spid", "ea_code", "district", vars[1:2])] |>
    (\(x) x[!is.na(x$spid) & x$spid != 0, ])()
  
  ##
  params <- vars[1:2]
  
  ## Rename "eid" to psu
  colnames(currentDF)[1] <- "psu"
  
  w <- w[w$psu %in% currentDF$psu, ]
  
  ##
  outputColumns <- params
  
  bootPROBIT <- function(x, params, threshold = THRESHOLD) {
    d <- x[[params[1]]]
    m <- median(d, na.rm = TRUE)
    s <- IQR(d, na.rm = TRUE) / 1.34898
    x <- pnorm(q = threshold, mean = m, sd = s)
    return(x)
  }
  
  ##
  temp <- bbw::bootBW(
    x = currentDF, 
    w = w,
    statistic = bootPROBIT,
    params = params,
    outputColumns = outputColumns,
    replicates = replicates
  )
  
  temp <- data.frame(
    global = temp[[1]],
    moderate = temp[[1]] - temp[[2]],
    severe = temp[[2]]
  )
  
  est <- apply(
    X = temp, 
    MARGIN = 2, 
    FUN = quantile,
    probs = c(0.5, 0.025, 0.975), na.rm = TRUE
  )
  
  se <- apply(
    X = temp,
    MARGIN = 2,
    FUN = sd
  )
  
  est <- t(est)
  
  vars <- ifelse(
    unique(vars) == "hfaz", 
    c("global_stunting", "moderate_stunting", "severe_stunting"),
    ifelse(
      unique(vars) == "wfaz",
      c("global_underweight", "moderate_underweight", "severe_underweight"),
      ifelse(
        unique(vars) == "wfhz",
        c("global_wasting_whz", "moderate_wasting_whz", "severe_wasting_whz"),
        c("global_wasting_muac", "moderate_wasting_muac", "severe_wasting_muac")
      )
    )
  )
  
  est <- data.frame(
    unique(currentDF$district), indicator_set, vars, labs, est, se
  )
  
  row.names(est) <- 1:nrow(est)
  
  names(est) <- c(
    "district", "indicator_set", "indicator_variable", 
    "indicator", "estimate", "lcl", "ucl", "sd"
  )
  
  est
}

## Bootstrap probit all districts ----------------------------------------------

boot_probits_anthro <- function(.data, 
                                w,
                                vars,
                                labs,
                                indicator_set,
                                THRESHOLD,
                                replicates = 399) {
  # vars <- c("hfaz", "hfaz", "wfaz", "wfaz", "wfhz", "wfhz", "cmuac", "cmuac")
  # labs <- c(
  #   "Global stunting", "Severe stunting",
  #   "Global underweight", "Severe underweight",
  #   "Global wasting by weight-for-height z-score",
  #   "Severe wasting by weight-for-height z-score",
  #   "Global wasting by MUAC", "Severe wasting by MUAC"
  # )
  # indicator_set <- rep("Child nutritional status", 8)
  
  .data         <- split(x = .data, f = .data$district)
  w             <- rep(list(w), length(.data)) 
  vars          <- rep(list(vars), length(.data))
  labs          <- rep(list(labs), length(.data))
  indicator_set <- rep(list(indicator_set), length(.data))
  THRESHOLD     <- rep(list(THRESHOLD), length(.data))
  
  parallel::mcMap(
    f = boot_probit,
    .data = .data,
    w = w,
    vars = vars,
    labs = labs,
    indicator_set = indicator_set,
    THRESHOLD = THRESHOLD,
    replicates = replicates,
    mc.cores = 4
  ) |>
    (\(x) do.call(rbind, x))() |>
    (\(x) { row.names(x) <- 1:nrow(x); x })()
}


boot_probits_stunting <- function(.data, w, replicates = 399) {
  boot_probits_anthro(
    .data = .data,
    w = w,
    vars = rep("hfaz", 3),
    labs = c(
      "Proportion of children 6-59 months old with height-for-age z-score less than -2",
      "Proportion of children 6-59 momths old with height-for-age z-score less than -2 and greater than or equal to -3",
      "Proportion of children 6-59 months old with height-for-age z-score less than -3"
    ),
    indicator_set = rep("Child nutritional status", 3),
    THRESHOLD = c(-2, -3),
    replicates = replicates
  )
}


boot_probits_underweight <- function(.data, w, replicates = 399) {
  boot_probits_anthro(
    .data = .data,
    w = w,
    vars = rep("wfaz", 3),
    labs = c(
      "Proportion of children 6-59 months old with weight-for-age z-score less than -2",
      "Proportion of children 6-59 momths old with weight-for-age z-score less than -2 and greater than or equal to -3",
      "Proportion of children 6-59 months old with weight-for-age z-score less than -3"
    ),
    indicator_set = rep("Child nutritional status", 3),
    THRESHOLD = c(-2, -3),
    replicates = replicates
  )
}

boot_probits_whz <- function(.data, w, replicates = 399) {
  boot_probits_anthro(
    .data = .data,
    w = w,
    vars = rep("wfhz", 3),
    labs = c(
      "Proportion of children 6-59 months old with weight-for-height z-score less than -2",
      "Proportion of children 6-59 momths old with weight-for-height z-score less than -2 and greater than or equal to -3",
      "Proportion of children 6-59 months old with weight-for-height z-score less than -3"
    ),
    indicator_set = rep("Child nutritional status", 3),
    THRESHOLD = c(-2, -3),
    replicates = replicates
  )
}

boot_probits_muac <- function(.data, w, replicates = 399) {
  boot_probits_anthro(
    .data = .data,
    w = w,
    vars = rep("cmuac", 3),
    labs = c(
      "Proportion of children 6-59 months old with mid-upper arm circumference less than 12.5 cms",
      "Proportion of children 6-59 momths old with mid-upper arm circumference less than 12.5 cms and greater than or equal to 11.5 cms",
      "Proportion of children 6-59 months old with mid-upper arm circumference less than 11.5 cms"
    ),
    indicator_set = rep("Child nutritional status", 3),
    THRESHOLD = c(12.5, 11.5),
    replicates = replicates
  )
}