# Clear all data from memory
rm(list = ls())

# Set the working directory
setwd("~/Desktop/side projects/cryptos/R")

# Import needed libraries
library("rpart", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")
library("rpart.plot", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")





## PREPOCESSING

# Read entire dataset
x <- read.csv('./crypto-markets.csv', header = TRUE)

# Extract only Ripple data
ripple <- x[x['symbol'] == 'XRP', ]

# Create new binary column
# 1 if increased in the day
ripple$Price_Increase <- 0

# If the closing price is greater than the opening price
ripple[ripple['open'] < ripple['close'], 14] <- 1

# Turn the numbers into factors (binary purposes)
ripple$Price_Increase = as.factor(ripple$Price_Increase)



## BUILD AND TEST MODEL

d = ncol(ripple)
n = nrow(ripple)
index = sample(n) %% 10 # every tenth item

decision_tree <- function() {
  fit <- rpart(Price_Increase~open+volume+spread, method = 'class', data = ripple[index!=0, ])
  pred = as.integer(predict(fit, ripple[index==0, ], type = 'vector'))

  rpart.plot(fit, type=4, extra=106)
  t = table(pred, ripple[index==0, 14])
  
  precision = (t[2,2]) / (t[2,2] + t[2,1])
  recall = (t[2,2]) / (t[2,2] + t[1,2])
  accuracy = (t[2,2] + t[1,1]) / (t[1,1] + t[1,2] + t[2,1] + t[2,2])
  
  prec = paste("Precision:", precision, sep = " ")
  rec = paste("Recall:", recall, sep = " ")
  acc = paste("Accuracy:", accuracy, sep = " ")
  print(prec)
  print(rec)
  print(acc)
  
}


## ANALYSIS
