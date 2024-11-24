#--- method --------------------------------------------------------------------

# Adapted from:
# https://www.oecd-ilibrary.org/docserver/9789264043466-en.pdf?expires=1732447217&id=id&accname=guest&checksum=C9FB3C0E94A6DE6D49C811382692119B
#
# Steps:
#   1. 
#
# library(psych)
#
# toy dataset
# dat <- read.csv("example_data.csv")
#
# recreating correlations
# cor(dat[-1])
#
# recreating pca
# pca <- prcomp(dat[-1], center = TRUE, scale. = TRUE)
#
# percent variance explained
# pca$sdev^2 / sum(pca$sdev^2)
#
# factors
# fa <- principal(cor(dat[-1]), 4)
# l <- apply(unclass(fa$loadings)^2, 2, function(x) x/sum(x))
# l[l < 0.2] <- 0
# l <- apply(l, 2, function(x) x/sum(x))
# w <- fa$Vaccounted[1,] / sum(fa$Vaccounted[1,])
#
# colSums(t(l) %*% t(apply(data.matrix(dat[-1]), 2, scale)) * w)
#
# NOTE: cannot replicate the final rankings of TAI example
# reason - not sure how they were normalized


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

# pca
pca <- prcomp(indicators[-1], center = TRUE, scale. = TRUE)
# number of components selected as explained % of cummulative variance > 60 %
npc <- which(cumsum(round(pca$sdev^2 / sum(pca$sdev^2) * 100)) > 60)[1]

# factors
fa <- principal(cor(indicators[-1]), npc)
fw <- fa$Vaccounted[1,] / sum(fa$Vaccounted[1,])
l <- apply(unclass(fa$loadings)^2, 2, function(x) x/sum(x))
l <- t(apply(l, 1, function(x) {x[x < max(x)] <- 0; x}))
l <- apply(l, 2, function(x) x/sum(x))
l <- l * fw[col(l)]
w <- apply(l, 1, max)

scores <- data.frame(ltla24_code = indicators$ltla24_code)

scores$score    <- colSums(t(indicators[-1]) * w)
scores$rank     <- rank(scores$score)
scores$quantile <- as.numeric(cut(scores$rank, quantile(scores$rank, seq(0,1,0.1)), include.lowest = TRUE))


#--- save ----------------------------------------------------------------------

write_csv(scores, "data/index-varimax.csv")
