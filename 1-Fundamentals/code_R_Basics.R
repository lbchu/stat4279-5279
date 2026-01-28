############################################################
# R Basics: Data Types and Operators (example code)
# Purpose: demonstrate interactive evaluation, types, operators,
#          assignment, workspace, and reproducibility mindset.
############################################################

# ----------------------------------------------------------
# 1) Interactive evaluation (everything runs line-by-line)
# ----------------------------------------------------------
7
7 + 5
7 - 5
7 * 5
7^5
7 / 5
7 %% 5

# Show that functions are objects too:
log
`+`          # operators are functions in R
`%%`

# ----------------------------------------------------------
# 2) Comparison operators return logical values
# ----------------------------------------------------------
7 > 5
7 < 5
7 >= 7
7 <= 5
7 == 5
7 != 5

# Common pitfall: "=" assigns in some contexts; "==" compares
x <- 7
x == 7
# x = 8      # also assignment, but prefer <- for clarity

# ----------------------------------------------------------
# 3) Logical operators: &, |, !  (and why parentheses help)
# ----------------------------------------------------------
(5 > 7) & (6 * 7 == 42)
(5 > 7) | (6 * 7 == 42)
!(6 * 7 == 42)

# elementwise (&, |) vs single-test (&&, ||)

TRUE  & c(TRUE, FALSE, TRUE) ## elementwise logicals 
any(c(TRUE, TRUE, TRUE)) && any(c(FALSE, FALSE, FALSE)) ## length 1 logicals (scalar)

# ----------------------------------------------------------
# 4) Types: typeof() and is.*()
# ----------------------------------------------------------
typeof(7)        # "double" (numeric) in R
typeof(7L)       # "integer" (the L forces integer)
typeof(TRUE)     # "logical"
typeof("hello")  # "character"

is.numeric(7)
is.integer(7)
is.integer(7L)
is.character("FALSE")
is.character(FALSE)

# NA and special values:
is.na(7)
is.na(7 / 0)     # Inf is not NA
is.infinite(7/0)
is.na(0 / 0)     # NaN (Not a Number) is NA-like

# ----------------------------------------------------------
# 5) Type casting (coercion): as.character(), as.numeric(), etc.
# ----------------------------------------------------------
typeof(5/6)
as.character(5/6)

# Cast to character, then back:
x_char <- as.character(5/6)
x_num  <- as.numeric(x_char)

x_char
x_num
6 * x_num

# Floating-point note: exact equality can be tricky
(5/6) == x_num
all.equal(5/6, x_num)  # preferred for numeric comparisons

# ----------------------------------------------------------
# 6) Names (variables) and built-ins
# ----------------------------------------------------------
pi
pi * 10
cos(pi)

approx.pi <- 22/7
diameter  <- 10
approx.pi * diameter

circumference <- approx.pi * diameter
circumference

# Reassignment (same name, new value):
circumference <- 30
circumference

# ----------------------------------------------------------
# 7) Inspecting objects quickly
# ----------------------------------------------------------
x <- 42
x
print(x)      # explicit printing
str(x)        # structure (more useful later for data/df)
class(x)      # "numeric" (class) vs typeof(x) (storage type)

# ----------------------------------------------------------
# 8) Workspace: ls(), rm()
# ----------------------------------------------------------
ls()              # what's currently defined?
rm(x)             # remove one object
ls()

# Danger zone (do NOT run unless you mean it):
# rm(list = ls())

# ----------------------------------------------------------
# 9) Reproducibility mindset (R Markdown runs top-to-bottom)
# ----------------------------------------------------------
# Example of "explicit is better than implicit":
# - Load packages at the top
# - Create objects in code (do not rely on saved workspace)

set.seed(123)         # makes randomness repeatable
rnorm(5)

# If you restart R and re-run THIS FILE, you get the same results.
