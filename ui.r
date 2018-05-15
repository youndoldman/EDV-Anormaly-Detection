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
    )),
  h2("Boxplot of 3 different position on the coil"),
  plotOutput("boxPlot",click = clickOpts("click_1")),
  
  #================graphy2=================
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: Select a dataset ----
        selectInput(inputId = "Bandd", label = "Choose a banddicke:",
                    choices = c(0.7, 0.8, 0.9), selected = 0.7),
        actionButton('submit',"Update")
        
        # Input: actionButton() to defer the rendering of output ----
        # until the user explicitly clicks the button (rather than
        # doing it immediately when inputs change). This is useful if
        # the computations required to render output are inordinately
        # time-consuming
      ),
      # Main panel for displaying outputs ----
      mainPanel(
       
      )#end of mainpane
    )#end of the sidebar
  ,
  
  #=====================graph 3==========================
  fluidRow(
  column(12,
         h4("KDE banddicke", align = "central"),
         tags$div(id="frequency2", style="width:100%;height:400px;"),
         deliverChart(div_id = "frequency2")
  )  )
)
 

