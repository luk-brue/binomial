library(shiny)
library(ggplot2)


function(input, output, session) {
  # x should not be allowed to be greater than n
  # solution: dynamic UI
  observe({
    updateSliderInput(inputId = "x",
                            max = input$n,
                            value = input$x
                            )
          }) |> bindEvent(input$n)


  # this sequence is needed a lot
  x_seq <- reactive({
    seq_len(input$n)
  })

  # distribution function
  density_binom <- reactive({
    dbinom(x = x_seq(),
           size = input$n,
           prob = input$p)
  })

  # cumul. dist. funct.
  cumdens_binom <- reactive({
    pbinom(q = x_seq(),
           size = input$n,
           prob = input$p)
  })

  # current density based on x
  current_dens <- reactive({
    density_binom()[input$x]
  })

  # current cumulative density based on x
  current_cumdens <- reactive({
    cumdens_binom()[input$x]
  })

  # colors
  # dist. funct
  dens_color <- reactive({
    forcats::fct(ifelse(x_seq() == input$x,
           yes = "red",
           no = "black"),
           levels = c("black", "red"))
  })

  # cumul. dist. funct.
  cumul_color <- reactive({
    forcats::fct(ifelse(x_seq() <= input$x,
           yes = "red",
           no = "black"),
           levels = c("red", "black"))
  })


  # data frame for ggplot
  plot_df <- reactive({
    tibble::tibble(x = x_seq(),
               dens = density_binom(),
               cumdens = cumdens_binom(),
               dens_color = dens_color(),
               cumul_color = cumul_color())
  })

  base_dens_plot <- reactive({
    ggplot(plot_df()) +
      theme_bw() +
      theme(text = element_text(size = 17)) +
      scale_x_continuous(breaks = scales::breaks_pretty(),
                         minor_breaks = NULL) +
      scale_y_continuous(breaks = scales::breaks_pretty() ,
                         minor_breaks = NULL) +
      scale_color_manual(values = c("black", "red"),
                         guide = NULL) +
      labs(y = "f(x)",
           title = "Wahrscheinlichkeitsfunktion",
           x = "x: Erfolge")
  })

  base_cumul_plot <- reactive({
    ggplot(plot_df()) +
      theme_bw() +
      theme(text = element_text(size = 17)) +
      scale_x_continuous(breaks = scales::breaks_pretty(),
                         minor_breaks = NULL) +
      scale_y_continuous(breaks = scales::breaks_pretty() ,
                         minor_breaks = NULL) +
      scale_color_manual(values = c("red", "black"),
                         guide = NULL) +
      labs(y = "F(x)",
           title = "Verteilungsfunktion",
           x = "x: Erfolge")

  })

  output$wahrscheinlichkeitsfunktion <- renderPlot({
      base_dens_plot() +
      geom_segment(aes(x = x,
                       yend = dens,
                       y = 0,
                       xend = x,
                       color = dens_color)) +
      geom_point(aes(x,
                     dens,
                     color = dens_color)) +
      geom_segment(x = input$x,
                   xend = input$x,
                   y = current_dens() + 0.024,
                   yend = current_dens() + 0.009,
                   arrow = arrow(length = unit(0.1, "inches"))) +
      annotate(geom = "label",
               x = input$x,
               y = current_dens() + 0.024,
               label = round(current_dens(), 4) |> format(scientific = F))
  })

  output$verteilungsfunktion <- renderPlot({

    base_cumul_plot() +
      geom_segment(aes(x = x,
                       yend = cumdens,
                       y = cumdens,
                       xend = x + 1,
                       color = cumul_color)) +
      geom_point(aes(x,
                     cumdens,
                     color = cumul_color)) +
      geom_segment(x = input$x - 0.6,
                   xend = input$x,
                   y = current_cumdens() + 0.1,
                   yend = current_cumdens() + 0.03,
                   arrow = arrow(length = unit(0.1, "inches"))) +
      annotate(geom = "label",
               x = input$x - 0.6,
               y = current_cumdens() + 0.1,
               label = round(current_cumdens(), 4) |> format(scientific = F))
  })

  output$dist <- renderText({
    paste0("X ~ B(N = ", input$n, ", p = ", input$p, ")")
  })

}


