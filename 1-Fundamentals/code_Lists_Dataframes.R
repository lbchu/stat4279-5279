############################################################
# Data Structures: Lists and Data Frames
############################################################

# ----------------------------------------------------------
# 1) LISTS: storing mixed information about one student
# ----------------------------------------------------------
student_1 <- list(
  name = "Alex",
  year = 2,
  major = "Statistics",
  enrolled = TRUE,
  quiz_scores = c(8, 9, 10)
)

student_1
str(student_1)

# Lists can store different types together
typeof(student_1$name)
typeof(student_1$quiz_scores)

# ----------------------------------------------------------
# 2) ACCESSING LIST ELEMENTS: [ ] vs [[ ]]
# ----------------------------------------------------------
student_1["quiz_scores"]    # returns a sub-list
student_1[["quiz_scores"]]  # returns the vector itself

# Indexing inside a list element
student_1[["quiz_scores"]][1]

# Shortcut using $
student_1$name
student_1$year

# ----------------------------------------------------------
# 3) ADDING AND REMOVING LIST ELEMENTS
# ----------------------------------------------------------
# Add new information
student_1$final_exam <- 92
student_1[["attendance_rate"]] <- 0.95

student_1

# Remove an element by setting it to NULL
student_1$attendance_rate <- NULL
names(student_1)

# ----------------------------------------------------------
# 4) EXPANDING LISTS WITH c() AND append()
# ----------------------------------------------------------
# Create a second student
student_2 <- list(
  name = "Jordan",
  year = 3,
  major = "Economics",
  enrolled = TRUE,
  quiz_scores = c(7, 8, 9)
)

# Combine students into a list of students
class_list <- list(student_1, student_2)
class_list
str(class_list)

# Add a note at the beginning
class_list2 <- append(class_list, list("Spring semester"), after = 0)
class_list2

# ----------------------------------------------------------
# 5) FLATTENING LISTS
# ----------------------------------------------------------
# Only makes sense when contents are compatible
simple_list <- list(1:3, 4:6)
simple_list
unlist(simple_list)

# Mixed types force coercion
mixed_list <- list(1, TRUE, "A")
unlist(mixed_list)

# ----------------------------------------------------------
# 6) KEY–VALUE IDEA: position does not matter
# ----------------------------------------------------------
grading_rule <- list(
  homework_weight = 0.3,
  quiz_weight = 0.2,
  exam_weight = 0.5
)

grading_rule$exam_weight
grading_rule[["homework_weight"]]

# ----------------------------------------------------------
# 7) DATA FRAMES: multiple students, same variables
# ----------------------------------------------------------
students_df <- data.frame(
  name = c("Alex", "Jordan", "Taylor"),
  year = c(2, 3, 1),
  major = c("Statistics", "Economics", "Mathematics"),
  midterm = c(88, 75, 91),
  enrolled = c(TRUE, TRUE, FALSE)
)

students_df
str(students_df)

# ----------------------------------------------------------
# 8) DATA FRAME INDEXING (matrix-like)
# ----------------------------------------------------------
students_df[1, ]          # first student
students_df[, "midterm"]  # midterm scores as a vector
students_df[,"midterm", drop = FALSE]  # midterm scores as a data frame

# Logical indexing on rows
students_df[students_df$midterm > 80, ]

# ----------------------------------------------------------
# 9) DATA FRAMES VS MATRICES
# ----------------------------------------------------------
score_matrix <- matrix(
  c(88, 75, 91,
    92, 81, 85),
  nrow = 3
)

colnames(score_matrix) <- c("Midterm", "Final")
score_matrix

# Matrix: all one type
typeof(score_matrix)

# Data frame: columns can differ in type
typeof(students_df)

# ----------------------------------------------------------
# 10) COLUMN-WISE OPERATIONS
# ----------------------------------------------------------
mean(students_df$midterm)

# Works on numeric columns only
colMeans(students_df[, c("midterm")])

# ----------------------------------------------------------
# TAKEAWAYS
# ----------------------------------------------------------
# - Lists store *anything* (mixed types, nested structures)
# - [[ ]] extracts contents; [ ] preserves structure
# - Names enable key–value lookup
# - Data frames organize many observations in a $nxp$ table
# - Data frames behave like both lists and matrices
