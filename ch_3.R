library(jsonlite)
library(rjson)


# read in offical Yelp review set (available at https://www.yelp.com/dataset_challenge)
yelp_raw_data <- stream_in(file("yelp_academic_dataset_review.json"),pagesize = 10000)

# take a look at the data
head(yelp_raw_data)
tail(yelp_raw_data)

# take a look at the sructure
str(yelp_raw_data)

# find NA's
sum(is.na(yelp_raw_data))

summary(yelp_raw_data)
