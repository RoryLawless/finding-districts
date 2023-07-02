# Load libraries ----------------------------------------------------------
library(tidyverse)
library(httr)
library(tidygeocoder)

# Define openstates API URL components -------------------------------------

api_root <- "https://v3.openstates.org"

method <- "/people.geo"

api_key <- Sys.getenv("OPEN_STATES_API")

# Load test addresses -----------------------------------------------------
# data.frame should contain the columns name and address
address_tbl <- read_csv("data/addresses.csv")

# Geocode addresses -------------------------------------------------------
coords <- geocode(address_tbl, address, method = "census")

# API call ----------------------------------------------------------------
# Create vector of API URLs ====
# Using the already defined URL components and the latitudes and longitudes in
# coords
req_url <- paste0(
  api_root, method,
  "?lat=", coords$lat,
  "&lng=", coords$long, "&apikey=",
  api_key
) |> set_names(address_tbl$name)

# Loop through vector of URLs ====
result2 <- map(req_url, jsonlite::fromJSON, flatten = TRUE)

# Format results ----------------------------------------------------------

extract_district <- function(x) {
  df <- x[["results"]]

  df <- df |>
    select(
      jurisdiction.name, current_role.title,
      current_role.district, current_role.org_classification
    ) |>
    set_names(nm = c(
      "name", "jurisdiction",
      "role_title", "district",
      "chamber_classification"
    ))
}


test <- result2 |> map(extract_district)

result <- result2 |> map_depth(1, ~ keep(., is.data.frame))

result <- unlist(result, recursive = FALSE, use.names = TRUE)

result <- result |> map(~ select(
  ., `jurisdiction.name`,
  `current_role.title`, `current_role.district`,
  `current_role.org_classification`
))


df <- result |>
  bind_rows(.id = "name") |>
  set_names(nm = c(
    "name", "jurisdiction",
    "role_title", "district",
    "chamber_classification"
  ))
