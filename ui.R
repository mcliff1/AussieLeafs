library(shiny)
library(dplyr)
library(DAAG)
data("leafshape", package="DAAG")
ds <- mutate(leafshape, arch=as.factor(arch))
levels(ds$arch) <- c("plagiotropic", "othotropic")

varChoices <- list("Blade Length (mm)" = "bladelen", 
                   "Petiole length (mm)" = "petiole",
                   "Leaf Width (mm)" = "bladewid", 
                   "Log of Length" = "loglen", 
                   "Log of Petiole" = "logpet", 
                   "Log of Width" = "logwid")


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
          radioButtons("WithLoess", "Include smoothed means?",
                       choices=list("yes", "no")),
          textInput("XLab", "Input X Label", value="default x"),
          textInput("YLab", "Input Y Label", value="default y")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         h1("Chart Generation Tool"),
         p("Update information in the side panel and the graph will be automatically updated"),
         plotOutput("distPlot"),
         p("To save: right clight \"Save Image\" and use png format"),
         br(),
         textOutput("model")
      )
   )
))
