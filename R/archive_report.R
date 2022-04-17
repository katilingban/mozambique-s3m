################################################################################
#
#'
#' Archive daily survey progress report
#'
#
################################################################################

archive_progress_report <- function(from = "outputs/sofala_survey_progress.html",
                                    to = paste0("outputs/", Sys.Date(), "/progress/index.html")) {
  directory <- stringr::str_extract(string = from, pattern = "^(.*?)/")
  
  if(!dir.exists(paste0(directory, "/", Sys.Date(), "/progress"))) {
    dir.create(paste0(directory, "/", Sys.Date(), "/progress"), recursive = TRUE)
  }
  
  file.copy(from = from, to = to)
  
  to
}


################################################################################
#
#'
#' Archive data quality report
#'
#
################################################################################

archive_quality_report <- function(from = "outputs/sofala_data_quality.html",
                                         to = paste0("outputs/", Sys.Date(), "/quality/index.html")) {
  directory <- stringr::str_extract(string = from, pattern = "^(.*?)/")
  
  if(!dir.exists(paste0(directory, "/", Sys.Date(), "/quality"))) {
    dir.create(paste0(directory, "/", Sys.Date(), "/quality"), recursive = TRUE)
  }
  
  file.copy(from = from, to = to)
  
  to
}