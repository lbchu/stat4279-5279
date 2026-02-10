############################################################
# STAT 4279/5279 — Control Flow Examples
# Conditional statements, short-circuit logic, and iteration
############################################################


############################################################
# 1) if() / else: robust absolute value + input checks
############################################################

x <- -0.5

if (!is.numeric(x)) {
  stop("x must be numeric.")
}

if (x >= 0) {
  abs_x = x
} else {
  abs_x = -x
}

abs_x


############################################################
# 2) else if(): letter grades with clear boundaries
############################################################

score <- 83

letter_grade <-
  if (score < 0 || score > 100) {
    stop("Score must be between 0 and 100.")
  } else if (score >= 90) {
    "A"
  } else if (score >= 80) {
    "B"
  } else if (score >= 70) {
    "C"
  } else if (score >= 60) {
    "D"
  } else {
    "F"
  }

letter_grade


############################################################
# 3) ifelse(): vectorized decisions + NA handling
############################################################

scores <- c(55, 68, 83, 95, NA)

# Add 5 points to each score
scores_plus5 <- scores + 5
scores_plus5

# Cap scores above 100
curved <- ifelse(scores_plus5 > 100, 100, scores_plus5)
curved

############################################################
# 4) & vs &&, | vs || : indexing vs single logical decisions
############################################################

u <- runif(10, -1, 1)
u

u[u >= -0.5 & u <= 0.5] <- 999
u


u <- numeric(0)

# Safe: if length(u) == 0, min(u) is never evaluated
if (length(u) > 0 && min(u) < 0) {
  print("Has a negative.")
} else {
  print("Either empty or nonnegative.")
}


u <- runif(1e5)

if (any(u > 0.9999) || mean(u) > 0.55) {
  print("Flag for review.")
} else {
  print("No flag.")
}


############################################################
# 5) for() loop + indexing: compute row means 
############################################################

M <- matrix(1:20, nrow = 5)
M

row_means <- numeric(nrow(M))
for (i in 1:nrow(M)) {
  row_means[i] <- mean(M[i, ])
}
row_means


############################################################
# 6) Nested loops: build a distance matrix
############################################################

x <- c(1, 4, 6)

D <- matrix(NA, nrow = length(x), ncol = length(x))
for (i in seq_along(x)) {
  for (j in seq_along(x)) {
    D[i, j] <- abs(x[i] - x[j])
  }
}
D


############################################################
# 7) while(): simulate until condition is met
############################################################
set.seed(1)

vals <- numeric(0)
while (length(vals) < 1 || max(abs(vals)) <= 2.5) {
  vals <- c(vals, rnorm(1))
}

length(vals)
tail(vals, 5)
max(abs(vals))


