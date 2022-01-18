# Load libraries ----------------------------------------------------------
library(tidyverse)
library(tidygeocoder)

# Define openstate API URL components --------------------------------------

api_root <- "https://v3.openstates.org"

method <- "/people.geo"

api_key <- "ENTER_KEY"

# Define tibble of test addresses -----------------------------------------
address_tbl <- tribble(~name, ~address,
                "test1", "test_1_address",
                "test2", "test_2_address",
                "test3", "test_3_address")


# Geocode addresses -------------------------------------------------------
coords <- geocode(address_tbl, address, method = "census")


# API call ----------------------------------------------------------------
# Create vector of API URLs ====
# Using the already defined URL components and the latitudes and longitudes in
# coords
req_url <- paste0(api_root, method,
                  "?lat=", coords$lat,
                  "&lng=", coords$long, "&apikey=",
                  api_key)

# Loop through vector of URLs ====
result <- lapply(req_url, function(x) content(GET(x)))

# Format results ----------------------------------------------------------
# TODO

