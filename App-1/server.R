library(shiny)
library(DT)
#Obtainning access for the twittwer account
create_token(
  app = "xxxxxxxxxxxxxxxxxxxxxxxxx",
  consumer_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  consumer_secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
#Key for the google coordenates. 
my_key<-'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  

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

  

