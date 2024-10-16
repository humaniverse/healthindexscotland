# ---- Load packages ----
library(httr)
library(readxl)
library(tidyverse)
library(geographr)
library(demographr)

# Quarter 3 2023
# ---- Get data ----
# Source: https://webarchive.nrscotland.gov.uk/20240326182106/https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/quarterly-births-deaths-and-other-vital-events/3rd-quarter-2023
GET(
  "https://webarchive.nrscotland.gov.uk/20240326182106mp_/https://www.nrscotland.gov.uk/files//statistics/births-marriages-deaths-quarterly/23/q3/quarter-3-2023-tables.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

q3_births_raw <- read_excel(tf, sheet = 6, skip = 3)

# ---- Clean data ----
q3_




# Sources for:
# Q4 2023 - https://webarchive.nrscotland.gov.uk/20240326182120/https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/quarterly-births-deaths-and-other-vital-events/4th-quarter-2023
# dataset url - https://webarchive.nrscotland.gov.uk/20240326182120mp_/https://www.nrscotland.gov.uk/files//statistics/births-marriages-deaths-quarterly/23/q4/quarter-4-23-tables.xlsx

# Q1 2024 - https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/quarterly-births-deaths-and-other-vital-events/1st-quarter-2024
# dataset url - https://www.nrscotland.gov.uk/files//statistics/births-marriages-deaths-quarterly/24/quarter-1-24-tables.xlsx

# Q2 2024 - https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/quarterly-births-deaths-and-other-vital-events/2nd-quarter-2024
# dataset url - https://www.nrscotland.gov.uk/files//statistics/births-marriages-deaths-quarterly/24/quarter-2-24-tables.xlsx







library(readr)
library(httr)
library(dplyr)

# Source:https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Indicator: Infant deaths, ages 0-1 years

# Interactively generate the data by:
#   1. Navigating the the source (above)
#   2. Clicking the 'Data' box
#   3. Selecting the relevant indicator (above)
#   4. Ticking 'All available geographies'
#   5. Moving the time period slider until the latest data shows
#   6. Right-clicking on 'Download data' and clicking 'Copy Link Location'
#   7. Pasting the link into the GET request below
#   8. Running the code below

GET(
  "https://scotland.shinyapps.io/ScotPHO_profiles_tool/_w_bf38394a/session/b36bf6618e0e15fa0175acb6560866c3/download/download_table_csv?w=bf38394a",
  write_disk(tf <- tempfile(fileext = ".csv"))
)

infant_mortality_raw <-
  read_csv(tf)

unlink(tf)
rm(tf)

infant_mortality <-
  infant_mortality_raw %>%
  filter(area_type == "Council area") %>%
  select(
    lad_code = area_code,
    infant_mortality_per_1000 = measure
  )

write_rds(infant_mortality, "data/vulnerability/health-inequalities/scotland/healthy-lives/infant-mortality.rds")
