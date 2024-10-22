# ---- Load libs ----
library(geographr)
library(tidyverse)

# ---- Get and clean data ----
# The NOMIS API query creator was used to generate the url in the GET request:
# Source: https://www.nomisweb.co.uk/datasets/apsnew
# Data Set: Annual Population Survey
# Indicator: T22a (Job related training (SIC 2007)
training_raw <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_17_5.data.csv?geography=1807745025...1807745028,1807745030...1807745032,1807745034...1807745083,1807745085,1807745282,1807745283,1807745086...1807745155,1807745157...1807745164,1807745166...1807745170,1807745172...1807745177,1807745179...1807745194,1807745196,1807745197,1807745199,1807745201...1807745218,1807745221,1807745222,1807745224,1807745226...1807745231,1807745233,1807745234,1807745236...1807745244&date=latest&variable=18,416&measures=20599,21001,21002,21003")

lives_job_training <-
  training_raw |>
  filter(str_detect(GEOGRAPHY_CODE, "^S") &
    VARIABLE_NAME == "% of all who received job related training in last  4 wks - aged 16-64" &
    MEASURES_NAME == "Variable") |>
  select(
    ltla21_code = GEOGRAPHY_CODE,
    ltla21_name = GEOGRAPHY_NAME,
    `job_related_training_perc` = OBS_VALUE
  ) |>
  mutate(
    year = "2023-2024"
  )

# Check all codes
ltla21_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla21_code, "^S")) |>
  pull(ltla21_code)

dplyr::setequal(lives_job_training$ltla21_code, ltla21_code)

# Check codes match correct names
lives_job_training |>
  left_join(
    lookup_ltla_ltla |>
      filter(str_detect(ltla21_code, "^S")) |>
      distinct(ltla21_code, name = ltla21_name)
  ) |>
  count(ltla21_name == name)

# Don't need the LTLA name column anymore
lives_job_training <-
  lives_job_training |>
  select(-ltla21_name)

# ---- Save output to data/ folder ----
usethis::use_data(lives_job_training, overwrite = TRUE)
