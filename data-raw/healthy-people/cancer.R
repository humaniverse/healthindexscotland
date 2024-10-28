# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Get data ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
people_cancer <- full_data_raw |>
  filter(
    area_type == "Council area",
    indicator == "Cancer registrations"
  ) |>
  mutate(year = "2019-2021") |>
  select(
    ltla24_code = area_code,
    cancer_registration_rate_per_100k = measure,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_cancer, overwrite = TRUE)
