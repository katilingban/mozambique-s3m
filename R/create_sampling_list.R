################################################################################
#
#'
#' Create sampling list in format needed for ODK
#'
#
################################################################################

create_sampling_list <- function(selected_ea_file_updated, 
                                 selected_urban_ea_file) {
  ## Read updated rural list
  x <- readxl::read_xls(
    path = selected_ea_file_updated$local_path, sheet = 1
  ) |>
    (\(x) x[!duplicated(x$AES), c("spid", "Area_Geogr", "CodProv", "Provincia", 
                                  "CodDist", "Distrito", "CodPost", "Posto", 
                                  "CodLocal", "Localidade", "CodBairro", 
                                  "Bairro", "CodN1", "NomeN1", "CodN2", "NomeN2", 
                                  "CodN3", "NomeN3", "AES", "CodAE_2017")])()
  
  ## Read urban list
  y <- readxl::read_xls(
    path = selected_urban_ea_file$local_path, sheet = 1
  ) |>
    (\(x) tibble::tibble(spid = 210:(210 + 20), x[ , 1:15], CodN3 = NA, 
                         NomeN3 = NA, 
                         x[ , 16:17]))()
  
  ## Concatenate lists
  z <- rbind(x, y)
  
  ## Clean up lists
  z <- z |>
    dplyr::mutate(
      Localidade = ifelse(Localidade == "Nao Aplicavel", NA, Localidade),
      Bairro = ifelse(Bairro == "Nao Aplicavel", NA, Bairro),
      NomeN1 = ifelse(NomeN1 == "Nao Aplicavel", NA, NomeN1),
      NomeN2 = ifelse(NomeN2 == "Nao Aplicavel", NA, NomeN2),
      NomeN3 = ifelse(NomeN3 == "Nao Aplicavel", NA, NomeN3)
    )
  
  ## Return
  z
}

