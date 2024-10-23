# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
lives_low_birth_weight <- full_data_raw |>
  filter(area_type == "Council area" &
    indicator == "Healthy birth weight") |>
  mutate(
    not_healthy_birth_rate_percentage = 100 - measure,
    year = "2020-2022"
  ) |>
  select(
    ltla24_code = area_code,
    not_healthy_birth_rate_percentage,
    year
  )

ltla24_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

lives_low_birth_weight$ltla24_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(lives_low_birth_weight, overwrite = TRUE)
