library(idr)
library(ggplot2)

#### Chapeter 1 - spawner-recruits model ####
ggplot(salmon, aes(x = spawners, y = recruits)) + 
        geom_point(color = "darkblue", alpha = 0.6)