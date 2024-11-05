# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)

# ---- Get data ----
# LA code
ltla_lookup <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  select(ltla19_code, ltla19_name)

# Mortality all causes
# Source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/deaths-time-series-data

GET(
  "https://www.nrscotland.gov.uk/files//statistics/time-series/death-23/deaths-time-series-23-dt-9.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

all_mortality_raw <- read_excel(tf, sheet = 2, skip = 5)

all_mortality <- all_mortality_raw |>
  select(-35) |>
  slice(34) |>
  pivot_longer(
    cols = 2:34,
    names_to = "ltla19_name",
    values_to = "death_rate_per_1k"
  ) |>
  mutate(
    "death_rate_per_100k" = (death_rate_per_1k * 100),
    `ltla19_name` = str_replace_all(`ltla19_name`, "&", "and")
  ) |>
  slice(-1) |>
  select(
    ltla19_name,
    death_rate_per_100k,
    year = `...1`
  )

# Combine datasets
people_all_mortality <- all_mortality |>
  left_join(ltla_lookup, by = c("ltla19_name" = "ltla19_name")) |>
  select(
    ltla24_code = ltla19_code,
    death_rate_per_100k,
    year
  ) |>
  distinct(ltla24_code, .keep_all = TRUE)

# ---- Save output to data/ folder ----
usethis::use_data(people_all_mortality, overwrite = TRUE)
