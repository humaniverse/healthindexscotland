# ---- Load libs ----
library(tidyverse)
library(geographr)

# ---- Get data ----
# Source: https://statistics.gov.scot/slice?dataset=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data&http%3A%2F%2Fpurl.org%2Flinked-data%2Fcube%23measureType=http%3A%2F%2Fstatistics.gov.scot%2Fdef%2Fmeasure-properties%2Fpercent&http%3A%2F%2Fpurl.org%2Flinked-data%2Fsdmx%2F2009%2Fdimension%23refPeriod=http%3A%2F%2Freference.data.gov.uk%2Fid%2Fgregorian-interval%2F2016-01-01T00%3A00%3A00%2FP4Y
health_survey <-
  read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data")

hl_smoking <-
  health_survey |>
  filter(
    `Scottish Health Survey Indicator` == "Smoking status: Current smoker",
    Measurement == "Percent",
    Sex == "All",
    DateCode == "2018-2022",
    FeatureType == "Council Area"
  ) |>
  select(
    ltla19_code = FeatureCode,
    smoking_percent = Value,
    year = DateCode
  )

# ---- Check all LTLA codes are present ----
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

hl_smoking$ltla19_code %in% ltla19_code
ltla19_code %in% hl_smoking$ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(hl_smoking, overwrite = TRUE)
