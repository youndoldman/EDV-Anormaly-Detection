# identify if a coil is somehow different from existing observations.
# Authr: Xiaoli Yang
# Date: 2018
library(stats)
library(ggplot2)
library(dplyr)
library(plotly)
library(lmtest)
library(xlsx)
library(MASS)
library(mclust, quietly=TRUE) #is used to fit Gaussian mixture models
library(shiny)
library(ECharts2Shiny)
library(RColorBrewer)
library(FSA)


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
dfm_B3 = database[,'Banddicke3']
dfm_B2 = database[,'Banddicke2']
dfm_B1 = database[,'Banddicke1']

#TODO: draw distplot_gbanddicke

## second: For a quantitative analysis, mean, median, and std values are analyzed.
#frequency
frequencies <- list(100,50,10,1)
aggfuncs <- list('mean','median','std')

#mean
mean_B1<- mean(dfm_B1)
mean_B2<- mean(dfm_B2)
mean_B3<- mean(dfm_B3)

#median
median_B1<-median(dfm_B1)
median_B2<-median(dfm_B2)
median_B3<-median(dfm_B3)

#standard deviation
var_B2 <- var(dfm_B2)

#IQR The Interquartile Range
IQR(dfm_B2, na.rm = FALSE, type = 6)

#Pair plot

# mixture of gaussian
#fit = Mclust(dfm_B2, G=4, model="V")
#summary(fit)
#plot(fit, what="density", main="", xlab="Velocity (Mm/s)")
#rug(dfm_B2[,'Banddicke2'])

# graph1 -- line graphy
dat <- data.frame(c(min(dfm_B1), mean_B1, median_B1, max(dfm_B1)),
                  c(min(dfm_B2), mean_B2, median_B2, max(dfm_B2)),
                  c(min(max(dfm_B2)),mean_B3, median_B3, max(dfm_B3)))
names(dat) <- c("Banddicke1", "Banddicke2", "Banddicke3")
row.names(dat) <- c("min","mean", "median","max")

# graph3 -- bar graphy by frequency
distriDB <- function (dfm_B1,dfm_B2,dfm_B3){
x1 <- hist(dfm_B1)
x2 <- hist(dfm_B2)
x3 <- hist(dfm_B3)

l1 <- length(x1$counts)
l2 <- length(x2$counts)
l3 <- length(x3$counts)
m = max(l1,l2)
m <- max(m, l3)
ran <- range(x2$breaks,x3$breaks,x1$breaks) 
base <- seq(ran[1],ran[2],0.005)
c <-x1$breaks[1]
n <- which(base-c<0.0001)
b1 <- x1$counts
x1 <-rep(0, length(base))
x1[length(n):(length(n)+l1-1)]<-b1

c <-x2$breaks[1]
n <- which(base-c<0.0001)
b2 <- x2$counts
x2 <-rep(0, length(base))
x2[length(n):(length(n)+l2-1)]<-b2

c <-x3$breaks[1]
n <- which(base-c<0.0001)
b3 <- x3$counts
x3 <-rep(0, length(base))
x3[length(n):(length(n)+l3-1)]<-b3

dat123 <- data.frame(c(x1),c(x2),c(x3))
names(dat123) <- c("Banddicke1", "Banddicke2", "Banddicke3")
row.names(dat123) <- base

return (dat123)
}

# boxData
boxData<-database
boxData$Banddicke <- factor(boxData$Banddicke,
                           labels = c("Banddicke1", "Banddicke2", "Banddicke3"))


#server function
server <- function(input, output,session) {
  
  #==========graph 1 line=========
  renderLineChart(div_id = "Banddicke1",
                  data = dat,
                  line.width = 3,
                  line.type = "solid",
                  show.legend = TRUE,
                  show.tools= TRUE,
                  theme = "macarons"
  )
  
  #==============graph 2 boxplot=============
  fill <- "#4271AE"
  line <- "#1F3552"
  output$boxPlot = renderPlot({ggplot(boxData, aes(x = Banddicke, y = Banddicke1)) + 
      geom_boxplot(fill = fill, colour = line)+
      scale_x_discrete(name = "3 position Of coil") 
  })
  
  
  #=========graph 3 frequency disctribution ============
  # this function aims to show the distribution of the banddicke frequence.
  
  observeEvent(input$submit,{
    renderBarChart(div_id = "frequency2",grid_left = '1%', direction = "vertical",
                   data =
                   {dfm_B1 = database[database[,'Banddicke'] == input$Bandd,'Banddicke1']
                   dfm_B2 = database[database[,'Banddicke'] == input$Bandd,'Banddicke2']
                   dfm_B3 = database[database[,'Banddicke'] == input$Bandd,'Banddicke3']
                   distriDB(dfm_B1, dfm_B2, dfm_B3)}, theme = "vintage")
  })
  
  
  
}