library(caret)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(RColorBrewer)  
library(reshape2) 
library("tm") # for text-mining
library("SnowballC") # for text-stemming
library("wordcloud") # word cloud generator
library('wordcloud2') #word cloud generator2
library(memoise)
library(relaimpo)

airlines_raw = read.csv('~/Dropbox/NYCDSA/US_Airline_Reviews/US_airline_reviews3.csv')
airlines = read.csv('~/Dropbox/NYCDSA/US_Airline_Reviews/US_airline_reviews3.csv')
airlines_imputed_numerical = read.csv('~/Dropbox/NYCDSA/US_Airline_Reviews/US_airline_reviews3.csv')
airlines_imputed = read.csv('~/Dropbox/NYCDSA/US_Airline_Reviews/US_airline_reviews3.csv')  

# Remove rogue line and turn numeric-like categorical variables into factors
airlines = airlines %>% filter(airline != "http://www.airlinequality.com/airline-reviews/american-airlines/")
#airlines = airlines %>% select(-X)
airlines$overall = as.factor(airlines$overall)
airlines$seat_comfort = as.factor(airlines$seat_comfort)
airlines$cabin_service = as.factor(airlines$cabin_service)
airlines$food_bev = as.factor(airlines$food_bev)
airlines$route = as.factor(airlines$route)
airlines$entertainment = as.factor(airlines$entertainment)
airlines$ground_service = as.factor(airlines$ground_service)
airlines$value_for_money = as.factor(airlines$value_for_money)

# For airlines_imputed, remove rogue line
air_imputed_numerical_3 = airlines_imputed_numerical %>% filter(airline != "http://www.airlinequality.com/airline-reviews/american-airlines/")
air_imputed_mean = airlines_imputed_numerical %>% filter(airline != "http://www.airlinequality.com/airline-reviews/american-airlines/")
air_complete = airlines_raw %>% filter(airline != "http://www.airlinequality.com/airline-reviews/american-airlines/")

air_complete = air_complete[complete.cases(air_complete), ]

air_complete= air_complete[, c("cabin_service", "entertainment",
                                                      "food_bev", "ground_service", "overall",
                                                      "seat_comfort", "value_for_money")]

names(which(colSums(is.na(airlines_imputed))>0))
# "overall" "seat_comfort" "cabin_service" "food_bev"
# "entertainment" "ground_service" "value_for_money"

# air_imputed_numerical_3: Impute the median rating *option*
air_imputed_numerical_3$overall[is.na(air_imputed_numerical_3$overall)] = 6
air_imputed_numerical_3$seat_comfort[is.na(air_imputed_numerical_3$seat_comfort)] = 3
air_imputed_numerical_3$cabin_service[is.na(air_imputed_numerical_3$cabin_service)] = 3
air_imputed_numerical_3$food_bev[is.na(air_imputed_numerical_3$food_bev)] = 3
air_imputed_numerical_3$entertainment[is.na(air_imputed_numerical_3$entertainment)] = 3
air_imputed_numerical_3$ground_service[is.na(air_imputed_numerical_3$ground_service)] = 3
air_imputed_numerical_3$value_for_money[is.na(air_imputed_numerical_3$value_for_money)] = 3

air_imputed_numerical_3 = air_imputed_numerical_3[, c("cabin_service", "entertainment",
                                                      "food_bev", "ground_service", "overall",
                                                      "seat_comfort", "value_for_money")]

