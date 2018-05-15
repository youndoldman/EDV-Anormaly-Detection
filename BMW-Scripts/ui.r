library(shiny)
library(ECharts2Shiny)

# Define UI for slider demo app ----
ui <- fluidPage(
  
  loadEChartsLibrary(),
  
  h2("BWM Data analysis"),
  
  #==================graphy 1=====================
  fluidRow(
    column(8,
           h4("Overview of Banddick", align = "central"),
           tags$div(id="Banddicke1", style="width:100%;height:400px;"),  # Specify the div for the chart. Can also be considered as a space holder
           deliverChart(div_id = "Banddicke1")  # Deliver the plotting
    ),
    column(12,
           h4("KDE banddicke", align = "central"),
           tags$div(id="frequency2", style="width:100%;height:400px;"),
           deliverChart(div_id = "frequency2")
    )
  ),
  #==================graphy 2=====================
  # App title ----
  titlePanel("Sliders"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar to demonstrate various slider options ----
    sidebarPanel(
      
      # Input: Simple integer interval ----
      sliderInput("integer", "Integer:",
                  min = 0, max = 1000,
                  value = 500),
      # Input: Decimal interval with step value ----
      sliderInput("decimal", "Decimal:",
                  min = 0, max = 1,
                  value = 0.5, step = 0.1),
      # Input: Specification of range within an interval ----
      sliderInput("range", "Range:",
                  min = 1, max = 1000,
                  value = c(200,500)),
      
      # Input: Custom currency format for with basic animation ----
      sliderInput("format", "Custom Format:",
                  min = 0, max = 10000,
                  value = 0, step = 2500,
                  pre = "$", sep = ",",
                  animate = TRUE),
      
      # Input: Animation with custom interval (in ms) ----
      # to control speed, plus looping
      sliderInput("animation", "Looping Animation:",
                  min = 1, max = 2000,
                  value = 1, step = 10,
                  animate =
                    animationOptions(interval = 300, loop = TRUE))
      
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Table summarizing the values entered ----
      tableOutput("values")
    )
  )
  
  
)
