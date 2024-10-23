# ---- Load packages ----
library(tidyverse)
library(rio)
library(geographr)
library(demographr)

# ---- Get data ----
# Disability data
# Source: https://statistics.ukdataservice.ac.uk/dataset/scotland-s-census-2022-uv303a-long-term-health-problem-or-disability-by-sex-by-age-20-groups/resource/5ccf8e62-96d1-4b13-8871-39082b0c5f49
disability_raw <- import("https://s3-eu-west-1.amazonaws.com/statistics.digitalresources.jisc.ac.uk/dkan/files/2022/NRS/UV303a/census_2022_UV303a_Disability_by_sex_by_age_20_Local_authority_CA2019.csv")

# Population and code data
population_2022 <- population22_ltla19_scotland |>
  filter(sex == "Persons") |>
  select(
    ltla19_name,
    ltla19_code,
    population_2022 = all_ages
  )

# ---- Clean data ----
disability_daily_activities <- disability_raw |>
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
  group_by(`Council Area 2019`, `Disability`) |>
  mutate(total_count = sum(Count, na.rm = TRUE)) |>
  ungroup() |>
  distinct(`Council Area 2019`, `Disability`, `total_count`) |>
  mutate(
    total_disability_daily_activity =
      sum(
        total_count[Disability %in% c(
          "Day-to-day activities limited a lot",
          "Day-to-day activities limited a little"
        )],
        na.rm = TRUE
      ), .by = `Council Area 2019`
  ) |>
  filter(Disability == "All people") |>
  mutate(
    disability_daily_activities_percentage = (total_disability_daily_activity /
      total_count) * 100,
    year = "2022"
  ) |>
  select(
    ltla19_name = `Council Area 2019`,
    disability_daily_activities_percentage,
    year
  )

# Combine LA ID data
people_disability_daily_activities <- disability_daily_activities |>
  left_join(population_2022, by = c("ltla19_name" = "ltla19_name")) |>
  select(
    ltla24_code = ltla19_code,
    disability_daily_activities_percentage,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_disability_daily_activities, overwrite = TRUE)
