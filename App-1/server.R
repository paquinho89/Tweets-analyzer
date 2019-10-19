library(shiny)
library(DT)
#Obtainning access for the twittwer account
create_token(
  app = "TwitterMiningAppPaquinho",
  consumer_key = "neLjKSZoj6cSRqSp9686vGbq8",
  consumer_secret = "tqm10cENHprTQtDvvoAUPvqPGXo3WvfL33R5fJzaqluBgbZbvq")
#Key for the google coordenates. 
my_key<-'AIzaSyBtYwLtBkPRBXW4EB1tzbaYBTXSb1rXCwg'
  

shinyServer (function(input, output){
#Obtaining the tweets.  
  GSK_tweets <- eventReactive(input$go, {data.frame(search_tweets(input$text, type='recent', n=input$tweets, include_rts =TRUE, 
                              geocode = lookup_coords(input$country, apikey = my_key ), lang=input$language))
  })
#Ploting the table with the most_famous_people who are twetting about the topic
  
  output$most_famous_people <- renderDataTable({
    GSK_tweets()[c("name", "followers_count")]
    })
})

  
#https://stackoverflow.com/questions/32009512/shiny-application-to-fetch-twitter-search-results-and-show-last-5-tweets-and-wor 

  

