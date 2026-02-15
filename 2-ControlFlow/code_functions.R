## Suppose we want to standardize a few vectors. 
## Without a function, you would need a lot of copy/pastes:
x <- 1:5
y <- c(100, 1000)
z <- c(-1, 1, 3)
w <- c(1, 3, NA, 5)


## Let's make this fast/easy with a custom function: 
standardize <- function(x) {
  return((x - mean(x)) / sd(x))
}

# Note: return statement is optional if are only returning a single value.
# Function names should be meaninful. Naming your function fun1 or fun2 will make
# reading your code very difficult. 

## More robust version that can handle NAs: 

standardize_robust <- function(x, na.rm=FALSE) {
  (x - mean(x, na.rm=na.rm)) / sd(x, na.rm=na.rm)
}


## If you want to return multiple objects, return a list:
standardize <- function(x, na.rm=FALSE) {
  m <- mean(x, na.rm=na.rm)
  s <- sd(x, na.rm=na.rm) 
  list(standardized = (x - m) / s,
       mean = m,
       sd = s)
}

## Defensive programming ##
## using conditional statements to ensure your input is the right data type
myMean <- function(x, na.rm=FALSE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  sum(x) / length(x)
}