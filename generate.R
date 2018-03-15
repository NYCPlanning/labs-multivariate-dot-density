library('tidyverse')
library('sf')
library('lwgeom')

tracts <- st_read("data/tracts/RegionalLabs_CensusTracts_withData.shp")
dots <- st_sample(tracts, tracts$EmPr15 / 100) %>% 
  st_sf %>% 
  st_join(tracts)
