## function to derive an optimal cut off point for F-score measures
## in classification tasks. 
## classification: two column matrix with probabilities from classifier 
## and true values for the different conditions
## return true pos, false.pos, false.negative, precision, recall, F-score

Fscore = function(predicted, true){
  
classes = unique(true)

# true.pos = false.pos = false.neg = vector()

precision = recall = accuracy =  vector()
misclassified = matrix(0, nrow = length(classes),
    ncol = length( classes ) )

colnames(misclassified) = rownames(misclassified) = classes

count = 0
for (c in classes){
  count = count + 1
  
  ind.pred = which(predicted == c) ## indeces of predicted classified points
  ind.true = which(true == c) ## indeces of true classes

  common =  intersect(ind.true, ind.pred)
  missing = setdiff(ind.true, ind.pred)
  missed = predicted[missing]

  classmis = unique(missed)

  for (c1 in 1:length(classmis) ){

      i1 = which(rownames(misclassified) == classmis[c1])
      i2 = which(colnames(misclassified) == c)

      lms = length( which(missed == classmis[c1]) )/length(ind.true)

      misclassified[i1,i2] = lms
  }

  
  accuracy = c(accuracy, length( common ) )
    
  precision = c(precision, length( common )/length(ind.pred) )
    
  recall = c(recall, length( common )/length(ind.true) )

  ## misclassified

  
  # the below calculation need to be fixed. 
  #  true.pos =  c(true.pos, true.positive)
  #  false.pos = c(false.pos, length(setdiff(ind.pred, ind.true)))
  #  false.neg = c(false.neg, (length(ind.true) - true.positive))
  
}

accuracy = sum(accuracy)/length(true)

# precision = sum(true.pos)/ (sum(true.pos) + sum(false.pos))
# recall = sum(true.pos) / (sum(true.pos) + sum(false.neg))

Fscore = 2*((precision * recall)/(precision + recall))

ans = cbind(classes, cbind(precision, recall, Fscore, deparse.level = 0),
  deparse.level = 0)

return( list(ans, accuracy, misclassified) )

        #list(F_score = F_score, precision = precision, recall = recall) )
        #  , true.pos = true.pos, false.pos = false.pos, 
        #    false.neg = false.neg, classes = classes))
}
