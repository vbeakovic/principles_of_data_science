library(ggplot2)
library(reshape2)
library(dplyr)
library(gridExtra)
library(ggthemes)
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
