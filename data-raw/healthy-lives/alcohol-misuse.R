# ---- Load libs ----
library(tidyverse)
library(rio)
library(geographr)
library(demographr)

# ---- Get data ----
# Population
population_2022 <- population22_ltla19_scotland |>
  filter(sex == "Persons") |>
  select(
    ltla19_name,
    ltla19_code,
    population_2022 = all_ages
  )

# Alcohol related admissions
# Source: https://www.opendata.nhs.scot/dataset/alcohol-related-hospital-statistics-scotland/resource/b0b520e8-3507-46cd-a9b5-cff03007bb57
alcohol_raw <- import(
  "https://www.opendata.nhs.scot/dataset/c4db1692-fa02-4a1c-af4c-6039c74633ea/resource/b0b520e8-3507-46cd-a9b5-cff03007bb57/download/arhs_council_area_28_02_2023.csv",
)

alcohol <- alcohol_raw |>
  filter(Condition %in% c("All alcohol conditions") &
    FinancialYear %in% c("2021/22") &
    SMRType == "Combined") |> # General acute and psychiatric hospitals
  select(
    ltla11_code = CA,
    alcohol_related_admissions = EASRPatients,
    year = FinancialYear
  )

# ---- Join datasets ----
hl_alcohol_misuse <- alcohol |>
  left_join(population_2022, by = c("ltla11_code" = "ltla19_code")) |>
  mutate(alcohol_admissions_per_100k = (((as.double(alcohol_related_admissions)) /
    as.double(population_2022)) * 100000)) |>
  slice(-1) |>
  select(ltla19_code = ltla11_code, alcohol_admissions_per_100k, year)

# Council codes were revised in 2018 and 2019
# Check 2011 code is same as 2019
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

hl_alcohol_misuse$ltla19_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(hl_alcohol_misuse, overwrite = TRUE)
