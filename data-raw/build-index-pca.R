#--- method --------------------------------------------------------------------
#
# # Adapted from:
# # https://www.oecd-ilibrary.org/docserver/9789264043466-en.pdf?expires=1732447217&id=id&accname=guest&checksum=C9FB3C0E94A6DE6D49C811382692119B
#
# library(psych)
#
# # toy dataset
# dat <- read.csv("example_data.csv")
#
# # recreating correlations
# cor(dat[-1])
#
# # recreating pca
# pca <- prcomp(dat[-1], center = TRUE, scale. = TRUE)
#
# # percent variance explained
# pca$sdev^2 / sum(pca$sdev^2)
#
# # factors
# fa <- principal(cor(dat[-1]), 4)
# l <- apply(unclass(fa$loadings)^2, 2, function(x) x/sum(x))
# l[l < 0.2] <- 0
# l <- apply(l, 2, function(x) x/sum(x))
# w <- fa$Vaccounted[1,] / sum(fa$Vaccounted[1,])
#
# colSums(t(l) %*% t(apply(data.matrix(dat[-1]), 2, scale)) * w)
#
# # NOTE: cannot replicate the final rankings of TAI example
# # reason - not sure how they were normalized


#--- libraries -----------------------------------------------------------------

library(tidyverse)
library(psych)


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

# impute NA values by using a simple mean
# note that means are 0 after scaling
indicators[is.na(indicators)] <- 0


#--- combine -------------------------------------------------------------------

build_pc_indicators <- function(x) {
  # pca
  # center and scale to make sure all indicators are weighted equally
  pca <- prcomp(x, center = TRUE, scale. = TRUE)
  # determine the number of components selected (cummulative variance > 60 %)
  npc <- which(cumsum(round(pca$sdev^2 / sum(pca$sdev^2) * 100)) > 60)[1]

  # factors
  # NOTE: based on replication from OECD toy dataset example
  # NOTE: using psych::principal() since it aligned with OECD results
  fa <- principal(cor(x), npc)
  # variance explained by each factor
  fw <- fa$Vaccounted[1,] / sum(fa$Vaccounted[1,])

  # square loadings and make sure they sum to 1
  l <- apply(unclass(fa$loadings)^2, 2, function(x) x/sum(x))
  # for each indicator only leave the highest weight
  l <- t(apply(l, 1, function(x) {x[x < max(x)] <- 0; x}))
  # scale again so each factor sums to 1
  l <- apply(l, 2, function(x) x/sum(x))
  # multiply by variance explain
  # NOTE: not sure why, but it's in the OECD example
  l <- l * fw[col(l)]

  # indicator weights
  w <- apply(l, 1, max)

  # final score
  colSums(t(x) * w)
}

quantise <- function(x) {
  findInterval(x, quantile(x, seq(0,1,0.1)), rightmost.closed = TRUE)
}


scores <- data.frame(ltla24_code = indicators$ltla24_code)

# healthy lives
scores$healthy_lives_score    <- build_pc_indicators(select(indicators, starts_with("lives")))
scores$healthy_lives_rank     <- rank(scores$healthy_lives_score)
scores$healthy_lives_quantile <- quantise(scores$healthy_lives_rank)

# healthy places
scores$healthy_places_score    <- build_pc_indicators(select(indicators, starts_with("places")))
scores$healthy_places_rank     <- rank(scores$healthy_places_score)
scores$healthy_places_quantile <- quantise(scores$healthy_places_rank)

# healthy people
scores$healthy_people_score    <- build_pc_indicators(select(indicators, starts_with("people")))
scores$healthy_people_rank     <- rank(scores$healthy_people_score)
scores$healthy_people_quantile <- quantise(scores$healthy_people_rank)

# combined
scores$health_inequalities_score    <- rowSums((select(scores, ends_with("_rank")) - 1) / (nrow(scores) - 1))
scores$health_inequalities_rank     <- rank(scores$health_inequalities_score)
scores$health_inequalities_quantile <- quantise(scores$health_inequalities_rank)


#--- save ----------------------------------------------------------------------

write_csv(scores, "data/index-varimax.csv")
