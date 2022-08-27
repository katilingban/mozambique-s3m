################################################################################
#
#'
#' Recode immunisation card indicators
#'
#'
#
################################################################################

imm_recode_card <- function(.data) {
  imm_card1 <- .data[["imm1"]] |>
    (\(x)
      {
        ifelse(
          x %in% c(8, 9), NA,
            ifelse(
            x == 2, 0, x 
          )
        )
      }
     )()  
  
  imm_card2 <- .data[["imm2"]] |>
    (\(x) 
      {
        ifelse(
          x %in% c(88, 99), NA,
          ifelse(
            x == 1, 1, 0
          )
        )
      }
    )()  |>
    (\(x) ifelse(imm_card1 == 1 & x == 1, 1, 0))()

  data.frame(imm_card1, imm_card2)
}


################################################################################
#
#'
#' Recode immunisation indicators
#'
#
################################################################################

imm_recode_vaccine <- function(vars, .data, imm_label = NULL) {
  x <- .data[[vars]]
  
  imm1 <- x |>
    (\(x) 
      {
        ifelse(
          x %in% 4:5, NA,
          ifelse(
            x == 3, 0, 1
          )
        )
      }
    )()
  
  imm2 <- x |>
    (\(x) 
     {
       ifelse(
         x %in% 4:5, NA,
         ifelse(
           x == 1, 1, 0
         )
       )
    }
    )()
  
  if (!is.null(imm_label)) {
    imm_label <- paste(imm_label, c("card_recall", "card_only"), sep = "_")
  } else {
    imm_label <- paste(vars, c("card_recall", "card_only"), sep = "_")
  }
  
  data.frame(imm1, imm2) |>
    (\(x) { names(x) <- imm_label; x })()
}


imm_recode_vaccines <- function(vars, .data,
                                imm_label = c("bcg", 
                                              "opv1", "opv2", "opv3", "opv4",
                                              "dpt1", "dpt2", "dpt3",
                                              "rub1", "rub2",
                                              "pcv1", "pcv2", "pcv3",
                                              "vorh1", "vorh2")) {
  imm_df <- lapply(
    X = vars,
    FUN = imm_recode_vaccine,
    .data = .data,
    imm_label = NULL
  ) |>
    dplyr::bind_cols()
  
  names(imm_df) <- lapply(
    X = imm_label, 
    FUN = paste, 
    c("card_recall", "card_only"), 
    sep = "_"
  ) |>
    unlist()
  
  imm_df
}


################################################################################
#
#'
#' Overall immunisation recode
#'
#
################################################################################

imm_recode <- function(vars, .data, 
                       imm_label = c("bcg", "opv1", "opv2", "opv3", "opv4",
                                     "dpt1", "dpt2", "dpt3", "rub1", "rub2",
                                     "pcv1", "pcv2", "pcv3", "vorh1", "vorh2")) {
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  imm_card_df <- imm_recode_card(.data = .data)
  
  imm_vaccines_df <- imm_recode_vaccines(
    vars = vars,
    .data = .data,
    imm_label = imm_label
  )
  
  data.frame(core_vars, imm_card_df, imm_vaccines_df)
}

