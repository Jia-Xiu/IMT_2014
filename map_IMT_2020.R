# Map for Inner Mongolia transect (sampling in 2014 summer)
# Author: Xiu Jia
# Date: 2020-04-19

rm(list=ls())

setwd("")

library(ggmap)
library(ggsn) #North Symbols and Scale Bars for Maps Created with 'ggplot2' or 'ggmap'
northSymbols()

df <- read.csv("Sites_lons_lats_MAT_MAP.csv")
df$lon <- df$lons
df$lat <-df$lats
df$Sites <- factor(df$Sites,  levels = c("D", "E", "F", "G", "H", "I", "J", "K"), 
                   labels = c("A", "B", "C", "D", "E", "F", "G", "H"))
str(df)
head(df)

# compute the mean lat and lon
ll_means <- sapply(df[2:3], mean)
ll_means


sq_map <- get_map(location = ll_means,  maptype = "satellite", source = "google", zoom = 6)

(p <- ggmap(sq_map) + 
    geom_point(data = df, aes(x=lons, y=lats, fill = Sites), shape = 21, 
               colour = "yellow", size = 6, alpha = .8) +
    geom_text(data = df, aes(label = paste("  ", as.character(Sites), sep="")), 
              angle = 0, hjust = -.1, color = "yellow", size = 4) +
    scale_fill_brewer(palette="PuBu", direction=-1) +
    scale_x_continuous(limits=c(112, 122.5))+
    scale_y_continuous(limits=c(41, 47))+
    labs(title= "", x = "Longitude", y = "Latitude") +
    theme(legend.position = "none"))


bb <- attr(sq_map, "bb")
(bb2 <- data.frame(long = unlist(bb[c(2, 4)]), lat = unlist(bb[c(1,3)])))

(p2 <- p + scalebar(x.min = 109, x.max = 122.5, y.min = 38,  y.max = 48, # or bb2
                    dist = 50, dist_unit = "km", 
                    height=0.015,
                    st.bottom = FALSE, st.color = "white", st.size=3,
                    transform = TRUE, model = "WGS84",
                    anchor = c(x = 114, y = 46 )))

ggsave("map_imt.jpg", width = 12, height = 9, units = "cm", p2, device = "jpeg", scale = 1.5, dpi = 600)
  

