# Load libraries ----------------------------------------------------------
library(tidyverse)
library(httr)
library(tidygeocoder)

# > Source function from R script

source("code/00_functions.R")

# Define openstates API URL components -------------------------------------

api_root <- "https://v3.openstates.org"

method <- "/people.geo"

# NOTE: API key is set in .Renviron and obtained from
# https://open.pluralpolicy.com/
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
result <- req_url |>
  map(\(x) jsonlite::fromJSON(x, flatten = TRUE))

# Format results ----------------------------------------------------------

# Extract district related variables from results
results_extract <- result |>
  imap(extract_district)

# Create final dataframe containing all queried data
df <- results_extract |>
  bind_rows()
