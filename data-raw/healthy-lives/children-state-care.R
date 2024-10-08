library(readr)
library(httr)
library(dplyr)

# Source:https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Indicator: Children looked after by local authority

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
  "https://scotland.shinyapps.io/ScotPHO_profiles_tool/_w_62b37840/session/db375ba2ae45ca39a5219a0ad242f16b/download/download_table_csv?w=62b37840",
  write_disk(tf <- tempfile(fileext = ".csv"))
)

children_state_care_raw <-
  read_csv(tf)

unlink(tf)
rm(tf)

children_state_care <-
  children_state_care_raw %>%
  filter(area_type == "Council area") %>%
  select(
    lad_code = area_code,
    children_state_care_per_1000 = measure
  )

write_rds(children_state_care, "data/vulnerability/health-inequalities/scotland/healthy-lives/children-state-care.rds")