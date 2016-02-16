library(shiny)
library(ggplot2)
library(gsheet)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  
  df<-gsheet2tbl('https://docs.google.com/spreadsheets/d/1ibu_mY1Ej91GUYP6oE0RghcnEadcsKPTniDnz2_0f_A/edit?usp=sharing')
  
  df$ts <- as.Date( df$ts, '%m/%d/%Y')
  
  
  output$distPlot <- renderPlot({
    plot(ggplot( data = df, aes( ts, d )) + geom_line())
  })
})
