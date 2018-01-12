#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# User Interface that Creates an Interactive ggplotly chart of select NHL player performances
shinyUI(fluidPage(
  
  
  
  # Application title
  titlePanel("NHL Player Statistics"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
     # fileInput('file1', 'Choose CSV File',
     #           accept=c('text/csv', 'text/comma-separated- values,text/plain', '.csv')),
      
      sliderInput(inputId = "TOICutoff",
                  label = "Minimum Time on Ice to Include:",
                  min = 0,
                  max = max(nhlData$TOI),
                  value = 428),
      
      checkboxGroupInput(inputId = "PickedPositions",
                         label = "Positions: ",
                         choices = c("C","L","R","D"),
                         selected = c("C","L","R","D")),
      
      checkboxGroupInput(inputId = "PickedTeams",
                         label = "Which Teams to Include:",
                         choices = sort(unique(nhlData$FullTeamName)),
                         selected = c("Calgary Flames", "Edmonton Oilers", "Vancouver Canucks", "Winnipeg Jets",
                                      "Toronto Maple Leafs", "Ottawa Senators", "Montreal Canadiens")),
      actionLink("selectall","Select/Unselect All")
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      textOutput(outputId = "teamList"),
      "Positions: ",
      textOutput(outputId = "posList"),
      plotOutput(outputId = "playerPlot", width = "1000px", height = "800px"),
      tags$a(href = "http://www.fenwicka.com/shiny/skater_stats/", "Source: Fenwick NHL Data", target = "_blank")
    )
  )
))
