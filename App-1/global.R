#UPLOADING PACKAGES
##########################################################################################
# install rtweet from CRAN
# Here we are checking if the package is installed
#if(!require("rtweet")){
  # If the package is not in the system then it will be install
  #install.packages("rtweet", dependencies = TRUE)
  # Here we are loading the package
  #library("rtweet")
#}
#isntall tmap from the maps
#if(!require("tmap")){
  # If the package is not in the system then it will be install
#  install.packages("tmap", dependencies = TRUE)
  # Here we are loading the package
#  library("tmap")
#}
# Here we are checking if the package is installed
#if(!require("ggplot2")){
  # If the package is not in the system then it will be install
#  install.packages(
#    "ggplot2",
#    repos = c("http://rstudio.org/_packages",
#              "http://cran.rstudio.com")
#  )
  # Here we are loading the package
#  library("ggplot2")
#}
#This is for the maps and geolocations
# Here we are checking if the package is installed
#if(!require("googleway")){
  # If the package is not in the system then it will be install
#  install.packages("googleway", dependencies = TRUE)
  # Here we are loading the package
#  library("googleway")
#}
#install stringi
# Here we are checking if the package is installed
#if(!require("stringi")){
  # If the package is not in the system then it will be install
#  install.packages("stringi", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
#  library("stringi")
#}
#install yaml
# Here we are checking if the package is installed
#if(!require("yaml")){
  # If the package is not in the system then it will be install
#  install.packages("yaml", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
#  library("yaml")
#}
#install mapsapi
# Here we are checking if the package is installed
#if(!require("mapsapi")){
  # If the package is not in the system then it will be install
#  install.packages("yaml", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
#  library("mapsapi")
#}
#install devtools
# Here we are checking if the package is installed
#if(!require("devtools")){
  # If the package is not in the system then it will be install
  #install.packages("devtools", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
  #library("devtools")
#}
#install googleLanguageR
# Here we are checking if the package is installed
#if(!require("googleLanguageR")){
  # If the package is not in the system then it will be install
#  install.packages("googleLanguageR", repos="http://cran.rstudio.com/", dependencies=TRUE)
  # Here we are loading the package
#  library("googleLanguageR")
#}

#library(shiny)
#library(DT)

##############################################################################
#INSTALLING THE PACKAGES FOR THE WORDCLOUD
#################################################################################
# install tidytext
# Here we are checking if the package is installed
#if(!require("tidytext")){
  # If the package is not in the system then it will be install
#  install.packages("tidytext", dependencies = TRUE)
  # Here we are loading the package
#  library("tidytext")
#}
# install dplyr
# Here we are checking if the package is installed
#if(!require("dplyr")){
  # If the package is not in the system then it will be install
#  install.packages("dplyr", dependencies = TRUE)
  # Here we are loading the package
#  library("dplyr")
#}
# install stringr
# Here we are checking if the package is installed
#if(!require("stringr")){
  # If the package is not in the system then it will be install
#  install.packages("stringr", dependencies = TRUE)
  # Here we are loading the package
#  library("stringr")
#}
#require(devtools)
# install wordcloud
# Here we are checking if the package is installed
#if(!require("wordcloud")){
  # If the package is not in the system then it will be install
#  install.packages("wordcloud", dependencies = TRUE)
  # Here we are loading the package
#  library("wordcloud")
#}

library(stopwords)
library(leaflet)

############################################### PART 1 - PLOTTING THE MAP ###############################
#############################################################################
#AUTHENTICATION
############################################################################
#TWITTER AUTHENTICATION
#For more information regarding the tweets, see the below link:
#https://rtweet.info/ para quitar os tweets

#Authentification on Twitter accounts
#Hiding my credentials
#key_set("app")
#key_set("consumer_key")
#key_set("consumer_secret")

#Authentification on Twitter accounts
create_token(
  app = key_get("app"),
  consumer_key = key_get("consumer_key"),
  consumer_secret = key_get("consumer_secret"))


#GOOGLE AUTHENTICATION
#Authentification on my google account to get the geocOde
#This is my API from my API key. To get the API see this site:
#https://cloud.google.com/maps-platform/?__utma=102347093.739445211.1529438971.1543151047.1543151047.1&__utmb=102347093.0.10.1543151047&__utmc=102347093&__utmx=-&__utmz=102347093.1543151047.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)&__utmv=-&__utmk=222020888&_ga=2.179297060.1418589899.1543143627-739445211.1529438971#get-started

#Hiding my credentials
#key_set("key_google")
key_google<-key_get("key_google")


