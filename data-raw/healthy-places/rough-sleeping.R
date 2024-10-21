library(httr)
library(readxl)
library(readr)
library(dplyr)
library(demographr)

# Load population estimates
# source: https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/mid-year-population-estimates/mid-2023
GET(
  "https://www.nrscotland.gov.uk/files//statistics/population-estimates/mid-23/mid-year-pop-est-23-data.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

pop_raw <- read_excel(tf, sheet = "Table 1", skip = 3)

# Calculate population estimates
pop <-
  pop_raw |>
  filter(`Area type` == "Council area") |>
  filter(Sex == "Persons") |>
  select(
    ltla21_name = `Area name`,
    ltla21_code = `Area code`,
    pop_count = `All ages`
  )

# Homelessness in Scotland: 2023-24
# Source: https://www.gov.scot/publications/homelessness-in-scotland-2023-24/
#
# In the absence of similar counts of people sleeping rough in England, we're using
# people who have slept rough within the last three months then applied for Local
# Authority support.
GET(
  "https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2024/09/homelessness-in-scotland-2023-24/documents/main-tables_homelessness-in-scotland-2023-24/main-tables_homelessness-in-scotland-2023-24/govscot%3Adocument/Main%2Btables_Homelessness%2Bin%2BScotland%2B2023-24.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

# Table 3b: Applications where at least one member of the household experienced rough sleeping in the three months prior to their application, by local authority: 2019-20 to 2023-24 [Notes 1 & 2]
rough_sleeping_raw <-
  read_excel(
    tf,
    sheet = "T3",
    range = "A14:F47"
  )

# Select latest data and join to population counts
rough_sleeping <-
  rough_sleeping_raw |>
  filter(`Local Authority` != "Scotland") |>
  select(
    ltla21_name = `Local Authority`,
    rough_sleeping_count = `2023-24`
  ) |>
  mutate(
    ltla21_name = case_when(
      ltla21_name == "Argyll & Bute" ~ "Argyll and Bute",
      ltla21_name == "Dumfries & Galloway" ~ "Dumfries and Galloway",
      ltla21_name == "Edinburgh" ~ "City of Edinburgh",
      ltla21_name == "Eilean Siar" ~ "Na h-Eileanan Siar",
      ltla21_name == "Orkney" ~ "Orkney Islands",
      ltla21_name == "Perth & Kinross" ~ "Perth and Kinross",
      ltla21_name == "Shetland" ~ "Shetland Islands",
      .default = ltla21_name
    )
  ) |>
  left_join(pop, by = "ltla21_name") |>
  relocate(ltla21_code) |>
  select(-ltla21_name)

# Normalise by population size
places_rough_sleeping <-
  rough_sleeping |>
  mutate(rough_sleeping_per_10k = rough_sleeping_count / pop_count * 100000) |>
  select(ltla21_code, rough_sleeping_per_10k)

# ---- Save output to data/ folder ----
usethis::use_data(places_rough_sleeping, overwrite = TRUE)
