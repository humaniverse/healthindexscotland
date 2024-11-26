library(readr)
library(dplyr)

raw <- read_csv("https://www.publichealthscotland.scot/media/14116/disease-prevalence.csv")

people_copd <-
  raw |>
  filter(`Area Type` == "NHS Board") |>
  filter(Year == "2021-22 Financial Year") |>
  select(
    hb19_name = `GP Practice/Area`,
    copd_prevalence = `Chronic Obstructive Pulmonary Disease Register`
  )

usethis::use_data(people_copd, overwrite = TRUE)
