# Playership demographic analysis
# Author: Tri Nguyen 
# Date: 6/3/2020


library(shiny)
# library(RODBC)
# 
# db <- DBI::dbConnect(odbc::odbc(),
#                      Driver = "SQL Server",
#                      Server = "tst-biba-dw",
#                      Database = "FinbidwDB",
#                      Trusted_Connection = "True")
# Port = 1433

# This is the Playership database
sql<-"with Players (playerzip,activeplayersperzip) as
(SELECT
playerzip,count(*)
from finstagedb.[dbo].[StgPlayer]
WHERE
PlayerState='ca'
AND PlayerLastLoginTime > DATEADD(MONTH,6,PlayerCreateDate)
group by playerzip
)
select [ZIP]
,activeplayersperzip
      ,[AREA]
      ,[POPcurrent]
      ,[POPplus5]
      ,[#OFBUSS]
      ,[POPSQMI]
      ,[DAYPOP]
      ,[URBANPCT]
      ,[RURALPCT]
      ,[WHITECOLLAR]
      ,[18-24%]
      ,[25-34%]
      ,[35-44%]
      ,[45-54%]
      ,[55-64%]
      ,[65+%]
      ,[INCOMEMED]
      ,[MALEPOP]
      ,[FEMALEPOP] from Players
join	[FinbidwDB].[dbo].[CAZips4Web$] D
on	d.zip=Players.playerzip
"

# query <- DBI::dbGetQuery(db, sql)

players<- read.csv('players.csv')

#regressor = lm(formula = activeplayersperzip ~ .,data = players)

# This builds the app

ui<-(fluidPage(
  titlePanel("Summary of Playership per Zipcode"),
  sidebarLayout(
    sidebarPanel(
      selectInput("var",label="Choose a Demographic Factor",choice=c("Active Players"=2,
                                                           "CurrentPopulation"=4,
                                                           "ProjectedPopulation"=5,
                                                           "Number of Businesses"=6), selectize=FALSE)),
    mainPanel(
      h2("Summary Factor"),
      verbatimTextOutput("sum"),
      plotOutput("box")
    )
  ))
)


# Define server logic 
server <- function(input, output)
{
  
  output$sum <- renderPrint({
    
    summary(players[,as.numeric(input$var)])
  })
  
  output$box <- renderPlot({
    
    x<-summary(players[,as.numeric(input$var)])
     hist(x,col="sky blue",border="purple",main=names(players[as.numeric(input$var)]))

    #summarizes the stats
    #writes to csv how the model is performing
    #batch jobs scheduled weekly after the db refresh
    
  })
}

shinyApp(ui = ui, server = server)

