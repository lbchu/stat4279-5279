## Example of sampling importance resampling 

## Idea: sample from something easy, then reweight and resample to mimic something hard.
set.seed(2026)

# -----------------------------
# 1. Define target and proposal
# -----------------------------

# Unnormalized target density
target_unnorm <- function(x) {
  0.4 * exp(-0.5 * ((x + 2) / 0.7)^2) +
    0.6 * exp(-0.5 * ((x - 2) / 1.0)^2)
}

# Proposal density q(x) = N(0, 3^2)
proposal_density <- function(x) {
  dnorm(x, mean = 0, sd = 3)
}

# -----------------------------
# 2. Draw from proposal
# -----------------------------
N <- 5000
x_prop <- rnorm(N, mean = 0, sd = 3)

# -----------------------------
# 3. Compute importance weights
# -----------------------------
w_raw <- target_unnorm(x_prop) / proposal_density(x_prop)
w <- w_raw / sum(w_raw)

# -----------------------------
# 4. Resample using the weights
# -----------------------------
M <- 5000
x_sir <- sample(x_prop, size = M, replace = TRUE, prob = w)

