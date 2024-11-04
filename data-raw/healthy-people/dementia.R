# England's Health Index dementia indicator collects data on the weighted number
# of people answering yes to Alzheimer's disease or other cause of dementia in the
# national GP Patient Survey. The only available dementia data at Local Authority
# level in Scotland focuses on nursing care residents across all sectors.

# --- Load packages ----
library(tidyverse)
library(rio)

# ---- Get data ----
# Source: https://www.opendata.nhs.scot/dataset/care-home-census/resource/9bf418aa-c54d-45d3-8306-023e81f49f60
dementia_raw <- import("https://www.opendata.nhs.scot/dataset/75cca0a9-780d-40e0-9e1f-5f4796950794/resource/9bf418aa-c54d-45d3-8306-023e81f49f60/download/file8a_percentage_of_long_stay_residents_by_health_characteristics.csv")

people_dementia <- dementia_raw |>
  filter(
    KeyStatistic == "Percentage of Long Stay Residents with Dementia Medically Diagnosed",
    MainClientGroup == "All Adults",
    Date == "20240331"
  ) |>
  mutate(Date = "2023-2024") |>
  select(
    ltla24_code = CA,
    dementia_percentage = Value,
    year = Date
  ) |>
  slice(-33)

# ---- Save output to data/ folder ----
usethis::use_data(people_dementia, overwrite = TRUE)
