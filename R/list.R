#' Check List
#' 
#' Checks whether an object is a list and optionally the names and values
#' of its elements.
#'
#' @inheritParams check_length
#' @inheritParams check_data
#' @param x The object to check.
#' @param values An optional vector or named list specifying the values.
#' @param length A flag indicating whether x should have elements (versus no elements) or a missing value indicating no requirements or a count or count range of the number of elements or a count vector of the permitted number of elements.
#' @param unique A flag indicating whether the values must be unique.
#' @param named A flag indicating whether the list must be named or unnamed or a regular expression that must match all the names or count or count range of the number of characters in the names or NA if it doesn't matter if the list is named.
#' @param exclusive A flag indicating whether other elements are not permitted.
#' @param order A flag indicating whether the elements have to occur in the same order as values.
#' @param x_name A string of the name of the object.
#' @param error A flag indicating whether to throw an informative error or immediately generate an informative message if the check fails.
#' @return An invisible copy of x (if it doesn't throw an error).
#' @seealso \code{\link{check_length}} and \code{\link{check_unique}}
#' @export
#' 
#' @examples
#' check_list(list())
#' check_list(list(x1 = 2, x2 = 1:2), values = list(x1 = 1, x2 = 1L))
check_list <- function(x,
                       values = NULL,
                       length = NA,
                       unique = FALSE,
                       named = NA,
                       exclusive = FALSE,
                       order = FALSE,
                       x_name = substitute(x),
                       error = TRUE) {
  x_name <- chk_deparse(x_name)
  
  if (!is.list(x)) err(x_name, " must be a list")
  
  check_flag_internal(unique)
  check_flag_internal(error)
  
  if (!missing(length))
    wrn("argument length is deprecated; please specify values or use check_length() instead.")

  if (!missing(unique))
    wrn("argument unique is deprecated; please use check_unique() instead.")

  if (!missing(named))
    wrn("argument named is deprecated; please name values or use check_named() instead.")

  if(!(is_flag(named) || is_string(named) || is_NA(named) || is_count(named) || is_count_range(named))) 
    err("named must be a flag, string, count, count range or NA")
  
  regex <- ".*"
  nchar <- c(0L, .Machine$integer.max)
  if(is_string(named)) {
    regex <- named
    named <- TRUE
  } else if(is_count(named) || is_count_range(named)) {
    nchar <- named
    named <- TRUE
  }
  
  if(!is.null(values)) {
    if(is.list(values)) {
      check_named(values, unique = TRUE)
      check_names(x, names = names(values), exclusive = exclusive, order = order)
      
      for(name in names(values)) {
        check_values(x[[name]], values[[name]], x_name = paste("element", name, "of", x_name), error = error)
      }
    } else {
      if(!is.atomic(values)) err("values must be an atomic vector or a named list")
      check_names(x, names = values, exclusive = exclusive, order = order)
    }
  }
  check_length(x, length = length, x_name = x_name, error = error)
  
  if(unique) check_unique(x, x_name = x_name, error = error)
  
  if(is_flag(named) && named) {
    check_named(x, nchar = nchar, pattern = regex, x_name = x_name, error = error)
  } else if(is_flag(named) && !named)
    check_unnamed(x, x_name = x_name, error = error)
    
  invisible(x)
}
