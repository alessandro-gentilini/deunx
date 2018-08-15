library(shiny)
library(ggplot2)
library(RCurl)
library(reshape2)
library(zoo)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  raw <- getURL("https://raw.githubusercontent.com/alessandro-gentilini/deunx/master/DEUNX.csv")
  df <- read.csv(text=raw,sep=",",header=TRUE)

  
  
  date_fmt <- "%m/%d/%Y"
  

  z <- read.zoo(df,format=date_fmt)
  
  df$ts <- as.Date( df$ts, date_fmt )
  
  z6 <- rollmean(na.approx(z),6,align="right")
  df6 <- data.frame(ts=index(z6),d=coredata(z6))  
  
  z7 <- rollmean(na.approx(z),7,align="right")
  df7 <- data.frame(ts=index(z7),d=coredata(z7))
  
  p <- ggplot(data=df,aes(x = ts, y = d)) + 
    geom_line(aes(color="raw")) +
    geom_line(data = df6, aes(x = ts, y = d, color = "mov. avg. 6")) +
    geom_line(data = df7, aes(x = ts, y = d, color = "mov. avg. 7")) +
    labs(color="",title="D E U N X")
    
  
  output$distPlot <- renderPlot({
    plot(p)
  })
})
