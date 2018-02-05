library(shiny)
library(dplyr)
library(DAAG)
data("leafshape", package="DAAG")
ds <- mutate(leafshape, arch=as.factor(arch))
levels(ds$arch) <- c("plagiotropic", "othotropic")

varChoices <- list("Blade Length (mm)" = "bladelen", "petiole", "bladewid", "logwid", "logpet", "loglen")



# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Australian Leaf Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
          textInput("Title", "Input Title", value="Australian Leaf Data"),
          selectInput("XVar", "Variable for X-axis",
                       choices=varChoices, selected="logpet"),
          selectInput("YVar", "Variable for Y-axis",
                       choices=varChoices, selected="loglen"),
          radioButtons("Factor", "Variable for Factor",
                       choices=list("none", "location", "arch")),
          radioButtons("WithLoess", "include fits",
                       choices=list("yes", "no")),
          textInput("XLab", "Input X Label", value="default x"),
          textInput("YLab", "Input Y Label", value="default y")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         h1("Scatter Plot"),
         plotOutput("distPlot"),
         p("Linear Model fit"),
         textOutput("model")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
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
       paste("lm(", input$YVar,"~", input$XVar,
             ") has residual standard error", 
             round(summary(fit)[[6]],3))
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

