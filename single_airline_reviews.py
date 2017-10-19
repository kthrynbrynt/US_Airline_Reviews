from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv
from math import ceil

driver = webdriver.Chrome()

#driver.get("http://www.airlinequality.com/review-pages/a-z-airline-reviews/")
driver.get("http://www.airlinequality.com/airline-reviews/adria-airways/")



csv_file = open('single_airline_reviews.csv', 'w')
writer = csv.writer(csv_file)
writer.writerow(['overall', 'author', 'author_country', 'review_date', 'customer_review', 'table'])
# Page index used to keep track of where we are.
review_count = driver.find_element_by_xpath('//div[@class = "rating-totals"]//span[@itemprop = "reviewCount"]').text
review_count = float(review_count)
n = int(ceil(review_count/10))

index = 1
while index <= n:
	driver.get("http://www.airlinequality.com/airline-reviews/adria-airways/page/" + str(index) +'/')
	time.sleep(2)
	try:
		print("Scraping Page number " + str(index))
		index = index + 1
		
		
		#Find all the reviews:
		reviews = driver.find_elements_by_xpath('//article[@itemprop = "review"]')
# 		print(reviews)
		for review in reviews:
			# Initialize an empty dictionary for each review
			review_dict = {}
			try:
				overall = review.find_element_by_xpath('.//span[@itemprop = "ratingValue"]').text
			except: 
				overall = ""
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

# 			Locate the next button on the page.
# 		button = driver.find_elements_by_xpath('//article[@class = "comp comp_reviews-pagination querylist-pagination position-"]//a')[0]
# 		print(button)
# 		driver.execute_script("arguments[0].click();", button)
# 		button.send_keys('\n')

csv_file.close()
driver.close()
