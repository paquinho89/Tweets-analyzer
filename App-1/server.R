
shinyServer(function(input, output){
#Obtaining the tweets.  
  GSK_tweets <- eventReactive(input$go, {data.frame(search_tweets(input$text, type='recent', n=input$tweets, include_rts =TRUE, 
                              geocode = lookup_coords(input$country, apikey = key_google ), lang=input$language))
  })

##PREPARING THE DAT TO PLOT THE MAP
#A new Column just with the location_city is added to the GSK_tweets Data Frame
  GSK_tweets_location<-reactive({
    GSK_tweets_1 <- data.frame(GSK_tweets())
    for (i in 1:length(GSK_tweets()[['location']]))
         {
      GSK_tweets_1[['location_city']][i] <-strsplit(GSK_tweets()[['location']], split=",") [[i]][1]
    }
    GSK_tweets_1
  })
#Managing Missing Values##
  #Option 2: (THE ONE WHICH IT IS GOING TO BE USED). We are going to delete the rows which 
  #have NA in the location_city column.
  GSK_tweets_location_clean <- reactive({GSK_tweets_location()[!is.na(GSK_tweets_location()$location_city),]
  })
#OBTAINING THE GEOCODE COORDENATES WITH THE LOCATION_CITY COLUMN
  #Coordenadas en y
  GSK_tweets_location_clean_1<-reactive({
   GSK_tweets_location_clean_y<-data.frame(GSK_tweets_location_clean())
    for (m in 1:nrow(GSK_tweets_location_clean()))
    {
      GSK_tweets_location_clean_y[['coordenates_y']][m] <-lookup_coords(GSK_tweets_location_clean()[['location_city']][m], apikey = key_google)$point[1]
    }
    GSK_tweets_location_clean_y
    })
  #Coordenates en x
  GSK_tweets_location_clean_2<-reactive({
    GSK_tweets_location_clean_x<-data.frame(GSK_tweets_location_clean_1())
    for (m in 1:nrow(GSK_tweets_location_clean_1()))
    {
      GSK_tweets_location_clean_x[['coordenates_x']][m] <-lookup_coords(GSK_tweets_location_clean_1()[['location_city']][m], apikey = key_google)$point[2]
    }
    GSK_tweets_location_clean_x
  })
  
#Removing the overlapping from the coordenates.
  GSK_tweets_location_clean_3<-reactive({
    GSK_tweets_no_overlap<-data.frame(GSK_tweets_location_clean_2())
    for (i in 2:nrow(GSK_tweets_location_clean_2()))
    {
      GSK_tweets_no_overlap[['coordenates_y_1']][1]<-GSK_tweets_location_clean_2()[[1,92]]
      GSK_tweets_no_overlap[['coordenates_y_1']][i]<-if (GSK_tweets_location_clean_2()[[i,92]]==GSK_tweets_location_clean_2()[[i-1,92]])
      {
        GSK_tweets_location_clean_2()[[i,92]]+i/900} else {
          GSK_tweets_location_clean_2()[[i,92]]
        }
    }
    GSK_tweets_no_overlap
  })
  
#Ploting the coordentaes (coordenates_x and coordenates_y_1) on the map.
#Actually, we use the table just created (GSK_tweets_location_clean_3) to plot
#the map. We use the "coordenates_x" and the "coordenates_y_1" columns.
#see the "PLOTING MAP" heading, where the map is plotted.
  
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

######### PLOTING THE MAP ########################
  output$map <- renderLeaflet({
    leaflet(data = GSK_tweets_location_clean_3()) %>% addTiles() %>%
        addMarkers(lng = as.numeric(GSK_tweets_location_clean_3()$coordenates_x), lat= as.numeric(GSK_tweets_location_clean_3()$coordenates_y_1),
                   popup = ~as.character(text),label = ~as.character(name))
    })

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
    GSK_tweets()[c("name", "text", "followers_count")]
  })
})


  
#https://stackoverflow.com/questions/32009512/shiny-application-to-fetch-twitter-search-results-and-show-last-5-tweets-and-wor 

#BÓTALLE UN OLLO A ESTO
#https://paula-moraga.github.io/book-geospatial/sec-shinyexample.html


