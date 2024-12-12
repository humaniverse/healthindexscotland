# ---- Load packages ----
library(readr)
library(dplyr)
library(geographr)

# ---- Get data ----
# COPD
raw <- read_csv("https://www.publichealthscotland.scot/media/14116/disease-prevalence.csv")

people_copd <-
  raw |>
  filter(`Area Type` == "NHS Board") |>
  filter(Year == "2021-22 Financial Year") |>
  select(
    hb19_name = `GP Practice/Area`,
    copd_prevalence = `Chronic Obstructive Pulmonary Disease Register`
  )

# HB Codes
hb_ltla_lookup <- lookup_dz11_ltla19_hb19 |>
  distinct(ltla19_code, hb19_code)

hb_lookup <- boundaries_hb19 |>
  sf::st_drop_geometry()



# ---- Save output to data/ folder ----
usethis::use_data(people_copd, overwrite = TRUE)
