# The 'Average (mean)' estimate provides the score out of 0-10. The other
# estimates are thresholds (percentages) described in the QMI:
# https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/methodologies/personalwellbeingintheukqmi.
# Orkney Islands missing data in 2022-23; 2020-21 most recent data for Orkney.

# ---- Load packages ----
library(tidyverse)
library(rio)

# ---- Get data ----
# Source: https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4
anxiety_raw <-
  import("https://download.ons.gov.uk/downloads/datasets/wellbeing-local-authority/editions/time-series/versions/4.csv")

# ---- Clean data ----
# Anxiety scores for 2022-23. Data missing for Orkney Islands.
anxiety_2022 <- anxiety_raw |>
  filter(
    str_starts(`administrative-geography`, "S"),
    MeasureOfWellbeing == "Anxiety",
    Estimate == "Average (mean)",
    Time == "2022-23"
  ) |>
  select(
    ltla24_code = `administrative-geography`,
    anxiety_score_out_of_10 = `v4_3`,
    year = `Time`
  )

# Anxiety scores for 2020-21, with latest Orkney Islands data.
anxiety_orkney <- anxiety_raw |>
  filter(
    `administrative-geography` == "S12000023",
    MeasureOfWellbeing == "Anxiety",
    Estimate == "Average (mean)",
    Time == "2020-21"
  ) |>
  select(
    ltla24_code = `administrative-geography`,
         anxiety_score_out_of_10 = `v4_3`,
         year = `Time`
    )

# Combine data
anxiety_2022_filtered <- anxiety_2022 |>
  filter(!(ltla24_code == "S12000023" & year == "2022-23"))

people_anxiety <-
  bind_rows(anxiety_2022_filtered, anxiety_orkney) |>
  slice(-15) # Remove Scotland

# ---- Save output to data/ folder ----
usethis::use_data(people_anxiety, overwrite = TRUE)
