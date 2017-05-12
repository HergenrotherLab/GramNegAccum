##########################################
# Building regression models to predict
# small molecule accumulation in bacteria
#
##########################################

library(caret)

raw <- read.delim("../data/table4.csv", sep=",")
accum <- raw[,4]
Props <- raw[9:326]
training <- cbind(accum, Props)
fullSet <- names(training)[names(training) != "accum"]
numObs <- length(accum)

## Remove Near Zero variance
isNZV <- nearZeroVar(training[,fullSet], saveMetrics = TRUE, freqCut = floor(nrow(training)/5))
fullSet <- rownames(subset(isNZV, !nzv))

# number of conformers is problematic
fullSet <- fullSet[fullSet != "confs"]

## Some are extremely correlated, so removed
predCorr <- cor(training[,fullSet])
highCorr <- findCorrelation(predCorr, .99)
modCorr <- findCorrelation(predCorr, 0.8)
reducedSet <- fullSet[-modCorr]
fullSet <- fullSet[-highCorr]

# Train regressions
ctrl <- trainControl(method = "cv", number = 10)

set.seed(12)
plsTune <- train(x = training[,reducedSet],
                 y = accum,
                 method = "pls",
                 tuneLength = 20,
                 trControl = ctrl,
                 preProc = c("center", "scale"))

set.seed(12)
rlmPCA <- train(x = training[,reducedSet],
                y = accum,
                method = "rlm",
                preProcess = "pca",
                trControl = ctrl)

ridgeGrid <- expand.grid(lambda = seq(0.0001, 0.5, length = 50))
set.seed(12)
ridgeTune <- train(x = training[,reducedSet],
                   y = accum,
                   method = "ridge",
                   tuneGrid = ridgeGrid,
                   trControl = ctrl,
                   preProc = c("center", "scale"))

enetGrid <- expand.grid(lambda = c(0, 0.01, 0.1),
                        fraction = seq(0.05, 1, length = 20))
set.seed(12)
enetTune <- train(x = training[,reducedSet],
                  y = accum,
                  method = "enet",
                  tuneGrid = enetGrid,
                  trControl = ctrl,
                  preProc = c("center", "scale"))

# Evaluate tuning
png(filename = "figs/tune_pls.png",
    width=6, height=6,
    units = "in",
    res = 600)
plot(plsTune)
dev.off()

png(filename = "figs/tune_rlm.png",
    width=6, height=6,
    units = "in",
    res = 600)
plot(rlmPCA)
dev.off()

png(filename = "figs/tune_ridge.png",
    width=6, height=6,
    units = "in",
    res = 600)
plot(ridgeTune)
dev.off()

png(filename = "figs/tune_enet.png",
    width=6, height=6,
    units = "in",
    res = 600)
plot(enetTune)
dev.off()

# Combined plot
par(mfrow=c(2,2))
plot(plsTune)
plot(rlmPCA)
plot(ridgeTune)
plot(enetTune)

# Compare prediction fits
results <- data.frame(obs = rep(accum, 4))
results$pred <- c(predict(plsTune), predict(rlmPCA),
                  predict(ridgeTune), predict(enetTune))
results$type <- c(rep("PLS", numObs), rep("RLM", numObs),
                  rep("Ridge", numObs), rep("Enet", numObs))
results$class <- rep(raw$Accum_class, 4)

# Plot comparison of fits
png(filename = "figs/OvP_regressions.png",
    width=6, height=6,
    units = "in",
    res = 600)
xyplot(obs ~ pred | type, data = results, group = class,
       panel = function(x, y, ...) {
           panel.xyplot(x, y, ...)
           panel.abline(0, 1, lty = "dotted", col = "black")
       },
       xlab = "Predicted Accumulation",
       ylab = "Observed Accumulation",
       xlim = c(-150, 2100),
       ylim = c(-150, 2100),
       scales = list(alternating = 1),
       auto.key = TRUE)
dev.off()

### Variable importance
## Individual models
png(filename = "figs/varImp_pls.png",
    width=4, height=4,
    units = "in",
    res = 1200)
plot(varImp(plsTune), top = 20,
     title = "Top 20 Variables from PLS Regression")
dev.off()

png(filename = "figs/varImp_rlm.png",
    width=4, height=4,
    units = "in",
    res = 1200)
plot(varImp(rlmPCA), top = 20,
     title = "Top 20 Variables from RLM Regression")
dev.off()

png(filename = "figs/varImp_ridge.png",
    width=4, height=4,
    units = "in",
    res = 1200)
plot(varImp(ridgeTune), top = 20,
     title = "Top 20 Variables from Ridge Regression")
dev.off()

png(filename = "figs/varImp_enet.png",
    width=4, height=4,
    units = "in",
    res = 1200)
plot(varImp(enetTune), top = 20,
     title = "Top 20 Variables from Enet Regression")
dev.off()
