# ---- Load packages ----
library(geographr)
library(tidyverse)
library(rio)
library(readxl)
library(demographr)

# ---- Get data ----
# HPV
# Source: https://publichealthscotland.scot/publications/hpv-immunisation-statistics-scotland/hpv-immunisation-statistics-scotland-school-year-202223/
 hpv_raw <- import("https://www.opendata.nhs.scot/dataset/272ce3f2-875b-4271-9a44-67486c1b59c4/resource/993b4c4d-996e-4fa2-b398-eebcd526e7ec/download/ca-hpv-immunisation-20231128.csv")

hpv <- hpv_raw |>
  filter(Sex == "Total") |>
  group_by(CA) |>
  mutate(
    PercentCoverage = as.numeric(PercentCoverage),
    total_av_percentage_coverage = sum(PercentCoverage, na.rm = TRUE) / 4
  ) |>
  ungroup() |>
  rename(year = 1,
         ltla19_code = 2) |>
  select(`ltla19_code`, `total_av_percentage_coverage`, `year`) |>
  slice(1:32)

# Teenage booster immunisations
# Source: https://publichealthscotland.scot/publications/teenage-booster-immunisation-statistics-scotland/teenage-booster-immunisation-statistics-scotland-school-year-202223/#:~:text=In%202022%2F23%20an%20additional,77.3%25%2C%20MenACWY%2077.4%25).
teenage_booster_raw <- import("https://www.opendata.nhs.scot/dataset/807cf7c8-ba2a-49e3-b9d8-055799ecefd2/resource/964b7fe0-28b3-4aa8-a16c-f1ca29c13f85/download/ca-teenb-immunisation-20231128.csv")

teenage_booster <- teenage_booster_raw |>
  filter(Sex == "Total") |>
  group_by(CA) |>
  mutate(
    PercentCoverage = as.numeric(PercentCoverage),
    total_av_percentage_coverage = sum(PercentCoverage, na.rm = TRUE) / 4
    ) |>
  ungroup() |>
  rename(year = 1,
         ltla19_code = 2) |>
  select(`ltla19_code`, `total_av_percentage_coverage`, `year`) |>
  slice(1:32)

# Childhood immunisations
# Population
population_2022 <- population22_ltla19_scotland |>
  filter(sex == "Persons") |>
  select(
    ltla19_name,
    ltla19_code,
    population_2022 = all_ages
  )

# Source: https://publichealthscotland.scot/publications/childhood-immunisation-statistics-scotland/childhood-immunisation-statistics-scotland-quarter-ending-30-june-2024/
url <- "https://publichealthscotland.scot/media/29110/child_imms_latestrates_quarter_224_la.xlsx"

temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")

# Immunisation uptake rates by 12 months of age
twelve_months_raw <- read_excel(temp_file, sheet = 2, skip = 4)

twelve_months <- twelve_months_raw |>
  slice(2:33) |>
  mutate(across(2:10, ~ as.numeric(as.character(.)))) |>
  rename(ltla19_name = 1,
         percent_six_in_one = 4,
         percent_pcv = 6,
         percent_rotavirus = 8,
         percent_menb = 10) |>
  select(`ltla19_name`, `percent_six_in_one`, `percent_pcv`,
         `percent_rotavirus`, `percent_menb`) |>
  mutate(year = "2023")

twelve_months <- twelve_months |>
  mutate(ltla19_name = str_remove(ltla19_name, "\\d+$"))

# Primary and booster immunisation uptake rates by 24 months of age
twenty_four_months_raw <- read_excel(temp_file, sheet = 3, skip = 4)

twenty_four_months <- twenty_four_months_raw |>
  slice(2:33) |>
  mutate(across(2:12, ~ as.numeric(as.character(.)))) |>
  rename(ltla19_name = 1,
         percent_six_in_one = 4,
         percent_mmr1 = 6,
         percent_hib_menc = 8,
         percent_pcvb = 10,
         percent_menb_booster = 12) |>
  select(`ltla19_name`, `percent_six_in_one`, `percent_mmr1`,
         `percent_hib_menc`, `percent_pcvb`, `percent_menb_booster`) |>
  mutate(year = "2023")

