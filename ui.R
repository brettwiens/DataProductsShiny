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
      tabsetPanel(type = "tabs",
        tabPanel("Output Player Plot", 

          plotOutput(outputId = "playerPlot", width = "1000px", height = "800px"),
          tags$a(href = "http://www.fenwicka.com/shiny/skater_stats/", "Source: Fenwick NHL Data", target = "_blank")
          ),
        tabPanel("Documentation",
          h2("Side Panel Input"),
          h4("Time on Ice"),
          ("Select the minimum amount of time on the ice for a player to be included."),
          ("Lower the threshold for more players, but increase the risk of high/low outliers."),
          h4("Positions"),
          ("Four positions may be selected, D - Defense, L - Left Wing, C - Centre, R - Right Wing"),
          h4("Teams"),
          ("Select as many teams as you wish to analyse."),
          ("Note: more teams = more computation and may be difficult to interpret"),
          h2("Output Player Plot"),
          h4("Main Plot"),
          ("The main plot shows time on ice (x) and points per minute (y)"),
          ("The size of the markers is indicative of total points scored (also labeled.)"),
          h4("Team Lines"),
          ("The lines represent the predictive function (linear) for each team predicting points per minute"),
          ("using the predictor, time on the ice."),
          ("A team that rewards point production with increased ice time should show a steeper positive line."),
          h1("Echo Tab"),
          ("The echo tab shows your selected inputs, just as a reference for validation.")
        ),
        tabPanel("Echo Tab",
                 textOutput(outputId = "teamList"),
                 "Positions: ",
                 textOutput(outputId = "posList")
        )      
      )
    )
  )
))
