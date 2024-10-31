# ---- Load packages ----
library(tidyverse)
library(geographr)
library(readODS)
library(httr)

# ---- Get data ----
# Source: https://www.gov.scot/publications/scottish-household-survey-2022-key-findings/documents/
url <- "https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2023/12/scottish-household-survey-2022-key-findings/documents/shs-2022-annual-report-tables-4-internet/shs-2022-annual-report-tables-4-internet/govscot%3Adocument/SHS%2B2022%2B-%2BAnnual%2BReport%2B-%2BTables%2B-%2B4%2BInternet.ods"
tf <- tempfile(fileext = ".ods")
GET(url, write_disk(tf, overwrite = TRUE))

internet_access_raw <- read_ods(tf, sheet = 4, skip = 2)

# ---- Clean data ----
internet_access <- internet_access_raw |>
  filter(Answser == "Yes") |>
  mutate(year = "2022") |>
  select(ltla19_name = council,
         internet_access_percentage = All,
         year)


names(internet_access_raw)
