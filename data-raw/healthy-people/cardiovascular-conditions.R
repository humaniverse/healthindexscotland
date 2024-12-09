# ---- Load packages ----
library(tidyverse)
library(rio)
library(geographr)
library(demographr)

# ---- Get data ----
# Population
population_2022 <- population22_ltla19_scotland |>
  filter(sex == "Persons") |>
  select(
    ltla19_name,
    ltla19_code,
    population_2022 = all_ages
  )

# Cardiovascular Conditions
# Source: https://www.opendata.nhs.scot/dataset/scottish-heart-disease-statistics/resource/5379a655-d677-46cf-814d-bc0574ac59e4
cardiovascular_conditions_raw <- import("https://www.opendata.nhs.scot/dataset/0e17f3fc-9429-48aa-b1ba-2b7e55688253/resource/5379a655-d677-46cf-814d-bc0574ac59e4/download/hd_activitybyca.csv")

# ---- Clean data ----
cardiovascular_conditions <- cardiovascular_conditions_raw |>
  filter(`FinancialYear` == "2022/23",
         `AgeGroup` == "All",
         `AdmissionType` == "All",
         `Sex` == "All") |>
  rename(ltla24_code = 2,
         discharge_number = 11) |>
  group_by(ltla24_code) |>
  summarise(
    cardiovascular_discharge_number = sum(discharge_number, na.rm = TRUE)
  ) |>
  mutate(year = "2022/23") |>
  select(`ltla24_code`, `cardiovascular_discharge_number`, `year`) |>
  slice(-33)

# ---- Join datasets ---
people_cardiovascular_conditions <- cardiovascular_conditions |>
  left_join(population_2022, by = c("ltla24_code" = "ltla19_code")) |>
  mutate(
    cardiovascular_discharge_number = as.numeric(cardiovascular_discharge_number),
    population_2022 = as.numeric(population_2022),
    av_percentage_discharged = ((cardiovascular_discharge_number / population_2022)) * 1000) |>
  rename(cardiovascular_discharges_per_1k = 6) |>
  select(`ltla24_code`, `cardiovascular_discharges_per_1k`, `year`)

# ---- Save output to data/ folder ----
usethis::use_data(people_cardiovascular_conditions, overwrite = TRUE)
