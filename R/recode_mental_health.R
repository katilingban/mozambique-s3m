################################################################################
#
#' 
#' Process and recode mental health data/indicators
#'
#' Relevant variables:
#'
#'   ment1 - In the last two weeks, how many days did you have little interest 
#'     or little happiness in doing things?
#'   
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   ment2 - In the last two weeks, how many days did you feel down, depresssed 
#'     or without motivation?
#'
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   ment3 - In the last two weeks, how many days did you have difficulty 
#'     sleeping, or staying asleep, or sleeping more than is customary?
#'
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   ment4 - In the last two weeks, how many days did you feel tired or with 
#'     little energy?
#'
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   ment5 - In the last two weeks, how many days did you have lack of appetite 
#'     or ate less?
#'
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   ment6 - In the last two weeks, how many days did you feel bad about 
#'     yourself or thought you were a failure or that you let down your family 
#'     or yourself?
#'
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   ment7 - In the last two weeks, how many days did you have difficulty 
#'     concentrating on things (such as reading a newspaper, watching 
#'     television, or listening to the radio?
#'
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   	ment8 - In the last two weeks, how many days did you feel slow in your 
#'      movements or in speaking; or the contrary, in which you felt agitated 
#'      and you stayed walking from one side to another, more than is customary?
#'
#'     1=No days; 2=Less than 1 week; 3=1 week or more; 4=Almost all days; 
#'     88=Don&apos;t know; 99=No response
#'
#'   	ment9 - With what frequency do you consume alcoholic beverages?
#'
#'      1=Never; 2=Monthly or less; 3=Between 2-4 times per month; 
#'      4=Between 2-3 times per week; 5=4 or more times per week; 
#'      88=Don&apos;t know; 99=No response
#'      
#
################################################################################

phq_recode_symptom <- function(x, na_values) {
  ifelse(x %in% na_values, NA, x - 1)
}

phq_recode_symptoms <- function(vars, .data, na_values) {
  .data <- .data[vars]
  
  apply(
    X = .data,
    MARGIN = 2,
    FUN = phq_recode_symptom,
    na_values = na_values
  ) |>
    data.frame()
}


phq_calculate_score <- function(phq_df, .data, add = TRUE) {
  phq <- rowSums(phq_df, na.rm = TRUE) |>
    (\(x) 
      ifelse(
        .data[["mother_carer_sex"]] == 1 | 
          .data[["mother_age"]] < 15 | 
          .data[["mother_age"]] > 49, NA, x
      )
    )()
  
  if (add) {
    data.frame(
      phq_df,
      phq = phq
    )
  } else {
    phq
  }
  
}


phq_classify <- function(phq, add = FALSE, spread = FALSE) {
  #breaks <- c(1, 4, 9, 14, 19, 27)
  #labels <- c("minimal", "mild", "moderate", "moderate severe", "severe")
  breaks <- c(1, 10, 20, 24)
  labs <- c("minimal to mild", "major", "severe")
  
  phq_class <- cut(
    x = phq,
    breaks = breaks,
    labels = labs,
    include.lowest = TRUE, right = TRUE
  ) |>
    as.character() |>
    (\(x) ifelse(is.na(x), "no depression", x))() |>
    factor(levels = c("no depression", "minimal to mild", "major", "severe"))
  
  phq_integer <- cut(
    x = phq,
    breaks = breaks,
    labels = FALSE,
    include.lowest = TRUE, right = TRUE
  ) |>
    (\(x) ifelse(is.na(x), 0, x))()
  
  if (spread) {
    phq_class <- data.frame(
      phq_class = phq_class,
      spread_vector_to_columns(x = phq_integer, prefix = "phq")
    )
    
    names(phq_class) <- c(
      "phq_class", 
      paste0(
        "phq_", 
        stringr::str_replace_all(
          string = c("no depression", labs), pattern = " ", replacement = "_"
        )
      )
    )
    
    phq_class
  }
  
  if (add) {
    phq_class <- data.frame(
      phq, phq_class
    )
  }
  
  phq_class
}

## Recode alcohol frequency

alcohol_recode_frequency <- function(x,
                                     age,
                                     sex,
                                     na_values,
                                     fill = 1:5, 
                                     prefix = "alcohol_frequency") {
  ifelse(x %in% na_values | age < 15 | age > 49 | sex == 1, NA, x) |>
    spread_vector_to_columns(fill = 1:5, na_rm = FALSE, prefix = prefix)
}


################################################################################
#
#'
#' Overall recode function
#'
#
################################################################################

phq_recode <- function(vars,
                       .data,
                       na_values = NA) {
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  recoded_vars <- phq_recode_symptoms(
    vars = vars, .data = .data, na_values = na_values
  )
  
  alcohol_frequency <- alcohol_recode_frequency(
    x = .data[["ment9"]], 
    age = .data[["mother_age"]], 
    sex = .data[["mother_carer_sex"]],
    na_values = na_values
  )
    
  
  recoded_vars |>
    phq_calculate_score(.data = .data, add = FALSE) |>
    phq_classify(add = TRUE, spread = TRUE) |>
    (\(x) data.frame(core_vars, recoded_vars, x, alcohol_frequency))()
}

