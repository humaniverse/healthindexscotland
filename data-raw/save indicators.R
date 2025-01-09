library(tidyverse)

# load all indicators
files <- list.files("data", pattern = "^(lives|places|people).*\\.rda", full.names = TRUE)
indicators <- map(files, ~ get(load(.x)))
indicators <- map(indicators, ~ select(.x, -starts_with("year")))

# check whether all indicator tables had the same number of columns
stopifnot(all(lengths(indicators) == 2))

# combine to a single table
indicators <- reduce(indicators, left_join, by = "ltla24_code")
indicators[,-1] <- map(indicators[,-1], as.numeric)
names(indicators)[-1] <- sub(".rda$", "", basename(files))

scotland_health_index_indicators <-
  indicators |>
  pivot_longer(cols = -ltla24_code, names_to = "indicator") |>

  # Domain names
  mutate(domain = str_extract(indicator, "^([a-z]+)")) |>
  mutate(domain = paste0("Healthy ", str_to_title(domain))) |>

  # Subdomain names
  mutate(subdomain = case_match(
    indicator,

    c("people_disability") ~ "Difficulties in daily life",
    c("people_mental_health_conditions", "people_suicides") ~ "Mental health",
    c("people_avoidable_deaths", "people_infant_mortality", "people_healthy_life_expectancy", "people_all_mortality") ~ "Mortality",
    c("people_life_worthwhileness", "people_anxiety", "people_happiness", "people_life_satisfaction") ~ "Personal wellbeing",
    c("people_cancer", "people_cardiovascular_conditions", "people_dementia", "people_musculoskeletal_conditions") ~ "Physical health conditions",

    c("lives_alcohol_misuse", "lives_drug_misuse", "lives_healthy_eating", "lives_physical_activity", "lives_sedentary_behaviour", "lives_smoking") ~ "Behavioural risk factors",
    c("lives_early_years_development", "lives_pupil_absence", "lives_national_five_attainment", "lives_teenage_pregnancy", "lives_young_people_training") ~ "Children and young people",
    c("lives_high_blood_pressure", "lives_low_birth_weight", "lives_overweight_obesity_adults", "lives_overweight_obesity_children") ~ "Physiological risk factors",
    c("lives_cancer_screening", "lives_child_vaccine_coverage") ~ "Protective measures",

    c("places_private_outdoor_space") ~ "Access to green space",
    c("places_gp_travel_time", "places_pharmacy_travel_time", "places_sports_centre_travel_time", "places_internet_access") ~ "Access to services",
    c("places_low_level_crime", "places_personal_crime") ~ "Crime",
    c("places_child_poverty", "places_job_training", "places_unemployment", "places_workplace_safety") ~ "Economic and working conditions",
    c("places_air_pollution", "places_household_overcrowding", "places_road_safety", "places_rough_sleeping") ~ "Living conditions"
  )) |>

  mutate(
    indicator = str_remove(indicator, "^people_|^lives_|^places_") |>
      str_replace_all("_", " ") |>
      str_to_sentence()
  ) |>

  select(ltla24_code, domain, subdomain, indicator, value)

usethis::use_data(scotland_health_index_indicators, overwrite = TRUE)
write_csv(scotland_health_index_indicators, "docs/indicators.csv")
