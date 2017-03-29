library(idr)
library(ggplot2)

#### Chapeter 1 - spawner-recruits model ####

salmon_model <- lm(recruits ~ spawners, data = salmon)
summary(salmon_model)

salmon_model$coefficients

# linear model
# recruits = 1.44 * spawners + 436.08


ggplot(salmon, aes(x = spawners, y = recruits)) + 
        geom_point(color = "darkblue", alpha = 0.6)