# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
hl_pupil_absence <- full_data_raw |>
  filter(area_type == "Council area" &
    indicator == "School exclusion rate") |>
  select(
    ltla19_code = `area_code`,
    pupil_absence_per_1k = `measure`,
    year
  )

ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

hl_pupil_absence$ltla19_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(hl_pupil_absence, overwrite = TRUE)
