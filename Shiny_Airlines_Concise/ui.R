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
    
    sidebarUserPanel(tags$h5('Kathryn Bryant'),
                     image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
    sidebarMenu(
      menuItem("Motivation", tabName = 'motivation', icon = icon('plane')),
      menuItem("Data", tabName = 'scraping', icon = icon('search')),
      menuItem('Question 1', tabName = 'question1', icon = icon('lightbulb-o')),
      menuItem('Question 2', tabName = 'question2', icon = icon('lightbulb-o')),
      menuItem('Question 3', tabName = 'question3', icon = icon('lightbulb-o')),
      menuItem('Conclusions', tabName = 'conclusions', icon = icon('gavel')),
      menuItem('Raw Data', tabName = 'data', icon = icon('table'))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = 'text/css', href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = 'motivation', fluidRow(box(tags$div(class = "header", 
                                                      tags$h4("Increasing Customer Satisfaction
                                                            in the Airline Industry")), width = 12),
                                               align = 'center'),
                                      fluidRow(box(tags$p("The International Air Transport Association (IATA) writes:"),
                                                   tags$p('"While airline industry profits are expected to have reached a cyclical peak in 
                                                     2016 of $35.6 billion, a soft landing in profitable territory is expected in 2017 
                                                     with a net profit of $29.8 billion. 2017 is expected to be the eighth year in a 
                                                     row of aggregate airline profitability, illustrating the resilience to shocks that 
                                                     have been built into the industry structure. On average, airlines will retain $7.54
                                                     for every passenger carried."',
                                                          tags$a(href = "http://www.iata.org/pressroom/pr/Pages/2016-12-08-01.aspx",
                                                                 "(reference)")),
                                                   tags$p("Furthermore, in looking at carriers by region the IATA concludes:"),
                                                   tags$p('"The strongest financial performance is being delivered by airlines in North America. 
                                                     Net post-tax profits will be the highest at $18.1 billion next year [...]. The net margin 
                                                     for the region’s carriers is also expected to be the strongest at 8.5% with an average 
                                                     profit of $19.58/passenger."',
                                                          tags$a(href = "http://www.iata.org/pressroom/pr/Pages/2016-12-08-01.aspx",
                                                                 "(reference)")), width = 12)),
                                      fluidRow(box(tags$p("Knowing which areas a particular airline is struggling with or that the industry as a 
                                                          whole is struggling with can present an airline with an opportunity to become an industry 
                                                          leader in one or more specific realms."),
                                                  width = 12))),
      tabItem(tabName = 'scraping', fluidRow(box(tags$div(class = "header",
                                                          tags$h4("Data Collection and Variables")), width = 12),
                                             align = 'center'),
                                    fluidRow(box(tags$div(
                                                    tags$ul(
                                                        tags$li("Website scraped: ",
                                                                tags$a(href = "http://www.airlinequality.com/", "Skytrax")),
                                                        tags$li("Scraping performed in ",
                                                                tags$a(href = "http://selenium-python.readthedocs.io/", "Selenium"), "; full code available on ",
                                                                tags$a(href = "https://github.com/kthrynbrynt/US_airline_reviews",
                                                                         "my Github.")))), width = 12)),
                                    fluidRow(box(tags$div("Variables:",
                                                   tags$ul(
                                                     tags$li(tags$b("airline"), ": Airline with which the review-writer flew (possibilities listed
                                                             above"),
                                                     tags$li(tags$b("overall"), ": Overall airline rating (out of 10) given by the review-writer"),
                                                     tags$li(tags$b("author"), ": Name of the review-writer"),
                                                     tags$li(tags$b("review_date"), ": Date the review was written"),
                                                     tags$li(tags$b("customer_review"), ": Text of the customer review"),
                                                     tags$li(tags$b("aircraft"), ": Aircraft class/type on which the review-writer flew 
                                                             (possibilities too numerous to list; example: Boeing 737)"),
                                                     tags$li(tags$b("traveller_type"), ": Type of traveller of the review-writer (Business,
                                                             Couple Leisure, Family Leisure, Solo Leisure)"),
                                                     tags$li(tags$b("cabin"), ": Type of cabin/class in which the review-writer flew (Business
                                                             Class, Economy Class, First Class, Premium Economy)"),
                                                     tags$li(tags$b("route"), ": Origin and destination of the flight (example: Chicago to Boston)"),
                                                     tags$li(tags$b("date_flown"), ": Month and year in which the flight in question took place"),
                                                     tags$li(tags$b("seat_comfort"), ": Rating (out of 5) of seat comfort"),
                                                     tags$li(tags$b("cabin_service"), ": Rating (out of 5) of the inflight service"),
                                                     tags$li(tags$b("food_bev"), ": Rating (out of 5) of the quality of the inflight food and beverages"),
                                                     tags$li(tags$b("entertainment"),": Rating (out of 5) of the availability and connectivity of the 
                                                             inflight entertainment; includes movies and wifi connectivity"),
                                                     tags$li(tags$b("ground_service"), ": Rating (out of 5) of the service on the ground before and/or 
                                                             after the flight"),
                                                     tags$li(tags$b("value_for_money"), ": Rating (out of 5) of the value of the airline against the cost
                                                             of a ticket"),
                                                     tags$li(tags$b("recommended"), ": Does the review-writer plan to recommend the airline to others 
                                                             (Yes or No)")
                                                   )
                                                 ),
                                                 width = 12))),
      tabItem(tabName = 'question1', fluidRow(box(tags$div(class = "header",
                                                      tags$h4("Which aspect of a flight best predicts a 
                                                              customers' overall rating of an airline?")), width = 12),
                                                      align = 'center'),
                                      fluidRow(radioButtons('button0', 'Data to show:', c('Middle rating imputed', 'Mean imputed', 'Complete cases only'),
                                                            selected = 'Middle rating imputed'), align = 'center'),
                                      fluidRow(conditionalPanel("input.button0 == 'Middle rating imputed'",
                                                      box(plotOutput('imp3'), width = 12)),
                                               conditionalPanel("input.button0 == 'Mean imputed'",
                                                      box(plotOutput('impmean'), width = 12)),
                                               conditionalPanel("input.button0 == 'Complete cases only'",
                                                                box(plotOutput('impcomp'), width = 12))),
                                      fluidRow(box(tags$p('The above values represent the estimated relative power of each of the variables "cabin_service", 
                                                          "entertainment", "food_bev", "ground_service", and "seat_comfort" in predicting "overall" rating. 
                                                          The computations are done with the randomForest() function from the R package "randomForest," 
                                                          which uses the non-parametric Breiman random forest algorithm for regression.',
                                                          tags$a(href = 'http://www.bios.unc.edu/~dzeng/BIOS740/randomforest.pdf', '(reference)')),
                                        width = 12)),
                                      fluidRow(box(plotOutput('features'), width = 12))),
      tabItem(tabName = 'question2', fluidRow(box(tags$div(class = "header", 
                                                           tags$h4("How are US airlines performing across different aspects
                                                                      of customer flight experience?")),
                                                              width = 12), align = 'center'),
                                    fluidRow(selectInput('selected2', 'Flight feature:', features,
                                                         selected = 'seat_comfort'), align = 'center'),
                                    fluidRow(box(plotOutput('facets_raw'), width = 12)),
                                    fluidRow(box(plotOutput('pie_raw'), width = 12))),
      tabItem(tabName = 'question3', fluidRow(box(tags$div(class = "header", 
                                                           tags$h4("What words come up most frequently in 
                                                                   positive reviews? In negative reviews?")), width = 12),
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
                                                    tags$h4("Conclusions")), width = 12), 
                                              align = 'center'),
                                      fluidRow(box(tags$div(
                                                      tags$ul(
                                                          tags$li(tags$b("Question 1 Summary:"), ": Since seat_comfort and cabin_service are both strong predictors 
                                                                  of overall rating AND the two most filled-in fields, I would 
                                                                  recommend that an airline invest in improving these aspects over 
                                                                  others if having to choose."),
                                                          tags$li(tags$b("Question 2"), ": Jetblue (or Virgin, Alaska, Delta) should market themselves as 
                                                                  the industry leaders in some/all of the categories they lead in."),
                                                          tags$li(tags$b("Question 2"), ": The industry as a whole is getting dinged on cabin_service, ground_service, 
                                                                  and seat_comfort. One of the middling airlines could invest in becoming an 
                                                                  industry leader in one of these realms to set itself apart from the rest."),
                                                          tags$li(tags$b("Question 2 Summary:"), ": People care about ease and comfort."),
                                                          tags$li(tags$b("Question 3"), ": Delta has problems in Atlanta; Frontier has problems in Denver; Hawaiian 
                                                                  airline customers mention class more than those of any other airline."),
                                                          tags$li(tags$b("Question 3"), ": Despite Spirit having the worst seats from Question 2, the negative reviews 
                                                                  for Spirit seem to be more related to delays and cancellations."),
                                                          tags$li(tags$b("Question 3 Summary:"), ": People care about time a lot, yet they don't seem to care about 
                                                                  minutes of lateness or delay; they care when they are late or delayed by 'hours'.")
                                                        )
                                      ), width = 12))),
      tabItem(tabName = 'data', fluidRow(infoBoxOutput('pdf', width = 6)),
              fluidRow(box(DT::dataTableOutput('table'), 
                           width = 12)))
    )
  )
)
)









 
