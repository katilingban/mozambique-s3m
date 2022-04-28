################################################################################
#
#'
#' Apply data check based on Benford's law
#'
#
################################################################################

check_benford_law <- function(x, multiplier) {
  ## Get expected probabilities/proportion of first digits
  expected <- benlaw(d = 1:9)
  
  ## Get first digits from data being tested
  fd <- firstDigits(x = x, multiplier = multiplier)
  
  ## Get observed proportions/probabilities of first digits
  observed <- pFirstDigits(x = x, multiplier = multiplier)
  
  #X2 <- nrow(svy) * sum((observed - expected)^2 / expected)
  X2 <- sum((observed - expected) ^ 2 / expected)
  DF = length(observed) - 1
  P <- pchisq(q = X2, df = DF)
  
  result <- list(
    expected = expected,
    observed = observed,
    X2 = X2,
    df = DF,
    p = P
  )
  
  #cat("Chi-square = ", round(X2, 4), "\tdf = ", DF, "\tp = ", P)
  result
}


################################################################################
#
#'
#' Calculate expected probabilities of the first digit based on Benford's Law
#'
#
################################################################################

benlaw <- function(d) {
  log10(1 + 1 / d)
}


################################################################################
#
#'
#' Get first digit of numerical data 
#'
#' Function to get first digit after multiplying 'x' by 'multiplier'
#'
#
################################################################################

firstDigits <- function(x, multiplier) {
  substr(abs(x * multiplier), 1, 1) |>
    (\(x) x[x != "0"])()
}


################################################################################
#
#'
#' Calculate observed proportions/probabilities of first digits in dataset
#' 
#' Function to calculate observed proportions of first digits
#'
#
################################################################################

pFirstDigits <- function(x, multiplier) {
  as.numeric(table(firstDigits(x, multiplier)) / length(x))
}


#
# Read survey data (comes with the NIPN toolkit)
#
#svy <- read.table("z.ex01.csv", header = TRUE, sep = ",")

#
# Add W/H z-scores
#
# require(zscorer)
# svy <- addWGSR(data = svy, sex = "sex", firstPart = "weight", secondPart = "height", index = "wfh")

## Censor missing (NA) z-scores
# svy <- svy[!is.na(svy$wfhz), ]

#
# Function to calculate expected proportionsions from Benford's law.
#
# benlaw <- function(d)
# {
#   return(log10(1 + 1 / d))
# }

#
# Calculate expected probabilities for digits 1..p from Benford's Law
#
# expected <- benlaw(1:9)



#
# Calculate and plot observed probabilities
#
# observed <- pFirstDigits(svy$wfhz, 100)
# basePlot <- barplot(observed, names.arg = 1:9, xlab = "First Digits",  ylim = c(0, 0.40))

#
# Plot expected BL probabilities
#
# lines (basePlot[,1], expected, type = "b", col = "green", lwd = 4, pch = 20, cex = 1.5)

## Chi-square goodness of fit ### I THINK THIS IS RIGHT ### NEEDS CHECKING
#
# we may neeed to group values to keep expected values >5 for a chi-square to be valid.
#
# X2 <- nrow(svy) * sum((observed - expected)^2 / expected)
# DF = length(observed) - 1
# P <- pchisq(q = X2, df = DF)
# cat("Chi-quares = ", round(X2,4), "\tdf = ", DF, "\tp = ", P)