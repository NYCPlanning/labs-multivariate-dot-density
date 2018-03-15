library('tidyverse')
library('sf')
library('lwgeom')

per_dot <- 100

# read in the data, select only what's needed, and divide variables
# by the per_dot factor. Include a total of the new per_dot.
tracts <- st_read("data/tracts/RegionalLabs_CensusTracts_withData.shp") %>%
  select(c(geometry, EmOff15, EmIns15, EmInd15, EmSer15, EmOth15)) %>%
  mutate(
    EmOff15 = EmOff15 / per_dot,
    EmIns15 = EmIns15 / per_dot,
    EmInd15 = EmInd15 / per_dot,
    EmSer15 = EmSer15 / per_dot,
    EmOth15 = EmOth15 / per_dot,
    total = EmOff15 + EmIns15 + EmInd15 + EmSer15 + EmOth15
  )

# randomly distribute dots from the tracts and join back in
dots <- st_sample(tracts, tracts$total) %>% 
  st_sf %>% 
  st_join(tracts)
