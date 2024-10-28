# England uses pupils with social, emotional and mental health listed as their
# primary special education need requirement; use mean mental wellbeing score for S4
# as proxy for Scotland. Latest data is 2013.


# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
people_child_mental_health <- full_data_raw |>
  filter(area_type == "Council area" &
    indicator == "Mean mental wellbeing score for S4 pupils") |>
  select(
    ltla24_code = `area_code`,
    child_mental_wellbeing_score = `measure`,
    year
  )

ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

people_child_mental_health$ltla24_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(people_child_mental_health, overwrite = TRUE)
