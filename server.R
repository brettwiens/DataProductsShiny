#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

require(shiny); require(ggplot2); require(plotly); require(ggrepel); require(shadowtext)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  ## Code to operate the Select All/Unselect All ActionLink
  observe({
    if(input$selectall == 0) return(NULL)
    else if(input$selectall%%2 == 0)
    {
      updateCheckboxGroupInput(session, "PickedTeams", "Select Teams:", 
                               choices = sort(unique(nhlData$FullTeamName)))
    }
    else
    {
      updateCheckboxGroupInput(session, "PickedTeams", "Select Teams:", 
                               choices = sort(unique(nhlData$FullTeamName)), 
                               selected = sort(unique(nhlData$FullTeamName)))
      
    }
  })
  
  ## A little string along the top of the table to highlight the selected teams.
  output$teamList <- renderText({
    paste((input$PickedTeams),".")
  })
  
  output$posList <- renderText({
    paste("", (input$PickedPositions)," ... ")

  })
  
  ## Reactive to the user input, selects teams and positions.
  # datasetTOI <- reactive({
  #   nhlTOI <- nhlData[nhlData$TOI >= input$TOICutoff,]
  # })
  # 
  # datasetTeam <- reactive({
  #   nhlTeam <- nhlTOI[nhlTOI$CurrentTeamName %in% input$PickedTeams,]
  # })
  # 
  # datasetPosition <- reactive({
  #   nhlPosition <- nhlTeam[nhlTeam$Position %in% input$PickedPositions,]
  # })
  
  datasetInput <- reactive({
    # nhlData[nhlData$Team %in% input$PickedTeams,]
    #subset(nhlData, TOI >= input$TOICutoff)
    subset(nhlData, FullTeamName %in% input$PickedTeams & TOI >= input$TOICutoff & Position %in% input$PickedPositions)
  ##TOI, Team, Postiion
  })
  
  output$playerPlot <- renderPlot({
    
    nhlSelected <- datasetInput()
    
    # ggplotly(ggplot(data = nhlSelected, aes(x = PointsPerMinute, y = TOI, col = Team, size = P, label = paste(PlayerTeam, " ", Position),
    #                                         shape = factor(TeamsFullName)))
    #          + geom_point()
    #          + geom_text(size = 2)
    #          + geom_smooth(method = 'lm', formula = y ~ x, alpha = 0.2, size = 0.5, se=FALSE)
    # 
    # )
    
    # maxP <- max(nhlSelected$P)
    
    # ggplot(data = nhlSelected, aes(x = G, y = P)) + geom_point()
    
    ggplot(data = nhlSelected, aes(x = nhlSelected$PointsPerMinute, y = nhlSelected$TOI)) + 
      geom_point(data = nhlSelected, aes(fill = CurrentTeamName, size = nhlSelected$P/1.5), pch = 21, alpha = 0.5) +
      geom_smooth(data = nhlSelected, aes(col = CurrentTeamName), method = 'lm', formula = y ~ x, alpha = 0.2,
                  size = 1.5, se=FALSE) +
      geom_label_repel(data = nhlSelected, aes(color = nhlSelected$CurrentTeamName, label = nhlSelected$keyLabel), size = 3,
                       box.padding = 0.3, alpha = 0.8) +
      geom_shadowtext(data = nhlSelected, aes(label = nhlSelected$P), size = 4, hjust = 1, vjust = 1) +
      theme(legend.position = "bottom") +
      scale_size_identity() +
      labs(title = "2017/18 Player Production", x = 'Points / Minute', y = "Time on Ice (Minutes)")
    
    # plot_ly(data = nhlSelected, x = ~PointsPerMinute, y = ~TOI, type = "scatter", 
    #         color = ~Team, size = ~P, 
    #         text = ~paste(nhlSelected$PlayerTeam, '</br> Points: ', nhlSelected$P, '</br> TOI: ', nhlSelected$TOI, '</br> Points per Minute: ', nhlSelected$PointsPerMinute) 
    # )
    
    # labelMaster <- paste(nhlSelected$PlayerTeam, '</br> Points: ', nhlSelected$P, '</br> TOI: ', nhlSelected$TOI, '</br> Points per Minute: ', nhlSelected$PointsPerMinute)
    # plot_ly(data = nhlSelected, x = ~P, y = ~TOI, type = "scatter",
    #       color = ~Team, size = ~P, mode = "markers", colors = "Set2", symbol = ~Position, symbols = c(28, 25, 24, 26),
    #       text = labelMaster
    #       )
    
    # plot(nhlSelected$P, nhlSelected$TOI, type = "p", cex = nhlSelected$PointsPerMinute*100, xlim=c(0,100), ylim=c(0,1000))
    
    ## The steeper the negative curve, the less a team rewards production with Time on Ice.  
    ## Generally indicative of a team that gets more production out of all players.
    
  })
  
  
})