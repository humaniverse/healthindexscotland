library(readr)
library(httr)
library(dplyr)

# Source:https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Indicator: Coronary heart disease (CHD) patient hospitalisations

# Interactively generate the data by:
#   1. Navigating the the source (above)
#   2. Clicking the 'Data' box
#   3. Selecting the relevant indicator (above)
#   4. Ticking 'All available geographies'
#   5. Moving the time period slider until the latest data shows
#   6. Right-clicking on 'Download data' and clicking 'Copy Link Location'
#   7. Pasting the link into the GET request below
#   8. Running the code below

GET(
  "https://scotland.shinyapps.io/ScotPHO_profiles_tool/_w_a7e2d2e8/session/e96daa290ff0d26c923ce4c38f4b7b38/download/download_table_csv?w=a7e2d2e8",
  write_disk(tf <- tempfile(fileext = ".csv"))
)

chd_raw <-
  read_csv(tf)

unlink(tf)
rm(tf)

chd <-
  chd_raw %>%
  filter(area_type == "Council area") %>%
  select(
    lad_code = area_code,
    coronary_heart_disease_per_100000 = measure
  )

write_rds(chd, "data/vulnerability/health-inequalities/scotland/healthy-people/coronary-heart-disease.rds")