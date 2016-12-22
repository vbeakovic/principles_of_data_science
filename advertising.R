library(ggplot2)
library(reshape2)
advertising <- read.csv("./data/Advertising.csv")
advertising_long <- melt(data = advertising[,2:5], id.vars = "Sales", 
                         measure.vars = c("TV", "Radio", "Newspaper"), 
                         variable.name = "ad_category",
                         value.name = "ad_qty")



gg <- ggplot(data = advertising_long, aes(x = ad_qty, y = Sales, group=ad_category)) + 
        geom_point() + 
        geom_smooth(method = "lm") + 
        facet_wrap(facets = "ad_category", scales = "free")
gg
