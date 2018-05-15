# identify if a coil is somehow different from existing observations.
# Authr: Xiaoli Yang
# Date: 2018
library(stats)
library(ggplot2)
library(dplyr)
library(plotrix)
library(fitdistrplus)
library(lmtest)
library(xlsx)
library(MASS)
library(mclust, quietly=TRUE) #is used to fit Gaussian mixture models
library(shiny)
library(ECharts2Shiny)

Sys.setlocale("LC_ALL","German")

### Input data
path ="D:/ubuntu/WZL-2018/Automobil_training_data/"
filename = "Datenbasis_Gefiltert_zusammengefuehrt.csv"
setwd(path)
database <- read.csv(filename, header=TRUE,encoding='UTF-8',sep=",")
# to observe the basic info about database
names(database)
dim(database)

### Distribution analysis of `Banddicke2`

## first remove the duplication
dfm_B2 = database[!duplicated(database[,'Banddicke2']),]
#TODO: draw distplot_gbanddicke

## second: For a quantitative analysis, mean, median, and std values are analyzed.
#frequency
frequencies <- list(100,50,10,1)
aggfuncs <- list('mean','median','std')

#mean
mean_B2<- mean(dfm_B2[,'Banddicke2'])

#median
median_B2<-median(dfm_B2[,'Banddicke2'])

#standard deviation
var_B2 <- var(dfm_B2[,'Banddicke2'])

#IQR The Interquartile Range
IQR(dfm_B2[,'Banddicke2'], na.rm = FALSE, type = 6)

#Pair plot


# mixture of gaussian
fit = Mclust(dfm_B2[,'Banddicke2'], G=4, model="V")
summary(fit)
plot(fit, what="density", main="", xlab="Velocity (Mm/s)")
rug(dfm_B2[,'Banddicke2'])
# UI

