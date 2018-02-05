library(shiny)
library(dplyr)
library(DAAG)
data("leafshape", package="DAAG")
ds <- mutate(leafshape, arch=as.factor(arch))
levels(ds$arch) <- c("plagiotropic", "othotropic")

varChoices <- list("Blade Length (mm)" = "bladelen", "petiole", "bladewid", "logwid", "logpet", "loglen")


shinyUI(fluidPage(
   
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
))
