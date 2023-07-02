# Custom functions for finding-districts process --------------------------

extract_district <- function(result, id) {
  require(rlang)
  require(dplyr)

  df <- result[["results"]]

  df <- df |>
    select(
      jurisdiction = "jurisdiction.name",
      role_title = "current_role.title",
      district = "current_role.district",
      chamber_classification = "current_role.org_classification"
    ) |>
    mutate(name = id, .before = everything())
}
