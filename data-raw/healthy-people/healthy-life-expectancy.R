# England's Health Index uses a weighted population average. Available Scottish
# data only has the average mean healthy life expectancy for men and women
# separately.

# ---- Load packages ----
library(tidyverse)
library(geographr)
library(httr)
library(readxl)

# ---- Import data ----
# Source: https://scotland.shinyapps.io/ScotPHO_profiles_tool/
# Uses the full ScotPHO dataset saved in data-raw/healthy-lives/data/
# See teenage-pregnancy.R to download the full dataset
data_raw <- read_csv("data-raw/healthy-lives/data/scotpho_data.csv")

GET(
  "https://www.nrscotland.gov.uk/files//statistics/population-estimates/mid-21/mid-year-pop-est-21-data.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

pop_raw <-
  read_excel(
    tf,
    sheet = "Table 1",
    range = "A4:E145"
  )

pop <- pop_raw |>
  filter(`Area type` == "Council area") |>
  filter(Sex != "Persons") |>
  select(ltla24_code = `Area code`, sex = Sex, population = `All ages`)

# ---- Clean data ----
healthy_life_expectancy <- data_raw |>
  filter(
    area_type == "Council area",
    indicator == "Healthy life expectancy, males" | indicator == "Healthy life expectancy, females"
  ) |>
  mutate(year = "2019-2021") |>
  mutate(sex = if_else(indicator == "Healthy life expectancy, males", "Males", "Females")) |>
  select(
    ltla24_code = area_code,
    year,
    sex,
    healthy_life_expectancy = measure
  )

# ---- Analyse ----
people_healthy_life_expectancy <-
  healthy_life_expectancy |>
  left_join(pop) |>
  summarise(
    healthy_life_expectancy = sum(healthy_life_expectancy * population) / sum(population),
    .by = c("ltla24_code", "year")
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_healthy_life_expectancy, overwrite = TRUE)
