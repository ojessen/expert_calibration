
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Expert Calibration"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # This is intentionally an empty object.
      h6(textOutput("save.results")),
      h5("Created by:"),
      tags$a("Econometrics by Simulation",
             href="http://www.econometricsbysimulation.com"),
      h5("For details on how data is generated:"),
      tags$a("Blog Post",
             href=paste0("http://www.econometricsbysimulation.com/",
                         "2013/19/Shiny-Survey-Tool.html")),
      h5("Github Repository:"),
      tags$a("Survey-Tool",
             href=paste0("https://github.com/EconometricsBySimulation/",
                         "Shiny-Demos/tree/master/Survey")),
      # Display the page counter text.
      h5(textOutput("counter")),
      selectInput("num_questions", "Number of questions", seq(10,40, by = 10),selected = 20)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      # Main Action is where most everything is happenning in the
      # object (where the welcome message, survey, and results appear)
      uiOutput("MainAction"),
      # This displays the action putton Next.
      actionButton("Click.Counter", "Next")
    )
  )
))
