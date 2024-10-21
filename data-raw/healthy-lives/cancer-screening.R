# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset

full_data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

# ---- Clean data ----
hl_cancer_screening <- full_data_raw |>
  filter(area_type == "Council area" &
           indicator == "Bowel screening uptake") |>

# England's Health Index includes bowel, breast, and cervical cancers for
# cancer-screening indicator. Scotland does not have data on cervical cancer
# and latest breast cancer screening data is from 2010-2012 aggregate. Only bowel
# cancer screening data included here.

  mutate(year = "2020-2022") |>
  select(ltla19_code = area_code,
         cancer_screening_uptake = measure,
         year)

# ---- Save output to data/ folder ----
usethis::use_data(hl_cancer_screening, overwrite = TRUE)

