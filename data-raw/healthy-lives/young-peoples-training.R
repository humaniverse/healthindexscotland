# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
hl_young_people_training <- full_data_raw |>
  filter(area_type == "Council area" &
    indicator == "Annual participation (in education, training or employment) measure for 16 – 19 year olds") |>
  select(
    ltla19_code = area_code,
    young_people_participation_education_training_employment_percentage = measure,
    year
  )

ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

hl_young_people_training$ltla19_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(hl_young_people_training, overwrite = TRUE)
