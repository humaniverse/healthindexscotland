# ---- Load packages ----
library(tidyverse)
library(readxl)
library(httr)
library(geographr)
library(demographr)

# ---- Get data ----
# LA ID
population_2022 <- population22_ltla19_scotland |>
  filter(sex == "Persons") |>
  select(
    ltla19_name,
    ltla19_code,
    population_2022 = all_ages
  )

# Avoidable Deaths
# Source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/avoidable-mortality
GET(
  "https://www.nrscotland.gov.uk/files//statistics/avoidable-mortality/2021/avoid-mortality-21-all-tabs.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

# ---- Clean data ----
avoidable_deaths_raw <-
  read_excel(
    tf,
    sheet = "Table 10",
    skip = 2
  )

avoidable_deaths <- avoidable_deaths_raw |>
  slice(6:37) |>
  mutate(year = "2019-2021") |>
  select(
    ltla19_name = `...2`,
    avoidable_mortality_rate_per_100k = `Avoidable mortality rates: 2019-2021`,
    year
  )

# Combine datasets
people_avoidable_deaths <- avoidable_deaths |>
  left_join(population_2022, by = c("ltla19_name")) |>
  select(
    ltla24_code = ltla19_code,
    avoidable_mortality_rate_per_100k,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_avoidable_deaths, overwrite = TRUE)
