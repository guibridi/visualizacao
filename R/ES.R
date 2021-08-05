state <- geobr::read_state("ES")
state[, 1] |>
  rmapshaper::ms_filter_islands(min_area = 1e8) |>
  mapview::mapview()

library(tidyverse)

state[, 1] %>%
  rmapshaper::ms_filter_islands(min_area = 1e8) %>%
  mapview::mapview()


es <- read_state("ES")

ggplot(data = es) +
  geom_sf() +
  coord_sf(xlim = c(-42,-39.7))
