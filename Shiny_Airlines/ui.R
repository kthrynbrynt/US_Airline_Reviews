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
      menuItem("Background", tabName = 'background', icon = icon('plane')),
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
      tabItem(tabName = 'background', fluidRow(box(tags$div(class = "header", 
                                                      tags$h4("Increasing Customer Satisfaction
                                                            in the Airline Industry")), width = 12),
                                               align = 'center'),
                                      fluidRow(box(tags$p("The sheer size of the airline industry provides a reason to care about it: 
                                                          it affects not only millions of people directly (flyers), but also millions 
                                                          more indirectly (non-flyers) by the heft of its economic presence. In a 
                                                          December 2016 report, the International Air Transport Association (IATA) writes:"),
                                                   tags$p('"While airline industry profits are expected to have reached a cyclical peak in 
                                                     2016 of $35.6 billion, a soft landing in profitable territory is expected in 2017 
                                                     with a net profit of $29.8 billion. 2017 is expected to be the eighth year in a 
                                                     row of aggregate airline profitability, illustrating the resilience to shocks that 
                                                     have been built into the industry structure. On average, airlines will retain $7.54
                                                     for every passenger carried."',
                                                          tags$a(href = "http://www.iata.org/pressroom/pr/Pages/2016-12-08-01.aspx",
                                                                 "(reference)")),
                                                   tags$p("As a resident of the US and semi-frequent flyer, the US airline industry is of 
                                                     particular interest to me. In looking at carriers by region, the IATA concludes:"),
                                                   tags$p('"The strongest financial performance is being delivered by airlines in North America. 
                                                     Net post-tax profits will be the highest at $18.1 billion next year [...]. The net margin 
                                                     for the region’s carriers is also expected to be the strongest at 8.5% with an average 
                                                     profit of $19.58/passenger."',
                                                          tags$a(href = "http://www.iata.org/pressroom/pr/Pages/2016-12-08-01.aspx",
                                                                 "(reference)")),
                                                   tags$p("Although the North American airline industry is strong, it must be ever-vigilant about 
                                                     keeping up with customer demands in order to maintain its continued growth and its 
                                                     continued position as regional industry leader. From the standpoint of a specific airline, 
                                                     knowing which areas the industry as a whole is struggling with can present an opportunity
                                                     to become an industry leader in one or more specific realms. For example, if customers  
                                                     consistently complain about mobile technology industry-wide, a single airline could set 
                                                     itself apart from the crowd by striving to have an effective, reliable, and user-friendly
                                                     mobile platform."),
                                                  width = 12))),
      tabItem(tabName = 'scraping', fluidRow(box(tags$div(class = "header",
                                                          tags$h4("Data Collection and Variables")), width = 12),
                                             align = 'center'),
                                    fluidRow(box(tags$p("One way to gain insights into what customers care about is to analyze review data.
                                                   In this project, I scrape airline review data from ", 
                                                        tags$a(href = "http://www.airlinequality.com/", "Skytrax "), 
                                                        "for eleven major US carriers. The carriers analyzed are: Alaska Airlines, American 
                                                        Airlines, Delta Air Lines, Frontier Airlines, Hawaiian Airlines, Jetblue, Airways, 
                                                        Southwest Airlines, Spirit Airlines, United Airlines, and Virgin America."),
                                                 # tags$div(
                                                 #   tags$ul(
                                                 #     tags$li("Alaska Airlines"),
                                                 #     tags$li("Allegiant Air"),
                                                 #     tags$li("American Airlines"),
                                                 #     tags$li("Delta Air Lines"),
                                                 #     tags$li("Frontier Airlines"),
                                                 #     tags$li("Hawaiian Airlines"),
                                                 #     tags$li("Jetblue Airways"),
                                                 #     tags$li("Southwest Airlines"),
                                                 #     tags$li("Spirit Airlines"),
                                                 #     tags$li("United Airlines"),
                                                 #     tags$li("Virgin America")
                                                 #   )
                                                 # ),
                                                 tags$p("To perform the scraping I wrote a python script using ",
                                                        tags$a(href = "http://selenium-python.readthedocs.io/", "Selenium"), ", the full code of which
                                                   can be accessed on ", 
                                                        tags$a(href = "https://github.com/kthrynbrynt/US_airline_reviews",
                                                                         "my Github."), "The variables scraped from the Skytrax reviews are:"),
                                                 tags$div(
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
                                                 tags$p("Note: All variables are categorical from a statistical standpoint."),
                                                 tags$p(tags$b("Missingness:"), "One of the issues addressed in the questions is that of missingness.
                                                        The variables of cabin_service, entertainment, food_bev, ground_service, overall, seat_comfort, 
                                                        and value_for_money all contain missing values. These fields happen to all be fields for which a
                                                        rating can be given, either on a scale of 1-10 (overall) or 1-5 (others). We use missingness to 
                                                        help analyze the importance of a variable to a flyers' opinions, and in order to gain as much
                                                        insight as possible, we analyze the data with missing values and the data with imputed values 
                                                        separately. For the imputed data, we simply replaced missing values in the overall rating variable
                                                        with a 6 and the missing values in the remaining variables with a 3. These were chosen with the
                                                        assumption that a person who fails to give a rating in a particular variable is likely ambivalent
                                                        about that variable, therefore we imputed a middle value from the rating scale."),
                                                 width = 12))),
      tabItem(tabName = 'question1', fluidRow(box(tags$div(class = "header",
                                                      tags$h4("Which aspects of a flight most positively and most negatively 
                                                                  affect customers' overall rating of an airline?")), width = 12),
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
                                      # fluidRow(box(p("The above plots are based on the results of running a Pearson Chi-square
                                      #                test of independence on each combination of the variables: aircraft type,
                                      #                overall rating, traveller type, cabin, seat comfort, cabin service, food
                                      #                and beverages, inflight entertainment, ground service, value for money, and
                                      #                recommended. The degree of shading for a combination depends on the resulting
                                      #                p-value from this test."),
                                      #              p('NOTE: Nearly all of the p-values in all of the above tables fall into the 
                                      #                category of "statistically significant." Using the widely-agreed-upon industry 
                                      #                standard of claiming significance for p-values less than 0.05 leads to the
                                      #                correct but unhelpful conclusion that a flyer\' overall impression of an airline
                                      #                is dependent on nearly every aspect of a flight. For this reason, the above plots
                                      #                separate the small p-values into bins of size 1e-50 so that differentiation
                                      #                between different flight aspects can be done to some degree based on the order of 
                                      #                magnitude of their chi-square test p-values.'),
                                      #              width = 12))),
      tabItem(tabName = 'question2', fluidRow(box(tags$div(class = "header", 
                                                           tags$h4("How are US airlines performing across different aspects
                                                                      of customer flight experience?")),
                                                              width = 12), align = 'center'),
                                    fluidRow(selectInput('selected2', 'Flight feature:', features,
                                                         selected = 'seat_comfort'), align = 'center'),
                                    fluidRow(box(plotOutput('facets_raw'), width = 12)),
                                    fluidRow(box(plotOutput('pie_raw'), width = 12))),
                      # fluidRow(radioButtons('button', 'Data to show:', c('Raw (includes NAs)', 'Middle rating imputed'),
                      #               selected = 'Raw (includes NAs)'),
                      #         selectInput('selected2', 'Flight feature:', features,
                      #               selected = 'seat_comfort'), align = 'center'),
                      # fluidRow(conditionalPanel("input.button == 'Raw (includes NAs)'",
                      #                           box(plotOutput('facets_raw'), width = 12)),
                      #          conditionalPanel("input.button == 'Middle rating imputed'",
                      #                    box(plotOutput('facets_imputed'), width = 12))),
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
                                      fluidRow(box(p(), width = 12))),
      tabItem(tabName = 'data', fluidRow(infoBoxOutput('pdf', width = 6)),
              fluidRow(box(DT::dataTableOutput('table'), 
                           width = 12)))
    )
  )
)
)









 
