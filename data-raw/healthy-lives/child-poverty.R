# ---- Load packages ----
library(readODS)
library(httr)
library(tidyverse)

# ---- Get data ----
# Source: https://www.gov.uk/government/statistics/children-in-low-income-families-local-area-statistics-2014-to-2023
GET(
  "https://assets.publishing.service.gov.uk/media/65fd4758f1d3a0001d32ad89/children-in-low-income-families-local-area-statistics-2014-to-2023.ods",
  write_disk(tf <- tempfile(fileext = ".ods"))
)

child_poverty_raw <-
  read_ods(tf, sheet = 8, skip = 9)

# ---- Clean data ----
lives_child_poverty <- child_poverty_raw |>
  filter(str_starts(`Area Code`, "S")) |>
  select(`Area Code`, `Percentage of children \nFYE 2023\n(%)\n[p] [note 3]`) |>
  rename(ltla24_code = 1,
         child_poverty_percentage = 2) |>
  mutate(child_poverty_percentage = (child_poverty_percentage * 100),
    year = "2022-2023")

# ---- Save output to data/ folder ----
usethis::use_data(lives_child_poverty, overwrite = TRUE)

