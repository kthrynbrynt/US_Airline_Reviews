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
      menuItem("Data Collection", tabName = 'scraping', icon = icon('search')),
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
                                               align = 'center'),
                                      fluidRow(box(p("The sheer size of the airline industry provides a reason to care about it: 
                                                          it affects not only millions of people directly (flyers), but also millions 
                                                          more indirectly (non-flyers) by the heft of its economic presence. In a 
                                                          December 2016 report, the International Air Transport Association (IATA) writes:"),
                                                   p('"While airline industry profits are expected to have reached a cyclical peak in 
                                                     2016 of $35.6 billion, a soft landing in profitable territory is expected in 2017 
                                                     with a net profit of $29.8 billion. 2017 is expected to be the eighth year in a 
                                                     row of aggregate airline profitability, illustrating the resilience to shocks that 
                                                     have been built into the industry structure. On average, airlines will retain $7.54
                                                     for every passenger carried."'),
                                                   p("As a resident of the US and semi-frequent flyer, the US airline industry is of 
                                                     particular interest to me. In looking at carriers by region, the IATA concludes:"),
                                                   p('"The strongest financial performance is being delivered by airlines in North America. 
                                                     Net post-tax profits will be the highest at $18.1 billion next year [...].The net margin 
                                                     for the region’s carriers is also expected to be the strongest at 8.5% with an average 
                                                     profit of $19.58/passenger."'),
                                                   p("Although the North American airline industry is strong, it must be ever-vigilant about 
                                                     keeping up with customer demands in order to maintain its continued growth and its 
                                                     continued position as regional industry leader. From the standpoint of a specific airline, 
                                                     knowing which areas the industry as a whole is struggling with can present an opportunity
                                                     to become an industry leader in one or more specific realms. For example, if customers  
                                                     consistently complain about mobile technology industry-wide, a single airline could set 
                                                     itself apart from the crowd by striving to have an effective, reliable, and user-friendly
                                                     mobile platform."),
                                                  width = 12))),
      tabItem(tabName = 'scraping', fluidRow(box(tags$div(class = "header",
                                                          tags$h4("Web Scraping with Selenium")), width = 12),
                                             align = 'center'),
                                    fluidRow(box(width = 12))),
      tabItem(tabName = 'question1', fluidRow(box(tags$div(class = "header",
                                                      tags$h4("Which aspects of a flight most positively and most negatively 
                                                                  affect a customers' overall rating of an airline?")), width = 12),
                                                      align = 'center'),
                                      fluidRow(radioButtons('button0', 'Data to show:', c('Raw (includes NAs)', 'Middle rating imputed'),
                                                            selected = 'Raw (includes NAs)'), align = 'center'),
                                      fluidRow(conditionalPanel("input.button0 == 'Raw (includes NAs)'",
                                                      box(plotOutput('ppos'), width = 6), 
                                                      box(plotOutput('pneg'), width = 6)),
                                               conditionalPanel("input.button0 == 'Middle rating imputed'",
                                                      box(plotOutput('pimppos'), width = 6), 
                                                      box(plotOutput('pimpneg'), width = 6))),
                                      fluidRow(box(p("The above plots are based on the results of running a Pearson Chi-square
                                                     test of independence on each combination of the variables: aircraft type,
                                                     overall rating, traveller type, cabin, seat comfort, cabin service, food
                                                     and beverages, inflight entertainment, ground service, value for money, and
                                                     recommended. The degree of shading for a combination depends on the resulting
                                                     p-value from this test."),
                                                   p('NOTE: Nearly all of the p-values in all of the above tables fall into the 
                                                     category of "statistically significant." Using the widely-agreed-upon industry 
                                                     standard of claiming significance for p-values less than 0.05 leads to the
                                                     correct but unhelpful conclusion that a flyer\' overall impression of an airline
                                                     is dependent on nearly every aspect of a flight. For this reason, the above plots
                                                     separate the small p-values into bins of size 1e-50 so that differentiation
                                                     between different flight aspects can be done to some degree based on the order of 
                                                     magnitude of their chi-square test p-values.'),
                                                   width = 12))),
                                                   # tags$div(
                                                   #   tags$ul(
                                                   #     tags$li("Airline: Name of"),
                                                   #     tags$li("Overall Rating (1-10)"),
                                                   #     tags$li("Aircraft"),
                                                   #     tags$li("Traveller Type"),
                                                   #     tags$li("Cabin"),
                                                   #     
                                                   #   )
                                                   # )), width = 12)),
      tabItem(tabName = 'question2', fluidRow(box(tags$div(class = "header", 
                                                           tags$h4("How are US airlines performing across different aspects
                                                                      of customer flight experience?")),
                                                              width = 12), align = 'center'),
                      fluidRow(radioButtons('button', 'Data to show:', c('Raw (includes NAs)', 'Middle rating imputed'),
                                    selected = 'Raw (includes NAs)'),
                              selectInput('selected2', 'Flight feature:', features,
                                    selected = 'seat_comfort'), align = 'center'),
                      fluidRow(conditionalPanel("input.button == 'Raw (includes NAs)'",
                                                box(plotOutput('facets_raw'), width = 12)),
                               conditionalPanel("input.button == 'Middle rating imputed'",
                                         box(plotOutput('facets_imputed'), width = 12))),
                      fluidRow(box(plotOutput('features'), width = 12))),
                      # fluidRow(conditionalPanel("input.button == 'Raw (includes NAs)'",
                      #                           box(plotOutput('pie_raw'), width = 12)),
                      #          conditionalPanel("input.button == 'Middle rating imputed'",
                      #                           box(plotOutput('pie_imputed'), width = 12)))),
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









 