twenty_four_months <- twenty_four_months |>
  mutate(ltla19_name = str_remove(ltla19_name, "\\d+$"))

# Primary and booster immunisation uptake rates by 5 years of age
three_five_years_raw <- read_excel(temp_file, sheet = 4, skip = 4)

three_five_years <- three_five_years_raw |>
  slice(2:33) |>
  mutate(across(2:12, ~ as.numeric(as.character(.)))) |>
  rename(ltla19_name = 1,
         percent_six_in_one = 4,
         percent_mmr1 = 6,
         percent_hib_menc = 8,
         percent_four_in_one = 10,
         percent_mmr2 = 12) |>
  select(`ltla19_name`, `percent_six_in_one`, `percent_mmr1`,
         `percent_hib_menc`, `percent_four_in_one`, `percent_mmr2`) |>
  mutate(year = "2023")

three_five_years <- three_five_years |>
  mutate(ltla19_name = str_remove(ltla19_name, "\\d+$"))

# Primary and booster immunisation uptake rates by 6 years of age
four_six_years_raw <- read_excel(temp_file, sheet = 5, skip = 4)

four_six_years <- four_six_years_raw |>
  slice(2:33) |>
  mutate(across(2:8, ~ as.numeric(as.character(.)))) |>
  rename(ltla19_name = 1,
         percent_mmr1 = 4,
         percent_four_in_one = 6,
         percent_mmr2 = 8) |>
  select(`ltla19_name`, `percent_mmr1`, `percent_four_in_one`, `percent_mmr2`) |>
  mutate(year = "2023")

four_six_years <- four_six_years |>
  mutate(ltla19_name = str_remove(ltla19_name, "\\d+$"))

# Combine childhood vaccine indicators and calculate mean
childhood_coverage <-
  twelve_months |>
  left_join(twenty_four_months, by = "ltla19_name") |>
  left_join(three_five_years, by = "ltla19_name") |>
  left_join(four_six_years, by = "ltla19_name") |>
  select(-year.x, -year.y, -year.x.x, -year.y.y) |>
  mutate(total_av_percentage_coverage = rowMeans(across(c(2:18))),
         year = "2023") |>
  rename(ltla19_name = 1) |>
  select(`ltla19_name`, `total_av_percentage_coverage`, `year`)

# Combine LA ID data
unmatched_LAs <- childhood_coverage |>
  anti_join(population_2022, by = c("ltla19_name" = "ltla19_name"))

childhood_coverage <- childhood_coverage |>
  mutate(ltla19_name = str_replace_all(ltla19_name, "&", "and")) |>
  mutate(ltla19_name = if_else(ltla19_name == "Edinburgh City", "City of Edinburgh", ltla19_name))

childhood_coverage <- childhood_coverage |>
  left_join(population_2022, by = c("ltla19_name" = "ltla19_name"))

childhood_coverage <- childhood_coverage |>
  select(`ltla19_code`, `total_av_percentage_coverage`, `year`)

# ---- Join datasets ----
hl_vaccine_coverage <-
  hpv |>
  left_join(teenage_booster, by = "ltla19_code") |>
  left_join(childhood_coverage, by = "ltla19_code") |>
  select(-year.x, -year.y) |>
  group_by(ltla19_code) |>
  mutate(vaccine_coverage_percentage = ((total_av_percentage_coverage.x +
                                          total_av_percentage_coverage.y +
                                          total_av_percentage_coverage) / 3),
         year = "2022/23") |>
  select(`ltla19_code`, `vaccine_coverage_percentage`, `year`)

# ---- Save output to data/ folder ----
usethis::use_data(hl_vaccine_coverage, overwrite = TRUE)
