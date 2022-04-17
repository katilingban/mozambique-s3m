################################################################################
#
#'
#' Archive report
#'
#
################################################################################

archive_daily_report <- function(from = "outputs/data_review.html",
                                 to = paste0("outputs/", Sys.Date(), "/index.html")) {
  directory <- stringr::str_extract(string = from, pattern = "^(.*?)/")
  
  if(!dir.exists(paste0(directory, "/", Sys.Date()))) {
    dir.create(paste0(directory, "/", Sys.Date()))
  }
  
  file.copy(from = from, to = to)
  
  to
}