## ---------------------------- ##
## Load libraries and functions ##
## ---------------------------- ##

library(glmnet)
library(nnet)
library(kernlab)
library(e1071)

setwd("~/Box/projects/deepeye/dev_git/deepeye/code-replicate_and_compare/Coco_Keller/")

source("MyCenter.R")
source("F-score.R")

data = databack = read.table("EMstatistics.txt", header = TRUE)
## saving dataset twice, we need databack later

## show the names of the different features extracted
colnames(data)[4:ncol(data)]


## --------------------------- ##
## Features for Classification ##
## --------------------------- ##

## take out only the features of Green,ea, 20 12
dvs = c(5, 6, 7, 13, 18, 23)

depM = data[, 24] ## the column where the task is
mat = data[, dvs] 
mat = myCenter(mat)

## give the column names back
if ( is.matrix(mat) ) colnames(mat) = colnames(data)[dvs]

data = data.frame(mat, depM)

predictors = names(data) ## define the predictors
predictors = predictors[-length(predictors)]


## ---------------------------------------- ##
## Prepare the set for training and testing ##
## ---------------------------------------- ##

percent = 10
total = test.ind = seq(1,nrow(data), 1)
nr.t = round( length(total)*percent/100 )  ## nr. of testing instances

fold = 10 ## number of folds
train.folds = test.folds = list()
keep = vector()

for (k in 1:fold){   ## create the 10 folds for cross-validation
  
  if (length(test.ind) >= nr.t) {
    tt = sample(test.ind, nr.t) ## may not be possible to create
    ## 10 identical folds
    keep = c(keep, tt)
    ##  print ( c( length(tt), length(unique(tt) ) ) )
  } else {                        ## last fold put all remaining indeces in
    tt = test.ind
  }
  
  ts = setdiff(total, tt)
  
  train.folds[[k]] = ts
  test.folds[[k]] = tt
  
  rm = vector()
  
  for (r in tt){ rm = c(rm, which(test.ind == r)) }
  
  test.ind = test.ind[-rm]
  
  # print( length(test.ind) )
  
}


## initialize the mis-classification matrices, where instances 
## of inaccurate classifications are stored

classes = unique(data$depM)
FglmMis = FmmMis = FsvmMis = matrix(0, nrow = length(classes),
                                    ncol = length( classes ) )
colnames(FglmMis) = rownames(FglmMis) = colnames(FmmMis) = rownames(FmmMis) = colnames(FsvmMis) = rownames(FsvmMis) =  classes


## --------------- ##
## Run classifiers ##
## --------------- ##

k = 1
ans = vector() ## store the results in it

for (k in 1:fold){ ## for all the folds
  print(k)
  
  build = vector()
  
  train.ml = train = data[train.folds[[k]],]
  test = data[test.folds[[k]], ]
  
  ind.var = which(names(test) == "depM") ## get the col index of depM
  test.m = as.character(test[, ind.var])
  predictors = names( train.ml[1:(ncol(train.ml)-1)] )
  
  formula = as.formula ( paste("depM", "~", paste(predictors, collapse = "+"), sep = "") )
  # formula = factor(depM) ~ cMean.Gaze + cNr..Fixation + cMean.Saccade + cProportion.Fixation.Body + cProportion.Fixation.Object + cProportion.Fixation.Face
  
  ## Parameters are kept at standard values
  ## room for optimizing them
  
  ## run multinomial model (MM)
  train.ml$depM = relevel(factor(train.ml$depM), ref = "Prod")
  
  mmodel = multinom(formula, train.ml, maxit = 150, Hess = FALSE)
  mmtest = predict(mmodel, newdata = test, "probs") 
  
  ## run support vector machine (SVM)
  train$depM = factor(train$depM)
  
  SVMmodel =  ksvm(formula, data = train, kernel = "rbfdot")
  SVMpredict = predict(SVMmodel, test)
  
  ## run Lasso regression (LASSO)
  ## LASSO does not cope with NAs, so, first find them in both training and testing
  ## if some are found, remove the row containing them. 
  
  y = train$depM
  glmdata = as.matrix( train[,1:(ncol(train)-1)] )
  glmtest = as.matrix( test[, 1:(ncol(test)-1)] )
  
  ind = which(is.na(glmdata == TRUE), arr.ind = TRUE)  
  if(length(ind) > 0){ glmdata = glmdata[-ind[,1],]; y = y[-ind[,1]]}
  ind = which(is.na(glmtest == TRUE), arr.ind = TRUE)   
  if(length(ind) > 0){ glmtest = glmtest[-ind[,1],]}
  
  glmnetmodel = glmnet(glmdata, y, family = "multinomial", alpha = 0,
                       standardize = F)  
  predglmnet = predict(glmnetmodel, glmtest, s = 1, type = "class" )
  
  ## calculate F-score and percentage accuracy  
  classes = vector()
  
  for (r in 1:nrow(mmtest)){
    row.prob = which(mmtest[r,] == max(mmtest[r, ]) ) 
    classes = c(classes, names(row.prob))}
  
  resd = Fscore(classes, test.m)
  fscr = resd[[1]][, c(1,4)]
  
  Fmm = cbind(fscr, rep("MM", nrow(fscr)))
  FmmMis = (FmmMis + resd[[3]])/2
  
  resd = Fscore(SVMpredict, test.m)
  fscr = resd[[1]][, c(1,4)]
  
  Fsvm = cbind(fscr, rep("SVM", nrow(fscr)))
  FsvmMis = (FsvmMis + resd[[3]])/2
  
  
  resd = Fscore(predglmnet, test.m)
  fscr = resd[[1]][, c(1,4)]
  
  Fglmnet = cbind(fscr, rep("LASSO", nrow(fscr)))
  FglmMis = (FglmMis + resd[[3]])/2
  
  ans = rbind(ans, 
              rbind(Fmm, Fglmnet, Fsvm, deparse.level = 0),
              deparse.level = 0)
  
}

colnames(ans) = c("task", "fscore", "classifier")

# show the overall mean accuracy for the different classifiers, and divided by task
ans = as.data.frame(ans)
ans$fscore = as.numeric(as.matrix(ans$fscore))
# ans$task <- factor(ans$task, levels = c("Naming", "Prod", "Search"))
# ans$classifier <- factor(ans$classifier, levels = c("Lasso", "MM", "SVM"))

str(ans)

## overall
with(ans, tapply(fscore, list(classifier), mean))

## divided by task
with(ans, tapply(fscore, list(classifier, task), mean))

## ----------------------------------------- ##
## Classification of Two Tasks - Plot Figure ##
## ----------------------------------------- ##

## make the dataset smaller on the range to improve plotting
colnames(databack)

databack = subset(databack, databack$Initiation.Time <= 600 & databack$Mean.Saccade <= 500)

Initiation = databack$Initiation.Time
Saccade = databack$Mean.Saccade

Task = as.character(databack$Task)
Task[which(Task == "Prod")] = "Description" 
## just rename Prod, with something clearer
Task = as.factor(Task)

DF = data.frame(Initiation, Saccade, Task)
model = svm(Task ~ Saccade + Initiation, data = DF)

alphacol = c("#00CD0050","#FF000050","#0000FF50") ## transparency

plot(model, DF, svSymbol = 8, dataSymbol = 16, grid = 200,
     symbolPalette = c("green4", "red", "blue"),
     pch = c(16,15,3), col = alphacol)

