# Same underlying information (year in school),
# stored in three different ways

# Numeric representation:
# Appropriate when values have a natural order and arithmetic meaning
grade_num <- c(1, 2, 3, 4)

# Factor representation:
# Appropriate for categorical variables with a fixed set of levels
grade_fac <- factor(c("Freshman", "Sophomore", "Junior", "Senior"))

# Character representation:
# Just text labels; no inherent statistical meaning
grade_chr <- c("Freshman", "Sophomore", "Junior", "Senior")


# Numeric variables support arithmetic
mean(grade_num)
mean(grade_fac)
mean(grade_chr)
# Numeric comparisons are well-defined
grade_num > 2


# Factors are designed for counting and grouping
table(grade_fac)
levels(grade_fac)
levels(grade_chr)

# Outcome variable (e.g., exam scores)
y <- c(70, 75, 82, 90)

# Using a factor in a linear regression model: 
# Fits a separate mean for each grade level (categorical effect)
lm(y ~ grade_fac)

# When a character variable is used in a model,
# R silently converts it to a factor
lm(y ~ grade_chr)

# Using numeric grade assumes a linear trend:
# each one-unit increase in grade_num has the same effect
lm(y ~ grade_num)

# Using factor grade estimates a separate mean for each group
lm(y ~ grade_fac)

### How are factors represented mathematically in a linear regression model? 


