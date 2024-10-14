# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Get data ----
# Source: https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data
health_survey_raw <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data")

hl_overweight_obesity_adults <- health_survey_raw |>
  filter(`FeatureType` == "Council Area",
         `Sex` == "All",
         `Measurement` == "Percent",
         `DateCode` == "2016-2019",
         `Scottish Health Survey Indicator` == "Overweight: Overweight (including obesity)") |>
  rename(ltla19_code = 1,
         overweight_obesity_percentage = 7,
         year = 4) |>
  select(`ltla19_code`, `overweight_obesity_percentage`, `year`)

# ---- Save output to data/ folder ----
usethis::use_data(hl_overweight_obesity_adults, overwrite = TRUE)

