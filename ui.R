library(shiny)

fluidPage(
  column(width = 2,
         br(),
         sliderInput("p",
                     "Erfolgswahrscheinlichkeit p",
                     value = 0.7,
                     min = 0,
                     max = 1,
                     step = 0.01),
         sliderInput("n",
                     "Anzahl an Versuchen N",
                     value = 15,
                     min = 1,
                     max = 100,
                     step = 1),
         sliderInput("x",
                     "Anzahl an Erfolgen x",
                     value = 4,
                     min = 0,
                     max = 15,
                     step = 1),
         # actionButton("go",
         #              "Go!",
         #              icon = icon("microchip")),
         br(),
         textOutput("dist"),
         br(),
         span(uiOutput("github"), style = "font-size:10px;")

  ),
  column(width = 5,
         br(),
         plotOutput("wahrscheinlichkeitsfunktion")),
  column(width = 5,
         br(),
         plotOutput("verteilungsfunktion"))
)
