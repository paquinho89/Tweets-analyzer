library(shiny)
library(DT)

shinyServer (function(input, output){
#Obtaining the tweets.  
  GSK_tweets <- eventReactive(input$go, {data.frame(search_tweets(input$text, type='recent', n=input$tweets, include_rts =TRUE, 
                              geocode = lookup_coords(input$country, apikey = my_key ), lang=input$language))
  })

###PREPARING THE DATA TO PLOT THE MAP WITH THE TWEETS######  
  
  
  
######PREPARING THE DATA TO PLOT THE WORDCLOUD WITH THE MOST REPEATED HASHTGs###
  #Unlist hashtags vectors
  GSK_hashtags <- reactive({unlist(GSK_tweets()$hashtags)})
  #Count the number of the reeated words
  GSK_hashtags_count <- reactive({table(GSK_hashtags())})
  #Converting it to a data frame
  GSK_hashtags_count_df <- reactive({data.frame(GSK_hashtags_count())})
  
###PREPARING THE DATA TO PLOT THE WORDCLOUD WITH MOST REPEATED WORDS IN THE TWEETS######
  #O que estamos facendo e crear unha fila por palabra.
  GSK_tweetsTable <- reactive({GSK_tweets() %>% 
    unnest_tokens(word, text)})

  #The data frame is created.
  GSK_tweetsTable_df <- reactive({data.frame(GSK_tweetsTable())})
  #The data frame with the stop words is created, and we name the column
  #with the "words"name.
  spanish_stop_words<-reactive({data.frame(word=stopwords(language = input$language))})
  #We are going to do an anti_join. The values which are in both tables are going to be removed
  #from the GSK_tweetsTable. We are going to anti_join both tables by the column named "words".
  #Both tables need to have a common column.
  #Therefore, the antijoin is performed with both tables (GSK_tweetsTable and spanish_stop_words)
  GSK_tweetsTable_no_stopwords <- reactive({GSK_tweetsTable_df() %>%
    anti_join(spanish_stop_words())})
  #We do a word count to see what words are most repeated
  GSK_tweetsTable_word_counting <- reactive({GSK_tweetsTable_no_stopwords() %>%
    count(word, sort = TRUE)})
  #Removing other words with no sense.
  GSK_tweetsTable_word_counting_final <- reactive({GSK_tweetsTable_word_counting() %>%
    filter(!word %in% c('t.co', 'https'))})

#########PLOTING THE TABLE WITH THE WORDCLOUD FOR THE TWEETS##############
#Ploting the wordcloud of the text of the tweets
  output$wordcloud_tweets <- renderPlot({
    wordcloud(words=GSK_tweetsTable_word_counting_final()$word,
              GSK_tweetsTable_word_counting_final()$n, min.freq = 5,
              max.words = 500, random.order = TRUE, rot.per = 0.1,
              colors=brewer.pal(2,"Dark2"))
  })
#########PLOTING THE TABLE WITH THE WORDCLOUD FOR THE HASHTAGS############## 
#Ploting the wordcloud of the hashtag
  output$wordcloud_hashtag <- renderPlot({
    wordcloud(words=GSK_hashtags_count_df()$Var1,
              GSK_hashtags_count_df()$Freq, min.freq = 1,
              max.words = 500, random.order = TRUE, rot.per = 0.1,
              colors=brewer.pal(2,"Dark2"))
  })
#########PLOTING THE TABLE WITH THE MOST RELEVANT PEOPLE##############
#Ploting the table with the most_famous_people who are twetting about the topic
  output$most_famous_people <- renderDataTable({
    GSK_tweets()[c("name", "followers_count")]
  })
  
})
  
#https://stackoverflow.com/questions/32009512/shiny-application-to-fetch-twitter-search-results-and-show-last-5-tweets-and-wor 

  

