library(httr)
library(readxl)
library(dplyr)
library(readr)
library(stringr)
library(geographr)

# Lookup HSCP to LAD (contains 2011 and 2019 LAD codes):
# Source: # https://www.opendata.nhs.scot/km/dataset/geography-codes-and-labels/resource/967937c4-8d67-4f39-974f-fd58c4acfda5
lookup <- read_csv("https://www.opendata.nhs.scot/km/datastore/dump/967937c4-8d67-4f39-974f-fd58c4acfda5?bom=True")

# Keep only 2019 LAD codes
lookup <-
  lookup %>%
  select(
    lad_code = CA,
    hscp_name = HSCPName
  ) %>%
  filter(lad_code %in% boundaries_lad$lad_code) %>%
  distinct(lad_code, hscp_name, .keep_all = TRUE)

# Diabetes
GET(
  "https://beta.isdscotland.org/media/3764/disease-prevalence.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

diabetes_raw <- read_excel(tf, sheet = "Data")

diabetes <-
  diabetes_raw %>%
  filter(Year == "2018-19 Financial Year") %>%
  filter(`Area Type` == "HSCP") %>%
  select(
    hscp_name = `GPPractice / Area`,
    diabetes_percent = `Diabetes Rate`
  ) %>%
  mutate(diabetes_percent = diabetes_percent / 100)

# Clean up HSCP names to match lookup table
diabetes <-
  diabetes %>%
  mutate(hscp_name = str_remove_all(hscp_name, "HSCP")) %>%
  mutate(hscp_name = str_squish(hscp_name)) %>%
  mutate(hscp_name = str_replace_all(hscp_name, "&", "and")) %>%
  mutate(hscp_name = if_else(hscp_name == "City of Edinburgh", "Edinburgh", hscp_name)) %>%
  mutate(hscp_name = if_else(hscp_name == "Comhairle nan Eilean Siar", "Western Isles", hscp_name))

# Join to lookup
diabetes <-
  diabetes %>%
  left_join(lookup, by = "hscp_name") %>%
  select(lad_code, diabetes_percent)

write_rds(diabetes, "data/vulnerability/health-inequalities/scotland/healthy-people/diabetes.rds")