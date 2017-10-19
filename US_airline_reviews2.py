from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv
from math import ceil


csv_file = open('US_airline_reviews2.csv', 'w')
writer = csv.writer(csv_file)
writer.writerow(['airline', 'overall', 'author', 'review_date', 'customer_review', 'aircraft', 'traveller_type', 'cabin', 'route', 'date_flown', 'seat_comfort', 'cabin_service', 'food_bev', 'entertainment', 'ground_service', 'value_for_money', 'recommended'])
#writer.writerow(['overall', 'author', 'author_country', 'review_date', 'customer_review', 'table'])

driver = webdriver.Chrome()

US_airlines = ["alaska-airlines/", "allegiant-air/", "american-airlines/", "delta-air-lines/", "frontier-airlines/", "hawaiian-airlines/", "jetblue-airways/", "southwest-airlines", "spirit-airlines/", "united-airlines/", "virgin-america/"]
US_airline_pages = ["http://www.airlinequality.com/airline-reviews/" + airline for airline in US_airlines]
#driver.get("http://www.airlinequality.com/review-pages/a-z-airline-reviews/")

for page in US_airline_pages:
	driver.get(page)
	time.sleep(10)		
	try:
		print("="*40)
		print("Scraping " + page)
			
		# Find total number of reviews for the airline
		# Turn value into a float
		# Each page defaults to showing 10 reviews, so take the ceiling of the total number of reviews divided by 10 
		# to get the number of pages of reviews for the airline
		review_count = driver.find_element_by_xpath('//div[@class = "rating-totals"]//span[@itemprop = "reviewCount"]').text
		review_count = float(review_count)
		n = int(ceil(review_count/10))
	
		# Page index used to keep track of the pages we've reviewed
		index = 1
		while index <= n:
			driver.get(page + "page/" + str(index) +'/')
			time.sleep(5)
			
			try:
				print("Scraping Page number " + str(index))
				index = index + 1
		
				#Find all the reviews:
				reviews = driver.find_elements_by_xpath('//article[@itemprop = "review"]')
				for review in reviews:
					# Initialize an empty dictionary for each review
					review_dict = {}
					try:
						airline = review.find_element_by_xpath('//div[@class = "review-heading"]//h1[@itemprop = "name"]').text
					except:
						airline = page
					try:
						overall = review.find_element_by_xpath('.//span[@itemprop = "ratingValue"]').text
					except: 
						overall = ""
					try:
						author = review.find_element_by_xpath('.//h3[@class = "text_sub_header userStatusWrapper"]//span[@itemprop = "name"]').text
					except:
						author = ""
					try:
						review_date = review.find_element_by_xpath('.//time[@itemprop = "datePublished"]').text
					except:
						review_date = ""
					try:	
						customer_review = review.find_element_by_xpath('.//div[@itemprop = "reviewBody"]').text
					except: 
						customer_review = ""
					try:
						aircraft_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header aircraft "]')
						aircraft = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header aircraft "]/following-sibling::td').text
					except:
						aircraft = ""
					try:
						traveller_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header type_of_traveller "]')
						traveller_type = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header type_of_traveller "]/following-sibling::td').text
					except:
						traveller_type = ""
					try:
						cabin_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header cabin_flown "]')
						cabin = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header cabin_flown "]/following-sibling::td').text
					except:
						cabin = ""
					try:
						route_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header route "]')
						route = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header route "]/following-sibling::td').text
					except:
						route = ""
					try:
						date_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header date_flown "]')
						date_flown = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header date_flown "]/following-sibling::td').text
					except:
						date_flown = ""
					try:
						seat_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header seat_comfort"]')
						seat_comfort = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header seat_comfort"]/following-sibling::td/span[@class = "star fill"][last()]').text
					except:
						seat_comfort = ""
					try:
						cabin_service_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header cabin_staff_service"]')
						cabin_service = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header cabin_staff_service"]/following-sibling::td//span[@class = "star fill"][last()]').text
					except:
						cabin_service = ""
					try:
						food_bev_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header food_and_beverages"]')
						food_bev = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header food_and_beverages"]/following-sibling::td//span[@class = "star fill"][last()]').text
					except:
						food_bev = ""
					try:
						entertainment_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header inflight_entertainment"]')
						entertainment = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header inflight_entertainment"]/following-sibling::td//span[@class = "star fill"][last()]').text
					except:
						entertainment = ""
					try:
						ground_service_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header ground_service"]')
						ground_service = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header ground_service"]/following-sibling::td//span[@class = "star fill"][last()]').text
					except:
						ground_service = ""
					try:
						wifi_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header wifi_and_connectivity"]')
						wifi = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header wifi_and_connectivity"]/following-sibling::td//span[@class = "star fill"][last()]').text
					except:
						wifi = ""
					try:
						value_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header value_for_money"]')
						value_for_money = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header value_for_money"]/following-sibling::td//span[@class = "star fill"][last()]').text
					except:
						value_for_money = ""
					try:
						recommended_label = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header recommended"]')
						recommended = review.find_element_by_xpath('.//table[@class = "review-ratings"]//td[@class = "review-rating-header recommended"]/following-sibling::td').text
					except:
						recommended = ""


					review_dict['airline'] = airline
					review_dict['overall'] = overall
					review_dict['author'] = author
					review_dict['review_date'] = review_date
					review_dict['customer_review'] = customer_review
					review_dict['aircraft'] = aircraft
					review_dict['traveller_type'] = traveller_type
					review_dict['cabin'] = cabin
					review_dict['route'] = route
					review_dict['date_flown'] = date_flown
					review_dict['seat_comfort'] = seat_comfort
					review_dict['cabin_service'] = cabin_service
					review_dict['food_bev'] = food_bev
					review_dict['entertainment'] = entertainment
					review_dict['ground_service'] = ground_service
					review_dict['value_for_money'] = value_for_money
					review_dict['recommended'] = recommended
					writer.writerow(review_dict.values())
			
			except Exception as e:
				print(e)
				csv_file.close()
				#driver.close()
				break
				
				
	except Exception as e:
				print(e)
				csv_file.close()
				#driver.close()
				break
		
csv_file.close()
#driver.close()
		
#Alaska Airlines, Allegiant Air, American Airlines, Delta Air Lines, Frontier Airlines, Hawaiian Airlines, 
#JetBlue Airways, Southwest Airlines, Spirit Airlines, Sun Country Airlines, United Airlines, Virgin America