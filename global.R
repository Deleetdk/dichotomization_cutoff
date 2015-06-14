n = 100000

#Percent function
#credit: http://stackoverflow.com/a/7146270/3980197
percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}