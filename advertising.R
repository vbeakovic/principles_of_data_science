#### Libraries ####
library(stringr)
library(slam)
library(ggplot2)
library(reshape2)
library(dplyr)
library(gridExtra)
library(ggthemes)
library(RCurl)
library(XML)
library(tm)
library(RWeka)
library(parallel)
library(tidytext)
library(purrr)

#### Data ####
data("stop_words")

options(mc.cores = 2)
#### Data types ####
# Integer
a <- c(3L, 6L, 99L, -34L, 34L, 11111111L)
class(a)

# Numeric
b <- c(3.14159, 2.71, -0.34567)
class(b)

# Logical
c <- c(TRUE, FALSE)
class(c)

# Character
d <- c(
        "I love hamburgers",
        "Matt is awesome",
        "A Tweet is a string"
)
class(d)

#### List ####
al <- list(1L, 5.4, TRUE, "apple")
class(al)


#### Basic logical operators ####
3 + 4 == 7 # TRUE
3 - 2 == 7 # FALSE
3 < 5 # TRUE
5 < 3 # FALSE
3 <= 3 # TRUE
5 <= 3 # FALSE
3 > 5 # FALSE
5 > 3 # FALSE
3 >= 3 # TRUE
5 >= 7 # FALSE

#### Example of basic R ####
X <- 5.8
Y <- 9.5

X + Y == 15.3 # TRUE
X - Y == 15.3 # FALSE
if (X + Y == 15.3) {
        print("True!")
}

my_list <- list(1L, 5.7, TRUE, "apples")
length(my_list) # four objects in the list
my_list[[1]] == 1
my_list[[2]] == 5.7

#### Parsing a tweet ####
tweet <- "RT @j_o_n_dnger: $TWTR now top holding for 
             Andor, unseating $AAPL"
words_in_tweet <- strsplit(tweet, split = " ", fixed = TRUE)[[1]]

walk(words_in_tweet, function(x) {
        if (grepl("$", x, fixed = TRUE) == TRUE) {
                print(paste("THIS TWEET IS ABOUT ", x))  # alert the user
        }     
})

#### Marketing Dollars ####
advertising <- read.csv("./data/Advertising.csv")
advertising_long <- melt(data = advertising[,2:5], id.vars = "Sales", 
                         measure.vars = c("TV", "Radio", "Newspaper"), 
                         variable.name = "ad_category",
                         value.name = "ad_qty")
advertising_long_newspaper <- filter(advertising_long, ad_category == "Newspaper")
advertising_long_tv <- filter(advertising_long, ad_category == "TV")
advertising_long_radio <- filter(advertising_long, ad_category == "Radio")

gg_newspaper <- ggplot(data = advertising_long_newspaper, aes(x = ad_qty, y = Sales, group=ad_category)) + 
        geom_point(color="steelblue") + 
        geom_smooth(method = "lm", colour="steelblue", fill = "steelblue") + 
        theme_pander() +
        theme(
                axis.title.y=element_blank(),
                axis.text.y=element_blank(),
                axis.ticks.y=element_blank()
        ) +
        scale_x_continuous(breaks = seq(0,120,by = 20), limits = c(0, 120)) + 
        scale_y_continuous(breaks = seq(0, 30, by = 5), limits = c(0, 30)) + 
        xlab("Newspaper") + 
        ylab("")
gg_newspaper
gg_radio <- ggplot(data = advertising_long_radio, aes(x = ad_qty, y = Sales, group=ad_category)) + 
        geom_point(color="steelblue") + 
        geom_smooth(method = "lm", colour="steelblue", fill = "steelblue") + 
        theme_pander() + 
        theme(
                axis.title.y=element_blank(),
                axis.text.y=element_blank(),
                axis.ticks.y=element_blank()
        ) +
        scale_x_continuous(breaks = seq(0,50,by = 10), limits = c(0, 50)) + 
        scale_y_continuous(breaks = seq(0, 30, by = 5), limits = c(0, 30)) + 
        xlab("Radio") + 
        ylab("")
gg_radio

gg_tv <- ggplot(data = advertising_long_tv, aes(x = ad_qty, y = Sales)) + 
        geom_point(color="steelblue") + 
        geom_smooth(method = "lm", colour="steelblue", fill = "steelblue") + 
        theme_pander() + 
        scale_x_continuous(breaks = seq(0, 300,by = 50), limits = c(0, 300)) + 
        scale_y_continuous(breaks = seq(0, 30, by = 5), limits = c(0, 30)) + 
        xlab("TV") + 
        ylab(NULL)
gg_tv
grid.arrange(gg_tv, gg_radio, gg_newspaper, ncol = 3, left = "Sales")

#### What's in a job description ####

texts <- character()

pathPaging <- "//span[@class='summary']"

for(i in seq(0,1000, by = 10)) {
        pageUrl = paste0("https://www.indeed.com/jobs?q=data+scientist&start=", as.character(i))
        page = getURL(pageUrl)
        page_parsed <- htmlParse(page)
        #texts[[i/10+1]] <- xpathSApply(doc = page_parsed, path = pathPaging, fun = xmlValue)
        texts <- c(texts, xpathSApply(doc = page_parsed, path = pathPaging, fun = xmlValue))
}
texts <- gsub("\n", "", texts, fixed = TRUE)
save(texts, file = "./data/texts2.Rdata")
# Analysis
load(file = "./data/texts2.Rdata")

# data frame with texts
texts_df <- data_frame(
        ad = 1:length(texts),
        text = texts
)

texts_df_uni <- texts_df %>% 
        unnest_tokens(tokens, text) %>% 
        group_by(tokens) %>% 
        summarise(freq = n()) %>% 
        arrange(desc(freq))

texts_df_bi <- texts_df %>% 
        unnest_tokens(tokens, text, token = "ngrams", n = 2) %>% 
        group_by(tokens) %>% 
        summarise(freq = n()) %>% 
        arrange(desc(freq))


# join unigrams & bigrams
frequent_phrases <- rbind(texts_df_uni, texts_df_bi) %>% 
        anti_join(stop_words, by = c("tokens" = "word")) %>% 
        arrange(desc(freq))

