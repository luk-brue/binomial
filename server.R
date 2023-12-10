library(shiny)


function(input, output, session) {

  output$erfolge <- renderUI({
    sliderInput("x",
                "Anzahl an Erfolgen",
                value = ifelse(is.null(input$x), floor(input$n / 2),
                               ifelse(input$n < input$x, input$n, input$x)),
                min = 1,
                max = input$n,
                step = 1)
    })

  density_binom <- reactive({
    dbinom(x = seq_len(input$n),
           size = input$n,
           prob = input$p)
  })

  output$wahrscheinlichkeitsfunktion <- renderPlot({
    density_binom() |> plot(type = "h",
                            main = "Wahrscheinlichkeitsfunktion",
                            ylab = "f(x)",
                            xlab = "x: Erfolge")
    points(x = seq_len(input$n),
         y = density_binom(),
         pch = 19)
    segments(y1 = density_binom()[input$x],
             y0 = 0,
             x0 = input$x,
             col = "red")
    points(y = density_binom()[input$x],
           x = input$x,
           col = "red",
           pch = 19)
  }) |> bindEvent(input$go)

  cumdens_binom <- reactive({
    withProgress(message = "Konsultiere Binomialverteilung...", {
    # Simulate Expensive Calculation
    Sys.sleep(2)
      incProgress(amount = 0.8, message = "fast fertig!")
      Sys.sleep(0.8)
    pbinom(q = seq_len(input$n),
           size = input$n,
           prob = input$p)
    })
  })

  output$verteilungsfunktion <- renderPlot({

      stepfun(x = seq_len(input$n),
              y = c(0, cumdens_binom()),
              right = F) |>
      plot.stepfun(verticals = F,
        main = "Verteilungsfunktion",
        ylab = "F(x)",
        xlab = "x: Erfolge",
        pch = 19,
        xaxt = "n")
    axis(side = 1, at = seq(2, 14, by = 2))
    points(x = input$x,
           y = cumdens_binom()[input$x],
           col = "red",
           pch = 19)
  }) |> bindEvent(input$go)

  output$f <- renderText({
   paste0("f(", input$x, ") = ",
          density_binom()[input$x] |>
            round(digits = 5) |>
            format(scientific = F))
  }) |> bindEvent(input$go)

  output$fcum <- renderText({
    # req(input$go, cancelOutput = TRUE)
    paste0("F(", input$x, ") = ",
           cumdens_binom()[input$x] |>
             round(digits = 5) |>
             format(scientific = F))
  }) |> bindEvent(input$go)
}


