# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
lives_infant_mortality <- full_data_raw |>
  filter(area_type == "Council area" &
           indicator == "Infant deaths, aged 0-1 years") |>
  mutate(year = "2017-2021") |>
  select(ltla24_code = area_code,
         infant_mortality_rate_per_1k = measure,
         year)

# ---- Save output to data/ folder ----
usethis::use_data(lives_infant_mortality, overwrite = TRUE)

