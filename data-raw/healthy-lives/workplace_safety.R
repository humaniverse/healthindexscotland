library(tidyverse)
library(httr)
library(readxl)
library(geographr)

# ---- Scrape URL ----
# ---- Source: https://www.hse.gov.uk/statistics/tables/index.htm#riddor
url <- "https://www.hse.gov.uk/statistics/assets/docs/ridreg.xlsx"

# ---- Download and read URL as temp file ----
temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")
workplace_safety_raw <- read_excel(temp_file, sheet = 5, skip = 7)

# ---- Clean data ----
lives_workplace_safety <- workplace_safety_raw |>
  filter(str_starts(`Area code\r\n[Note 10]`, "S")) |>
  rename(year = 1) |>
  slice(which(str_starts(`year`, "2022/23"))) |>
  slice(2:33) |>
  rename(
    non_fatal_injuries_per_100k_employees = 8,
    ltla24_code = 2
  ) |>
  select(`ltla24_code`, `non_fatal_injuries_per_100k_employees`, `year`)

# Council codes were revised in 2018 and 2019
# Check 2011 code is same as 2019
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

lives_workplace_safety$ltla24_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(lives_workplace_safety, overwrite = TRUE)
