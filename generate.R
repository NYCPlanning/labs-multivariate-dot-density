library(multivariateDotDensity)

final <- generate_dots(
  "data/tracts/region_censustract_v0/region_censustract_v0.shp",
  c('EmOff15', 'EmIns15', 'EmInd15', 'EmSer15', 'EmOth15'),
  100
)
