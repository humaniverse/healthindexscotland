# ---- Load packages ----
library(tidyverse)
library(rio)
library(geographr)
library(demographr)

# ---- Get data ----
# Population
population_2022 <- population22_ltla19_scotland |>
  filter(sex == "Persons") |>
  select(
    ltla19_name,
    ltla19_code,
    population_2022 = all_ages
  )

# Cardiovascular Conditions
# Source: https://www.opendata.nhs.scot/dataset/scottish-heart-disease-statistics/resource/5379a655-d677-46cf-814d-bc0574ac59e4
cardiovascular_conditions_raw <- import("https://www.opendata.nhs.scot/dataset/0e17f3fc-9429-48aa-b1ba-2b7e55688253/resource/5379a655-d677-46cf-814d-bc0574ac59e4/download/hd_activitybyca.csv")

# ---- Clean data ----
cardiovascular_conditions <- cardiovascular_conditions_raw |>
  filter(`FinancialYear` == "2022/23",
         `AgeGroup` == "All",
         `AdmissionType` == "All",
         `Sex` == "All") |>
  rename(ltla19_code = 2,
         discharge_rate_per_100k = 13) |>
  group_by(ltla19_code) |>
  summarise(
    total_discharge_rate_per_100k = sum(discharge_rate_per_100k, na.rm = TRUE)
  ) |>
  mutate(year = "2022/23",
         av_discharge_rate_per_100k = (total_discharge_rate_per_100k / 4)) |>
  select(`ltla19_code`, `av_discharge_rate_per_100k`, `year`) |>
  slice(-33)

# ---- Join datasets ---
hl_cardiovascular_conditions <- cardiovascular_conditions |>
  left_join(population_2022, by = c("ltla19_code" = "ltla19_code")) |>



# what i need to do is go back to the cardiovascular conditions dataset and
# reintroduce number of discharges and get the mean average from number of
# discharges. Can call it `av_discharge_total` = so dataset is LA ID, av_discharge_total,
# and year. THEN join datasets (pop and CV) where  av_discharge_rate_per_100k =
# av_discharge_total / pop_2022 * 100000!!

  mutate(av_discharge_rate_per_100k = (((as.double(av_discharge_rate_per_100k)) /
                                           as.double(population_2022)) * 100000))





