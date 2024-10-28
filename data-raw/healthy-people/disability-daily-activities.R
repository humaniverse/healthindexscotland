# ---- Load packages ----
library(tidyverse)
library(rio)
library(demographr)

# ---- Get data ----
# Disability data
# Source: https://statistics.ukdataservice.ac.uk/dataset/scotland-s-census-2022-uv303a-long-term-health-problem-or-disability-by-sex-by-age-20-groups/resource/5ccf8e62-96d1-4b13-8871-39082b0c5f49
disability_raw <- import("https://s3-eu-west-1.amazonaws.com/statistics.digitalresources.jisc.ac.uk/dkan/files/2022/NRS/UV303a/census_2022_UV303a_Disability_by_sex_by_age_20_Local_authority_CA2019.csv")

# LTLA code and name lookup
ltla_lookup <- population22_ltla19_scotland |>
  select(
    ltla19_name,
    ltla19_code
  )

# ---- Clean data ----
people_disability <- disability_raw |>
  filter(
    Sex == "All people",
    Disability %in% c(
      "All people", "Day-to-day activities limited a lot",
      "Day-to-day activities limited a little"
    ),
    Age %in% c(
      "16 to 17", "18 to 19", "20 to 24", "25 to 29",
      "30 to 34", "35 to 39", "40 to 44", "45 to 49", "50 to 54",
      "55 to 59", "60 to 64"
    )
  ) |>
  group_by(`Council Area 2019`, Disability) |>
  summarise(total_count = sum(Count, na.rm = TRUE), .groups = "drop") |>
  pivot_wider(names_from = Disability, values_from = total_count) |>
  mutate(
    total_disability = `Day-to-day activities limited a little` +
      `Day-to-day activities limited a lot`,
    disability_activities_limited_percentage = (total_disability / `All people`) * 100
  ) |>
  left_join(ltla_lookup, by = c("Council Area 2019" = "ltla19_name")) |>
  select(
    ltla24_code = ltla19_code,
    disability_activities_limited_percentage
  ) |>
  mutate(year = 2022)

# ---- Save output to data/ folder ----
usethis::use_data(people_disability, overwrite = TRUE)
