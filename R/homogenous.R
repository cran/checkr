#' Check Homogenous
#' 
#' Checks whether the elements of x are all of the same class.
#' It works on vectors, matrices and arrays which, by definition will always
#' be homogenous and lists and data frames which may or may not be homogenous.
#'
#' @param x The object to check.
#' @param strict A flag indicating whether all the objects must have identical classes or just share one or more classes.
#' @param recursive A flag indicating whether the check should be applied recursively.
#' @param x_name A string of the name of the object.
#' @param error A flag indicating whether to throw an informative error or immediately generate an informative message if the check fails.
#' @return An invisible copy of x (if it doesn't throw an error).
#' @seealso \code{\link{check_vector}}, \code{\link{check_list}} and \code{\link{check_data}} 
#' @export
#'
#' @examples
#' check_homogenous(1:2)
#' check_homogenous(list(1,2))
#' check_homogenous(list(1,TRUE), error = FALSE)
check_homogenous <- function(x,
                             strict = FALSE,
                             recursive = FALSE,
                             x_name = substitute(x),
                             error = TRUE) {
  x_name <- chk_deparse(x_name)
  
  check_flag_internal(strict)
  check_flag_internal(recursive)
  check_flag_internal(error)

  if(is.atomic(x) || is.matrix(x) || is.array(x)) return(invisible(x))
  
  y <- as.list(x)
  if(!length(y)) return(invisible(x))
  
  classes <- lapply(y, class)
  union <- Reduce(union, classes)
  intersect <- Reduce(intersect, classes)
  
  if(strict && (!identical(union, intersect) || !all(vapply(classes, identical, TRUE, union)))) {
    chk_fail("elements in ", x_name, " must have identical classes", error = error)
    return(invisible(x))
  } else if(!strict && !length(intersect)) {
    chk_fail("all elements in ", x_name, " must inherit from the same class", error = error)
    return(invisible(x))
  }
  
  if(recursive) {
    lapply(y, check_homogenous, strict = strict, recursive = recursive, x_name = paste("elements in", x_name), error = error)
  }
  invisible(x)
}
