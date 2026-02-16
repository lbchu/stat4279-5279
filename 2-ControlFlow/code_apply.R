# Matrix
X <- matrix(1:12, nrow = 3)

apply(X, 1, mean)   # row means
apply(X, 2, mean)   # column means

col_means = numeric(ncol(X))
for(i in 1:ncol(X)){
  col_means[i] = mean(X[,i])
}

# List (same data split by column)
L <- list(col1 = X[,1], col2 = X[,2], col3 = X[,3], col4 = X[,4])

lapply(L, mean)

sapply(L, mean)

vapply(L, mean, FUN.VALUE = numeric(1))

####################################
# What would you use on a data frame? 
####################################
df <- data.frame(
  x = 1:5,
  y = 6:10,
  z = rnorm(5)
)

# A data frame is internally a list of columns.
lapply(df, mean)
sapply(df, mean)

apply(df, 2, mean) ## apply converts the df to a matrix. Avoid apply() unless data is purely numeric.

########################################################################
# When you have mix types, make sure you are using appropriate functions 
########################################################################
df2 <- data.frame(
  x = 1:5,
  group = c("A", "B", "A", "B", "A")
)

apply(df2, 2, mean)   # likely error or coercion issue

lapply(df2, mean)   # likely error or coercion issue

tapply(df2$x, df2$group, mean)
