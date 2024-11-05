# ---- Load packages ----
library(httr)
library(tidyverse)
library(geographr)

# ---- Scrape URL ----
# Source: https://www.opendata.nhs.scot/dataset/primary-1-body-mass-index-bmi-statistics/resource/4a3daa0f-1580-4a59-ac9e-64d9a31a4429
url <- "https://www.opendata.nhs.scot/dataset/01fe4008-23f8-4b34-b8f6-c38699a2f00d/resource/4a3daa0f-1580-4a59-ac9e-64d9a31a4429/download/od_p1bmi_ca_clin.csv"

# ---- Download and read URL as temp file ----
tf <- tempfile(fileext = ".csv")
GET(url, write_disk(tf))
child_bmi_raw <- read_csv(tf)
unlink(tf)

# ---- Clean data ----
lives_overweight_obesity_children <- child_bmi_raw |>
  filter(SchoolYear == "2022/23") |>
  select(`CA`, `ClinOverweightObeseAndSeverelyObese`, `SchoolYear`) |>
  mutate(ClinOverweightObeseAndSeverelyObese = ClinOverweightObeseAndSeverelyObese * 100) |>
  rename(ltla24_code = 1,
         overweight_obese_percentage = 2,
         year = 3)

# ---- Save output to data/ folder ----
usethis::use_data(lives_overweight_obesity_children, overwrite = TRUE)
