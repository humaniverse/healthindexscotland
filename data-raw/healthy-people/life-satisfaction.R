# The 'Average (mean)' estimate provides the score out of 0-10. The other
# estimates are thresholds (percentages) described in the QMI:
# https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/methodologies/personalwellbeingintheukqmi.
# Orkney Islands missing data in 2022-23; 2020-21 most recent data for Orkney.

# ---- Load packages ----
library(httr)
library(readxl)
library(tidyverse)
library(rio)

# ---- Get data ----
# Source: https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4
life_satisfaction_raw <-
  import("https://download.ons.gov.uk/downloads/datasets/wellbeing-local-authority/editions/time-series/versions/4.csv")

# ---- Clean data ----
# Life satisfaction scores for 2022-23. Data missing for Orkney Islands.
life_satisfaction_2022 <- life_satisfaction_raw |>
  filter(
    str_starts(`administrative-geography`, "S"),
    MeasureOfWellbeing == "Life satisfaction",
    Estimate == "Average (mean)",
    Time == "2022-23"
  ) |>
  select(
    ltla24_code = `administrative-geography`,
    life_satisfaction_score_out_of_10 = `v4_3`,
    year = `Time`
  )

# Life satisfaction scores for 2020-21, with latest Orkney Islands data.
life_satisfaction_orkney <- life_satisfaction_raw |>
  filter(
    `administrative-geography` == "S12000023",
    MeasureOfWellbeing == "Life satisfaction",
    Estimate == "Average (mean)",
    Time == "2020-21"
  ) |>
  select(
    ltla24_code = `administrative-geography`,
    life_satisfaction_score_out_of_10 = `v4_3`,
    year = `Time`
  )

# Combine data
life_satisfaction_2022_filtered <- life_satisfaction_2022 |>
  filter(!(ltla24_code == "S12000023" & year == "2022-23"))

people_life_satisfaction <-
  bind_rows(life_satisfaction_2022_filtered, life_satisfaction_orkney) |>
  slice(-15)

# ---- Save output to data/ folder ----
usethis::use_data(people_life_satisfaction, overwrite = TRUE)
