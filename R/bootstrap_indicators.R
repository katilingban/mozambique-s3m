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
                          vars,
                          labs,
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
    statistic = bbw::bootClassic,
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
  
  est <- t(est)
    
  est <- data.frame(unique(currentDF$district), labs, est)
  
  row.names(est) <- 1:nrow(est)
    
  names(est) <- c("district", "indicators", "estimate", "lcl", "ucl")
  
  est
}


boot_estimates <- function(.data, 
                           w, vars, labs, 
                           replicates = 399) {
  .data  <- split(x = .data, f = .data$district)
  w      <- rep(list(w), length(.data)) 
  vars   <- rep(list(vars), length(.data))
  labs   <- rep(list(labs), length(.data))

  parallel::mcMap(
    f = boot_estimate,
    .data = .data,
    w = w,
    vars = vars,
    labs = labs,
    replicates = replicates,
    mc.cores = 4
  ) |>
    (\(x) do.call(rbind, x))()
}

