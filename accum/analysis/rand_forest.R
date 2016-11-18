library(caret)
library(pROC)
library(ggplot2)
library(GGally)

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

ctrl <- trainControl(method = "repeatedcv",
                     number = 10,
                     repeats = 20,
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE,
                     returnResamp = "all")
mtryValues <- c(2, 4, 6, 8, 10, 20, 30, 40, 60)

## Ensure reproducibility
set.seed(10)

## Train random forest model
rfFit <- train(x = training[,reducedSet],
               y = training$Class,
               method = "rf",
               ntree = 2000,
               tuneGrid = data.frame(mtry = mtryValues),
               importance = TRUE,
               metric = "ROC",
               trControl = ctrl)
rfFit

rfp <- merge(rfFit$pred,  rfFit$bestTune)
rfCM <- confusionMatrix(rfFit, norm = "none")
rfCM

# Calculate important variables
rfImp <- varImp(rfFit)
rfImp.top <- rfImp$importance[with(rfImp$importance, order(-High)),]
rfImp.names <- rownames(rfImp.top[1:5,]) # top 5 variables
rfImp.final <- data.frame(name = rownames(rfImp.top[1:15,]), importance = rfImp.top$High[1:15])
rfImp.final <- data.matrix(rfImp.top$High[1:15])
rownames(rfImp.final) <- rownames(rfImp.top[1:15,])

rfRoc <- roc(response = rfFit$pred$obs,
             predictor = rfFit$pred$High,
             levels = rev(levels(rfFit$pred$obs)))

### Create plots ###

## Plot tuning ##
pdf("figs/tuningPlot.pdf",
    width=6, height=6)
plot(rfFit)
dev.off()

## Plot ROC curve ##
pdf("figs/rocPlot.pdf",
    width=6, height=6)
plot(rfRoc, type = "s", print.thres = c(.5),
     print.thres.pch = 3, legacy.axes = TRUE, print.thres.pattern = "",
     print.thres.cex = 1.2,
     col = "red", print.thres.col = "red",
     print.auc = TRUE, print.auc.x = 0.8, print.auc.y = 0.6)
dev.off()

## Plot variable importance ##
pdf("figs/varImpPlot.pdf",
    width=6, height=6)
dotchart(rfImp.final)
dev.off()

## Plot important variable interaction ##
pdf("figs/varImpMatrix.pdf",
    width = 6, height = 6)
ggpairs(training, mapping = aes(color = Class), columns = rfImp.names,
        upper = list(
          continuous = wrap("cor", size = 4, alignPercent = 1)
        ),
        lower = list(continuous = wrap("points", size = 0.6)), 
        diag = list(continuous = "densityDiag"),
        axisLabels = "show", 
        title = "Top 5 Important Variables from Random Forest") +
  theme_linedraw(base_size = 8) + 
  theme(plot.title = element_text(size = 10), 
        axis.title = element_text(size = 10), 
        axis.text = element_text(size = 8), 
        legend.position = "top",
        legend.title = element_blank()) 
dev.off()
