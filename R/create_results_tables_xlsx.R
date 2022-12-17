################################################################################
#
#'
#' Create XLSX of indicator results
#'
#
################################################################################

create_results_xlsx <- function(path, 
                                household, 
                                carer, 
                                woman, 
                                child, 
                                child_anthro) {
  wb <- openxlsx::buildWorkbook(
    x = list(
      household = household, 
      carer = carer, 
      woman = woman, 
      child = child,
      child_anthro = child_anthro
    ),
    asTable = TRUE,
    colWidths = "auto"
  )
  
  openxlsx::saveWorkbook(wb = wb, file = path, overwrite = TRUE)
}

