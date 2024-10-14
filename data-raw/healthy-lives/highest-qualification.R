library(tidyverse)
library(readxl)
library(httr2)
library(geographr)

# ---- Get data ----
# Lookup for OA22 to council areas
# Source: https://www.nrscotland.gov.uk/statistics-and-data/geography/our-products/census-datasets/2022-census/2022-census-indexes
url <- "https://www.nrscotland.gov.uk/files//geography/2022-census/Census_2022_Index.zip"

download <- tempfile(fileext = ".zip")

request(url) |>
  req_perform(download)

unzip(download, exdir = tempdir())

lookup_oa22_ltla19 <- read_csv(file.path(tempdir(), "Census_2022_Index/OA_TO_HIGHER_AREAS.csv")) |>
  select(oa22_code = OA2022, ltla19_code = CA2019) |>
  distinct()

# Qualifications data
# Source: https://www.scotlandscensus.gov.uk/documents/2022-output-area-data/
url <- "https://nrscensusprodumb.blob.core.windows.net/media/zz85kfinmf97whklasd98gfjk_20241003_1200_Topic2G__9575hj6t9375h/Census-2022-Output-Area-v1.zip"

download <- tempfile(fileext = ".zip")

request(url) |>
  req_perform(download)

unzip(download, exdir = tempdir())

qualification_raw <- read_csv(file.path(tempdir(), "UV501 - Highest level of qualification.csv"),
  skip = 3
)

hl_highest_qualification <- qualification_raw |>
  rename(oa22_code = 1) |>
  filter(str_detect(oa22_code, "^S0")) |>
  mutate(`Lower school qualifications` = replace(
    `Lower school qualifications`,
    `Lower school qualifications` == "-", 0
  ),
  `No qualifications` = replace(
    `No qualifications`,
    `No qualifications` == "-", 0 )
  ) |>
  mutate(highest_qualification_lower_school_percent = (as.numeric(`Lower school qualifications`) +
           as.numeric(`No qualifications`)) /
    as.numeric(`All people aged 16 and over`) * 100) |>
  select(oa22_code, highest_qualification_lower_school_percent) |>
  left_join(lookup_oa22_ltla19) |>
  group_by(ltla19_code) |>
  summarise(highest_qualification_lower_school_percent = mean(highest_qualification_lower_school_percent))

# ---- Check all LTLA codes are present ----
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

hl_highest_qualification$ltla19_code %in% ltla19_code
ltla19_code %in% hl_highest_qualification$ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(hl_highest_qualification, overwrite = TRUE)