# airlines_imputed_mean: Impute mean of the ratings
air_imputed_mean$overall[is.na(air_imputed_mean$overall)] = mean(air_imputed_mean$overall, na.rm=TRUE)
air_imputed_mean$seat_comfort[is.na(air_imputed_mean$seat_comfort)] = mean(air_imputed_mean$seat_comfort, na.rm=TRUE)
air_imputed_mean$cabin_service[is.na(air_imputed_mean$cabin_service)] = mean(air_imputed_mean$cabin_service, na.rm=TRUE)
air_imputed_mean$food_bev[is.na(air_imputed_mean$food_bev)] = mean(air_imputed_mean$food_bev, na.rm=TRUE)
air_imputed_mean$entertainment[is.na(air_imputed_mean$entertainment)] = mean(air_imputed_mean$entertainment, na.rm=TRUE)
air_imputed_mean$ground_service[is.na(air_imputed_mean$ground_service)] = mean(air_imputed_mean$ground_service, na.rm=TRUE)
air_imputed_mean$value_for_money[is.na(air_imputed_mean$value_for_money)] = mean(air_imputed_mean$value_for_money, na.rm=TRUE)

air_imputed_mean = air_imputed_mean[, c("cabin_service", "entertainment",
                                        "food_bev", "ground_service", "overall",
                                        "seat_comfort", "value_for_money")]

# Alternative imputation (median):
# class(airlines_imputed$seat_comfort)
# pre = preProcess(airlines_imputed, method = "medianImpute") 
# airlines_imputed = predict(pre, airlines_imputed)

#Turn numeric-like categorical variables into factors
airlines_imputed$overall = as.factor(airlines_imputed$overall)
airlines_imputed$seat_comfort = as.factor(airlines_imputed$seat_comfort)
airlines_imputed$cabin_service = as.factor(airlines_imputed$cabin_service)
airlines_imputed$food_bev = as.factor(airlines_imputed$food_bev)
airlines_imputed$route = as.factor(airlines_imputed$route)
airlines_imputed$entertainment = as.factor(airlines_imputed$entertainment)
airlines_imputed$ground_service = as.factor(airlines_imputed$ground_service)
airlines_imputed$value_for_money = as.factor(airlines_imputed$value_for_money)

##################################################################################
##################################################################################

# Dealing with NAs

names(which(colSums(is.na(airlines))>0))

# Refactor variables with NAs to include the string "NA" as a factor level
# by replacing NA with "NA"

# First, get levels and add "NA" (as a string)
levels.overall <- levels(airlines$overall)
levels.overall[length(levels.overall) + 1] = "NA"

levels.seat_comfort <- levels(airlines$seat_comfort)
levels.seat_comfort[length(levels.seat_comfort) + 1] = "NA"

levels.cabin_service <- levels(airlines$cabin_service)
levels.cabin_service[length(levels.cabin_service) + 1] = "NA"

levels.cabin_service <- levels(airlines$cabin_service)
levels.cabin_service[length(levels.cabin_service) + 1] = "NA"

levels.food_bev <- levels(airlines$food_bev)
levels.food_bev[length(levels.food_bev) + 1] = "NA"

levels.entertainment <- levels(airlines$entertainment)
levels.entertainment[length(levels.entertainment) + 1] = "NA"

levels.ground_service <- levels(airlines$ground_service)
levels.ground_service[length(levels.ground_service) + 1] = "NA"

levels.value_for_money <- levels(airlines$value_for_money)
levels.value_for_money[length(levels.value_for_money) + 1] = "NA"

# Refactoring:
airlines$overall = factor(airlines$overall, levels = levels.overall)
airlines$overall[is.na(airlines$overall)] = "NA"

airlines$seat_comfort = factor(airlines$seat_comfort, levels = levels.seat_comfort)
airlines$seat_comfort[is.na(airlines$seat_comfort)] = "NA"

airlines$cabin_service = factor(airlines$cabin_service, levels = levels.cabin_service)
airlines$cabin_service[is.na(airlines$cabin_service)] = "NA"

airlines$food_bev = factor(airlines$food_bev, levels = levels.food_bev)
airlines$food_bev[is.na(airlines$food_bev)] = "NA"

airlines$entertainment = factor(airlines$entertainment, levels = levels.entertainment)
airlines$entertainment[is.na(airlines$entertainment)] = "NA"

airlines$ground_service = factor(airlines$ground_service, levels = levels.ground_service)
airlines$ground_service[is.na(airlines$ground_service)] = "NA"

