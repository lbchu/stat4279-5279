############################################################
# Context: tracking study time and lab measurements
# Goal: demonstrate data structures + indexing naturally
############################################################

# ----------------------------------------------------------
# 1) VECTORS: weekly study hours for one student
# ----------------------------------------------------------
study_hours <- c(12, 9, 15, 8, 10)
study_hours

length(study_hours)
is.vector(study_hours)

# Inspect specific days
study_hours[1]      # Monday
study_hours[5]      # Friday
study_hours[-3]     # all days except Wednesday

# ----------------------------------------------------------
# 2) BUILDING VECTORS PROGRAMMATICALLY
# ----------------------------------------------------------
# Planned target hours (same each weekday)
target_hours <- rep(10, times = 5)
target_hours

rep(c(1,2), times=5)
rep(c(1,2), each=5)

# Difference between actual and planned
study_hours - target_hours

# ----------------------------------------------------------
# 3) VECTORIZED OPERATIONS + RECYCLING
# ----------------------------------------------------------
# Increase all study hours by 10% (scalar recycling)
1.1 * study_hours

# Weekend bonus applied unevenly (recycling rule)
study_hours + c(0, 0, 0, 2, 2)

# Logical comparisons are vectorized
study_hours >= 10

# Combine logical conditions
(study_hours >= 10) & (study_hours <= 14)

1:6 + 1:2
1:7 + 1:3
# ----------------------------------------------------------
# 4) LOGICAL INDEXING
# ----------------------------------------------------------
# Extract "high study" days
high_days <- study_hours[study_hours >= 12]
high_days

# Which days were those?
which(study_hours >= 12)

# ----------------------------------------------------------
# 5) FUNCTIONS ON VECTORS
# ----------------------------------------------------------
mean(study_hours)
sd(study_hours)
summary(study_hours)

any(study_hours < 8)    # any low-study days?
all(study_hours >= 6)   # minimum effort threshold?

study_hours
which(study_hours > 10)
# ----------------------------------------------------------
# 6) NAMED VECTORS (SEMANTIC LABELS)
# ----------------------------------------------------------
days <- c("Mon", "Tue", "Wed", "Thu", "Fri")
typeof(days)
names(study_hours) <- days
study_hours

# Index using names
study_hours["Wed"]
study_hours[c("Mon", "Fri")]

# ----------------------------------------------------------
# 7) MATRIX: lab measurements for two experiments
# ----------------------------------------------------------
# Rows = experiments, columns = trials
lab_results <- matrix(
  c(5.1, 5.5, 4.9,
    6.2, 6.0, 6.4),
  nrow = 2,
  byrow = TRUE
)

lab_results

rownames(lab_results) <- c("Exp_A", "Exp_B")
colnames(lab_results) <- c("Trial_1", "Trial_2", "Trial_3")
lab_results

# ----------------------------------------------------------
# 8) MATRIX INDEXING
# ----------------------------------------------------------
lab_results["Exp_A", ]
lab_results[, "Trial_2"]
lab_results["Exp_B", "Trial_3"]

# Logical matrix indexing
lab_results > 6

which(lab_results > 6, arr.ind = TRUE)

# ----------------------------------------------------------
# 9) ROW / COLUMN OPERATIONS
# ----------------------------------------------------------
# Average measurement per experiment
rowMeans(lab_results)

# Average measurement per trial
colMeans(lab_results)

# ----------------------------------------------------------
# 10) MATRIX MULTIPLICATION (%*%)
# ----------------------------------------------------------
# Weighted average of trials
weights <- c(0.2, 0.3, 0.5)

# Each experiment gets a single weighted score
lab_results %*% weights

# ----------------------------------------------------------
# 11) FLATTENING AND BINDING
# ----------------------------------------------------------
as.vector(lab_results)

extra_trial <- c(5.0, 6.1)
cbind(lab_results, Trial_4 = extra_trial)

# ----------------------------------------------------------
# 12) TAKEAWAY
# ----------------------------------------------------------
# - Vectors store related values of ONE type
# - Indexing selects subsets (numeric, logical, named)
# - Matrices organize vectors into rows/columns
# - Most operations are vectorized
# - %*% is algebraic matrix multiplication
