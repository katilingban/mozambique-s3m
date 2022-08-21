################################################################################
#
#'
#' Translate text using Google Translate API
#' 
#' @param text A string or vector of strings to translate
#' @param target A 2 character ISO code for target language to translate to.
#'   Default to "en" for English.
#' @param model What translation model to use
#'
#
################################################################################

translate_response <- function(text, 
                               source = "",
                               target = "en", 
                               model = c("nmt", "base")) {
  model <- match.arg(model)
  
  if (is.na(text)) {
    tibble::tibble(
      translatedText = NA_character_,
      detectedSourceLanguage = NA_character_,
      text = NA_character_
    )
  } else {
    googleLanguageR::gl_translate(
      t_string = text,
      target = target,
      format = "text",
      source = source,
      model = model
    )
  }
}


translate_responses <- function(text, 
                                source = "",
                                target = "en", 
                                model = c("nmt", "base")) {
  text |>
    lapply(
      FUN = translate_response,
      source = source,
      target = target,
      model = model
    ) |>
    dplyr::bind_rows()
}

