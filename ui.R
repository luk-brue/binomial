library(shiny)

fluidPage(
  column(width = 2,
         sliderInput("p",
                     "p: Erfolgswahrscheinlichkeit",
                     value = 0.7,
                     min = 0,
                     max = 1,
                     step = 0.01),
         sliderInput("n",
                     "Anzahl an Versuchen",
                     value = 14,
                     min = 1,
                     max = 100,
                     step = 1),
         uiOutput("erfolge"),
         actionButton("go",
                      "Go!",
                      icon = icon("microchip"))
  ),
  column(width = 5,
         plotOutput("wahrscheinlichkeitsfunktion"),
         textOutput("f")
         ),
  column(width = 5,
         plotOutput("verteilungsfunktion"),
         textOutput("fcum"))
)
