
library(magrittr)

data.partition.multi <- function(X.train, X.test, seed = NULL){
   
   X.train <- as.matrix(X.train)
   X.test <- as.matrix(X.test)
   
   X <- rbind(X.train, X.test)
   
   classes <- unique(X[,1])
   
   partitioned.list <- selected.list <- train.sample <- test.sample <- list()
   
   for (i in 1:length(classes)) {
      partitioned.list[[i]] <- X[X[,1] == classes[i] , ]
   }
   
   partitioned.rows <- sapply(partitioned.list, nrow)
   
   if(is.null(seed) == FALSE) {set.seed(seed)}
   
   for (i in 1:length(classes)) {
      selected.list[[i]] <- sample(which(X[,1] == classes[i]), 
                                   round(partitioned.rows[i]/2),
                                   replace = FALSE)
      
      train.sample[[i]] <- X[selected.list[[i]],]
      test.sample[[i]] <- X[setdiff(which(X[,1] == classes[i]), 
                                    selected.list[[i]]),]
   }
   
   train.sample <- train.sample %>% do.call('rbind', .) %>% as.matrix()
   test.sample <- test.sample %>% do.call('rbind', .) %>% as.matrix()
   
   return(list("TRAIN" = train.sample, "TEST" = test.sample))
}


labels.rename <- function(X.train, X.test){
   
   X.train <- as.matrix(X.train)
   X.test <- as.matrix(X.test)
   
   X <- rbind(X.train, X.test)
   
   if (length(setdiff(unique(X[,1]), 1:length(unique(X[,1])))) == 0) {
      return(list("TRAIN" = X.train, "TEST" = X.test))
   }
   
   original.labels <- X[,1] %>% as.character()
   new.label.names <- 1 : length(unique(original.labels))
   
   X[,1] <- new.label.names[as.factor(original.labels)]
   
   return(list("TRAIN" = X[1:nrow(X.train) , ], 
         "TEST" = X[(nrow(X.train)+1):nrow(X) , ]))
}