airlines$value_for_money = factor(airlines$value_for_money, levels = levels.value_for_money)
airlines$value_for_money[is.na(airlines$value_for_money)] = "NA"




##################################################################################
##################################################################################

## Question 1:

features = c("cabin_service", "entertainment", "food_bev", "ground_service", 
             "seat_comfort", "value_for_money")

# Approach 1:Computing Relative importance in multiple linear model of 'overall'

# For air_imputed_numerical_3:
myimp_3 = calc.relimp(overall ~., data = air_imputed_numerical_3)
summary(lm(overall ~ ., data = air_imputed_numerical_3))
myimp_3@lmg/sum(myimp_3@lmg)

impvec_3 = c(00.17038122, 0.05867514, 0.09811587, 0.17298709, 0.16546550, 0.33437518) 
impact_3 = data.frame(feature = c("cabin_service", "entertainment", "food_bev", "ground_service",
                                  "seat_comfort", "value_for_money"), imp = impvec_3)

impact_plot_3 = ggplot(data = impact_3, aes(x = feature, y = imp)) + 
  geom_bar(aes(fill = feature), stat = 'identity') + 
  scale_fill_brewer(palette = "RdPu") +
  xlab("Feature") + ylab("Est. Coeff. of Determination (r^2)") + theme_minimal() +
  ggtitle("Feature impact on overall rating: calc.relimp") +
  guides(fill=guide_legend(title="Feature")) +
  theme(panel.spacing = unit(2, "lines"),
        axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(size = 20),
        axis.text=element_text(size=12),
        axis.title=element_text(size=14))


# For air_imputed_mean:
myimp_mean = calc.relimp(overall ~., data = air_imputed_mean)
summary(lm(overall ~ ., data = air_imputed_mean))
myimp_mean@lmg/sum(myimp_mean@lmg)

impvec_mean = c(0.17558693, 0.06837641, 0.11472528, 0.12867938, 0.15639555, 0.35623645)
impact_mean = data.frame(feature = c("cabin_service", "entertainment", "food_bev", "ground_service",
                                     "seat_comfort", "value_for_money"), imp = impvec_mean)

impact_plot_mean = ggplot(data = impact_mean, aes(x = feature, y = imp)) + 
  geom_bar(aes(fill = feature), stat = 'identity') + 
  scale_fill_brewer(palette = "RdPu") +
  xlab("Feature") + ylab("Est. Coeff. of Determination (r^2)") + theme_minimal() +
  ggtitle("Feature impact on overall rating: calc.relimp") +
  guides(fill=guide_legend(title="Feature")) +
  theme(panel.spacing = unit(2, "lines"),
        axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(size = 20),
        axis.text=element_text(size=12),
        axis.title=element_text(size=14))

# For air_complete:
myimp_comp = calc.relimp(overall ~., data = air_complete)
summary(lm(overall ~ ., data = air_complete))
myimp_comp@lmg/sum(myimp_comp@lmg)

impvec_comp = c(0.1315520, 0.1228263, 0.1387163, 0.1930213, 0.1486761, 0.2652080)
impact_comp = data.frame(feature = c("cabin_service", "entertainment", "food_bev", "ground_service",
                                     "seat_comfort", "value_for_money"), imp = impvec_comp)

impact_plot_comp = ggplot(data = impact_comp, aes(x = feature, y = imp)) + 
  geom_bar(aes(fill = feature), stat = 'identity') + 
  scale_fill_brewer(palette = "RdPu") +
  xlab("Feature") + ylab("Est. Coeff. of Determination (r^2)") + theme_minimal() +
  ggtitle("Feature impact on overall rating: calc.relimp") +
  guides(fill=guide_legend(title="Feature")) +
  theme(panel.spacing = unit(2, "lines"),
        axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(size = 20),
        axis.text=element_text(size=12),
        axis.title=element_text(size=14))


# Approach 2: Using percentage of responses to determine relative importance

airlines_raw_cat = airlines_raw[, c("cabin_service", "entertainment", "food_bev", "ground_service", 
                                    "seat_comfort", "value_for_money")]
