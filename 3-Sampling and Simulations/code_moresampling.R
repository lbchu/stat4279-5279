
set.seed(4279)

## ------------------------------------------------------------
## Example target distribution 
## Target density on [0, 4]:  f(t) ∝ exp(-t^2)
## We only need the *unnormalized* density f_tilde(t).
## ------------------------------------------------------------
f_tilde <- function(t) {
  out <- exp(-t^2)
  out[t < 0 | t > 4] <- 0   # force support to be [0,4]
  out
}

## Proposal distribution g(t): Uniform(0,4)
g_samp <- function(n) runif(n, min = 0, max = 4)   # how to sample from g
g_dens <- function(t) dunif(t, min = 0, max = 4)   # density g(t)

## ------------------------------------------------------------
## Generic rejection sampler
## Inputs:
##   n       = number of accepted draws we want
##   f_tilde = unnormalized target density (we can evaluate it)
##   g_samp  = function to sample from proposal g
##   g_dens  = function to evaluate proposal density g
##   M       = constant so that f_tilde(t) <= M * g(t) for all t
## Output:
##   list with accepted draws and the acceptance rate
## ------------------------------------------------------------
rej_samp <- function(n, f_tilde, g_samp, g_dens, M) {
  out <- numeric(0)  # will store accepted draws
  n_try <- 0         # counts how many proposals we tried
  
  while (length(out) < n) {
    y <- g_samp(1)    ## sample a value 'y' from the proposal distribution g
    u <- runif(1)     ## sample a Uniform(0,1) random variable
    n_try <- n_try + 1
    
    ## Accept if u <= f_tilde(y) / (M * g(y))
    ## This makes the accepted y-values have the target distribution.
    if (u <= f_tilde(y) / (M * g_dens(y))) {
      out <- c(out, y)
    }
  }
  
  list(draws = out, acceptance_rate = n / n_try)
}

## For this example:
## - f_tilde(t) <= 1
## - g(t) = 1/4 on [0,4]
## so M = 4 works because 1 <= 4*(1/4).
sim <- rej_samp(n = 2000, f_tilde = f_tilde, g_samp = g_samp, g_dens = g_dens, M = 4)
sim$acceptance_rate

## Quick plot to check the shape
hist(sim$draws, breaks = 40, freq = FALSE, col = "lightgray",
     main = "Rejection sampling draws from f(t) = exp(-t^2) on [0,4]",
     xlab = "t")

## Overlay a normalized version of the density (for shape only)
Z <- integrate(f_tilde, lower = 0, upper = 4)$value
curve(f_tilde(x) / Z, from = 0, to = 4, add = TRUE, lwd = 2)

####################################################################

set.seed(4279)

## ------------------------------------------------------------
## Goal: estimate a rare probability under a Half-Normal model
## X = |Z| where Z ~ N(0,1)
## p = P(X > a)
## ------------------------------------------------------------
n <- 50000
a <- 4

## True value (for checking only): P(|Z| > a) = 2*(1 - F(a)), wher F(a) is the CDF for normal 
p_true <- 2 * (1 - pnorm(a))
p_true

## ------------------------------------------------------------
## Importance sampling:
## Choose a proposal g that generates large values more often.
## A simple choice is Exponential(rate).
## Exponential has a heavier tail than half-normal, so it oversamples the tail.
## ------------------------------------------------------------
rate <- 0.7
x_prop <- rexp(n, rate = rate)        # sample from proposal g

## Target density f for half-normal(0,1): f(x) = sqrt(2/pi) * exp(-x^2/2), x>=0
f_dens <- function(x) sqrt(2/pi) * exp(-x^2 / 2)

## Proposal density g for Exp(rate): g(x) = rate * exp(-rate*x), x>=0
g_dens <- function(x) dexp(x, rate = rate)

## Importance weights: w(x) = f(x)/g(x)
w <- f_dens(x_prop) / g_dens(x_prop)

## P(X >a) = E( I(X>a))

## Importance estimator for E_f[ I(X>a) ]  = E_g[ I(X>a) * w(X) ]
p_hat_is <- mean((x_prop > a) * w)

c(p_true = p_true, importance = p_hat_is)

## ------------------------------------------------------------
## ESS: Effective Sample Size (diagnostic for weight stability)
## ESS close to n is good; ESS much smaller than n is a warning.
## ------------------------------------------------------------
ESS <- (sum(w)^2) / sum(w^2)
c(n = n, ESS = ESS, ESS_fraction = ESS / n)


