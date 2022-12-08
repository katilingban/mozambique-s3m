################################################################################
#
#'
#' Create Sofala population datasets
#'
#
################################################################################

create_sofala_district_population <- function() {
  district <- c(
    "Cidade da Beira", "Buzi", "Caia", "Chemba", "Cheringoma", "Chibabava", 
    "Dondo", "Gorongosa", "Machanga", "Maringue", "Marromeu", "Muanza", 
    "Nhamatanda"
  )
  
  population <- c(
    700976, 210027, 187350, 98561, 68157, 160048, 228943, 209357, 66113, 
    112890, 182745, 45194, 330394)
  
  data.frame(district, population)
}

create_sofala_district_population <- function(pdf_data) {
  x <- pdf_data[[1]][["text"]]

  x[c(24:36, 40:(length(x) - 1))] |>
    matrix(ncol = 2) |>
    data.frame() |>
    (\(x) { names(x) <- c("district", "population"); x })() |>
    (\(x)
      {
        x$district <- ifelse(
          x$district == "Beira", "Cidade de Beira",
          ifelse(
            x$district == "Chirogoma", "Cheringoma", x$district
          )
        )
        x
      }
    )()
  
}



create_sofala_ea_population <- function(pdf_data, pdf_text) {
  x1 <- pdf_data[[1]][["text"]] |>
    (\(x) as.integer(x[196:490]))() |> 
    (\(x) x[x > 200])() |> 
    (\(x) x[!is.na(x)])()
  
  x2 <- pdf_data[[2]][["text"]] |>
    (\(x) x[467:513])() |>
    (\(x) as.integer(x))()
  
  x3 <- pdf_data[[3]][["text"]] |>
    (\(x) x[455:501])() |>
    (\(x) as.integer(x))()
  
  x4 <- pdf_data[[4]][["text"]] |>
    (\(x) x[460:506])() |>
    (\(x) as.integer(x))()
  
  x5 <- pdf_data[[5]][["text"]] |>
    (\(x) x[429:461])() |>
    (\(x) as.integer(x))()
  
  pop <- c(x1, x2, x3, x4, x5)
  
  y1 <- pdf_text[[1]][4:83] |>
    stringr::str_extract(pattern = "[0-9]{1,3}") |>
    (\(x) x[!stringr::str_detect(string = x, pattern = "^[0]")])() |>
    (\(x) x[!is.na(x)])() |>
    as.integer()
  
  y2 <- pdf_text[[2]] |> 
    (\(x) x[stringr::str_detect(string = x, pattern = "^[0-9]{2}")])() |>
    stringr::str_extract(pattern = "[0-9]{1,3}") |>
    as.integer()
  
  y3 <- pdf_text[[3]] |> 
    (\(x) x[stringr::str_detect(string = x, pattern = "^[0-9]{3}|^[ 0-9]")])() |>
    stringr::str_replace(pattern = "^[ ]", replacement = "") |>
    (\(x) x[!stringr::str_detect(string = x, pattern = "^[ ]")])() |>
    stringr::str_extract(pattern = "[0-9]{1,3}") |>
    as.integer()
  
  y4 <- pdf_text[[4]] |> 
    (\(x) x[stringr::str_detect(string = x, pattern = "^[0-9]{3}")])() |>
    stringr::str_extract(pattern = "[0-9]{1,3}") |>
    as.integer()
  
  y5 <- pdf_text[[5]] |> 
    (\(x) x[stringr::str_detect(string = x, pattern = "^[0-9]{3}")])() |>
    stringr::str_extract(pattern = "[0-9]{1,3}") |>
    as.integer()
  
  psu <- c(y1, y2, y3, y4, y5)
  
  data.frame(psu, pop)
}