care_vars = colMeans(1-is.na(airlines_raw_cat))
var_responses = data.frame(X = 1:6, percent_resp = care_vars, vars = names(airlines_raw_cat))

response_plot = ggplot(var_responses, aes(x = vars, y = percent_resp)) + 
  geom_bar(aes(fill = vars), stat = 'identity') + 
  scale_fill_brewer(palette = "RdPu") + 
  theme_minimal() + ggtitle("Feature impact on overall rating: reponse rate") +
  xlab("Feature") + ylab("Percent of responses including feature") + 
  theme(axis.text.x=element_text(angle=45,hjust=1),
        plot.title = element_text(size = 20),
        axis.text=element_text(size=12),
        axis.title=element_text(size=14))

##################################################################################
##################################################################################

# Question 2: Done in server.R


##################################################################################
##################################################################################

#Prep for Question 3: Getting postive and negative data frames into text files, 
# separated by airline.
# This will allow us to produce a word cloud corresponding to all airlines and 
# and word clouds for the airlines individually

#First define data frames for each airline and each review type (pos/neg):

airlines_pos = airlines %>% filter(overall %in% c('6','7', '8', '9', '10'))
airlines_neg = airlines %>% filter(overall %in% c('1', '2', '3', '4', '5'))

alaska_pos = airlines_pos %>% filter(airline == 'Alaska Airlines')
alaska_neg = airlines_neg %>% filter(airline == 'Alaska Airlines')

allegiant_pos = airlines_pos %>% filter(airline == 'Allegiant Air')
allegiant_neg = airlines_neg %>% filter(airline == 'Allegiant Air')

american_pos = airlines_pos %>% filter(airline == 'American Airlines')
american_neg = airlines_neg %>% filter(airline == 'American Airlines')

delta_pos = airlines_pos %>% filter(airline == 'Delta Air Lines')
delta_neg = airlines_neg %>% filter(airline == 'Delta Air Lines')

frontier_pos = airlines_pos %>% filter(airline == 'Frontier Airlines')
frontier_neg = airlines_neg %>% filter(airline == 'Frontier Airlines')

hawaiian_pos = airlines_pos %>% filter(airline == 'Hawaiian Airlines')
hawaiian_neg = airlines_neg %>% filter(airline == 'Hawaiian Airlines')

jetblue_pos = airlines_pos %>% filter(airline == 'Jetblue Airways')
jetblue_neg = airlines_neg %>% filter(airline == 'Jetblue Airways')

# southwest_pos = airlines_pos %>% filter(airline == 'Southwest Airlines')
# southwest_neg = airlines_neg %>% filter(airline == 'Southwest Airlines')

spirit_pos = airlines_pos %>% filter(airline == 'Spirit Airlines')
spirit_neg = airlines_neg %>% filter(airline == 'Spirit Airlines')

united_pos = airlines_pos %>% filter(airline == 'United Airlines')
united_neg = airlines_neg %>% filter(airline == 'United Airlines')

virgin_pos = airlines_pos %>% filter(airline == 'Virgin America')
virgin_neg = airlines_neg %>% filter(airline == 'Virgin America')


# Now write each of the above's 'customer_review' columns to a txt file:

write.table(airlines_pos$customer_review,"all_pos.txt",sep="\t",row.names=FALSE)
write.table(airlines_neg$customer_review,"all_neg.txt",sep="\t",row.names=FALSE)

write.table(alaska_pos$customer_review,"alaska_pos.txt",sep="\t",row.names=FALSE)
write.table(alaska_neg$customer_review,"alaska_neg.txt",sep="\t",row.names=FALSE)

write.table(allegiant_pos$customer_review,"allegiant_pos.txt",sep="\t",row.names=FALSE)
write.table(allegiant_neg$customer_review,"allegiant_neg.txt",sep="\t",row.names=FALSE)

