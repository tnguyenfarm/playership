# Multiple Linear Regression
library(dplyr)
# Importing the dataset
dataset = read.csv('activeplayers.csv')
players<- activeplayers2

# Encoding categorical data

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(players$activeplayersperzip, SplitRatio = 0.8)
training_set = subset(players, split == TRUE)
test_set = subset(players, split == FALSE)

# Feature Scaling
# training_set = scale(training_set)
# test_set = scale(test_set)
training_set <<- data.frame(training_set)

# Fitting Multiple Linear Regression to the Training set
regressor = lm(formula = activeplayersperzip ~ .,
               data = training_set)

# Predicting the Test set results
#y_pred = predict(regressor, newdata = test_set)
#print(y_pred)

result<-summary(regressor)

