library(httr)
library(readxl)
library(dplyr)

# Rheumatoid Arthritis
GET(
  "https://www.versusarthritis.org/media/14567/mskcalculator_laccg_scotland.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

people_rheumatoid_arthritis <-
  read_excel(tf, sheet = "RA_LA", range = "A2:E34") |>
  select(
    ltla24_code = `LA Code`,
    rheumatoid_arthritis_prevelenace = `Prevalence (general)`
  )

usethis::use_data(people_rheumatoid_arthritis, overwrite = TRUE)
