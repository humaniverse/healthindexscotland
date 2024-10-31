# ---- Load packages ----
library(httr)
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/sg-scottish-health-survey/

# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See high-blood-pressure.R to download the full dataset


full_data_raw <- read_csv("data-raw/healthy-lives/data/scot_health_survey_data.csv")

# ---- Clean data ----
lives_sedentary_behaviour <- full_data_raw |>
  filter(
    FeatureType == "Council Area",
    DateCode == "2018-2022",
    `Scottish Health Survey Indicator` ==
      "Summary activity levels: Very low activity",
    Sex == "All",
    Measurement == "Percent"
  ) |>
  select(
    ltla24_code = FeatureCode,
    sedentary_behaviour_percentage = Value,
    year = DateCode
  )

# ---- Save output to data/ folder ----
usethis::use_data(lives_sedentary_behaviour, overwrite = TRUE)
