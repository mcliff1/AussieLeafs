library(shiny)
library(dplyr)
library(DAAG)
library(ggplot2)
data("leafshape", package="DAAG")
ds <- mutate(leafshape, arch=as.factor(arch))
levels(ds$arch) <- c("plagiotropic", "othotropic")


shinyServer(function(input, output) {
   
   output$distPlot <- renderPlot({
       xvar <- ds[, input$XVar]
       yvar <- ds[, input$YVar]
       #cFactor <- ds[, input$Factor]
      
      # draws the plot with all the input variables
      if (input$Factor != "none" ) {
          cFactor <- ds[, input$Factor]
          g <- ggplot(data=ds, aes(x=xvar, y=yvar, color=cFactor)) +
          labs(title = input$Title,
               x = input$XLab, y = input$YLab,
               color=input$Factor) 
      } else {
          g <- ggplot(data=ds, aes(x=xvar, y=yvar)) +
          labs(title = input$Title,
               x = input$XLab, y = input$YLab)
      }

      g <- g + geom_point(size=2, alpha=.5)

      if (input$WithLoess == "yes") {
        g <- g + geom_smooth(method="loess")
      }

      g
   })
   
   
   output$model <- renderText({
       xvar <- ds[, input$XVar]
       yvar <- ds[, input$YVar]
       
       fit <- lm(yvar ~ xvar)
       paste0("lm(", input$YVar,"~", input$XVar,
             ") has residual standard error ", 
             round(summary(fit)[[6]],3))
   })
})

