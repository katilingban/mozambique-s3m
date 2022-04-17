################################################################################
#
#'
#' Email report to recipeients
#' 
#' @param message Email message to send
#' @param attachment The filename for the file to be attached to the email. 
#'   Default to "outputs/data_review.html"
#' @param sender Email address of the sender of the email. Default to
#'   Sys.getenv("GMAIL_USERNAME")
#' @param recipient Email addresses of report recipient/s. Default to
#'   Sys.getenv("REPORT_RECIPIENTS")
#' 
#
################################################################################

email_daily_report <- function(message = email_report_message,
                               attachment = c(survey_progress_report[1], data_quality_report[1]),
                               sender = Sys.getenv("GMAIL_USERNAME"),
                               recipient = Sys.getenv("REPORT_RECIPIENTS")) {
  ## Add attachment
  blastula::add_attachment(
    email = message,
    file = attachment[1]
  ) |>
  ## Add attachment
  blastula::add_attachment(
    email = message,
    file = attachment[2]
  ) |>
  ## Set-up SMTP and send email report
  blastula::smtp_send(
    to = recipient,
    bcc = sender,
    from = sender, 
    subject = paste0(
      "Daily survey progress and data quality report - Sofala S3M - ",
      Sys.Date()
    ), 
    credentials = blastula::creds_envvar(
      user = sender, 
      pass_envvar = "GMAIL_PASSWORD", 
      host = "smtp.gmail.com", 
      port = 465,
      use_ssl = TRUE
    )
  )  
}

