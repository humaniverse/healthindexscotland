#--- method --------------------------------------------------------------------

# Adapted from the methods used to develop the Health Index for England. As the
# devolved nations versions of the Health Index are not measured across time,
# several aspects of the construction differ and mirror those found in the
# Indices of Multiple Deprivation.
#
# Technical docs:
#   - https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/healthandwellbeing/methodologies/methodsusedtodevelopthehealthindexforengland2015to2018#overview-of-the-methods-used-to-create-the-health-index
#   - https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833951/IoD2019_Technical_Report.pdf
#
# Steps:
#   1. Align all indicators so that higher value = worse health.
#   2. Apply necessary transformations (e.g. log, square)  # NOTE: missing.
#   3. Normalise to mean 0 and sd 1 and then apply MFLA.
#   4. Optional step: Weight the indicators within domains: apply MFLA.
#   5. Calculate domain scores: add together normalised indicator scores
#      (weighted or unweighted) and rank and qunatise.
#   6. Combine domains with equal weighting to produce composite score: rank
#      and quantise output.


#--- libraries -----------------------------------------------------------------

library(tidyverse)


#--- prepare indicators --------------------------------------------------------

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

# all the indicators that are represented as higher = better
toflip <- c("lives_alcohol_misuse", "lives_cardiovascular_conditions",
            "lives_child_poverty", "lives_drug_misuse", "lives_high_blood_pressure",
            "lives_infant_mortality", "lives_low_birth_weight",
            "lives_overweight_obesity_adults", "lives_overweight_obesity_children",
            "lives_pupil_absence", "lives_sedentary_behaviour", "lives_smoking",
            "lives_teenage_pregnancy", "lives_unemployment", "lives_workplace_safety",
            # "lives_sexual_health"  # NOTE: missing from data
            "people_anxiety", "people_avoidable_deaths", "people_cancer",
            "people_child_mental_health", "people_disability", "people_dementia",
            "people_mental_health_conditions", "people_all_mortality",
            "people_musculoskeletal_conditions", "people_suicides",
            # "people_diabetes", "people_kidney_and_liver_disease"  # NOTE: missing
            "places_gp_travel_time", "places_air_pollution", "places_household_overcrowding",
            "places_internet_access", "places_low_level_crime", "places_personal_crime",
            "places_road_safety", "places_rough_sleeping", "places_pharmacy_travel_time",
            "places_sports_centre_travel_time"
            )

# check if all present
stopifnot(all(toflip %in% colnames(indicators)))

# align the indicators so that higher = worse
indicators[toflip] <- - indicators[toflip]

# scale to z-scores
indicators[-1] <- map(indicators[-1], function(x) scale(x)[,1])  # NOTE: [,1] to drop attribtes


#--- combine -------------------------------------------------------------------

scores <- data.frame(ltla24_code = indicators$ltla24_code)

# healthy lives
scores$healthy_lives_score    <- rowSums(select(indicators, starts_with("lives")), na.rm = TRUE)
scores$healthy_lives_rank     <- rank(scores$healthy_lives_score)
scores$healthy_lives_quantile <- as.numeric(cut(scores$healthy_lives_rank, quantile(scores$healthy_lives_rank, seq(0,1,0.1)), include.lowest = TRUE))

# healthy people
scores$healthy_people_score    <- rowSums(select(indicators, starts_with("people")), na.rm = TRUE)
scores$healthy_people_rank     <- rank(scores$healthy_people_score)
scores$healthy_people_quantile <- as.numeric(cut(scores$healthy_people_rank, quantile(scores$healthy_people_rank, seq(0,1,0.1)), include.lowest = TRUE))

# healthy places
scores$healthy_places_score    <- rowSums(select(indicators, starts_with("places")), na.rm = TRUE)
scores$healthy_places_rank     <- rank(scores$healthy_places_score)
scores$healthy_places_quantile <- as.numeric(cut(scores$healthy_places_rank, quantile(scores$healthy_places_rank, seq(0,1,0.1)), include.lowest = TRUE))

# combined
scores$health_inequalities_score    <- rowSums((select(scores, ends_with("_rank")) - 1) / (nrow(scores) - 1))
scores$health_inequalities_rank     <- rank(scores$health_inequalities_score)
scores$health_inequalities_quantile <- as.numeric(cut(scores$health_inequalities_rank, quantile(scores$health_inequalities_rank, seq(0,1,0.1)), include.lowest = TRUE))


#--- save ----------------------------------------------------------------------

write_csv(scores, "data/index-unweighted.csv")
