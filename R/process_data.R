################################################################################
#
#'
#' Access endline data from ONA
#' 
#' @param form_name Short form name of survey.
#' 
#'
#
################################################################################

get_data <- function(form_name = "sofala_s3m", survey_questions) {
  ## Get form ID
  form_id <- okapi::ona_data_list() |>
    (\(x) x$id[x$id_string == form_name])()
  
  ## Get data
  .data <- okapi::ona_data_get(form_id = form_id)
  
  ## clean-up variable names
  clean_names <- .data |>
    names() |>
    (\(x) gsub(pattern = "^(.*?)/", replacement = "", x = x))() |>
    (\(x) gsub(pattern = "^(.*?)/", replacement = "", x = x))() |>
    (\(x) gsub(pattern = "^(.*?)/", replacement = "", x = x))() |>
    (\(x) gsub(pattern = "^_", replacement = "", x = x))()
    
  ## rename data
  names(.data) <- clean_names
  
  ## remove extra uuid
  .data <- .data[ , c(1:100, 102:ncol(.data))]
  
  ## Process mother and child roster
  mother_roster <- process_mother_data(df = .data)
  child_roster <- process_child_data(df = .data)
  
  ## Add mother and child roster data
  mc_data <- merge(mother_roster, child_roster, by = "id")
  .data <- merge(.data, mc_data, by = "id")
  
  ## Create template DF
  vars <- get_variables(survey_questions, meta = TRUE)
  
  template_df <- eval(
    expr = parse(
      text = paste0(
        "data.frame(",
        paste(vars, " = ", NA, collapse = ", "),
        ")"
      )
    )
  )
  
  ## Remove first row
  .data <- dplyr::bind_rows(template_df, .data) |>
    (\(x) x[2:nrow(x), ])()
  
  ## make names lower case
  names(.data) <- names(.data) |> tolower()
  
  ## Return
  .data
}


################################################################################
#
#'
#' Process child data
#' 
#' @param df Data.frame of raw data drawn from ONA. Meant to be a helper
#'   function for `get_data()` function.
#'
#
################################################################################

process_child_data <- function(df) {
  ## Get child roster
  child_roster <- df$child_repeat
  names(child_roster) <- df$id
  
  child_roster <- child_roster |>
    lapply(FUN = clean_child_roster_types) |>
    dplyr::bind_rows(.id = "id")
  
  child_marker <- paste0(df$id, df$child_random)
  roster_marker <- paste0(child_roster$id, child_roster$child_id)
  
  child_roster <- child_roster |>
    subset(roster_marker %in% child_marker)
  
  child_roster
}


################################################################################
#
#'
#' Process mother data
#' 
#' @param df Data.frame of raw data drawn from ONA. Meant to be a helper
#'   function for `get_data()` function.
#'
#
################################################################################

process_mother_data <- function(df) {
  ## Get child roster
  mother_roster <- df$mother_repeat
  names(mother_roster) <- df$id
  
  mother_roster <- mother_roster |>
    lapply(FUN = clean_mother_roster_types) |>
    dplyr::bind_rows(.id = "id")
  
  mother_marker <- paste0(df$id, df$mother_random)
  roster_marker <- paste0(mother_roster$id, mother_roster$mother_id)
  
  mother_roster <- mother_roster |>
    subset(roster_marker %in% mother_marker)
  
  mother_roster
}


################################################################################
#
#'
#' Process child roster data
#' 
#' @param df Child roster data.frame
#'
#
################################################################################

clean_child_roster_types <- function(df) {
  ## Check if df is NULL
  if (is.null(df)) {
    df <- data.frame(
      child_id = NA_integer_, 
      child_name = NA_character_,
      child_dob_known = NA_integer_, 
      child_dob_exact = NA_character_, 
      child_dob_recall = NA_character_, 
      child_sex = NA_integer_, 
      child_dob = NA_character_,
      child_age = NA_integer_
    )
  } else {
    clean_names <- names(df) |> 
      (\(x) gsub(pattern = "^(.*?)/", replacement = "", x = x))() |>
      (\(x) gsub(pattern = "^(.*?)/", replacement = "", x = x))()
  
    names(df) <- clean_names
  
    template_df <- data.frame(
      child_id = NA_integer_, 
      child_name = NA_character_,
      child_dob_known = NA_integer_, 
      child_dob_exact = NA_character_, 
      child_dob_recall = NA_character_, 
      child_sex = NA_integer_, 
      child_dob = NA_character_,
      child_age = NA_integer_
    )
  
    ## Convert simple codes to integers
    integer_vars <- names(template_df)[sapply(X = template_df, FUN = class) == "integer"] |>
      (\(x) names(df)[names(df) %in% x])()
  
    df[ , integer_vars] <- df[ , integer_vars] |>
      apply(MARGIN = 2, FUN = function(x) as.integer(x))
  
    ## Conver to numeric  
    numeric_vars <- names(template_df)[sapply(X = template_df, FUN = class) == "numeric"] |>
      (\(x) names(df)[names(df) %in% x])()
  
    df[ , numeric_vars] <- df[ , numeric_vars] |>
      apply(MARGIN = 2, FUN = function(x) as.numeric(x))
  
    ## Concatenate
    df <- dplyr::bind_rows(template_df, df) |>
      (\(x) x[2:nrow(x), ])()  
  }

  df$child_dob_exact <- as.Date(df$child_dob_exact)
  df$child_dob_recall <- as.Date(df$child_dob_recall)
  df$child_dob <- as.Date(df$child_dob)
    
  ## Return
  df
}


################################################################################
#
#'
#' Process mother roster data
#' 
#' @param df Mother roster data.frame
#'
#
################################################################################

clean_mother_roster_types <- function(df) {
  ## Check if df is NULL
  if (is.null(df)) {
    df <- data.frame(
      mother_id = NA_integer_, 
      mother_name = NA_character_,
      mother_age = NA_integer_, 
      mother_child_size = NA_integer_
    )
  } else {
    clean_names <- names(df) |> 
      (\(x) gsub(pattern = "^(.*?)/", replacement = "", x = x))() |>
      (\(x) gsub(pattern = "^(.*?)/", replacement = "", x = x))()
    
    names(df) <- clean_names
    
    template_df <- data.frame(
      mother_id = NA_integer_, 
      mother_name = NA_character_,
      mother_age = NA_integer_, 
      mother_child_size = NA_integer_
    )
    
    ## Convert simple codes to integers
    integer_vars <- names(template_df)[sapply(X = template_df, FUN = class) == "integer"] |>
      (\(x) names(df)[names(df) %in% x])()
    
    df[ , integer_vars] <- df[ , integer_vars] |>
      apply(MARGIN = 2, FUN = function(x) as.integer(x))
    
    ## Concatenate
    df <- dplyr::bind_rows(template_df, df) |>
      (\(x) x[2:nrow(x), ])()  
  }
  
  ## Return
  df
}

