# install rtweet from CRAN
install.packages("rtweet")
#isntall tmap from the maps
install.packages('tmap')
#install ggplot2
install.packages(
  "ggplot2",
  repos = c("http://rstudio.org/_packages",
            "http://cran.rstudio.com")
)
#This is for the maps and geolocations
install.packages('googleway')
#install stringi
install.packages("stringi", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("yaml")
install.packages("mapsapi")
install.packages("devtools")
install.packages('googleLanguageR')

library(rtweet)
library(ggplot2)
library(ggmap)
library(tidyverse)
library(dplyr)
library (googleway)
require(rvest)
library(mapsapi)
library(googleLanguageR)

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
GSK_tweets <- search_tweets(
  "GSK", type='recent', n = 50, include_rts = FALSE, 
  lookup_coords(address='spain', apikey = my_key)
)
#To see where the tweets come from.
#The city is obtained
location <-GSK_tweets[['location']]
View(location)
location_city<-strsplit(location, split=",")
for (i in 1:length(location_city)){
  GSK_tweets[['location_city']][i] <-location_city [[i]][1]
}
#The latitude and longitude of the city is obtained (coordenate_y and coordenate_x)
for (i in 1:length(location)){
  GSK_tweets[['coordenates_y']][i] <- geocode_coordinates(google_geocode(address=GSK_tweets[['location_city']][i], key=my_key, simplify=TRUE))[1]
  GSK_tweets[['coordenates_x']][i] <- geocode_coordinates(google_geocode(address=GSK_tweets[['location_city']][i], key=my_key, simplify=TRUE))[2]
}
View(GSK_tweets)
labels(GSK_tweets)

geocode_coordinates(google_geocode(address='Madrid, Spain', key=my_key, simplify=TRUE))

#####################################################
#Temos que traducir o text para que me pille ben as cidades
#Pra darte de alta teste que ler estas duas paxinas
#https://cran.r-project.org/web/packages/googleLanguageR/vignettes/setup.html
#https://code.markedmondson.me/googleLanguageR/
text <- "to administer medicince to animals is frequently a very difficult matter, and yet sometimes it's necessary to do so"
gl_translate(text, target = "es")$translatedText
?Startup

##################################################
#Representing the map of the country
google_map(key = my_key, data = GSK_tweets) %>%
  add_markers(lat = "coordenates_y", lon = "coordenates_x", info_window = 'name')
#################################################
#Vou a intentar creaar outro tipo de mapas mais mol�n co tema do pop up mais guapo
library(leaflet)
leaflet() %>% addTiles() %>% addMarkers(lng= ~coordenates_y, lat= ~coordenates_x)
#m=addTiles(m)

leaflet(data = GSK_tweets) %>% addTiles() %>%
  addMarkers(lng = GSK_tweets[1,"coordenates_y"], lat= GSK_tweets[1,"coordenates_x"])
#, popup = ~as.character(mag), label = ~as.character(mag))

GSK_tweets[1,"coordenates_y"]

View(GSK_tweets[c("coordenates_y","coordenates_x")])
#https://rstudio.github.io/leaflet/popups.html
#https://rstudio.github.io/leaflet/markers.html








View(tram_stops)

geocode_coordinates(GSK_tweets_location)

google_map(key = my_key, location='spain'   )

get_map(m)










#WORDCLOUD
#Ver esta paxina http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes
# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

txt <- tweets$text
View(txt)
docs <- Corpus(VectorSource(txt))
View(docs)
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
#Esto é para eliminar os emoticonos
docs <- tm_map(docs, toSpace, "[^\x01-\x7F]")



################################################################
#Vamos a intentar identificar e eliminar os artículos, preposicions e demais cousas.
#Botalle un ollo a esta paxina que está interesante
#https://cran.r-project.org/web/packages/udpipe/vignettes/udpipe-usecase-postagging-lemmatisation.html

library("openNLP")
library(NLP)

install.packages("spacyr")
library("spacyr")
sentence <- "My name is Francisco"
##############################################################################################

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("https", "tco")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=500, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

#The frequency of the first 10 frequent words are plotted :
barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")

##Vamos a identificar se as palabras son positivas, negativas e que sentimentos nos
##transmiten.
library(tidytext)
View(d)

nrow(get_sentiments("bing"))
nrow(get_sentiments("nrc"))
nrow(get_sentiments("afinn"))
nrow(get_sentiments("loughran"))

#Utilizamos o paquete de NRC porque é o que mais palabras ten e é o que máis matches.
#ten co teu data set de 'd'.
join <- inner_join(d,get_sentiments("nrc"), by = "word")
View(join)
#Agrupamos e sumamos o número de ocurrenias de cada categoría. Desta forma podes ver
#de que está falando os tweets. De que categoría son cada un.
m<-aggregate(join$freq, by=list(Category=join$sentiment), FUN=sum)
ggplot(m, aes(x=Category, y=x)) + geom_bar(stat = "identity")
View(m) 
