# ---- Load packages ----
library(httr)
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/

# Interactively generate the full ScotPHO dataset by:
#   1. Navigating the the source (above)
#   2. Clicking the 'Download data' link on the top right
#   3. 'Select a dataset' - 'Main dataset
#   4. Tick 'Council area'
#   5. Get the URL from the download data button

# The URL is session-based; new URL will need to be generated each time this code is run.
# The full ScotPHO dataset is saved in data-raw/health-lives/data/ as it is used in other indicators

# ---- Download and read URL as temp file ----
# GET(
#   "https://scotland.shinyapps.io/ScotPHO_profiles_tool/_w_37cec01a/session/27e32ac7b3d83983d9374b1ee92b332d/download/data_tab-datatable_downloads-downloadCSV?w=37cec01a",
#   write_disk("data-raw/healthy-lives/data/scotpho_data.csv", overwrite = TRUE)
# )

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
lives_teenage_pregnancy <- full_data_raw |>
  filter(area_type == "Council area" &
    indicator == "Teenage pregnancies") |>
  select(
    ltla24_code = area_code,
    teenage_pregnancy_per_1k = measure
  ) |>
  mutate(year = "2019-2021")

ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

lives_teenage_pregnancy$ltla24_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(lives_teenage_pregnancy, overwrite = TRUE)
