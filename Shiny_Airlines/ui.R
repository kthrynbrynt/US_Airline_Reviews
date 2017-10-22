#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(dplyr)
library(ggplot2)
library(DT)
library(shinydashboard)

shinyUI(dashboardPage(
  skin = 'black',
  dashboardHeader(title = "US Airline Reviews"),
  dashboardSidebar(
    
    sidebarUserPanel(h5('Kathryn Bryant'),
                     image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
    sidebarMenu(
      menuItem("Background", tabName = 'background', icon = icon('plane')),
      menuItem('Question 1', tabName = 'question1', icon = icon('lightbulb-o')),
      menuItem('Question 2', tabName = 'question2', icon = icon('lightbulb-o')),
      menuItem('Question 3', tabName = 'question3', icon = icon('lightbulb-o')),
      menuItem('Conclusions', tabName = 'conclusions', icon = icon('gavel')),
      menuItem('Data', tabName = 'data', icon = icon('table'))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = 'text/css', href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = 'background', fluidRow(box(tags$div(class = "header", 
                                                      tags$h3("Increasing Customer Satisfaction
                                                            in the Airline Industry")), width = 12), 
                                               align = 'center')),
      tabItem(tabName = 'question1', fluidRow(box(tags$div(class = "header",
                                                      tags$h4("Which aspects of a flight most positively and most negatively 
                                                                  affect a customers' overall rating of an airline?")), width = 12),
                                                      align = 'center'),
                                      fluidRow(box(plotOutput('ppos'), width = 6), 
                                                box(plotOutput('pneg'), width = 6))),
      tabItem(tabName = 'question2', fluidRow(box(tags$div(class = "header", 
                                                           tags$h4("How are US airlines performing across different aspects
                                                                      of customer flight experience?")),
                                                              width = 12), align = 'center'),
                      fluidRow(radioButtons('button', 'Data to show:', c('Raw (includes NAs)', 'Median-imputed'),
                                    selected = 'Raw (includes NAs)'),
                              selectInput('selected2', 'Flight Feature', features,
                                    selected = 'seat_comfort'), align = 'center'),
                      # fluidRow(box(plotOutput('facets_raw'), width = 12, height = 500)),
                      # fluidRow(box(plotOutput('pie_raw'), width = 12))),
                      fluidRow(conditionalPanel("input.button == 'Raw (includes NAs)'",
                                                box(plotOutput('facets_raw'), width = 12)),
                               conditionalPanel("input.button == 'Median-imputed'",
                                         box(plotOutput('facets_imputed'), width = 12))),
                      fluidRow(conditionalPanel("input.button == 'Raw (includes NAs)'",
                                                box(plotOutput('pie_raw'), width = 12)),
                               conditionalPanel("input.button == 'Median-imputed'",
                                                box(plotOutput('pie_imputed'), width = 12)))),
      tabItem(tabName = 'question3', fluidRow(box(tags$div(class = "header", 
                                                           tags$h4("What words come up most frequently in 
                                                                   negative reviews? In positive reviews?")), width = 12),
                                              align = 'center'),
              fluidRow(box(plotOutput('wc_pos'), width = 6), 
                       box(plotOutput('wc_neg'), width = 6)),
              fluidRow(selectInput("selection", "Airline(s):",
                                   choices = airline_list),
                       actionButton("update", "Change"),
                       hr(),
                       sliderInput("freq","Minimum Frequency:",
                                   min = 1,  max = 50, value = 15)), 
                        align = 'center'),
      tabItem(tabName = 'conclusions', fluidRow(box(tags$div(class = "header", 
                                                    tags$h3("Conclusions")), width = 12), 
                                              align = 'center')),
      tabItem(tabName = 'data', fluidRow(infoBoxOutput('pdf', width = 6)),
              fluidRow(box(DT::dataTableOutput('table'), 
                           width = 12)))
    )
  )
)
)