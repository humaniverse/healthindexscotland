library(tidyverse)
library(httr)
library(readxl)

# ---- Scrape URL ----
# ---- Source: https://www.hse.gov.uk/statistics/tables/index.htm#riddor
url <- "https://www.hse.gov.uk/statistics/assets/docs/ridreg.xlsx"

# ---- Download and read URL as temp file ----
temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")
workplace_safety_raw <- read_excel(temp_file, sheet = 5, skip = 7)

# ---- Clean data ----
hl_workplace_safety <- workplace_safety_raw |>
  filter(str_starts(`Area code\r\n[Note 10]`, "S"))
