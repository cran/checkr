#' Check TimeZone
#' 
#' Checks an objects tzone attribute.
#' This function has been deprecated for \code{\link{check_tzone}}.
#'
#' @param x The object to check.
#' @param tz A string of the time zone.
#' @param x_name A string of the name of the object.
#' @param error A flag indicating whether to throw an informative error or immediately generate an informative message if the check fails.
#' @return An invisible copy of x (if it doesn't throw an error).
#' @seealso \code{\link{check_tzone}}
#' @export
#'
#' @examples
#' check_tzone(Sys.Date(), error = FALSE)
#' x <- as.POSIXct("2000-01-02 03:04:55", tz = "Etc/GMT+8")
#' check_tzone(x, tzone = "PST8PDT", error = FALSE)
check_tz <- function(x, tz = "UTC", x_name = substitute(x),
                         error = TRUE) {
  .Deprecated("check_tzone")
  x_name <- deparse_x_name(x_name)
  check_tzone(x, tzone = tz, x_name = x_name, error = error)
}
