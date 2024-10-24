# England's Health Index uses a weighted population average. Available Scottish
# data only has the average mean healthy life expectancy for women.

# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
people_healthy_life_expectancy_women <- full_data_raw |>
  filter(
    area_type == "Council area",
    indicator == "Healthy life expectancy, females"
  ) |>
  mutate(year = "2019-2021") |>
  select(
    ltla24_code = area_code,
    healthy_life_expectancy_female = measure,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_healthy_life_expectancy_women, overwrite = TRUE)
