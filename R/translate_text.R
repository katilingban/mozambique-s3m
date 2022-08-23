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


################################################################################
#
#'
#' Translate text within a data.frame
#' 
#' Given variable names of fields in data.frame to translate, translate fields
#' and then add translation to the original data.frame as a new column to the
#' right of the field that was translated. New translated field name will have
#' an appended two-letter ISO code for the language it has been translated to.
#' 
#' @param var A vector of variables/field names to be translated
#' @param df A data.frame with the different variables/fields needing
#'   translation
#' 
#'
#'
#
################################################################################

translate_df_variable <- function(var, df,
                                  source = "",
                                  target = "en",
                                  model = c("nmt", "base")) {
  translated_text <- translate_responses(
    text = df[[var]],
    source = source,
    target = target,
    model = model
  ) |>
    (\(x) x$translatedText)()
  
  df |>
    dplyr::mutate(
       "{var}_{target}" := translated_text,
       .after = var
    )
}


translate_df_variables <- function(var, df,
                                   source = "",
                                   target = "en",
                                   model = c("nmt", "base")) {
  df <- lapply(
    X = var,
    FUN = translate_df_variable,
    df = df,
    source = source,
    target = target,
    model = model
  ) |>
    dplyr::bind_rows()
  
  for (i in var) {
    df <- dplyr::relocate(
      .data = df,
      paste(i, "en", sep = "_"),
      .after = i
    )
  }
  
  df
}

