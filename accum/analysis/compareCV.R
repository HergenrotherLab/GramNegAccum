### Compare cross-validation methods

library(caret)
library(pROC)
library(RColorBrewer)

raw <- read.delim("../data/ensemble_gen/merged_data.csv", sep=",")

Class <- raw[,6]
Props <- raw[8:304]
training <- cbind(Class,Props)
fullSet <- names(training)[names(training) != "Class"]

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

## 2-fold CV
CV2ctrl <- trainControl(method = "cv",
                     number = 2,
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE,
                     returnResamp = "all")

## 5-fold CV
CV5ctrl <- trainControl(method = "cv",
                    number = 5,
                    summaryFunction = twoClassSummary,
                    classProbs = TRUE,
                    savePredictions = TRUE,
                    returnResamp = "all")

## 10-fold CV
CV10ctrl <- trainControl(method = "cv",
                     number = 10,
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE,
                     returnResamp = "all")

## Leave-one-out
LOOCVctrl <- trainControl(method = "LOOCV",
                    summaryFunction = twoClassSummary,
                    classProbs = TRUE,
                    savePredictions = TRUE,
                    returnResamp = "all")

## Repeated CV
RepCVctrl <- trainControl(method = "repeatedcv",
                    number = 10,
                    repeats = 20,
                    summaryFunction = twoClassSummary,
                    classProbs = TRUE,
                    savePredictions = TRUE,
                    returnResamp = "all")

mtryValues <- c(2, 4, 6, 8, 10, 20)

## Ensure reproducibility
set.seed(12)

## Train random forest model
CV2rfFit <- train(x = training[,reducedSet],
               y = training$Class,
               method = "rf",
               ntree = 2000,
               tuneGrid = data.frame(mtry = mtryValues),
               importance = TRUE,
               metric = "ROC",
               trControl = CV2ctrl)

## 5-fold CV
set.seed(12)
CV5rfFit <- train(x = training[,reducedSet],
               y = training$Class,
               method = "rf",
               ntree = 2000,
               tuneGrid = data.frame(mtry = mtryValues),
               importance = TRUE,
               metric = "ROC",
               trControl = CV5ctrl)

## 10-fold CV
set.seed(12)
CV10rfFit <- train(x = training[,reducedSet],
               y = training$Class,
               method = "rf",
               ntree = 2000,
               tuneGrid = data.frame(mtry = mtryValues),
               importance = TRUE,
               metric = "ROC",
               trControl = CV10ctrl)

## LOOCV
set.seed(12)
LOOCVrfFit <- train(x = training[,reducedSet],
               y = training$Class,
               method = "rf",
               ntree = 2000,
               tuneGrid = data.frame(mtry = mtryValues),
               importance = TRUE,
               metric = "ROC",
               trControl = LOOCVctrl)

## Repeated CV
set.seed(12)
RepCVrfFit <- train(x = training[,reducedSet],
               y = training$Class,
               method = "rf",
               ntree = 2000,
               tuneGrid = data.frame(mtry = mtryValues),
               importance = TRUE,
               metric = "ROC",
               trControl = RepCVctrl)


## Build and plot ROC curve
CV2rfRoc <- roc(response = CV2rfFit$pred$obs,
             predictor = CV2rfFit$pred$High,
             levels = rev(levels(CV2rfFit$pred$obs)))
CV5rfRoc <- roc(response = CV5rfFit$pred$obs,
            predictor = CV5rfFit$pred$High,
            levels = rev(levels(CV5rfFit$pred$obs)))
CV10rfRoc <- roc(response = CV10rfFit$pred$obs,
             predictor = CV10rfFit$pred$High,
             levels = rev(levels(CV10rfFit$pred$obs)))
LOOCVrfRoc <- roc(response = LOOCVrfFit$pred$obs,
            predictor = LOOCVrfFit$pred$High,
            levels = rev(levels(LOOCVrfFit$pred$obs)))
RepCVrfRoc <- roc(response = RepCVrfFit$pred$obs,
            predictor = RepCVrfFit$pred$High,
            levels = rev(levels(RepCVrfFit$pred$obs)))

# plot
pal <- brewer.pal(5, "Set1")

pdf("figs/compareCV.pdf",
    width=6, height=6)
plot(CV2rfRoc, type = "s", add = FALSE, print.thres = c(.5),
     print.thres.pch = 3, legacy.axes = TRUE, print.thres.pattern = "",
     print.thres.cex = 1.2,
     col = pal[1], print.thres.col = pal[1])

plot(CV5rfRoc, type = "s", add = TRUE, print.thres = c(.5),
    print.thres.pch = 3, legacy.axes = TRUE, print.thres.pattern = "",
    print.thres.cex = 1.2,
    col = pal[2], print.thres.col = pal[2])

plot(CV10rfRoc, type = "s", add = TRUE, print.thres = c(.5),
    print.thres.pch = 3, legacy.axes = TRUE, print.thres.pattern = "",
    print.thres.cex = 1.2,
    col = pal[3], print.thres.col = pal[3])

plot(LOOCVrfRoc, type = "s", add = TRUE, print.thres = c(.5),
    print.thres.pch = 3, legacy.axes = TRUE, print.thres.pattern = "",
    print.thres.cex = 1.2,
    col = pal[4], print.thres.col = pal[4])
plot(RepCVrfRoc, type = "s", add = TRUE, print.thres = c(.5),
    print.thres.pch = 3, legacy.axes = TRUE, print.thres.pattern = "",
    print.thres.cex = 1.2,
    col = pal[5], print.thres.col = pal[5])
legend(.75, .3,
       c("2-fold CV", "5-fold CV", "10-fold CV", "LOOCV", "Repeated 10-fold CV"),
       lwd = c(2, 2),
       col = pal,
       pch = c(3, 3),
       text.width = 0.4)
dev.off()
