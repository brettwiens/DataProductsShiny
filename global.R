filePath <- "Fenwick.csv"
nhlData <- read.csv(filePath)
rm(filePath)

nhlData$Teams <- as.character(nhlData$Team)
nhlData$CurrentTeamName <- substr(nhlData$Teams,nchar(nhlData$Teams)-2,nchar(nhlData$Teams))
nhlData$PointsPerMinute <- nhlData$P / nhlData$TOI

## Cleaning the position markers so they are a little more informative.
PositionAbbreviation <- sort(unique(nhlData$Position))
PositionFullName <- c("Centre Forward", "Defense", "Left Wing","Right Wing")
dfPosition <- data.frame(PositionAbbreviation, PositionFullName)
nhlData <- merge(nhlData, dfPosition, by.x = "Position", by.y = "PositionAbbreviation")
rm(PositionAbbreviation); rm(PositionFullName)

## Supplementing Team Name Information
TeamsAbbreviation <- sort(unique(nhlData$CurrentTeamName))
TeamsFullName <- c("Anaheim Ducks", "Arizona Coyotes", "Boston Bruins", 
                   "Buffalo Sabres","Carolina Hurricanes","Columbus Blue Jackets",
                   "Calgary Flames", "Chicago Blackhawks","Colorado Avalanche",
                   "Dallas Stars","Detroit Red Wings","Edmonton Oilers",
                   "Florida Panthers","Los Angeles Kings","Minnesota Wild",
                   "Montreal Canadiens","New Jersey Devils","Nashville Predators",
                   "New York Islanders","New York Rangers","Ottawa Senators",
                   "Philadelphia Flyers","Pittsburgh Penguins","San Jose Sharks",
                   "St. Louis Blues","Tampa Bay Lightning","Toronto Maple Leafs", 
                   "Vancouver Canucks", "Las Vegas Golden Knights", "Winnipeg Jets", 
                   "Washington Capitals")
dfTeams <- data.frame(TeamsAbbreviation, TeamsFullName)
nhlData <- merge(nhlData, dfTeams, by.x = "CurrentTeamName", by.y = "TeamsAbbreviation")

nhlData$FullTeamName <- as.character(nhlData$TeamsFullName)
nhlData$PlayerTeam <- paste(nhlData$CurrentTeamName,"-",nhlData$Player)
rm(TeamsAbbreviation); rm(TeamsFullName); rm(dfPosition); rm(dfTeams)

nhlData$keyLabel <- paste(nhlData$PlayerTeam, " ", nhlData$Position)

## Default Settings
nhlSelected <- nhlData[nhlData$TOI >= 500,]
nhlSelected <- nhlSelected[nhlSelected$CurrentTeamName %in% c("CGY", "EDM", "VAN", "TOR","MTL","OTT"),]
nhlSelected <- nhlSelected[nhlSelected$Position %in% c("C","L","R"),]