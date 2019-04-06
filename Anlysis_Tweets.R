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
#####-------------------------------------------------------------
#The GSK tweets are going to be downloaded
## load rtweet package
#For more information regarding the tweets, see the below link:
#https://rtweet.info/ para quitar os tweets
#Authentification on Twitter accounts
create_token(
  app = "TwitterMiningAppPaquinho",
  consumer_key = "neLjKSZoj6cSRqSp9686vGbq8",
  consumer_secret = "tqm10cENHprTQtDvvoAUPvqPGXo3WvfL33R5fJzaqluBgbZbvq")

#Authentification on my google account to get the geocde
#This is my API from my API key. To get the API see this site:
#https://cloud.google.com/maps-platform/?__utma=102347093.739445211.1529438971.1543151047.1543151047.1&__utmb=102347093.0.10.1543151047&__utmc=102347093&__utmx=-&__utmz=102347093.1543151047.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)&__utmv=-&__utmk=222020888&_ga=2.179297060.1418589899.1543143627-739445211.1529438971#get-started
my_key<-'AIzaSyC9EWMz-hClrRCdgaLwvl_N4B355d-CdAA'

#Get the tweets which talk about GSK, choosing the country and the recent tweets
#Collemos tamén os rtweets.
#E tamén collemos solo os tweets que están en español
GSK_tweets <- search_tweets(
  "GSK", type='recent', n = 10000, include_rts =TRUE, 
  lookup_coords(address='spain', apikey = my_key), lang="es"
)
View(GSK_tweets)
#To see where the tweets come from.
#The city is obtained
location <-GSK_tweets[['location']]
location_city<-strsplit(location, split=",")
for (i in 1:length(location_city)){
  GSK_tweets[['location_city']][i] <-location_city [[i]][1]
}

#########################################################################
#MISSING VALUES
#For the cells with no location, we are going to set Madrid as the default value

for(i in 1:nrow(GSK_tweets)){
  GSK_tweets[['location_city']][i]<-if (is.na(GSK_tweets[[i,89]])){
    'Madrid'} else {
      GSK_tweets[[i,89]]}
}
View(GSK_tweets)
############################################################################
#The latitude and longitude of the city is obtained (coordenate_y and coordenate_x)
for (i in 1:length(location)){
  GSK_tweets[['coordenates_y']][i] <- geocode_coordinates(google_geocode(address=GSK_tweets[['location_city']][i], key=my_key, simplify=TRUE))[1]
  GSK_tweets[['coordenates_x']][i] <- geocode_coordinates(google_geocode(address=GSK_tweets[['location_city']][i], key=my_key, simplify=TRUE))[2]
}




#The following code is to not overlap tweets and be able to visualize all of the tweets
#This is to not have tweets in the same place. If there are tweets in the same place,
#they overlap themselves and not all tweets can be visualized.
#To see the column names.
colnames(GSK_tweets)
#To get the number of rows
number_of_rows <- nrow(GSK_tweets)

#We go from 2 to the lenght of data frame.
#We check if the value is equal to the previous one, If it is equal, we add 1 and i/10.
for (i in 2:length(location)) {
  if (GSK_tweets[[i,90]]==GSK_tweets[[i-1,90]]){
    print(GSK_tweets[[i,90]]+i/900)} else {
      print(GSK_tweets[[i,90]])}
}

#We put the new coordenates in another column named 'coordenates_y_1'.
#I mean, the previous code is placed in a new column in the data frame.
#We add i in order to not have the same coordentes. Because if there are lot of equal
#values, and we add 1, we will still have the same values. For this reason,
#we need to add a different value each time. For this reason, we sum i, as it is
#a value which change over the loop.
for (i in 2:length(location)){
  GSK_tweets[['coordenates_y_1']][1]<- GSK_tweets[[1,90]]
  GSK_tweets[['coordenates_y_1']][i]<-if (GSK_tweets[[i,90]]==GSK_tweets[[i-1,90]]){
      GSK_tweets[[i,90]]+i/900} else {
        GSK_tweets[[i,90]]}
}
#We creaate another column where we copy the same value as in the coordenates_x_1 column
#This is because in some cases some coordenates appear as vector (c(52.1458,54.2214,14.251)).
#and if we copy the values in the new column, just copy a value from vector and 
#there is no problem ahead.
for (n in 1:length(location)){
  GSK_tweets[['coordenates_x_1']][n]<- GSK_tweets[[n,91]]
}

