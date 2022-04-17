################################################################################
#
#'
#' Deploy report
#'
#
################################################################################

deploy_daily_report <- function(from = data_review_report[1],
                                to = "docs/index.html") {
  file.copy(from = from, to = to, overwrite = TRUE)
  
  to
}