################################################################################
#
#'
#' Tally sampling point submissions
#'
#
################################################################################

tally_sp_total <- function(respondent_data_clean, endline_sample_list) {
  x <- data.frame(table(respondent_data_clean$fgh_id)) 
  x[ , 1] <- as.character(x[ , 1])
  
  y <- endline_sample_list$FGH_ID
  
  rbind(
    x, 
    data.frame(
      Var1 = c("Total", "Total records with wrong FGH ID"),
      Freq = c(sum(x$Freq), sum(x$Freq[!as.integer(x$Var1) %in% y]))
    )
  )
}


################################################################################
#
#'
#' Tally sampling point children submissions
#'
#'
#
################################################################################

tally_sp_children_total <- function(child_data_clean, endline_sample_list) {

  x <- data.frame(table(child_data_clean$fgh_id))
  x$Var1 <- as.character(x$Var1)

  rbind(
    x, 
    data.frame(
      Var1 = c("Total", "Total records with wrong sampling point ID"),
      Freq = c(
        sum(x$Freq), 
        sum(x$Freq[!as.integer(x$Var1) %in% endline_sample_list$FGH_ID])
      )
    )
  )
}


################################################################################
#
#'
#'
#'
#
################################################################################

tally_sp_date_total <- function(respondent_data_clean, endline_sample_list) {
  x <- cbind(
    table(respondent_data_clean$fgh_id, respondent_data_clean$today)
  ) 
  
  y <- data.frame(x)
  names(y) <- colnames(x)
  
  Total <- colSums(y)
  `Total records with wrong sampling point identifier per day` <- 
    colSums(y[!as.integer(row.names(y)) %in% endline_sample_list$FGH_ID, ])

  
  z <- rbind(
    y, 
    Total, 
    `Total records with wrong sampling point identifier per day`
  )
  
  `Sampling point identifier` <- row.names(z)
  
  z <- cbind(
    `Sampling point identifier`, 
    z,
    `Total records by sampling point identifier per day` = rowSums(z)
  )
  
  z$`Sampling point identifier`[nrow(z) - 1] <- "Total"
  z$`Sampling point identifier`[nrow(z)] <- "Total records with wrong sampling point identifier per day"
  
  z
}