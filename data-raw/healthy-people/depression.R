# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
people_mental_health_conditions <- full_data_raw |>
  filter(area_type == "Council area" &
    indicator == "Population prescribed drugs for anxiety/depression/psychosis") |>
  mutate(year = 2021) |>
  select(
    ltla24_code = area_code,
    mental_health_conditions_percentage = measure,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_mental_health_conditions, overwrite = TRUE)
