library('tidyverse')
library('sf')
library('lwgeom')

generate_dots <- function(file_path, per_dot = 100) {
  # read in the data, select only what's needed, and divide variables
  # by the per_dot factor. Include a total of the new per_dot.
  tracts <- st_read(file_path) %>%
    select(c(geometry, GEOID, EmOff15, EmIns15, EmInd15, EmSer15, EmOth15)) %>%
    mutate(
      total = as.integer((EmOff15 + EmIns15 + EmInd15 + EmSer15 + EmOth15) / per_dot)
    )
  
  # randomly distribute dots from the tracts and join back in
  # Notice:
  # When sampling polygons, the returned sampling size may differ from the requested size, 
  # as the bounding box is sampled, and sampled points intersecting the polygon are returned.
  dots <- tracts %>% 
    st_sample(tracts$total) %>% 
    st_sf %>% 
    st_join(tracts)
  
  # create a new column called category and generate a list of elements
  # for each variable. Then, randomly sample from that list. 
  # Distribution or weighting is reflected in the number of elements
  dots <- dots %>%
    rowwise %>%
    mutate(
      category = list(
        c(
          rep('EmOff15', EmOff15), 
          rep('EmIns15', EmIns15),
          rep('EmInd15', EmInd15),
          rep('EmSer15', EmSer15),
          rep('EmOth15', EmOth15)
        )
      )
    ) %>%
    mutate(
      category = sample(category, 1)
    ) %>%
    ungroup
  
  # set as factor for checking grouping stats
  dots <- dots %>%
    mutate(
      category = factor(category)
    ) %>%
    arrange(GEOID, category)
  
  return(dots)
}

generate_dots("data/tracts/region_censustract_v0/region_censustract_v0.shp", 100)
