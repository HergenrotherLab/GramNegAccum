calcWithinGroupsVariance <- function(variable,groupvariable)
      {
         # find out how many values the group variable can take
         groupvariable2 <- as.factor(groupvariable[[1]])
         levels <- levels(groupvariable2)
         numlevels <- length(levels)
         # get the mean and standard deviation for each group:
         numtotal <- 0
         denomtotal <- 0
         for (i in 1:numlevels)
         {
            leveli <- levels[i]
            levelidata <- variable[groupvariable==leveli,]
            levelilength <- length(levelidata)
            # get the mean and standard deviation for group i:
            meani <- mean(levelidata)
            sdi <- sd(levelidata)
            numi <- (levelilength - 1)*(sdi * sdi)
            denomi <- levelilength
            numtotal <- numtotal + numi
            denomtotal <- denomtotal + denomi
         }
         # calculate the within-groups variance
         Vw <- numtotal / (denomtotal - numlevels)
         return(Vw)
      }

calcBetweenGroupsVariance <- function(variable,groupvariable)
      {
         # find out how many values the group variable can take
         groupvariable2 <- as.factor(groupvariable[[1]])
         levels <- levels(groupvariable2)
         numlevels <- length(levels)
         # calculate the overall grand mean:
         grandmean <- mean(variable[,1])
         # get the mean and standard deviation for each group:
         numtotal <- 0
         denomtotal <- 0
         for (i in 1:numlevels)
         {
            leveli <- levels[i]
            levelidata <- variable[groupvariable==leveli,]
            levelilength <- length(levelidata)
            # get the mean and standard deviation for group i:
            meani <- mean(levelidata)
            sdi <- sd(levelidata)
            numi <- levelilength * ((meani - grandmean)^2)
            denomi <- levelilength
            numtotal <- numtotal + numi
            denomtotal <- denomtotal + denomi
         }
         # calculate the between-groups variance
         Vb <- numtotal / (numlevels - 1)
         Vb <- Vb[[1]]
         return(Vb)
      }

## Calculate the separation between groups based on group variances
calcSeparations <- function(variables,groupvariable)
  {
     # find out how many variables we have
     variables <- as.data.frame(variables)
     numvariables <- length(variables)
     # find the variable names
     variablenames <- colnames(variables)
     DF <- data.frame(Vw=rep(0.0, numvariables),
                      Vb=rep(0.0, numvariables),
                      sep=rep(0.0, numvariables),
                      stringsAsFactors=FALSE)
     rownames(DF) <- variablenames
     # calculate the separation for each variable
     for (i in 1:numvariables)
     {
        variablei <- variables[i]
        variablename <- variablenames[i]
        Vw <- calcWithinGroupsVariance(variablei, groupvariable)
        Vb <- calcBetweenGroupsVariance(variablei, groupvariable)
        sep <- Vb/Vw
        DF[i,] <- c(Vw, Vb, sep)
     }
     DF
  }

## Print Mean and SD by group
printMeanAndSdByGroup <- function(variables,groupvariable)
  {
     # find the names of the variables
     variablenames <- c(names(groupvariable),names(as.data.frame(variables)))
     # within each group, find the mean of each variable
     groupvariable <- groupvariable[,1] # ensures groupvariable is not a list
     means <- aggregate(as.matrix(variables) ~ groupvariable, FUN = mean)
     names(means) <- variablenames
     print(paste("Means:"))
     print(means)
     # within each group, find the standard deviation of each variable:
     sds <- aggregate(as.matrix(variables) ~ groupvariable, FUN = sd)
     names(sds) <- variablenames
     print(paste("Standard deviations:"))
     print(sds)
     # within each group, find the number of samples:
     samplesizes <- aggregate(as.matrix(variables) ~ groupvariable, FUN = length)
     names(samplesizes) <- variablenames
     print(paste("Sample sizes:"))
     print(samplesizes)
  }
