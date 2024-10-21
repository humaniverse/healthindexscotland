# The 'Average (mean)' estimate provides the score out of 0-10. The other
# estimates are thresholds (percentages) described in the QMI:
# https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/methodologies/personalwellbeingintheukqmi.
# Orkney Islands missing data in latest collection years. 2020-21 most recent
# completed data.

# ---- Load packages ----
library(httr)
library(readxl)
library(tidyverse)
library(rio)

# ---- Get data ----
# Source: https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4
anxiety_raw <-
  import("https://download.ons.gov.uk/downloads/datasets/wellbeing-local-authority/editions/time-series/versions/4.csv")

# ---- Clean data ----
people_anxiety <- anxiety_raw |>
  filter(
    str_starts(`administrative-geography`, "S"),
    MeasureOfWellbeing == "Anxiety",
    Estimate == "Average (mean)",
    Time == "2020-21"
  ) |>
  select(
    ltla19_code = `administrative-geography`,
    anxiety_score_out_of_10 = `v4_3`,
    year = `Time`
  ) |>
  slice(-15)

# ---- Save output to data/ folder ----
usethis::use_data(people_anxiety, overwrite = TRUE)
