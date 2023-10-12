# This script contains the function transform_metadata_to_df which should 
# complete the transformation of stations_metadata to a data frame

library(purrr)
library(tidyverse)
library(dplyr)
library(tibble)

transform_metadata_to_df <- function(stations_metadata) {
  stations_metadata[[1]] |>
    map(as_tibble) |> 
    list_rbind() |>
    mutate(latestData = map_chr(latestData, 1, .default=NA_character_)) |>
    mutate(latestData = as_datetime(latestData, tz = "Europe/Berlin")) |>
    mutate(latestData = with_tz(latestData, "UTC")) |>
    unnest_wider(location) |>
    unnest_wider(latLon)
}