library(shiny)
shinyUI (fluidPage(
  titlePanel("Analyzing Tweets"),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId="text",label= "Topic", value="Write just one word"),
      
      selectInput(inputId="language", label="Choose Language", 
                  c('Spanish'='es','English'='en','French'='fr',
                    'Italian'='it')),
      
      selectInput(inputId="country", label="Choose country", 
                  c('Spain'='Spain','UK'='United Kingdom','France'='France',
                    'Italy'='Italy')),

      sliderInput(inputId="tweets", label="Number of tweets",
                  min=5, max=50, value=20),
      
      actionButton(inputId='go', label = "Submit"),
      
      helpText(label="When you click the button above, you should see",
               "the output below update to reflect the value you",
               "entered at the top:")
    ),
    #Esto básicamente é para que me deixe espacio para os gráficos
    mainPanel(
      tabsetPanel(
        tabPanel(title="Map",
                 leafletOutput(outputId="map")),
        tabPanel(title="WordCloud_hashtag",
                 plotOutput("wordcloud_hashtag")),
        tabPanel(title="WordCloud_tweets",
          plotOutput("wordcloud_tweets")),
        tabPanel(title='relevant people',
                 dataTableOutput("most_famous_people"))
        
        
      #leafletOutput(label="map", width = "100%", height = "100%"),
      #textOutput("number_of_tweets")
    )
  )
)
)
)
#shinyApp(ui=ui, server=server)

