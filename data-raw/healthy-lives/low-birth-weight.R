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
  "https://scotland.shinyapps.io/ScotPHO_profiles_tool/_w_24295f36/session/2cbfa6bd6c7cc9114c6a007d90054974/download/download_table_csv?w=24295f36",
  write_disk(tf <- tempfile(fileext = ".csv"))
)

low_birth_weight_raw <-
  read_csv(tf)

unlink(tf)
rm(tf)

# ---- Get data ----
hl_low_birth_weight <- low_birth_weight_raw |>
  filter(area_type == "Council area", year == "2021") |>
  mutate(low_birth_weight_percentage = (100 - measure) / 100) |>
  select(`area_code`, `low_birth_weight_percentage`, `year`)|>
  rename(ltla19_code = 1)

# Council codes were revised in 2018 and 2019
# Check codes are the same as 2019
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

hl_low_birth_weight$ltla19_code %in% ltla19_code

# ---- Save output to data/ folder ----
usethis::use_data(hl_low_birth_weight, overwrite = TRUE)