write.table(american_pos$customer_review,"american_pos.txt",sep="\t",row.names=FALSE)
write.table(american_neg$customer_review,"american_neg.txt",sep="\t",row.names=FALSE)

write.table(delta_pos$customer_review,"delta_pos.txt",sep="\t",row.names=FALSE)
write.table(delta_neg$customer_review,"delta_neg.txt",sep="\t",row.names=FALSE)

write.table(frontier_pos$customer_review,"frontier_pos.txt",sep="\t",row.names=FALSE)
write.table(frontier_neg$customer_review,"frontier_neg.txt",sep="\t",row.names=FALSE)

write.table(hawaiian_pos$customer_review,"hawaiian_pos.txt",sep="\t",row.names=FALSE)
write.table(hawaiian_neg$customer_review,"hawaiian_neg.txt",sep="\t",row.names=FALSE)

write.table(jetblue_pos$customer_review,"jetblue_pos.txt",sep="\t",row.names=FALSE)
write.table(jetblue_neg$customer_review,"jetblue_neg.txt",sep="\t",row.names=FALSE)

# write.table(southwest_pos$customer_review,"southwest_pos.txt",sep="\t",row.names=FALSE)
# write.table(southwest_neg$customer_review,"southwest_neg.txt",sep="\t",row.names=FALSE)

write.table(spirit_pos$customer_review,"spirit_pos.txt",sep="\t",row.names=FALSE)
write.table(spirit_neg$customer_review,"spirit_neg.txt",sep="\t",row.names=FALSE)

write.table(united_pos$customer_review,"united_pos.txt",sep="\t",row.names=FALSE)
write.table(united_neg$customer_review,"united_neg.txt",sep="\t",row.names=FALSE)

write.table(virgin_pos$customer_review,"virgin_pos.txt",sep="\t",row.names=FALSE)
write.table(virgin_neg$customer_review,"virgin_neg.txt",sep="\t",row.names=FALSE)



##################################################################################
##################################################################################

# Question 3: Word Cloud Analysis

# The list of valid airlines
airline_list <<- list("All" = "all",
                      "Alaska Airlines" = "alaska",
                      "Allegiant Air" = "allegiant",
                      "American Airlines" = "american",
                      "Delta Air Lines" = "delta",
                      "Frontier Airlines" = "frontier",
                      "Hawaiian Airlines" = "hawaiian",
                      "Jetblue Airways" = "jetblue",
                      "Spirit Airlines" = "spirit",
                      "United Airlines" = "united",
                      "Virgin America" = "virgin")

# Use "memoise" to automatically cache the results
getTermMatrixPos <- memoise(function(company) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (!(company %in% airline_list))
    stop("Unknown airline")
  
  text = readLines(paste(c(company, '_pos.txt'), collapse = ''),
                   encoding="UTF-8")
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("english"), 
                      "flight", "airplane", "united", "alaska", "allegiant", "plane",
                      "spirit", "delta", "american", "airlines", "virgin", "america",
                      "hawaiian", "frontier", "flights", "airline"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})

getTermMatrixNeg <- memoise(function(company) {
  if (!(company %in% airline_list))
    stop("Unknown airline")
  
  text = readLines(paste(c(company, '_neg.txt'), collapse = ''),
                   encoding="UTF-8")
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("english"), 
                      "flight", "airplane", "united", "alaska", "allegiant", "plane",
                      "spirit", "delta", "american", "airlines", "virgin", "america",
                      "hawaiian", "frontier", "flights", "airline"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})






##################################################################################
##################################################################################

# Unused code:

