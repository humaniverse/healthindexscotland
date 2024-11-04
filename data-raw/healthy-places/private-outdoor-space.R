# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)

# ---- Get data ----
# Source: https://www.ons.gov.uk/economy/environmentalaccounts/datasets/accesstogardensandpublicgreenspaceingreatbritain
GET(
  "https://www.ons.gov.uk/file?uri=/economy/environmentalaccounts/datasets/accesstogardensandpublicgreenspaceingreatbritain/accesstogardenspacegreatbritainapril2020/osprivateoutdoorspacereferencetables.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

pos_raw <- read_excel(tf, sheet = 4, skip = 1)

places_private_outdoor_space <- pos_raw |>
  filter(str_detect(...3, "^S")) |>
  mutate(
    year = "2020",
    `Percentage of adresses with private outdoor space...10` =
      (`Percentage of adresses with private outdoor space...10` * 100)
  ) |>
  select(
    ltla24_code = `...5`,
    private_outdoor_space_percentage = `Percentage of adresses with private outdoor space...10`,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(places_private_outdoor_space, overwrite = TRUE)
