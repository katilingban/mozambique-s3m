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

get_data <- function(form_name = "sofala_s3m") {
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
  
  mother_roster <- process_mother_data(df = .data)
  child_roster <- process_child_data(df = .data)
  
  mc_data <- merge(mother_roster, child_roster, by = "id")
  
  .data <- merge(.data, mc_data, by = "id")
  
  .data
}


################################################################################
#
#'
#' Process household/respondent data
#' 
#' @param df Data.frame produced by function `get_data()`
#'
#
################################################################################

process_respondent_data <- function(df) {
  template_df <- data.frame(
    start = NA_character_,
    end = NA_character_,
    today = NA_character_,
    audit = NA_character_,
    id = NA_integer_,
    tags = NA,
    uuid = NA_character_,
    notes = NA,
    edited = NA,
    status = NA_character_,
    version = NA_character_,
    duration = NA_real_,
    xform_id = NA_integer_,
    attachments = NA,
    geolocation = NA,
    media_count = NA_integer_,
    total_media = NA_integer_,
    submitted_by = NA_character_,
    date_modified = NA_character_,
    instanceID = NA_character_,
    submission_time = NA_character_,
    xform_id_string = NA_character_,
    instanceName = NA_character_,
    bamboo_dataset_id = NA_character_,
    ENUMID = NA_character_,
    ENUMNAME = NA_character_,
    fgh_id = NA_integer_,
    ea_code = NA_character_,
    province = NA_character_,
    district = NA_character_,
    post = NA_character_,
    locality = NA_character_,
    bairro = NA_character_,
    name1 = NA_character_,
    name2 = NA_character_,
    name3 = NA_character_,
    fgh_confirm = NA_character_,
    RURURB = NA_integer_,
    IDIOMAQ = NA_integer_,
    IDIOMAQ_other = NA_integer_,
    GPS = NA_character_,
    SURVEYDATE = NA_character_,
    consent = NA_integer_,
    FAMSIZE = NA_integer_,
    FAMSIZE1 = NA_integer_,
    FAMSIZE2 = NA_integer_,
    RESP_NAME = NA_character_,
    RESP_SEX = NA_integer_,
    Q01 = NA_integer_,
    RESP_MARITAL_STATUS = NA_integer_,
    RESP_EDU = NA_integer_,
    Q02 = NA_integer_,
    Q02a = NA_integer_,
    Q02b = NA_integer_,
    Q02c = NA_integer_,
    Q02d = NA_integer_,
    Q03 = NA_integer_,
    Q05 = NA_integer_,
    Q05_specify = NA_character_,
    Q06 = NA_integer_,
    Q06_content = NA_character_,
    Q06a = NA_integer_,
    Q06b = NA_integer_,
    Q07 = NA_integer_,
    Q07_specify = NA_character_,
    GI1 = NA_integer_,
    GI1_other = NA_character_,
    GI2t = NA_integer_,
    GI2m = NA_integer_,
    GI3t = NA_integer_,
    GI3m = NA_integer_,
    WT1t = NA_integer_,
    WT1m = NA_integer_,
    SDH1 = NA_integer_,
    SDH2 = NA_integer_,
    SDH3 = NA_integer_,
    SDH4 = NA_integer_,
    SDH5 = NA_integer_,
    SDH6 = NA_integer_,
    SDH7 = NA_integer_,
    SDH8 = NA_integer_,
    CDCG1 = NA_integer_,
    CDCG2 = NA_integer_,
    CDCG3 = NA_integer_,
    CDCG4 = NA_integer_,
    CDCG7 = NA_integer_,
    CDCG8 = NA_integer_,
    CDCG9 = NA_integer_,
    CDCG10 = NA_integer_,
    CDCG11 = NA_integer_,
    CDCG11a = NA_integer_,
    CDCG13 = NA_integer_,
    CDCG14 = NA_integer_,
    CFEGS1 = NA_integer_,
    CFEGS2 = NA_integer_,
    CFEGS3 = NA_integer_,
    CFEGS4 = NA_integer_,
    CFEGS5 = NA_integer_,
    CFEGS67 = NA_integer_,
    IG1 = NA_integer_,
    Q08 = NA_integer_,
    IGS1 = NA_integer_,
    IGS2 = NA_integer_,
    IGS3 = NA_integer_,
    IGS6 = NA_integer_,
    IGS7 = NA_integer_,
    IGS8 = NA_integer_,
    IGS8a = NA_integer_,
    IGS8c = NA_integer_,
    IGS8e = NA_integer_,
    IGS8f = NA_integer_,
    GE1 = NA_integer_,
    GE2 = NA_integer_,
    GE3 = NA_integer_,
    GE4 = NA_integer_,
    GE5 = NA_integer_,
    GE6 = NA_integer_,
    GE7 = NA_integer_,
    GE8 = NA_integer_,
    GE9 = NA_integer_,
    GE10 = NA_integer_,
    WT2 = NA_integer_,
    WT2_other = NA_character_,
    WT3 = NA_integer_,
    WT3a = NA_integer_,
    WT3b = NA_integer_,
    WT4 = NA_integer_,
    WT4a = NA_integer_,
    WT5 = NA_integer_,
    WT6 = NA_integer_,
    CAHA1 = NA_integer_,
    CAHA2 = NA_integer_,
    CAHA2_other = NA_character_,
    CAHA3 = NA_integer_,
    LUSD1 = NA_integer_,
    LUSD2 = NA_integer_,
    LUSD3 = NA_integer_,
    LUSD4 = NA_integer_,
    LUSD5 = NA_integer_,
    LUSD6 = NA_integer_,
    LUSD7 = NA_integer_,
    LUSD8 = NA_integer_,
    CCARE1 = NA_integer_,
    CCARE2 = NA_integer_,
    CCARE3 = NA_integer_,
    DES1 = NA_integer_,
    DES2 = NA_integer_,
    WH1 = NA_integer_,
    WH2 = NA_integer_,
    WH3 = NA_integer_,
    WH4 = NA_integer_,
    WH5 = NA_integer_,
    WH6 = NA_integer_,
    WH6a = NA_character_,
    WH7 = NA_integer_,
    WH7a = NA_character_,
    WH8 = NA_integer_,
    PREG1 = NA_integer_,
    PREG2 = NA_integer_,
    PREG3 = NA_integer_,
    PMTCT1 = NA_integer_,
    PMTCT2 = NA_integer_,
    PMTCT3 = NA_integer_,
    IDK1 = NA_integer_,
    IDK2 = NA_integer_,
    SPC1 = NA_integer_,
    SPC2 = NA_integer_,
    SPC2a = NA_integer_,
    SPC2b = NA_integer_,
    SPC3 = NA_integer_,
    SPC4 = NA_integer_,
    SPC5 = NA_integer_,
    SPC5a = NA_integer_,
    SPC6 = NA_integer_,
    SPC6a = NA_integer_,
    SPC6b = NA_integer_,
    SPC7 = NA_integer_,
    SPC7a = NA_integer_,
    SPC7b = NA_integer_,
    THER1 = NA_integer_,
    CHM1 = NA_integer_,
    CHM2 = NA_integer_,
    FANSIDAR1 = NA_integer_,
    FANSIDAR2 = NA_integer_,
    FOL1 = NA_integer_,
    TT1 = NA_integer_,
    TT2 = NA_integer_,
    EB1 = NA_integer_,
    EB2 = NA_integer_,
    EB2_hours = NA_integer_,
    EB2_days = NA_integer_,
    EB2a = NA_integer_,
    EB3 = NA_integer_,
    EB4 = NA_integer_,
    EB5 = NA_integer_,
    EB5a = NA_integer_,
    EB6 = NA_integer_,
    EB6a = NA_integer_,
    PF1 = NA_integer_,
    BS1 = NA_integer_,
    BS1a = NA_integer_,
    BS2 = NA_integer_,
    BS2a = NA_character_,
    BS3 = NA_integer_,
    BS4 = NA_integer_,
    ABOR1 = NA_integer_,
    ABOR1a = NA_integer_,
    NUTMUL1 = NA_integer_,
    NUTMUL2 = NA_integer_,
    NUTMUL3 = NA_integer_,
    NUTMUL4 = NA_integer_,
    NUTMUL5 = NA_integer_,
    NUTMUL6 = NA_integer_,
    NUTMUL7 = NA_integer_,
    NUTMUL8 = NA_integer_,
    NUTMUL9 = NA_integer_,
    NUTMUL10 = NA_integer_,
    NUTMUL11 = NA_integer_,
    NUTMUL12 = NA_integer_,
    NUTMUL13 = NA_integer_,
    NUTMUL14 = NA_integer_,
    NUTMUL15 = NA_integer_,
    NUTMUL16 = NA_integer_,
    NUTMUL17 = NA_integer_,
    NUTMUL18 = NA_integer_,
    NUTMUL19 = NA_integer_,
    VON1 = NA_integer_,
    VON2 = NA_integer_,
    VON3 = NA_integer_,
    VON4 = NA_integer_,
    MENT1 = NA_integer_,
    MENT2 = NA_integer_,
    MENT3 = NA_integer_,
    MENT4 = NA_integer_,
    MENT5 = NA_integer_,
    MENT6 = NA_integer_,
    MENT7 = NA_integer_,
    MENT8 = NA_integer_,
    MENT9 = NA_integer_,
    MALTURA = NA_real_,
    MPESO = NA_real_,
    MBRACO = NA_real_,
    ANIM1 = NA_integer_,
    ANIM2 = NA_integer_,
    AGUA1 = NA_integer_,
    AGUA2 = NA_integer_,
    AGUA3 = NA_integer_,
    COZ1 = NA_integer_,
    COZ2 = NA_integer_,
    COZ3 = NA_integer_,
    QUIN1 = NA_integer_,
    MAO1 = NA_integer_,
    MAO1a = NA_integer_,
    MAO1b = NA_integer_,
    FCS1 = NA_integer_,
    FCS2 = NA_integer_,
    FCS3 = NA_integer_,
    FCS4 = NA_integer_,
    FCS5 = NA_integer_,
    FCS6 = NA_integer_,
    FCS7 = NA_integer_,
    FCS8 = NA_integer_,
    FCS9 = NA_integer_,
    FCS10 = NA_integer_,
    FCS11 = NA_integer_,
    FCS12 = NA_integer_,
    FCS13 = NA_integer_,
    FCS14 = NA_integer_,
    FCS15 = NA_integer_,
    FCS16 = NA_integer_,
    HDDS1 = NA_integer_,
    HDDS2 = NA_integer_,
    HDDS3 = NA_integer_,
    HDDS4 = NA_integer_,
    HDDS5 = NA_integer_,
    HDDS6 = NA_integer_,
    HDDS7 = NA_integer_,
    HDDS8 = NA_integer_,
    HDDS9 = NA_integer_,
    HDDS10 = NA_integer_,
    HDDS11 = NA_integer_,
    HDDS12 = NA_integer_,
    HDDS13 = NA_integer_,
    HDDS14 = NA_integer_,
    HDDS15 = NA_integer_,
    HDDS16 = NA_integer_,
    RCSI1 = NA_integer_,
    RCSI2 = NA_integer_,
    RCSI3 = NA_integer_,
    RCSI4 = NA_integer_,
    RCSI5 = NA_integer_,
    FIES01 = NA_integer_,
    FIES02 = NA_integer_,
    FIES03 = NA_integer_,
    FIES04 = NA_integer_,
    FIES05 = NA_integer_,
    FIES06 = NA_integer_,
    FIES07 = NA_integer_,
    FIES08 = NA_integer_,
    FS1 = NA_integer_,
    FS2 = NA_integer_,
    RESERVE1 = NA_integer_,
    RESERVE1a = NA_integer_,
    RESERVE2 = NA_integer_,
    RESERVE2a = NA_integer_,
    RESERVE3 = NA_integer_,
    RESERVE3a = NA_integer_,
    RESERVE4 = NA_integer_,
    RESERVE4a = NA_integer_,
    RESERVE5 = NA_integer_,
    RESERVE5a = NA_integer_,
    RESERVE6 = NA_integer_,
    RESERVE6a = NA_integer_,
    RESERVE7 = NA_integer_,
    RESERVE7a = NA_integer_,
    PEST1 = NA_integer_,
    PEST2 = NA_integer_,
    PEST2_other = NA_integer_,
    LCS01 = NA_integer_,
    LCS02 = NA_integer_,
    LCS03 = NA_integer_,
    LCS04 = NA_integer_,
    LCS05 = NA_integer_,
    LCS06 = NA_integer_,
    LCS07 = NA_integer_,
    LCS08 = NA_integer_,
    LCS09 = NA_integer_,
    LCS10 = NA_integer_,
    LCS11 = NA_integer_,
    LCS12 = NA_integer_,
    LCS13 = NA_integer_,
    LCS14 = NA_integer_,
    CHILD_ROSTER = NA,
    CHILD_ROSTER_count = NA_character_,
    CHILD_HEALTH = NA,
    CHILD_HEALTH_count = NA_character_,
    BF2 = NA,
    BF2_count = NA_character_,
    CHILD_ANTHRO_REPEAT = NA,
    CHILD_ANTHRO_REPEAT_count = NA_character_
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
    (\(x) x[2:nrow(x), ])() |>
    tibble::tibble()

  df$start <- gsub(pattern = "T", replacement = " ", x = df$start) |> 
    strptime(format = "%Y-%m-%d %H:%M:%S")
  
  df$end <- gsub(pattern = "T", replacement = " ", x = df$end) |> 
    strptime(format = "%Y-%m-%d %H:%M:%S")
  
  names(df) <- tolower(names(df))
  
  ## Return
  df
}


################################################################################
#
#'
#' Process child data
#' 
#' @param df Data.frame produced by function `get_data()`
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
#' @param df Data.frame produced by function `get_data()`
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

