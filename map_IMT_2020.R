# Map for Inner Mongolia transect (sampling in 2014 summer)
# Author: Xiu Jia
# Date: 2020-04-19

rm(list=ls())

setwd("/Users/jiaxiu/Dropbox/IMT_8")
#setwd("C:/Users/P278113/Dropbox/IMT_8")

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

# register_google(key = "AI", write = TRUE)
# Creating file /Users/jiaxiu/.Renviron
# Adding key to /Users/jiaxiu/.Renviron
sq_map <- get_map(location = ll_means,  maptype = "satellite", source = "google", zoom = 6)
# In ggmap, downloading a map as an image and formatting the image for plotting is done with the get_map function.
#> Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=44.061962,116.253856&zoom=6&size=640x640&scale=2&maptype=satellite&language=en-EN&sensor=false
# zoom argument (3-20): 3 continental level; 10 city scale; 20 single building level
# geocode(): determine the appropriate longitude/latitude
# In lieu of a center/zoom specification, some users find a bounding box specification more convenient.
# To accommodate this form of specification, location also accepts numeric vectors of length four,
# following the left/bottom/right/top convention. This option is not currently available for Google Maps

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
  

