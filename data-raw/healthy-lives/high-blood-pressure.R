# ---- Load packages ----
library(httr)
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/sg-scottish-health-survey/

# Interactively generate the full Scottish Health Survey data by:
# 1. Navigating the source (above)
# 2. Scroll down to 'Rank data'
# 3. Click 'Download'

# The URL can only be accessed by saving the data.
# The full Scottish Health Survey data is saved in data-raw/health-lives/data/ as it is used in other indicators.

# ---- Download and read URL as temp file ----
# GET(
#   "https://scotland.shinyapps.io/sg-scottish-health-survey/_w_914eca26/session/f49d60757ad33e1a648a7a07c5e51208/download/download_rank_csv?w=914eca26",
#   write_disk("data-raw/healthy-lives/data/scot_health_survey_data.csv", overwrite = TRUE)
# )

full_data_raw <- read_csv("data-raw/healthy-lives/data/scot_health_survey_data.csv")

# ---- Clean data ----
lives_high_blood_pressure <- full_data_raw |>
  filter(
    FeatureType == "Council Area",
    DateCode == "2018-2022",
    `Scottish Health Survey Indicator` ==
      "Doctor-diagnosed high blood pressure (excluding pregnant): Yes",
    Measurement == "Percent",
    Sex == "All"
  ) |>
  select(
    ltla24_code = FeatureCode,
    high_blood_pressure_percentage = Value,
    year = DateCode
  )

# ---- Save output to data/ folder ----
usethis::use_data(lives_high_blood_pressure, overwrite = TRUE)
