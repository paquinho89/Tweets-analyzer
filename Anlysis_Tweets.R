#UPLOADING PACKAGES
##########################################################################################
# install rtweet from CRAN
# Here we are checking if the package is installed
if(!require("rtweet")){
  # If the package is not in the system then it will be install
  install.packages("rtweet", dependencies = TRUE)
  # Here we are loading the package
  library("rtweet")
}
#isntall tmap from the maps
if(!require("tmap")){
  # If the package is not in the system then it will be install
  install.packages("tmap", dependencies = TRUE)
  # Here we are loading the package
  library("tmap")
}
# Here we are checking if the package is installed
if(!require("ggplot2")){
  # If the package is not in the system then it will be install
  install.packages(
    "ggplot2",
    repos = c("http://rstudio.org/_packages",
              "http://cran.rstudio.com")
  )
  # Here we are loading the package
  library("ggplot2")
}
#This is for the maps and geolocations
# Here we are checking if the package is installed
if(!require("googleway")){
  # If the package is not in the system then it will be install
  install.packages("googleway", dependencies = TRUE)
  # Here we are loading the package
  library("googleway")
}
#install stringi
# Here we are checking if the package is installed
if(!require("stringi")){
  # If the package is not in the system then it will be install
  install.packages("stringi", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
  library("stringi")
}
#install yaml
# Here we are checking if the package is installed
if(!require("yaml")){
  # If the package is not in the system then it will be install
  install.packages("yaml", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
  library("yaml")
}
#install mapsapi
# Here we are checking if the package is installed
if(!require("mapsapi")){
  # If the package is not in the system then it will be install
  install.packages("yaml", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
  library("mapsapi")
}
#install devtools
# Here we are checking if the package is installed
if(!require("devtools")){
  # If the package is not in the system then it will be install
  install.packages("devtools", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
  library("devtools")
}
#install googleLanguageR
# Here we are checking if the package is installed
if(!require("googleLanguageR")){
  # If the package is not in the system then it will be install
  install.packages("googleLanguageR", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
  library("googleLanguageR")
}

############################################### PART 1 - PLOTTING THE MAP ###############################
#############################################################################
#AUTHENTICATION
############################################################################
#TWITTER AUTHENTICATION
#For more information regarding the tweets, see the below link:
#https://rtweet.info/ para quitar os tweets

#Authentification on Twitter accounts
create_token(
  app = "XXXXXXXXXXXXXXXXXXXXX",
  consumer_key = "XXXXXXXXXXXXXXXX",
  consumer_secret = "XXXXXXXXXXXXXXXXXXXXXXX")


#GOOGLE AUTHENTICATION
#Authentification on my google account to get the geocOde
#This is my API from my API key. To get the API see this site:
#https://cloud.google.com/maps-platform/?__utma=102347093.739445211.1529438971.1543151047.1543151047.1&__utmb=102347093.0.10.1543151047&__utmc=102347093&__utmx=-&__utmz=102347093.1543151047.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)&__utmv=-&__utmk=222020888&_ga=2.179297060.1418589899.1543143627-739445211.1529438971#get-started

my_key<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
#########################################################################
#GETTING THE TWEETS
###########################################################################
#Get the tweets by the language, the country, their relationship with some word (for instance GSK)

GSK_tweets <- search_tweets(
  "GSK", type='recent', n = 10,include_rts =TRUE, 
  geocode = lookup_coords("Spain", apikey = my_key ), lang="es")
View(GSK_tweets)
class(GSK_tweets)
###################################################################################
#To see where the tweets come from.
#A NEW COLUMN IS CREATED WITH THE LOCATION CITY OF THE TWEET
##################################################
#2 different ways of obtain the column with the city_location.
  #Option 1: A code longer than the following one:
location <-GSK_tweets[['location']]
location_city<-strsplit(location, split=",")

for (i in 1:length(location_city)){
  GSK_tweets[['location_city']][i] <-location_city [[i]][1]
}
View(location)

  #Option 2: A shorter code than the previous one:
for (i in 1:length(strsplit(GSK_tweets[['location']], split=","))){
  GSK_tweets[['location_city']][i] <-strsplit(GSK_tweets[['location']], split=",") [[i]][1]
}
View(GSK_tweets)
#########################################################################
#MISSING VALUES
############################################################################
#Two options are presented to manage the missing values:
  #Option 1:We are going to set "Madrid" as the default value for those cells with NA in the  
  #location_city column.
for(i in 1:nrow(GSK_tweets)){
  GSK_tweets[['location_city']][i]<-if (is.na(GSK_tweets[[i,89]])){
    'Madrid'} else {
      GSK_tweets[[i,89]]}
}
  #Option 2: (THE ONE WHICH IT IS GOING TO BE USED). We are going to delete the rows which 
  #have NA in the location_city column.
GSK_tweets <- GSK_tweets[!is.na(GSK_tweets$location_city),]

View(GSK_tweets)
############################################################################
#OBTAINING THE GEOCODE COORDENATES WITH THE LOCATION_CITY COLUMN
###########################################################################
#Coordenadas en y
for (m in 1:nrow(GSK_tweets)){
  GSK_tweets[['coordenates_y']][m] <- if (is.null(lookup_coords(GSK_tweets[['location_city']][m], apikey = my_key)$point[1])){
    lookup_coords('Madrid', apikey = my_key)$point[1]} else {
      lookup_coords(GSK_tweets[['location_city']][m], apikey = my_key)$point[1]
    }
}
#Coordenadas en x
for (m in 1:nrow(GSK_tweets)){
  GSK_tweets[['coordenates_x']][m] <- if (is.null(lookup_coords(GSK_tweets[['location_city']][m], apikey = my_key)$point[2])){
    lookup_coords('Madrid', apikey = my_key)$point[2]} else {
      lookup_coords(GSK_tweets[['location_city']][m], apikey = my_key)$point[2]
    }
}
View(GSK_tweets)
##########################################################################################
#REMOVING THE OOVERLAPPING FROM THE TWEETS WITH THE SAME LOCATION
##############################################################################################
#The following code is to not overlap tweets and be able to visualize all of the tweets
#This is to not have tweets in the same place. If there are tweets in the same place,
#they overlap themselves as the geo-coordenates are the same. Therefore, just one tweet is plotted.
#To see the column names.
colnames(GSK_tweets)
#To get the number of rows
number_of_rows <- nrow(GSK_tweets)
#We go from 2 to the lenght of the data frame.
#We check if the value is equal to the previous one, If it is equal, we add 1 and i/10.
for (i in 2:length(GSK_tweets[['location']])) {
  if (GSK_tweets[[i,90]]==GSK_tweets[[i-1,90]]){
    print(GSK_tweets[[i,90]]+i/900)} else {
      print(GSK_tweets[[i,90]])}
}
View(GSK_tweets)
#########################################################################################
#CREATE A NEW COLUMN WITH THE COORDENATES NOT OVERLAPPED
########################################################################################
#We put the new coordenates in another column named 'coordenates_y_1'.
#I mean, the previous code is placed in a new column in the data frame.
#We add i in order to not have the same coordentes. Because if there are lot of equal
#values, and we add 1, we will still have the same values. For this reason,
#we need to add a different value each time. For this reason, we sum i, as it is
#a value which change over the loop.
for (i in 2:length(GSK_tweets[['location']])){
  GSK_tweets[['coordenates_y_1']][1]<- GSK_tweets[[1,90]]
  GSK_tweets[['coordenates_y_1']][i]<-if (GSK_tweets[[i,90]]==GSK_tweets[[i-1,90]]){
      GSK_tweets[[i,90]]+i/900} else {
        GSK_tweets[[i,90]]}
}
View(GSK_tweets)

#We creaate another column where we copy the same value as in the coordenates_x_1 column
#This is because in some cases some coordenates appear as vector (c(52.1458,54.2214,14.251)).
#and if we copy the values in the new column, just copy a value from vector, 
#there is no problem ahead.
for (n in 1:length(GSK_tweets[['location']])){
  GSK_tweets[['coordenates_x_1']][n]<- GSK_tweets[[n,91]]
}

View (GSK_tweets)

#####################################################ESTE CÓDIGO PODRÍASE ELIMINAR##########3
#Temos que traducir o text para que me pille ben as cidades
#Pra darte de alta teste que ler estas duas paxinas
#https://cran.r-project.org/web/packages/googleLanguageR/vignettes/setup.html
#https://code.markedmondson.me/googleLanguageR/
text <- "to administer medicince to animals is frequently a very difficult matter, and yet sometimes it's necessary to do so"
gl_translate(text, target = "es")$translatedText
?Startup
################################ATA ETIQUI ###########333#####################################

#############################################################################################
#PLOTTING THE COORDINATES IN A MAP
###############################################################################################
library(leaflet)
#Convertimos as coordenadas_x e as coordenadas_y a formao numérico para poder represenetar
#os markers no mapa. Se non da error
#Representamos o mapa e despois engadimos os markers para ver de donde son os tweets.
leaflet(data = GSK_tweets) %>% addTiles() %>%
  addMarkers(lng = as.numeric(GSK_tweets$coordenates_x_1), lat= as.numeric(GSK_tweets$coordenates_y_1),
             popup = ~as.character(text),label = ~as.character(name))

############################################### PART 2 - WORDCLOUD ###############################
###############################################################################################
#OBTAINING AGAIN THE TWEETS
########################################################################
#The tweets are again obtained as we have deleted the rows with NA applicable values in the
#location_city column. In this way, we will have the real data.
GSK_tweets <- search_tweets(
  "GSK", type='recent', n = 10,include_rts =TRUE, 
  geocode = lookup_coords("Spain", apikey = my_key ), lang="es")

View(GSK_tweets)
##############################################################################
#INSTALLING THE PACKAGES FOR THE WORDCLOUD
#################################################################################
# install tidytext
# Here we are checking if the package is installed
if(!require("tidytext")){
  # If the package is not in the system then it will be install
  install.packages("tidytext", dependencies = TRUE)
  # Here we are loading the package
  library("tidytext")
}
# install dplyr
# Here we are checking if the package is installed
if(!require("dplyr")){
  # If the package is not in the system then it will be install
  install.packages("dplyr", dependencies = TRUE)
  # Here we are loading the package
  library("dplyr")
}
# install stringr
# Here we are checking if the package is installed
if(!require("stringr")){
  # If the package is not in the system then it will be install
  install.packages("stringr", dependencies = TRUE)
  # Here we are loading the package
  library("stringr")
}
require(devtools)
# install wordcloud
# Here we are checking if the package is installed
if(!require("wordcloud")){
  # If the package is not in the system then it will be install
  install.packages("wordcloud", dependencies = TRUE)
  # Here we are loading the package
  library("wordcloud")
}
##################################################################################
#Taking a look to the tweets
################################################################################
head(GSK_tweets)
dim(GSK_tweets)
GSK_tweets$text
##################################################################################
#UNNESTING THE TWEETS
##################################################################
#Unnest the words - code via Tidy Text
#O que estamos facendo e crear unha fila por palabra.
GSK_tweetsTable <- GSK_tweets %>% 
  unnest_tokens(word, text)

#################################################################################
#DELETING THE WORDS WHICH DO NOT ADD ANY INFORMATION from the GSK_tweetsTable (stop words)
#################################################################################
#This library has stopwords which do not add value.
#We choose the stopowords in the spanish language and the column name is changed
#to the name "words".
library(stopwords)
spanish_stop_words<-data.frame(word=stopwords(language = 'es'))
colnames(spanish_stop_words)
View(spanish_stop_words)
#We are going to do an anti_join. The values which are in both tables are going to be removed
#from the GSK_tweetsTable.
#To do the antijoin, the name of the column from the 'spanish_stop_words' data set is changed to "words"
#it is necessary to have a column with the same name in both tables to do the antijoin.
names(spanish_stop_words) <- c('word')

#The antijoin is performed with both tables (GSK_tweetsTable and spanish_stop_words)
GSK_tweetsTable <- GSK_tweetsTable %>%
  anti_join(spanish_stop_words)

View(GSK_tweetsTable)

#We do a word count to see what words are most repeated
GSK_tweetsTable <- GSK_tweetsTable %>%
  count(word, sort = TRUE) 
View(GSK_tweetsTable)

#Remove other nonsense words
GSK_tweetsTable <-GSK_tweetsTable %>%
  filter(!word %in% c('t.co', 'https'))
View(GSK_tweetsTable)

#Ploting the word cloud for the tweets
wordcloud(words = GSK_tweetsTable$word, freq = GSK_tweetsTable$n, min.freq = 10,
          max.words=500, random.order=TRUE, rot.per=0.1, 
          colors=brewer.pal(8, "Dark2"))
###############################################################################
#WORDCLOUD for the hastags
######################################################################################
#The column with hashtags in column GSK_tweets, is obtained
GSK_hashtags<-GSK_tweets[[15]]
#All the hashtags are placed in a list.
GSK_hashtags_list<-list()
for (n in 1:length(GSK_hashtags)) GSK_hashtags_list<-{c(GSK_hashtags_list, GSK_hashtags[[n]][1:length(GSK_hashtags[[n]])])}
GSK_hashtags
m<-unlist(GSK_tweets$hashtags)
m
ml <- table(m)
l<-data.frame(l)
class(l)
#Remove the NA applicable values from the GSK_hashtags_list
for (hashtag in GSK_hashtags_list) {if (!is.na(hashtag)){
  GSK_hashtags_clean <- c(GSK_hashtags_clean, hashtag)
  }
}
GSK_hashtags_clean
#Converting the 'GSK_hashtag_clean' from a list to a data frame.
GSK_hashtags_clean <- data.frame(GSK_hashtags_clean)
View(GSK_hashtags_clean)
#Counting the word ocurrences in 'GSK_hashtgs_clean' list
GSK_hashtags_clean <- GSK_hashtags_clean %>%
  count(GSK_hashtags_clean, sort = TRUE)
# Ploting the word cloud foor the hashtags
wordcloud(words = GSK_hashtags_clean$GSK_hashtags_clean, freq = GSK_hashtags_clean$n,
          scale = c(1.5,.5), min.freq = 2,max.words=500, random.order=TRUE, 
          rot.per=0.01, colors=brewer.pal(8, "Dark2"))


###################################PART 3 - ANALYSIS OF PEOPLE ###########################
################################################################################
#See the people with the most number of followers which is talking about GSK
#The square brackes are used t extract the colum, Therefore we extract the colum
#and order the data frame by the followers account column. The "-" symbol is 
#to order from the highest to the lowest
most_famous_people<- data.frame(GSK_tweets[order(-GSK_tweets$followers_count),])
View(most_famous_people[c("followers_count", "name")])
View(GSK_tweets)
##See the people with the most number of friends which is talking about GSK
most_friendly_people<-data.frame(GSK_tweets[order(-GSK_tweets$friends_count),])
View(most_friendly_people)
##############################################################################
#AND NOW IT IS TIME FOR SHINY