# Heat maps based on p-values of chi-square tests
# #Define data frame with only the variables that take scale values (1-10 or 1-5)
# airlines_categorical = airlines[, c("cabin_service", "entertainment", "food_bev", "ground_service", "overall", 
#                                     "seat_comfort", "value_for_money")]
# 
# # %>% select(-airline, -author, -review_date,
# #                                            -customer_review, -route, -date_flown)
# 
# #Analyzing Chi-square p-values across all combos of categorical variables
# #(Didn't end up using due to questional mathematics underlying it!)
# # Separate above data frame by positive and negative reviews, according to overall rating
# air_cat_positive = airlines_categorical %>% filter(overall %in% c('6','7', '8', '9', '10'))
# air_cat_negative = airlines_categorical %>% filter(overall %in% c('1', '2', '3', '4', '5'))
# 
# # Define a matrix whose i,jth entry is the result of performing a Chi-square test
# # of independence on the ith variable and the jth variable
# k <- ncol(air_cat_positive)
# result_pos <- matrix(1, nrow=k, ncol=k)
# rownames(result_pos) <- colnames(result_pos) <- names(air_cat_positive)
# for(i in 1:k) {
#   for(j in 1:k) {
#     result_pos[i,j] <- chisq.test(air_cat_positive[,i], air_cat_positive[,j] )$p.value
#   }
# }
# 
# n <- ncol(air_cat_negative)
# result_neg <- matrix(1, nrow=n, ncol=n)
# rownames(result_neg) <- colnames(result_neg) <- names(air_cat_negative)
# for(i in 1:n) {
#   for(j in 1:n) {
#     result_neg[i,j] <- chisq.test(air_cat_negative[,i], air_cat_negative[,j] )$p.value
#   }
# }
# 
# 
# # Use the melt function from the reshape2 package to change the above matrix into a
# # graphable data frame
# pvalues_pos = melt(result_pos)
# pvalues_neg = melt(result_neg)
# 
# # See the ranges of p-values obtained above so that we can define our own color
# # interval ranges for our plot
# pvalues_pos %>% group_by(value) %>% filter(row_number() == 1)
# 
# # Define p-value intervals to be used for different colors in plot
# pvalues_pos$ranges <- cut(pvalues_pos$value, breaks = c(-Inf, 1e-300, 1e-250, 1e-200,
#                                                         1e-150, 1e-100, 1e-50, 0, .01, .05, .1, Inf),right = FALSE)
# pvalues_neg$ranges <- cut(pvalues_neg$value, breaks = c(-Inf, 1e-300, 1e-250, 1e-200,
#                                                         1e-150, 1e-100, 1e-50, 0, .01, .05, .1, Inf),right = FALSE)
# 
# # Heat maps of chi-squre test p-values:
# p_pos = ggplot(data = pvalues_pos, aes(x=Var1, y=Var2)) +
#   geom_tile(aes(fill = ranges), colour = "white", alpha = .8) +
#   scale_fill_brewer(palette = "RdPu") + theme_classic() +
#   xlab("") + ylab("")+ ggtitle("Chi-square p-values: Positive Reviews") +
#   guides(fill=guide_legend(title="p-value")) +
#   theme(axis.text.x=element_text(angle=45,hjust=1))
# 
# 
# p_neg = ggplot(data = pvalues_neg, aes(x=Var1, y=Var2, fill=value)) +
#   geom_tile(aes(fill = ranges), colour = "white", alpha = .8) +
#   scale_fill_brewer(palette = "RdPu") + theme_classic() +
#   xlab("") + ylab("") + ggtitle("Chi-square p-values: Negative Reviews") +
#   guides(fill=guide_legend(title="p-value")) +
#   theme(axis.text.x=element_text(angle=45,hjust=1))
# 
# 
# 
# 
# # Now get heat maps exactly as we did above but for the 'imputed' version of the data:
# 
# categorical_imputed = airlines_imputed[,c("cabin_service", "entertainment", "food_bev", "ground_service", "overall", 
#                                           "seat_comfort", "value_for_money")]
# 
# # %>% select(-airline, -author, -review_date,
# #                                            -customer_review, -route, -date_flown)
# 
# cat_imp_positive = categorical_imputed %>% filter(overall %in% c('6','7', '8', '9', '10'))
# cat_imp_negative = categorical_imputed %>% filter(overall %in% c('1', '2', '3', '4', '5'))
# 
# k_imp <- ncol(cat_imp_positive)
# result_imp_pos <- matrix(1, nrow=k_imp, ncol=k_imp)
# rownames(result_imp_pos) <- colnames(result_imp_pos) <- names(cat_imp_positive)
# for(i in 1:k_imp) {
#   for(j in 1:k_imp) {
#     result_imp_pos[i,j] <- chisq.test(cat_imp_positive[,i], cat_imp_positive[,j] )$p.value
#   }
# }
# 
# n_imp <- ncol(cat_imp_negative)
# result_imp_neg <- matrix(1, nrow=n_imp, ncol=n_imp)
# rownames(result_imp_neg) <- colnames(result_imp_neg) <- names(cat_imp_negative)
# for(i in 1:n_imp) {
#   for(j in 1:n_imp) {
#     result_imp_neg[i,j] <- chisq.test(cat_imp_negative[,i], cat_imp_negative[,j] )$p.value
#   }
# }
# 
# 
# pvalues_imp_pos = melt(result_imp_pos)
# pvalues_imp_neg = melt(result_imp_neg)
# 
# pvalues_imp_pos$ranges <- cut(pvalues_imp_pos$value, breaks = c(-Inf, 1e-300, 1e-250, 1e-200,
#                                                                 1e-150, 1e-100, 1e-50, 0, .01, .05, .1, Inf),right = FALSE)
# pvalues_imp_neg$ranges <- cut(pvalues_imp_neg$value, breaks = c(-Inf, 1e-300, 1e-250, 1e-200,
#                                                                 1e-150, 1e-100, 1e-50, 0, .01, .05, .1, Inf),right = FALSE)
# 
# p_imp_pos = ggplot(data = pvalues_imp_pos, aes(x=Var1, y=Var2)) + 
#   geom_tile(aes(fill = ranges), colour = "white", alpha = .8) +
#   scale_fill_brewer(palette = "RdPu") + theme_classic() +
#   xlab("") + ylab("")+ ggtitle("Chi-square p-values: Positive Reviews") +
#   guides(fill=guide_legend(title="p-value")) +
#   theme(axis.text.x=element_text(angle=45,hjust=1))
# 
# 
# p_imp_neg = ggplot(data = pvalues_imp_neg, aes(x=Var1, y=Var2, fill=value)) + 
#   geom_tile(aes(fill = ranges), colour = "white", alpha = .8) +
#   scale_fill_brewer(palette = "RdPu") + theme_classic() +
#   xlab("") + ylab("") + ggtitle("Chi-square p-values: Negative Reviews") +
#   guides(fill=guide_legend(title="p-value")) +
#   theme(axis.text.x=element_text(angle=45,hjust=1))


