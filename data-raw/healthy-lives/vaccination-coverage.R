# For child vaccination coverage, Eng's index uses a combination of DtAP/IPV/Hib, MenC,
# MenB, MMR, PCV and rotovirus vaccinations and boosters until six years of age.
# Vaccinations below are the best proxies for Scotland.


# ---- Load packages ----
library(geographr)
library(tidyverse)
library(rio)
library(readxl)
library(demographr)

# ---- Get data ----
# Use population dataset to code lookup for ltla19 codes and names
population_2022 <- population22_ltla19_scotland |>
  filter(sex == "Persons") |>
  select(
    ltla19_name,
    ltla19_code,
    population_2022 = all_ages
  )

# Childhood immunisations
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
  mutate(year = "2023",
         twelve_month_mean_perc = rowMeans(across(c(`percent_six_in_one`, `percent_pcv`,
                                        `percent_rotavirus`, `percent_menb`)))) |>
  select(ltla19_name, twelve_month_mean_perc)

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
  mutate(year = "2023",
         twenty_four_mean_perc = rowMeans(across(c(`percent_six_in_one`, `percent_mmr1`,
                                                    `percent_hib_menc`, `percent_pcvb`, `percent_menb_booster`)))) |>
  select(ltla19_name, twenty_four_mean_perc)

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
  mutate(year = "2023",
         three_five_mean_perc = rowMeans(across(c(`percent_six_in_one`, `percent_mmr1`,
                                                  `percent_hib_menc`, `percent_four_in_one`, `percent_mmr2`)))) |>
  select(ltla19_name, three_five_mean_perc)


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
  mutate(year = "2023",
         four_six_mean_perc = rowMeans(across(c(`percent_mmr1`, `percent_four_in_one`, `percent_mmr2`)))) |>
  select(ltla19_name, four_six_mean_perc)

four_six_years <- four_six_years |>
  mutate(ltla19_name = str_remove(ltla19_name, "\\d+$"))

# Combine childhood vaccine indicators and calculate mean
childhood_coverage <-
  twelve_months |>
  left_join(twenty_four_months, by = "ltla19_name") |>
  left_join(three_five_years, by = "ltla19_name") |>
  left_join(four_six_years, by = "ltla19_name") |>
  mutate(total_av_percentage_coverage = rowMeans(across(c(2:5))),
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

lives_child_vaccine_coverage <- childhood_coverage |>
  select(
    ltla24_code = ltla19_code,
    child_vaccine_coverage_percentage = total_av_percentage_coverage, year)

# ---- Save output to data/ folder ----
usethis::use_data(lives_child_vaccine_coverage, overwrite = TRUE)
