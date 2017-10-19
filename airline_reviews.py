from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv

# Windows users need to specify the path to chrome driver you just downloaded.
# You need to unzip the zipfile first and move the .exe file to any folder you want.
# driver = webdriver.Chrome(r'path\to\where\you\download\the\chromedriver.exe')
driver = webdriver.Chrome()

driver.get("http://www.airlinequality.com/review-pages/a-z-airline-reviews/")
#driver.get("http://www.airlinequality.com/airline-reviews/adria-airways/")

csv_file = open('airline_reviews.csv', 'w')
writer = csv.writer(csv_file)
writer.writerow(['overall', 'author', 'author_country', 'review_date', 'customer_review', 'table'])
# Page index used to keep track of where we are.
index = 1
while True:
	time.sleep(2)
	try:
		print("Scraping Page number " + str(index))
		index = index + 1
		
		#Find all the pages:
		airline_pages = driver.find_elements_by_xpath('//div[@class = "tabs-content"]//a')
		print(airline_pages)
		break
		for page in airline_pages:
			#Find all the reviews:
			reviews = driver.find_elements_by_xpath('//article[@itemprop = "review"]')
			for review in reviews:
				# Initialize an empty dictionary for each review
				review_dict = {}
				overall = review.find_element_by_xpath('.//span[@itemprop = "ratingValue"]').text
				author = review.find_element_by_xpath('.//h3[@class = "text_sub_header userStatusWrapper"]//span[@itemprop = "name"]').text
				author_country = review.find_element_by_xpath('.//h3[@class = "text_sub_header userStatusWrapper"]').text
				review_date = review.find_element_by_xpath('.//time[@itemprop = "datePublished"]').text	
				customer_review = review.find_element_by_xpath('.//div[@itemprop = "reviewBody"]').text
				table = review.find_element_by_xpath('.//table[@class = "review-ratings"]//descendant-or-self::*').text
				#print(review_date)
				#print("="*40)

				review_dict['overall'] = overall
				review_dict['author'] = author
				review_dict['author_country'] = author_country
				review_dict['review_date'] = review_date
				review_dict['customer_review'] = customer_review
				review_dict['table'] = table
				writer.writerow(review_dict.values())

			#Locate the next button on the page.
			button = driver.find_elements_by_xpath('//article[@class = "comp comp_reviews-pagination querylist-pagination position-"]//a')[0]
			button.click()
	except Exception as e:
		print(e)
		csv_file.close()
		driver.close()
		break
		
#Alaska Airlines, Allegiant Air, American Airlines, Delta Air Lines, Frontier Airlines, Hawaiian Airlines, 
#JetBlue Airways, Southwest Airlines, Spirit Airlines, Sun Country Airlines, United Airlines, Virgin America