View (GSK_tweets)
#####################################################
#Temos que traducir o text para que me pille ben as cidades
#Pra darte de alta teste que ler estas duas paxinas
#https://cran.r-project.org/web/packages/googleLanguageR/vignettes/setup.html
#https://code.markedmondson.me/googleLanguageR/
text <- "to administer medicince to animals is frequently a very difficult matter, and yet sometimes it's necessary to do so"
gl_translate(text, target = "es")$translatedText
?Startup
#################################################
#Representing the map.
library(leaflet)
#Convertimos as coordenadas_x e as coordenadas_y a formao numérico para poder represenetar
#os markers no mapa.
#Representamos o mapa e despois engadimos os markers para ver de donde son os tweets.
leaflet(data = GSK_tweets) %>% addTiles() %>%
  addMarkers(lng = as.numeric(GSK_tweets$coordenates_x_1), lat= as.numeric(GSK_tweets$coordenates_y_1),
             popup = ~as.character(text),label = ~as.character(name))
########################################################################
#WORDCLOUD
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

#Look at tweets
head(GSK_tweets)
dim(GSK_tweets)
GSK_tweets$text

#Unnest the words - code via Tidy Text
#O que estamos facendo e crear unha fila por palabra.
GSK_tweetsTable <- GSK_tweets %>% 
  unnest_tokens(word, text)
View(GSK_tweetsTable)

#Esto son unhas librerías de palabras, que valen para que me eliminen esas palabras
#que non aportan valor dos tweets.
View(stopwords("spanish"))
#Busca para que vale esto.
spanish_stop_words <- bind_rows(stop_words,
                                data_frame(word = tm::stopwords("spanish"),
                                           lexicon = "custom"))
#Esto traime tódolos valores que están na tabla GSK_tweetsTable e que non están na
#tabla de stop_words. Se os valores están nas duas tablas, pois non mos trae.
GSK_tweetsTable <- GSK_tweetsTable %>%
  anti_join(spanish_stop_words)

View(GSK_tweetsTable)
#do a word count
GSK_tweetsTable <- GSK_tweetsTable %>%
  count(word, sort = TRUE) 
View(GSK_tweetsTable)

#Remove other nonsense words
GSK_tweetsTable <-GSK_tweetsTable %>%
  filter(!word %in% c('t.co', 'https'))
View(GSK_tweetsTable)

#Imprimimos la nube de palabras
wordcloud(words = GSK_tweetsTable$word, freq = GSK_tweetsTable$n, min.freq = 10,
          max.words=500, random.order=TRUE, rot.per=0.1, 
          colors=brewer.pal(8, "Dark2"))

################################################################################
#See the people with the most number of followers which is talking about GSK
data.frame(GSK_tweets$name, sort(GSK_tweets$followers_count, decreasing=TRUE))
##See the people with the most number of friends which is talking about GSK
data.frame(GSK_tweets$name, sort(GSK_tweets$friends_count, decreasing=TRUE))









#ESTO POSIBLEMENTE O ELIMINES
##Vamos a identificar se as palabras son positivas, negativas e que sentimentos nos
##transmiten.
library(tidytext)
View(d)

nrow(get_sentiments("bing"))
nrow(get_sentiments("nrc"))
nrow(get_sentiments("afinn"))
nrow(get_sentiments("loughran"))

#Utilizamos o paquete de NRC porque Ã© o que mais palabras ten e Ã© o que mÃ¡is matches.
#ten co teu data set de 'd'.
join <- inner_join(d,get_sentiments("nrc"), by = "word")
View(join)
#Agrupamos e sumamos o nÃºmero de ocurrenias de cada categorÃ­a. Desta forma podes ver
#de que estÃ¡ falando os tweets. De que categorÃ­a son cada un.
m<-aggregate(join$freq, by=list(Category=join$sentiment), FUN=sum)
ggplot(m, aes(x=Category, y=x)) + geom_bar(stat = "identity")
View(m) 
