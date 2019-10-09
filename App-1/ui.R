library(shiny)
ui <- fluidPage(
  titlePanel("Analyzing Tweets"),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId="text",label= "Topic", value="Write just one word"),
      selectInput(inputId="language", label="Choose Language", c('Spanish'='es','English'='en')),
      checkboxGroupInput(inputId="grafica", label="plot", choices = list("Map"=1,
                                                           "TweetWordCloud"=2,
                                                           "HashtagWordCloud"=3)
      ),
      sliderInput(inputId="tweets", label="Number of tweets",
                  min=10, max=500, value=250),
      submitButton("Submit"),
      helpText(label="When you click the button above, you should see",
               "the output below update to reflect the value you",
               "entered at the top:")
    ),
    #Esto básicamente é para que me deixe espacio para os gráficos
    mainPanel(
      plotOutput("word_cloud_tweets")
      #leafletOutput(label="map", width = "100%", height = "100%"),
      #textOutput("number_of_tweets")
    )
  )
)
shinyApp(ui=ui, server=server)
  