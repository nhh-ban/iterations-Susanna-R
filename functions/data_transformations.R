# This script contains three different functions

library(purrr)
library(tidyverse)
library(dplyr)
library(tibble)
library(anytime)
library(lubridate)

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


to_iso8601 <- function(datetime, offset_days) {
  new_datetime <- datetime + days(offset_days)
  return(paste0(anytime::iso8601(new_datetime), "Z"))
}

# Don't know how to write this function
transform_volumes <- function(gql_metadata_qry) {  
  df <- gql_metadata_qry |>
    pluck("data", "trafficData", "volume", "byHour", "edges") |>
    map_dfr(~as_tibble(.x$node))
  df <- df |>
    mutate(across(c(from, to), as_datetime, origin = "1970-01-01"))
  
  return(df)
}

