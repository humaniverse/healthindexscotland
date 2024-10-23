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

# Drug related admissions
# Source: https://www.opendata.nhs.scot/dataset/drug-related-hospital-statistics-scotland
drug_raw <- import(
  "https://www.opendata.nhs.scot/dataset/a961302c-aeb7-49b2-9691-9d3da82ca0d9/resource/46f9d70b-8517-4af3-b65e-dbcd13dfa388/download/drug_related_hospital_stays_council.csv"
)

drug <- drug_raw |>
  filter(
    FinancialYear %in% c("2021/22")
  ) |>
  select(
    ltla19_code = CA,
    drug_related_stays = EASRStays, # Age-sex standardised
    year = FinancialYear
  )

# ---- Join datasets ----
lives_drug_misuse <- drug |>
  left_join(population_2022, by = c("ltla19_code")) |>
  mutate(drug_related_stays_per_100k = (((as.double(drug_related_stays)) /
    as.double(population_2022)) * 100000)) |>
  slice(-1) |>
  select(
    ltla24_code = ltla19_code,
    drug_related_stays_per_100k,
    year)

# Council codes were revised in 2018 and 2019
# Check 2011 code is same as 2019
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

lives_drug_misuse$ltla24_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(lives_drug_misuse, overwrite = TRUE)
