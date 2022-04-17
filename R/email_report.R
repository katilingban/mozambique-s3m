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
                               attachment = data_review_report[1],
                               sender = Sys.getenv("GMAIL_USERNAME"),
                               recipient = Sys.getenv("REPORT_RECIPIENTS")) {
  ## Add attachment
  blastula::add_attachment(
    email = message,
    file = attachment
  ) |>
  ## Set-up SMTP and send email report
  blastula::smtp_send(
    to = recipient,
    bcc = sender,
    from = sender, 
    subject = paste0(
      "Daily data quality report - Zambezia and Nampula Endline Survey - ",
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

