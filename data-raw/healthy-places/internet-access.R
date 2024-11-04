# Data missing for Moray and South Ayrshire.

# ---- Load packages ----
library(tidyverse)
library(geographr)
library(readODS)
library(httr)

# ---- Get data ----
# LA Codes
ltla_lookup <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  select(ltla19_code, ltla19_name)

# Internat access data
# Source: https://www.gov.scot/publications/scottish-household-survey-2022-key-findings/documents/
url <- "https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2023/12/scottish-household-survey-2022-key-findings/documents/shs-2022-annual-report-tables-4-internet/shs-2022-annual-report-tables-4-internet/govscot%3Adocument/SHS%2B2022%2B-%2BAnnual%2BReport%2B-%2BTables%2B-%2B4%2BInternet.ods"
tf <- tempfile(fileext = ".ods")
GET(url, write_disk(tf, overwrite = TRUE))

internet_access_raw <- read_ods(tf, sheet = 4, skip = 2)

# ---- Clean data ----
internet_access <- internet_access_raw |>
  filter(Answser == "Yes") |>
  mutate(
    year = "2022",
    council = str_replace_all(`council`, "&", "and"),
    council =
      if_else(`council` == "Edinburgh, City of", "City of Edinburgh", `council`),
    council = str_replace_all(council, "\n", " ")
  ) |>
  select(
    ltla19_name = council,
    internet_access_percentage = All,
    year
  )

# Join datasets
places_internet_access <- internet_access |>
  left_join(ltla_lookup, by = c("ltla19_name" = "ltla19_name")) |>
  slice(-1) |>
  distinct(ltla19_code, .keep_all = TRUE) |>
  select(
    ltla24_code = ltla19_code,
    internet_access_percentage,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(places_internet_access, overwrite = TRUE)
