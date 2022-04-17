################################################################################
#
#'
#' Deploy survey progress report
#'
#
################################################################################

deploy_progress_report <- function(from = survey_progress_report[1],
                                to = "docs/sofala_survey_progress.html") {
  file.copy(from = from, to = to, overwrite = TRUE)
  
  to
}


################################################################################
#
#'
#' Deploy data quality report
#'
#
################################################################################

deploy_quality_report <- function(from = data_quality_report[1],
                                  to = "docs/sofala_data_quality.html") {
  file.copy(from = from, to = to, overwrite = TRUE)
  
  to
}

