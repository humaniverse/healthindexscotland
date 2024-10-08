# ---- Load packages ----
library(readr)
library(httr)
library(tidyverse)
library(geographr)

# ---- Get data ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Indicator: Healthy birth weight

# Interactively generate the data by:
#   1. Navigating the Source (above)
#   2. Clicking the 'Data' box
#   3. 'Select what data you want'. Selecting the relevant indicator
#      (Healthy birth weight)
#   4. 'Select what areas you want'. Ticking 'All available geographies'
#   5. 'Select the time period'. Moving the time period slider until the latest
#      data shows (currently 2020-2023)
#   6. Right-clicking on 'Download data' and clicking 'Copy Link'
#   7. Pasting the link into the GET request below
#   8. Running the code below

GET(
  "https://scotland.shinyapps.io/ScotPHO_profiles_tool/_w_197d7f90/session/4b5e695a2121c092892d20cd790b2fbc/download/download_table_csv?w=197d7f90",
  write_disk(tf <- tempfile(fileext = ".csv"))
)

low_birth_weight_raw <-
  read_csv(tf)

unlink(tf)
rm(tf)

#START HERE WED 9TH






low_birth_weight <-
  low_birth_weight_raw %>%
  filter(area_type == "Council area") %>%
  select(
    lad_code = area_code,
    healthy_birth_weight_percent = measure
  ) %>%
  mutate(
    unhealthy_birth_weight_percent = (100 - healthy_birth_weight_percent)/100
  ) %>%
  select(-healthy_birth_weight_percent)

write_rds(low_birth_weight, "data/vulnerability/health-inequalities/scotland/healthy-lives/low-birth-weight.rds")