# 
# seat_comfort_NA = airlines %>% group_by(airline, seat_comfort) %>%
#   summarise(n = n()) %>%
#   mutate(percent = n*100/sum(n)) %>%
#   filter(airline != 'Southwest Airlines')
# 
# scNA = ggplot(data = seat_comfort_NA, aes(x = seat_comfort, y = percent)) + 
#   geom_bar(aes(fill = seat_comfort), stat = 'identity') + facet_wrap( ~ airline) +
#   xlab("Seat Comfort Rating") + ylab("Percent of Reviews") + theme_minimal() +
#   ggtitle("Seat Comfort Ratings by Airline") +
#   guides(fill=guide_legend(title="Rating"))
# scNA
# 
# seat_comfort_overall = airlines %>% filter(airline != 'Southwest Airlines') %>%
#   group_by(seat_comfort) %>% summarise(n = n()) %>% 
#   mutate(percent = n*100/sum(n))
# 
# 
# ggplot(data = seat_comfort_overall, aes(x = "", y = percent, fill = seat_comfort)) +
#   geom_bar(width = 1, stat = 'identity') + coord_polar(theta = 'y') +
#   theme_minimal() + guides(fill=guide_legend(title="Seat Comfort Rating")) +
#   ggtitle("Percentages of Seat Comfort Ratings Overall") 
# 
# 


