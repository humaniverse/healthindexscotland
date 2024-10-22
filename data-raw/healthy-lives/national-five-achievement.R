library(tidyverse)
library(rio)
library(geographr)
library(janitor)

# ---- LTLA code and name lookup ----
ltla_lookup <- lookup_ltla_ltla |>
  filter(str_detect(ltla19_code, "^S")) |>
  select(ltla19_code, ltla19_name)

replacements <- c("City of Edinburgh" = "The City of Edinburgh",
                  "Glasgow City" = "City of Glasgow",
                  "Na h-Eileanan Siar" = "Comhairle Na h-Eileanan Siar",
                  "Moray" = "The Moray")

ltla_name <- ltla_lookup |>
  mutate(ltla19_name = str_replace_all(ltla19_name, replacements)) |>
  distinct(ltla19_name) |>
  arrange(ltla19_name) |>
  pull(ltla19_name)

# ---- Get and clean data -----
# Source: https://www.sqa.org.uk/sqa/105123.html

url <- "https://www.sqa.org.uk/sqa/files_ccc/attainment-statistics-provisional-2024-education-authorities-national5.xlsx"

attainment_combined <- tibble()

for (i in 2:33) {

  attainment_raw <- import(url, sheet = i)

  attainment <- attainment_raw |>
    row_to_names(row_number = 3) |>
    filter(Subject %in% c("English", "Mathematics")) |>
    summarise(national_five_attainment_percent = mean(as.numeric(`Grade A-C Percentage 2023`), na.rm = TRUE)*100) |>
    mutate(ltla19_name = ltla_name[i-1])

  print(ltla_name[i-1])

  attainment_combined <- bind_rows(attainment_combined, attainment)
}

replacements_reverse <- c("The City of Edinburgh" = "City of Edinburgh",
                  "City of Glasgow" = "Glasgow City",
                  "Comhairle Na h-Eileanan Siar" = "Na h-Eileanan Siar",
                  "The Moray" = "Moray")

lives_national_five_attainment <- attainment_combined |>
  mutate(ltla19_name = str_replace_all(ltla19_name, replacements_reverse)) |>
  left_join(ltla_lookup) |>
  select(ltla19_code, national_five_attainment_percent) |>
  mutate(year = 2024) |>
  distinct()

 # ---- Save output to data/ folder ----
 usethis::use_data(lives_national_five_attainment, overwrite = TRUE)
