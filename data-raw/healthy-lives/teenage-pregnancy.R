# ---- Load packages ----
library(readr)
library(httr)
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# ---- Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/

# Interactively generate the data by:
#   1. Navigating the the source (above)
#   2. Clicking the 'Data' box
#   3. 'Select what data you want'. Click indicator and type
#     'teenage pregnancies'
#   4. 'Select what areas you want'. Tick 'All available geographies'
#   5. 'Select the time period'. Move the time period slider until the latest
#      data shows (currently 2020-2023 period)
#   6. Right-click on 'Download data' and click 'Copy Link'
#   7. Pasting the link into the GET request below
#   8. Running the code below

# ---- Download and read URL as temp file ----
GET(
  "https://scotland.shinyapps.io/ScotPHO_profiles_tool/_w_8ad1497b/session/57df6f324dd2fb071fadc1c54b15a3b2/download/download_table_csv?w=8ad1497b",
  write_disk(tf <- tempfile(fileext = ".csv"))
)

teenage_pregnancy_raw <-
  read_csv(tf)

unlink(tf)
rm(tf)

# ---- Clean data ----
hl_teenage_pregnancy <- teenage_pregnancy_raw |>
  filter(area_type == "Council area") |>
  select(`area_code`, `measure`, `year`) |>
  rename(
    ltla19_code = 1,
    teenage_pregnancies_per_1k = 2
  )

# ---- Save output to data/ folder ----
usethis::use_data(hl_teenage_pregnancy, overwrite = TRUE)
