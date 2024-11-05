# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
people_suicides <- full_data_raw |>
  filter(area_type == "Council area" &
    indicator == "Deaths from suicide (16+ years)") |>
  mutate(year = "2018-2022") |>
  select(
    ltla24_code = area_code,
    suicides_per_100k = measure,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_suicides, overwrite = TRUE)
