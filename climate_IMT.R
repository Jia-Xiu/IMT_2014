# extract mean annual temperature and mean anual precipitation from worldclim
# Author: Jia Xiu
# Date: 2020-04-20

rm(list=ls())

setwd("/Users/jiaxiu/Dropbox/IMT_8")
#setwd("C:/Users/P278113/Dropbox/IMT_8")

#library(dismo)
library(raster)
library(sp)

# dowload https://www.worldclim.org/data/worldclim21.html#
# Below you can download the standard (19) WorldClim Bioclimatic variables for WorldClim version 2. 
# They are the average for the years 1970-2000. 
# Each download is a "zip" file containing 19 GeoTiff (.tif) files, one for each month of the variables.
# Citation: Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.

cat("see which resolution you need?")
res <- as.numeric(readline("which resolution? 30s - (0.5); 2.5 m - (2.5); 5 m - (5); 10 m - (10)?"))
edge.length <- 6378*2*pi*1000/(360*60*60)*res*60
cat("min length between sites", edge.length *1.414/1000, "km")
cat("2.5 m works well")


# BIO1 = Annual Mean Temperature
# BIO12 = Annual Precipitation
r <- getData('worldclim', var='bio', res=2.5)
r <- r[[c(1,12)]]
names(r) <- c("MAT","MAP")

coords <- read.csv("Sites.csv", header = 1, row.names = 1)
coords <- coords[, c(1:2)]

points <- SpatialPoints(coords, proj4string = r@crs)

values <- extract(r, points)

df <- cbind.data.frame(coordinates(points), values)

df$MAT <- df$MAT/10
df

