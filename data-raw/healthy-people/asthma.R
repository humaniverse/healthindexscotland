library(readr)
library(dplyr)

raw <- read_csv("https://www.publichealthscotland.scot/media/14116/disease-prevalence.csv")

people_asthma <-
  raw |>
  filter(`Area Type` == "NHS Board") |>
  filter(Year == "2021-22 Financial Year") |>
  select(
    hb19_name = `GP Practice/Area`,
    asthma_prevalence = `Asthma Prevalence`
  )

usethis::use_data(people_asthma, overwrite = TRUE)
