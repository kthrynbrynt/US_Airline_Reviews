#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(dplyr)
library(ggplot2)
library(DT)
library(shinydashboard)
library(ggthemes)
library(grid)



shinyServer(function(input, output, session) {


  output$imp3 = renderPlot({
    impact_plot_3
  })
  
  output$impmean = renderPlot({
    impact_plot_mean
  })
  
  output$impcomp = renderPlot({
    impact_plot_comp
  })
  
  output$features = renderPlot({
    response_plot
  })
  
  output$facets_raw = renderPlot({
    holder_raw = airlines %>% group_by_("airline", input$selected2) %>%
      summarise(n = n()) %>%
      mutate(percent = n*100/sum(n)) 
    
    ggplot(data = holder_raw, aes_string(x = input$selected2, y = "percent")) + 
      geom_bar(aes_string(fill = input$selected2), stat = 'identity') + 
      facet_wrap( ~ airline, nrow = 2) +
      scale_fill_brewer(palette = "RdPu") +
      xlab("Rating") + ylab("Percent of reviews") + theme_minimal() +
      ggtitle("Percents of feature ratings") +
      guides(fill=guide_legend(title="Rating")) +
      theme(panel.spacing = unit(2, "lines"),
            plot.title = element_text(size = 20),
            axis.text=element_text(size=12),
            axis.title=element_text(size=14))
  })
  
  output$facets_imputed = renderPlot({
    holder_imputed = airlines_imputed %>% group_by_("airline", input$selected2) %>%
      summarise(n = n()) %>%
      mutate(percent = n*100/sum(n)) 
    ggplot(data = holder_imputed, aes_string(x = input$selected2, y = "percent")) + 
      geom_bar(aes_string(fill = input$selected2), stat = 'identity') + 
      facet_wrap( ~ airline, nrow = 2) +
      scale_fill_brewer(palette = "RdPu") +
      xlab("Rating") + ylab("Percent of reviews") + theme_minimal() +
      ggtitle("Ratings by airline") +
      guides(fill=guide_legend(title="Rating")) +
      theme(panel.spacing = unit(2, "lines"),
            plot.title = element_text(size = 20),
            axis.text=element_text(size=12),
            axis.title=element_text(size=14))
  })
  
  
  
  
  output$pie_raw = renderPlot({
    temp_raw = airlines %>%
      group_by_(input$selected2) %>% summarise(n = n()) %>%
      mutate(percent = n*100/sum(n))
    ggplot(data = temp_raw, aes_string(x = input$selected2, y = "percent")) +
      geom_bar(aes_string(fill = input$selected2), width = 1, stat = 'identity') +
      theme_minimal() + scale_fill_brewer(palette = "RdPu") +
      guides(fill=guide_legend(title="Rating")) +
      xlab(paste(c(input$selected2, "rating"), collapse = ' ')) +
      ylab("Percent of total ratings") +
      ggtitle("Feature percentages industry-wide") + 
      theme(plot.title = element_text(size = 20),
            axis.text=element_text(size=12),
            axis.title=element_text(size=14))
  })

  
  # Define a reactive expression for the document term matrix
  terms_pos <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrixPos(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep_pos <- repeatable(wordcloud)
  
  output$wc_pos = renderPlot({
    u <- terms_pos()
    wordcloud_rep_pos(names(u), u, scale=c(3,0.3),
                      min.freq = input$freq, max.words=50,
                      colors=brewer.pal(8, "Blues"))
  })
  
  
  # Define a reactive expression for the document term matrix
  terms_neg <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrixNeg(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep_neg <- repeatable(wordcloud)

  output$wc_neg = renderPlot({
    u <- terms_neg()
    wordcloud_rep_neg(names(u), u, scale=c(3,0.3),
                  min.freq = input$freq, max.words=50,
                  colors=brewer.pal(8, "Reds"))
  })
  
  
  
  output$table = DT::renderDataTable({
    datatable(airlines, rownames = FALSE, options = list(scrollX = TRUE)) 
  })
  
})

###################################################################################
###################################################################################

# Unused code

# output$pie_imputed = renderPlot({
#   temp_imputed = airlines_imputed %>% filter(airline != 'Southwest Airlines') %>%
#     group_by_(input$selected2) %>% summarise(n = n()) %>%
#     mutate(percent = n*100/sum(n))
#   ggplot(data = temp_imputed, aes_string(x = input$selected2, y = "percent")) +
#     geom_bar(aes_string(fill = input$selected2), width = 1, stat = 'identity') +
#     theme_minimal() + scale_fill_brewer(palette = "RdPu") +
#     guides(fill=guide_legend(title="Rating")) +
#     ggtitle("Percentage of Ratings Overall") + 
#     theme(plot.title = element_text(size = 20),
#           axis.text=element_text(size=12),
#           axis.title=element_text(size=14))
# })
# ggplot(data = seat_comfort_overall, aes(x = seat_comfort, y = percent)) +
#   geom_bar(aes(fill = seat_comfort), width = 1, stat = 'identity') +
#   theme_minimal() + guides(fill=guide_legend(title="Seat Comfort Rating")) +
#   ggtitle("Percentages of Seat Comfort Ratings Overall") +
#   scale_fill_brewer(palette = "RdPu")