# Dataset contains data on rheumatoid arthritis pain in people aged 18 years and
# over. England's Health Index musculoskeletal conditions gathers data on
# Weighted number of people answering yes to 'Arthritis or ongoing problem with
# back or joints'.

# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)

# ---- Clean data ----
# LA Codes
ltla_lookup <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  select(ltla19_code, ltla19_name)


# Source: https://www.versusarthritis.org/policy/resources-for-policy-makers/musculoskeletal-calculator/download-full-msk-calculator-datasets/
GET(
  "https://www.versusarthritis.org/media/14567/mskcalculator_laccg_scotland.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

# Rheumatoid arthritis
rheumatoid_arthritis_raw <- read_excel(tf, sheet = 8, skip = 1)

rheumatoid_arthritis <- rheumatoid_arthritis_raw |>
  mutate(
    year = "2016",
    `LA Name` = str_replace_all(`LA Name`, "&", "and"),
    `LA Name` =
      if_else(`LA Name` == "Edinburgh, City of", "City of Edinburgh", `LA Name`)
  ) |>
  select(
    ltla19_code = `LA Code`,
    ltla19_name = `LA Name`,
    rheumatoid_arthritis_percentage = `Prevalence (general)`,
    year
  )

people_musculoskeletal_conditions <- rheumatoid_arthritis |>
  left_join(ltla_lookup, by = c("ltla19_name" = "ltla19_name")) |>
  select(
    ltla24_code = ltla19_code.y,
    rheumatoid_arthritis_percentage,
    year
  ) |>
  distinct(ltla24_code, .keep_all = TRUE) |>
  slice(-33)

# ---- Save output to data/ folder ----
usethis::use_data(people_musculoskeletal_conditions, overwrite = TRUE)
