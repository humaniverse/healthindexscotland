library(httr)
library(readxl)
library(dplyr)

GET(
  "https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2024/05/health-and-care-experience-survey-2023-to-2024-results-by-geography/documents/health-and-care-experience-survey-2023-to-2024-geographical-data/health-and-care-experience-survey-2023-to-2024-geographical-data/govscot%3Adocument/Health%2Band%2BCare%2BExperience%2BSurvey%2B2023%2Bto%2B2024%2B-tables%2Bof%2Bresults%2Bby%2Bgeography.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

read_excel(tf, sheet = "Positive, Neutral or Negative")
