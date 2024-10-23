# ---- Load libs ----
library(tidyverse)
library(rio)
library(geographr)

# ---- Get data ----
# Developmental concerns at 27-30 months
# Source: https://www.opendata.nhs.scot/dataset/27-30-month-review-statistics/resource/018ba0e1-6562-43bb-82c5-97b6c6cc22d8
ecd_raw <- import(
  "https://www.opendata.nhs.scot/dataset/f4ee46d4-cda9-4180-b6be-0f0e45ee3c8c/resource/018ba0e1-6562-43bb-82c5-97b6c6cc22d8/download/open27mlatotals.csv",
)

lives_early_years_development <- ecd_raw |>
  filter(
    FinancialYear %in% c("2022/23")
  ) |>
  select(
    ltla24_code = CA,
    total_reviews = NumberOfReviews,
    concerns = ConcernAny,
    year = FinancialYear
  ) |>
  mutate(
    developmental_concerns_percent = concerns / total_reviews * 100
  ) |>
  select(-total_reviews, -concerns) |>
  slice(-1) |>
  relocate(year, .after = developmental_concerns_percent)


# Council codes were revised in 2018 and 2019
# Check 2011 code is same as 2019
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

lives_early_years_development$ltla24_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(lives_early_years_development, overwrite = TRUE)
