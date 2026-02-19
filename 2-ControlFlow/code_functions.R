############################################################
# 1) Write our own functions!
############################################################

## Suppose we want to standardize a few vectors. 
## Without a function, you would need a lot of copy/pastes:
x <- 1:5
y <- c(100, 1000)
z <- c(-1, 1, 3)
w <- c(1, 3, NA, 5)

(x - mean(x))/sd(x)
(y - mean(y))/sd(y)
(z - mean(z))/sd(z)
(w - mean(w))/sd(w)

## Let's make this fast/easy with a custom function: 
standardize <- function(x) {
  return((x - mean(x)) / sd(x))
}

standardize(x)
standardize(w)

# Note: return statement is optional if are only returning a single value.
# Function names should be meaningful. Naming your function fun1 or fun2 will make
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

############################################################
# 2) Connecting our custom functions with the apply() family:
############################################################

x <- 1:5
y <- c(100, 1000)
z <- c(-1, 1, 3)
w <- c(1, 3, NA, 5)

vecs <- list(x = x, y = y, z = z, w = w)

lapply(vecs, standardize_robust)

lapply(vecs, standardize_robust, na.rm = TRUE) ## can pass extra argument!

res <- lapply(vecs, standardize, na.rm = TRUE)
res$w                 # the output for vector w
res$w$standardized    # standardized values for w
res$w$mean            # mean used
res$w$sd              # sd used

#lapply() always returns a list. sapply() tries to simplify.
sapply(vecs, myMean, na.rm = TRUE)

### you can also write functions dynamically within apply()

M <- matrix(c(1, 5, 3,
              4, 2, 8,
              7, 6, 9), nrow = 3)

# col is each column
# the function is written inline
# no initilization 
apply(M, 2, function(col) {
  max(col) - min(col)
})

# Compute standardized columns without using standardize_robust():
apply(M, 2, function(col) {
  m <- mean(col)
  s <- sd(col)
  (col - m) / s
})

############################################################
# 3) Can build nested loops with custom functions:
############################################################
# Two matrices
M1 <- matrix(1:9, nrow = 3)
M2 <- matrix(c(10, 20, 30,
               5,  15, 25,
               2,   4,  6), nrow = 3)

mat_list <- list(A = M1, B = M2)


lapply(mat_list, function(M) {
  apply(M, 2, standardize_robust)
})

#############################
### explicit loop version ###
#############################

# Pre-allocate list to store results
result <- vector("list", length(mat_list))
names(result) <- names(mat_list)

# Loop over matrices
for (i in seq_along(mat_list)) {
  
  M <- mat_list[[i]]
  
  # Pre-allocate matrix for standardized columns
  M_std <- matrix(NA, nrow = nrow(M), ncol = ncol(M))
  
  # Loop over columns
  for (j in seq_len(ncol(M))) {
    M_std[, j] <- standardize_robust(M[, j])
  }
  
  result[[i]] <- M_std
}

result

