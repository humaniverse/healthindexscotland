library(httr)
library(readxl)
library(dplyr)
library(geographr)

hb_ltla_lookup <- lookup_dz11_ltla19_hb19 |>
  distinct(ltla19_code, hb19_code)

GET(
  "https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2024/05/health-and-care-experience-survey-2023-to-2024-results-by-geography/documents/health-and-care-experience-survey-2023-to-2024-geographical-data/health-and-care-experience-survey-2023-to-2024-geographical-data/govscot%3Adocument/Health%2Band%2BCare%2BExperience%2BSurvey%2B2023%2Bto%2B2024%2B-tables%2Bof%2Bresults%2Bby%2Bgeography.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

raw <- read_excel(tf, sheet = "Positive, Neutral or Negative")

gp_appointments_hb <- raw |>
  filter(`Geography Type` == "Health Board") |>
  # select(hb19_code = Area, )
  filter(`Question Text` == "Overall, how would you rate the care provided by your General Practice?") |>
  select(hb19_code = Area, acceptable_gp_appointments = `Percentage Positive`)

places_gp_appointments <-
  gp_appointments_hb |>
  left_join(hb_ltla_lookup) |>
  select(ltla24_code = ltla19_code, acceptable_gp_appointments)

usethis::use_data(places_gp_appointments, overwrite = TRUE)
