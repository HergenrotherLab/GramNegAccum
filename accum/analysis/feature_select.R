library(mlbench)
library(caret)
library(car)
library(corrplot)
library(ggplot2)

source("GroupVariance.R")
raw <- read.delim("../data/ensemble_gen/merged_data.csv", sep=",")

Class <- raw[,6]
Accum <- raw[,4]
Props <- raw[8:304]
class.training <- cbind(Class,Props)
fullSet <- names(class.training)[names(class.training) != "Class"]
accum.training <- cbind(Accum,Props)

## Remove Near Zero variance
isNZV <- nearZeroVar(class.training[,fullSet], saveMetrics = TRUE, freqCut = floor(nrow(class.training)/5))
#fullSet <- rownames(subset(isNZV, !nzv))

# Get distribution data for all of the descriptors
Mean <- apply(Props, 2, mean)
qt <- apply(Props, 2, quantile)

# Correlation of descriptor to accumulation
accumCorr <- cor(accum.training)[,1]

# Measure within and between group variance
fullSet.stat <- calcSeparations(class.training[,fullSet], class.training$Class)
fullSet.stat.ordered <- fullSet.stat[order(-fullSet.stat$sep),]

reducedSet.stat <- calcSeparations(class.training[,reducedSet], class.training$Class)
reducedSet.stat.ordered <- reducedSet.stat[order(-reducedSet.stat$sep),]

write.csv(as.matrix(cbind(Mean, t(qt), accumCorr[2:298], fullSet.stat$sep)), file = "accumcorr.csv")

# Molecular weight and accumulation
molwt.lm <- lm(Accum ~ MolWt, data = raw)
summary(molwt.lm)
plot(Accum ~ MolWt, data=raw)
molwt.cor <- cor(raw$Accum, raw$MolWt)
cor.test(raw$Accum, raw$MolWt, method = "pearson")
cor.test(raw$Accum, raw$MolWt, method = "spearman")
cor.test(raw$Accum, raw$MolWt, method = "kendall")

# Initial correlation matrix
preCorrMat <- cor(class.training[,fullSet])

# Filter out correlated variables
highCorr <- findCorrelation(preCorrMat, 0.99, exact = TRUE)
modCorr <- findCorrelation(preCorrMat, 0.8, exact = TRUE)
reducedSet <- fullSet[-modCorr]
fullSet <- fullSet[-highCorr]

# Resulting correlation matrix
fullcorMat <- cor(class.training[,fullSet])
reducedcorMat <- cor(class.training[,reducedSet])

# Plot results
png(filename = "figs/corrplot_reducedset.png",
    width=6, height=6,
    units = "in",
    res = 600)
corrplot(reducedcorMat, order="hclust", method="color", tl.pos="n", cl.pos="b")
dev.off()

png(filename = "figs/corrplot_fullset.png",
    width=6, height=6,
    units = "in",
    res = 600)
corrplot(fullcorMat, order="hclust", method="color", tl.pos="n", cl.pos="b")
dev.off()

png(filename = "figs/sepplot_fullset.png",
    width=6, height=6,
    units = "in",
    res = 600)
dotchart(fullSet.stat.ordered$sep[1:20],labels=row.names(fullSet.stat.ordered)[1:20],
         col="blue",
         main="Top 20 Greatest Variable Separations\nBetween Groups - Full Set",
         xlab="Separation")
dev.off()

png(filename = "figs/sepplot_reducedset.png",
    width=6, height=6,
    units = "in",
    res = 600)
dotchart(reducedSet.stat.ordered$sep[1:20],labels=row.names(reducedSet.stat.ordered)[1:20],
         col="blue",
         main="Top 20 Greatest Variable Separations\nBetween Groups - Reduced Set",
         xlab="Separation")
dev.off()
