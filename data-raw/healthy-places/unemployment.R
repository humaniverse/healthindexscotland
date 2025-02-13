# ---- Load packages ----
library(httr)
library(readxl)
library(tidyverse)
library(geographr)

# ---- Get data ----
# Source: https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/unemployment/datasets/modelledunemploymentforlocalandunitaryauthoritiesm01
GET(
  "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peoplenotinwork/unemployment/datasets/modelledunemploymentforlocalandunitaryauthoritiesm01/current/modelbasedunemploymentdataaugust2022.xls",
  write_disk(tf <- tempfile(fileext = ".xls"))
)

unemployment_raw <-
  read_excel(tf, sheet = 4, skip = 2)

# ---- Clean data ----
places_unemployment <- unemployment_raw |>
  select(2, 235) |>
  rename(ltla24_code = 1,
         unemployment_percentage = 2) |>
  filter(str_starts(`ltla24_code`, "S")) |>
  mutate(year = "2021/22")

# Council codes were revised in 2018 and 2019
ltla19_code <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  pull(ltla19_code)

places_unemployment$ltla24_code %in% ltla19_code

# Match 2019 LAD codes
# https://www.opendata.nhs.scot/dataset/geography-codes-and-labels/resource/967937c4-8d67-4f39-974f-fd58c4acfda5
# Look at the 'CADateArchived' column to view changes
places_unemployment <-
  places_unemployment |>
  mutate(
    ltla24_code = case_when(
      ltla24_code == "S12000015" ~ "S12000047",
      ltla24_code == "S12000024" ~ "S12000048",
      ltla24_code == "S12000046" ~ "S12000049",
      ltla24_code == "S12000044" ~ "S12000050",
      TRUE ~ ltla24_code
    )
  )

# ---- Save output to data/ folder ----
usethis::use_data(places_unemployment, overwrite = TRUE)
